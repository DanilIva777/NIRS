const { DataTypes } = require('sequelize');
const { client, sequelize } = require('./client');

const Account = sequelize.define('account', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    login: {
        type: DataTypes.TEXT,
        allowNull: false,
        unique: true
    },
    password: {
        type: DataTypes.TEXT,
        allowNull: false
    },
    info: {
        type: DataTypes.TEXT
    },
    id_otdelenia: {
        type: DataTypes.INTEGER,
        references: {
            model: 'otdelenia',
            key: 'id'
        }
    },
    id_dolzhnosti: {
        type: DataTypes.INTEGER,
        references: {
            model: 'dolzhnost',
            key: 'id'
        }
    }
}, {
    tableName: 'account',
    timestamps: false
});

const Okna = sequelize.define('okna', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    naim_okna: DataTypes.TEXT,
    id_otdelenia: {
        type: DataTypes.INTEGER,
        allowNull: true,
        references: {
            model: 'otdelenia',
            key: 'id'
        }
    }
}, {
    tableName: 'okna',
    timestamps: false
});

const Otdelenia = sequelize.define('otdelenia', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    adres: DataTypes.TEXT,
    naimenovanie: DataTypes.TEXT,
    ecs: DataTypes.BOOLEAN,
    index: DataTypes.TEXT,
    time_obrabotki: DataTypes.TIME
}, {
    tableName: 'otdelenia',
    timestamps: false
});

const Dolzhnost = sequelize.define('dolzhnost', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    naim: DataTypes.TEXT
}, {
    tableName: 'dolzhnost',
    timestamps: false
});

const DolzhnostiOkna = sequelize.define('dolzhnosti_okna', {
    id_okna: {
        type: DataTypes.INTEGER,
        references: {
            model: 'okna',
            key: 'id'
        },
        primaryKey: true
    },
    id_dolzhnosti: {
        type: DataTypes.INTEGER,
        references: {
            model: 'dolzhnost',
            key: 'id'
        },
        primaryKey: true
    }
}, {
    tableName: 'dolzhnosti_okna',
    timestamps: false
});

const Grafik = sequelize.define('grafik', {
    id_account: {
        type: DataTypes.INTEGER,
        references: {
            model: 'account',
            key: 'id'
        },
        primaryKey: true
    },
    den_nedeli: DataTypes.INTEGER,
    time_start: DataTypes.TIME,
    time_stop: DataTypes.TIME
}, {
    tableName: 'grafik',
    timestamps: false
});

const GrafikOtdelenia = sequelize.define('grafik_otdelenia', {
    id_otdelenia: {
        type: DataTypes.INTEGER,
        references: {
            model: 'otdelenia',
            key: 'id'
        },
        primaryKey: true
    },
    den_nedeli: DataTypes.INTEGER,
    pereryv_start: DataTypes.TIME,
    pereryv_stop: DataTypes.TIME,
    start: DataTypes.TIME,
    stop: DataTypes.TIME
}, {
    tableName: 'grafik_otdelenia',
    timestamps: false
});

const TelegramAcc = sequelize.define('telegram_acc', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    fio: DataTypes.TEXT,
    username: DataTypes.TEXT
}, {
    tableName: 'telegram_acc',
    timestamps: false
});

const Talony = sequelize.define('talony', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    id_otdelenia: {
        type: DataTypes.INTEGER,
        references: {
            model: 'otdelenia',
            key: 'id'
        }
    },
    date: DataTypes.DATEONLY,
    time: DataTypes.TIME,
    nom_talona: DataTypes.INTEGER,
    id_uslugi: {
        type: DataTypes.INTEGER,
        references: {
            model: 'uslugi',
            key: 'id'
        }
    },
    time_obr: DataTypes.TIME,
    id_status: {
        type: DataTypes.INTEGER,
        references: {
            model: 'status_obsl',
            key: 'id'
        }
    },
    time_nach_obsl: DataTypes.TIME,
}, {
    tableName: 'talony',
    timestamps: false
});

const TalonyTelegram = sequelize.define('talony_telegram', {
    id_talona: {
        type: DataTypes.INTEGER,
        references: {
            model: 'talony',
            key: 'id'
        },
        primaryKey: true
    },
    id_acc: {
        type: DataTypes.INTEGER,
        references: {
            model: 'telegram_acc',
            key: 'id'
        },
        primaryKey: true
    }
}, {
    tableName: 'talony_telegram',
    timestamps: false
});

const StatusObsl = sequelize.define('status_obsl', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    naim: DataTypes.TEXT
}, {
    tableName: 'status_obsl',
    timestamps: false
});

const Uslugi = sequelize.define('uslugi', {
    id: {
        type: DataTypes.INTEGER,
        primaryKey: true,
        autoIncrement: true
    },
    naim: DataTypes.TEXT
}, {
    tableName: 'uslugi',
    timestamps: false
});

const UslugiSpecialista = sequelize.define('uslugi_specialista', {
    id_uslugi: {
      type: DataTypes.INTEGER,
      references: {
        model: 'uslugi',
        key: 'id',
      },
      primaryKey: true
    },
    id_dolzhnosti: {
      type: DataTypes.INTEGER,
      references: {
        model: 'dolzhnost',
        key: 'id'
      },
      primaryKey: true
    }
}, {
    tableName: 'uslugi_specialista',
    timestamps: false
});

// Определение связей
Account.belongsTo(Otdelenia, { foreignKey: 'id_otdelenia' });
Account.belongsTo(Dolzhnost, { foreignKey: 'id_dolzhnosti' });
Account.hasMany(Grafik, { foreignKey: 'id_account' });

Okna.belongsTo(Otdelenia, { foreignKey: 'id_otdelenia' });
Otdelenia.hasMany(Okna, { foreignKey: 'id_otdelenia' });

Okna.belongsToMany(Dolzhnost, { through: DolzhnostiOkna, foreignKey: 'id_okna' });
Dolzhnost.belongsToMany(Okna, { through: DolzhnostiOkna, foreignKey: 'id_dolzhnosti' });

DolzhnostiOkna.belongsTo(Okna, { foreignKey: 'id_okna' });
DolzhnostiOkna.belongsTo(Dolzhnost, { foreignKey: 'id_dolzhnosti' });

Grafik.belongsTo(Account, { foreignKey: 'id_account' });

Otdelenia.hasMany(GrafikOtdelenia, { foreignKey: 'id_otdelenia', as: 'grafik' });
GrafikOtdelenia.belongsTo(Otdelenia, { foreignKey: 'id_otdelenia' });

Talony.belongsTo(Otdelenia, { foreignKey: 'id_otdelenia' });
Talony.belongsTo(Uslugi, { foreignKey: 'id_uslugi' });
Talony.belongsTo(StatusObsl, { foreignKey: 'id_status' });

TalonyTelegram.belongsTo(Talony, { foreignKey: 'id_talona' });
TalonyTelegram.belongsTo(TelegramAcc, { foreignKey: 'id_acc' });

UslugiSpecialista.belongsTo(Uslugi, { foreignKey: 'id_uslugi' });
UslugiSpecialista.belongsTo(Dolzhnost, { foreignKey: 'id_dolzhnosti' });

module.exports = {
    Account, Okna, Otdelenia, Dolzhnost, DolzhnostiOkna, Grafik, GrafikOtdelenia, TelegramAcc, Talony, TalonyTelegram, StatusObsl, Uslugi, UslugiSpecialista
};