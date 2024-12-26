const { Account, Dolzhnost } = require('../models/modelsDB');

async function authenticateUser(login, password) {
    try {
        const user = await Account.findOne({
            where: { login },
            include: Dolzhnost,
        });

        if (!user || password !== user.password) {
            return { success: false, message: 'Неверный логин или пароль' };
        }

        const redirectUrl = determineRedirectUrl(user.dolzhnost.naim);

        return {
            success: true,
            redirectUrl,
            user: {
                id: user.id,
                login: user.login,
                dolzhnost: user.dolzhnost.naim,
            },
        };
    } catch (error) {
        console.error(`Ошибка при аутентификации login = ${login}, password = ${password}:`, error);
        return { success: false, message: 'Ошибка сервера' };
    }
}

function logoutUser(req, res) {
    req.session.destroy(err => {
        if (err) {
            console.error('Ошибка удаления ссесии:', err);
            return res.status(500).json({ message: 'Ошибка сервера' });
        }
        return res.json({ message: 'Выход выполнен' });
    });
}


function determineRedirectUrl(dolzhnost) {
    switch (dolzhnost) {
        case 'Администратор':
            return '/admin';
        case 'Руководитель':
            return '/operator';
        case 'Сотрудник':
            return '/user';
        case 'Терминал выдачи талонов':
            return '/user';
        case 'Терминал вывода':
            return '/user';
        case 'user':
            return '/user';
        default:
            return '/';
    }
}

module.exports = { authenticateUser, determineRedirectUrl, logoutUser };