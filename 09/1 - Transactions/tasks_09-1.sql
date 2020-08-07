/**
*	Задание 1.
*	В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных.
*	Переместите запись id = 1 из таблицы shop.users в таблицу sample.users.
*	Используйте транзакции.
*/
-- 1) Для начала пересоздаю БД gb_shop
drop database if exists gb_shop;
create database gb_shop CHARACTER SET utf8 COLLATE utf8_general_ci;
USE gb_shop;

-- 2) Перезаполню БД новыми данными, выпонив скрипт shop.sql

-- 3) Создам с нуля БД gb_sample
drop database if exists gb_sample;
create database gb_sample CHARACTER SET utf8 COLLATE utf8_general_ci;
use gb_sample;

-- 4) Создам в текущей БД таблицу users
DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

use gb_shop;

-- Смотрим что есть в таблицах
select * from gb_shop.users;
select * from gb_sample.users;

-- 5) Перенос пользователя с id = 1
start transaction;
insert into gb_sample.users
	select * from gb_shop.users
    where id = 1;
delete from gb_shop.users
where id = 1;
commit;


/**
*	Задание 2.
*	Создайте представление, которое выводит название name товарной позиции из таблицы products
*	и соответствующее название каталога name из таблицы catalogs.
*/

