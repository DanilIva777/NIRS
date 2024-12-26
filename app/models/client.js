const { Sequelize, DataTypes } = require('sequelize');

const sequelize = new Sequelize('nirs', 'postgres', '159357', {
    host: 'localhost',
    port: 5433,
    dialect: 'postgres'
});

async function connectToDatabase() {
  try {
    await sequelize.authenticate();
    console.log('Connection has been established successfully.');
    return sequelize;
  } catch (error) {
    console.error('Unable to connect to the database:', error);
    throw error;
  }
}

async function disconnectFromDatabase() {
  try {
    await sequelize.close();
    console.log("Отключение от базы данных успешно");
  } catch (err) {
    console.error('Ошибка отключения от базы данных', err.stack);
  }
}

module.exports = { connectToDatabase, disconnectFromDatabase, sequelize };