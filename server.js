const express = require('express');
const app = express();
const port = 3000;
const path = require('path');
const bodyParser = require('body-parser');
const https = require('https');
const fs = require('fs');
const { client, disconnectFromDatabase, connectToDatabase } = require('./app/models/client');
const { authenticateUser, determineRedirectUrl, logoutUser } = require('./app/controllers/auth');
const session = require('express-session');
const { Account, Okna, Otdelenia, Dolzhnost, DolzhnostiOkna, Grafik, GrafikOtdelenia, TelegramAcc, Talony, TalonyTelegram, StatusObsl, Uslugi, UslugiSpecialista } = require('./app/models/modelsDB');
const privateKey = fs.readFileSync('localhost+2-key.pem');
const certificate = fs.readFileSync('localhost+2.pem');
const { Op } = require('sequelize');

const denNedeliMap = {
            'Понедельник': 0,
            'Вторник': 1,
            'Среда': 2,
            'Четверг': 3,
            'Пятница': 4,
            'Суббота': 5,
            'Воскресенье': 6
        };

function isAuthenticated(req, res, next) {
	if (req.session && req.session.user) {
		return next(); // Пользователь авторизован, продолжить
	} else {
		res.redirect('/'); // Пользователь не авторизован, перенаправить на страницу входа
	}
}

app.use(session({
	secret: 'pAssW0rd', // Секретный ключ
	resave: false,
	saveUninitialized: true,
	cookie: { secure: true } //  Устанавливаем secure: true для HTTPS
}));

app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));

app.use('/jquery', express.static(path.join(__dirname, '/app/jquery')));

const isAdmin = (req, res, next) => { // Проверка на администратора
	try {
		if (req.session && req.session.user && req.session.user.dolzhnost === 'Администратор') {
			return next();
		}
	} catch {
		res.status(403).redirect('/login');		
	}
	
    res.status(403).redirect('/login');		
};

const isManager = (req, res, next) => { // Проверка на руководителя
	try {
		if (req.session && req.session.user && (req.session.user.dolzhnost === 'Руководитель' || req.session.user.dolzhnost === 'Главный оператор')) {
			return next();
		}
	} catch {
		res.status(403).redirect('/login');		
	}
	
    res.status(403).redirect('/login');
};

const isEmployee = (req, res, next) => { // Проверка на роль сотрудника
	try {
		if (req.session && req.session.user && (req.session.user.dolzhnost === 'Кассир-операционист' || req.session.user.dolzhnost === 'Оператор почтовой связи' || req.session.user.dolzhnost === 'Консультант')) {
			return next();
		}
	} catch {
		res.status(403).redirect('/login');		
	}
	
    res.status(403).redirect('/login');		
};

app.get('/get_user_info', async (req, res) => {
    try {
        if (req.user) {
            res.json({ info: req.user.info });
        } else {
            res.status(401).json({ error: 'Unauthorized' });
        }
    } catch (error) {
        console.error("Error fetching user info:", error);
        res.status(500).json({ error: 'Internal Server Error' });
    }
});

app.use('/admin', isAdmin, express.static(path.join(__dirname, 'app/public/admin'))); 

app.get('/admin/otdelenia', isAdmin, async (req, res) => {
    try {
        const otdelenia = await Otdelenia.findAll();
        res.json(otdelenia);
    } catch (error) {
        console.error("Error fetching otdelenia:", error);
        res.status(500).json({ message: 'Server Error' });
    }
});

app.get('/admin/dolzhnosti', isAdmin, async (req, res) => {
    try {
    	const dolzhnosti = await Dolzhnost.findAll({
            where: {
                naim: { // Исключаем должности
                    [Op.notIn]: ['Администратор', 'Терминал вывода', 'Терминал выдачи талонов']
                }
            }
        });
    	res.json(dolzhnosti);
    } catch (error) {
    	console.error("Error fetching dolzhnosti:", error);
    	res.status(500).json({ message: 'Ошибка сервера' });
    }
});

app.put('/admin/otdelenie/:id/edit', isAdmin, async (req, res) => {
    const otdelenieId = req.params.id;
    const { 
        index, 
        naimenovanie, 
        adres, 
        ecs, 
        time_obrabotki, 
        okna, 
        sotrudniki, 
        terminals, 
        displayTerminals, 
        grafikOtdeleniya 
    } = req.body;
    
    try {
        const otdelenie = await Otdelenia.findByPk(otdelenieId);
        if (!otdelenie) {
            return res.status(404).json({ message: 'Отделение не найдено' });
        }

        await otdelenie.update({
            index,
            naimenovanie,
            adres,
            ecs,
            time_obrabotki
        });

        await GrafikOtdelenia.destroy({ where: { id_otdelenia: otdelenieId } });
        for (const grafikData of grafikOtdeleniya) {
            if (!grafikData.start_time || !grafikData.stop_time)
                continue;

            const grafikEntry = {
                id_otdelenia: otdelenie.id,
                den_nedeli: denNedeliMap[grafikData.den_nedeli],
                start: grafikData.start_time,
                stop: grafikData.stop_time
            };

            if (grafikData.break_start_time && grafikData.break_end_time) {
                grafikEntry.pereryv_start = grafikData.break_start_time;
                grafikEntry.pereryv_stop = grafikData.break_end_time;
            }

            await GrafikOtdelenia.create(grafikEntry);
        }

        const existingOkna = await Okna.findAll({ where: { id_otdelenia: otdelenieId }, attributes: ['id'] });
        const existingOknaIds = existingOkna.map(okno => okno.id);

        const oknaIdsFromFrontend = okna.map(okno => okno.id).filter(id => id !== null && id !== undefined);
        const oknaIdsToDelete = existingOknaIds.filter(id => !oknaIdsFromFrontend.includes(id));
        for (const oknoId of oknaIdsToDelete) {
            await DolzhnostiOkna.destroy({ where: { id_okna: oknoId } });
            await Okna.destroy({ where: { id: oknoId } });
        }

        for (const oknoData of okna) {
            if (oknoData.id) { 
                const okno = await Okna.findByPk(oknoData.id);
                await okno.update({ naim_okna: oknoData.naim_okna });
                await DolzhnostiOkna.destroy({ where: { id_okna: oknoData.id } });

                for (const dolzhnostId of oknoData.dolzhnosti) {
                    await DolzhnostiOkna.create({ id_okna: oknoData.id, id_dolzhnosti: dolzhnostId });
                }
            } else {
                const okno = await Okna.create({ naim_okna: oknoData.naim_okna, id_otdelenia: otdelenieId });
                for (const dolzhnostId of oknoData.dolzhnosti) {
                    await DolzhnostiOkna.create({ id_okna: okno.id, id_dolzhnosti: dolzhnostId });
                }
            }
        }

        for (const sotrudnikData of sotrudniki) {
            if (sotrudnikData.id) {
                const sotrudnik = await Account.findByPk(sotrudnikData.id);
                await sotrudnik.update({
                    info: sotrudnikData.info,
                    login: sotrudnikData.login,
                    password: sotrudnikData.password,
                    id_dolzhnosti: sotrudnikData.id_dolzhnosti
                });
                await Grafik.destroy({ where: { id_account: sotrudnik.id } }); 
                for (const grafikData of sotrudnikData.grafik) {
                    if (grafikData.time_start && grafikData.time_stop) {
                        await Grafik.create({
                            id_account: sotrudnik.id,
                            den_nedeli: denNedeliMap[grafikData.den_nedeli],
                            time_start: grafikData.time_start,
                            time_stop: grafikData.time_stop
                        });
                    }
                }
            } else {
                const account = await Account.create({
                    login: sotrudnikData.login,
                    password: sotrudnikData.password,
                    info: sotrudnikData.info,
                    id_dolzhnosti: sotrudnikData.id_dolzhnosti,
                    id_otdelenia: otdelenieId,
                });

                for (const grafikData of sotrudnikData.grafik) {
                    if (grafikData.time_start && grafikData.time_stop) {
                        await Grafik.create({
                            id_account: account.id,
                            den_nedeli: denNedeliMap[grafikData.den_nedeli],
                            time_start: grafikData.time_start,
                            time_stop: grafikData.time_stop
                        });
                    }
                }
            }
        }

        const existingTerminals = await Account.findAll({
            where: {
                id_otdelenia: otdelenieId,
                id_dolzhnosti: 16 // ID должности "Терминал выдачи талонов"
            },
            attributes: ['id']
        });
        const existingTerminalsIds = existingTerminals.map(terminal => terminal.id);

        const terminalIdsFromFrontend = terminals.map(terminal => terminal.id).filter(id => id !== null && id !== undefined);
        const terminalIdsToDelete = existingTerminalsIds.filter(id => !terminalIdsFromFrontend.includes(id));

        for (const terminalId of terminalIdsToDelete) {
            await Account.destroy({ where: { id: terminalId } });
        }

        for (const terminalData of terminals) {
            if (terminalData.id) {
                const terminal = await Account.findByPk(terminalData.id);
                await terminal.update({
                    info: terminalData.info,
                    login: terminalData.login,
                    password: terminalData.password
                });
            } else {
                await Account.create({
                    info: terminalData.info,
                    login: terminalData.login,
                    password: terminalData.password,
                    id_otdelenia: otdelenieId,
                    id_dolzhnosti: 16
                });
            }
        }

        const existingDisplayTerminals = await Account.findAll({
            where: {
                id_otdelenia: otdelenieId,
                id_dolzhnosti: 17 // ID должности "Терминал вывода"
            },
            attributes: ['id']
        });
        const existingDisplayTerminalsIds = existingDisplayTerminals.map(terminal => terminal.id);

        const displayTerminalIdsFromFrontend = displayTerminals.map(terminal => terminal.id).filter(id => id !== null && id !== undefined);
        const displayTerminalIdsToDelete = existingDisplayTerminalsIds.filter(id => !displayTerminalIdsFromFrontend.includes(id));


        for (const terminalId of displayTerminalIdsToDelete) {
            await Account.destroy({ where: { id: terminalId } });
        }

        for (const terminalData of displayTerminals) {
            if (terminalData.id) {
                const terminal = await Account.findByPk(terminalData.id);
                await terminal.update({
                    info: terminalData.info,
                    login: terminalData.login,
                    password: terminalData.password
                });
            
            } else {
                await Account.create({
                    info: terminalData.info,
                    login: terminalData.login,
                    password: terminalData.password,
                    id_otdelenia: otdelenieId,
                    id_dolzhnosti: 17 // ID должности "Терминал вывода"
                });
            }
        }

        res.json({ message: 'Отделение обновлено' });

    } catch (error) {
        console.error("Ошибка при обновлении отделения:", error);
        res.status(500).json({ message: 'Ошибка сервера' });
    }
});

app.get('/admin/otdelenie/:id', isAdmin, async (req, res) => {
    const otdelenieId = req.params.id;

    try {
        const otdelenie = await Otdelenia.findOne({
            where: { id: otdelenieId },
            include: [
                {
                    model: Okna,
                    include: [
                        {
                            model: Dolzhnost,
                            attributes: ['id', 'naim'],
                        }
                    ]
                }
            ]
        });

        if (!otdelenie) {
            return res.status(404).json({ message: 'Отделение не найдено' });
        }

        const grafik = await GrafikOtdelenia.findAll({
            where: { id_otdelenia: otdelenieId }
        });

        const sotrudniki = await Account.findAll({
            where: { id_otdelenia: otdelenieId },
            include: [
                { 
                    model: Dolzhnost,
                    where: {
                        naim: { // Исключаем должности
                            [Op.notIn]: ['Администратор', 'Терминал вывода', 'Терминал выдачи талонов']
                        }
                    },
                    attributes: ['id', 'naim'] 
                },
                { 
                    model: Grafik,
                    attributes: ['den_nedeli', 'time_start', 'time_stop']
                }
            ],
            attributes: ['id', 'login', 'info', 'id_okna', 'password']
        });

        const terminals = await Account.findAll({
            where: {
                id_otdelenia: otdelenieId,
                id_dolzhnosti: 7 // ID должности для терминала выдачи талонов
            },
            attributes: ['id', 'login', 'info', 'password']
        });

        const displayTerminals = await Account.findAll({
            where: {
                id_otdelenia: otdelenieId,
                id_dolzhnosti: 8 // ID должности для терминала вывода информации
            },
            attributes: ['id', 'login', 'info', 'password']
        });

        if (req.query.format === 'json') {
            res.json({
            ...otdelenie.toJSON(),
            grafik,
            sotrudniki,
            terminals,
            displayTerminals
        });
        } else {
            res.sendFile(path.resolve(__dirname, 'app/public/admin/otdelenie/index.html'));
        }
    } catch (error) {
        console.error("Ошибка при получении данных отделения:", error);
        res.status(500).json({ message: 'Ошибка сервера' });
    }
});

app.delete('/admin/otdelenia/:id', isAdmin, async (req, res) => {
    const otdelenieId = req.params.id;

    try {
        const accounts = await Account.findAll({ where: { id_otdelenia: otdelenieId }, attributes: ['id'] });
        const accountIds = accounts.map(account => account.id); // Получаем id сотрудников
        await Grafik.destroy({ where: { id_account: accountIds } });

        await GrafikOtdelenia.destroy({ where: { id_otdelenia: otdelenieId } });
        await Account.destroy({ where: { id_otdelenia: otdelenieId } });

        const okna = await Okna.findAll({ where: { id_otdelenia: otdelenieId }, attributes: ['id'] });
        const oknaIds = okna.map(okno => okno.id);
        await DolzhnostiOkna.destroy({ where: { id_okna: oknaIds } });

        await Okna.destroy({ where: { id_otdelenia: otdelenieId } });
        await Otdelenia.destroy({ where: { id: otdelenieId } });

        res.json({ message: 'Отделение и связанные данные удалены' });
    } catch (error) {
        console.error("Ошибка при удалении отделения:", error);
        res.status(500).json({ message: 'Ошибка сервера' });
    }
});

app.get('/admin/otdelenia/add', isAdmin, (req, res) => {
    res.sendFile(path.join(__dirname, 'app/public/admin/add_otdelenie/index.html'));
});

app.post('/admin/otdelenie/add', isAdmin, async (req, res) => {
    try {
        const { index, naimenovanie, adres, ecs, time_obrabotki, okna, sotrudniki, terminals, displayTerminals, grafikOtdeleniya } = req.body;

        // Создание отделения
        const otdelenie = await Otdelenia.create({
            index, naimenovanie, adres, ecs, time_obrabotki
        });

        // Добавление графика отделения
        for (const grafikData of grafikOtdeleniya) {
            if (!grafikData.start_time || !grafikData.stop_time)
                continue;

            const grafikEntry = {
                id_otdelenia: otdelenie.id,
                den_nedeli: denNedeliMap[grafikData.den_nedeli],
                start: grafikData.start_time,
                stop: grafikData.stop_time
            };

            if (grafikData.break_start_time && grafikData.break_end_time) {
                grafikEntry.pereryv_start = grafikData.break_start_time;
                grafikEntry.pereryv_stop = grafikData.break_end_time;
            }

            await GrafikOtdelenia.create(grafikEntry);
        }

        for (const oknoData of okna) {
            const okno = await Okna.create({
                naim_okna: oknoData.naim_okna,
                id_otdelenia: otdelenie.id
            });

            for (const dolzhnostId of oknoData.dolzhnosti) {
                await DolzhnostiOkna.create({
                    id_okna: okno.id,
                    id_dolzhnosti: dolzhnostId
                });
            }
        }

        // Добавление сотрудников
        for (const sotrudnikData of sotrudniki) {
            const account = await Account.create({
                login: sotrudnikData.login,
                password: sotrudnikData.password,
                info: sotrudnikData.info,
                id_dolzhnosti: sotrudnikData.id_dolzhnosti,
                id_otdelenia: otdelenie.id,
            });

            // Добавление графика сотрудника
            for (const grafikData of sotrudnikData.grafik) {
                if (!grafikData.start_time || !grafikData.stop_time)
                    continue;

                await Grafik.create({
                    id_account: account.id,
                    den_nedeli: denNedeliMap[grafikData.den_nedeli], // Преобразование дня недели в число
                    time_start: grafikData.time_start,
                    time_stop: grafikData.time_stop
                });
            }
        }

        // Добавление терминалов выдачи талонов
        const terminalDolzhnost = await Dolzhnost.findOne({ where: { naim: "Терминал выдачи талонов" } });
        if (!terminalDolzhnost) {
            return res.status(500).json({ error: "Должность 'Терминал выдачи талонов' не найдена" });
        }
        for (const terminal of terminals) {
            await Account.create({
                info: terminal.info,
                login: terminal.login,
                password: terminal.password,
                id_otdelenia: otdelenie.id,
                id_dolzhnosti: terminalDolzhnost.id
            });
        }

        // Добавление терминалов отображения очереди
        const displayTerminalDolzhnost = await Dolzhnost.findOne({ where: { naim: "Терминал вывода" } });
        if (!displayTerminalDolzhnost) {
            return res.status(500).json({ error: "Должность 'Терминал вывода' не найдена" });
        }

        for (const displayTerminal of displayTerminals) {
            await Account.create({
                info: displayTerminal.info,
                login: displayTerminal.login,
                password: displayTerminal.password,
                id_otdelenia: otdelenie.id,
                id_dolzhnosti: displayTerminalDolzhnost.id
            });
        }

        res.json({ message: 'Отделение добавлено', id: otdelenie.id });
    } catch (error) {
        console.error("Ошибка при добавлении отделения:", error);
        res.status(500).json({ error: 'Не удалось добавить отделение' });
    }
});

app.get('/admin/admins', isAdmin, async (req, res) => {
    try {
        const adminRole = await Dolzhnost.findOne({ where: { naim: 'Администратор'}}); // Поиск роли администратора

        if (!adminRole) { 
            console.error("Роль 'Администратор' не найдена в базе данных.");
            return res.status(500).json({ message: 'Server Error: Роль не найдена' });
        }

        const admins = await Account.findAll({
            attributes: ['id', 'info', 'login', 'password'],
            where: { id_dolzhnosti: adminRole.id }
        });
        res.json(admins);
    } catch (error) {
        console.error("Error fetching admins:", error);
        res.status(500).json({ message: 'Server Error' });
    }
});

app.post('/admin/admins', isAdmin, async (req, res) => {
    try {
        const { fio, login, password } = req.body;

        if (!fio || !login || !password) {
            return res.status(400).json({ error: 'Все поля обязательны для заполнения' });
        }
    
        const adminRole = await Dolzhnost.findOne({ where: { naim: 'Администратор' } });
        if (!adminRole) {
            return res.status(500).json({ error: 'Роль "Администратор" не найдена' });
        }

        const newAdmin = await Account.create({
            info: fio,
            login: login,
            password: password,
            id_dolzhnosti: adminRole.id
        });

        res.status(201).json(newAdmin);
    } catch (error) {
        console.error("Ошибка добавления администратора:", error);
        if (error.name === 'SequelizeUniqueConstraintError') {
            return res.status(400).json({ error: 'Пользователь с таким логином уже существует' });
        }
        res.status(500).json({ error: 'Ошибка сервера' });
    }
});

app.put('/admin/password', isAdmin, async (req, res) => { // Запрос для изменения пароля администратором
  try {
    const { currentPassword, newPassword } = req.body;
    const userId = req.session.user.id; // ID текущего пользователя из сессии

    const user = await Account.findByPk(userId);
    if (!user) {
      return res.status(404).json({ error: 'Пользователь не найден' });
    }

    if (currentPassword !== user.password) {
        return res.status(400).json({ error: 'Неверный текущий пароль' });
    }

    user.password = newPassword;
    await user.save();

      res.json({ message: 'Пароль успешно изменен' });
  } catch (error) {
      console.error('Ошибка при изменении пароля:', error);
      res.status(500).json({ error: 'Ошибка сервера' });
  }
});

app.get('/admin/*', isAdmin, (req, res) => { 
	res.sendFile(path.join(__dirname, 'app/public/admin/index.html'));
});

app.post('/login', async (req, res) => {
	try {
		const { login, password } = req.body;
        const authResult = await authenticateUser(login, password);

        if (!authResult.success) {
            return res.status(401).json({ message: authResult.message });
        }

        req.session.user = authResult.user; // Сохраняем данные пользователя в сессию
        res.json({ message: 'Авторизация успешна', redirectUrl: determineRedirectUrl(authResult.user.dolzhnost), user: authResult.user });
  
	} catch (error) {
		console.error('Ошибка при обработке запроса /login', error);
		res.status(500).json({ message: 'Ошибка сервера' });
	}
});

app.post('/logout', logoutUser);

app.get('/', (req, res) => {
	res.sendFile(path.join(__dirname, 'app/public/login/index.html'));
});

app.use(express.static(path.join(__dirname, 'app/public')));

https.createServer({
	key: privateKey,
	cert: certificate
}, app).listen(port, () => {
	console.log(`Сервер запущен на https://localhost:${port}`);
	connectToDatabase();
});

process.on('SIGINT', async () => {  //  Ctrl+C
	try {
	  console.log('Получен сигнал SIGINT. Завершение работы...');
	  await disconnectFromDatabase();
	} catch (error) {
	  console.error('Ошибка при отключении от БД:', error);
	} finally {
	  process.exit();
	}
});

process.on('SIGTERM', async () => { //  `kill` command
	try {
	  console.log('Получен сигнал SIGTERM. Завершение работы...');
	  await disconnectFromDatabase();
	} catch (error) {
	  console.error('Ошибка при отключении от БД:', error);
	} finally {
	  process.exit();
	}
});