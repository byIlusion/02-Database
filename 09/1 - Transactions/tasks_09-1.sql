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
create view prods_cats as
	select
		p.id as product_id,
		p.name as product_name,
		c.name as `catalog_name`
	from products as p
	join catalogs as c on c.id = p.catalog_id;

-- Выберем все из представления
select * from prods_cats;


/**
*	Задание 3.
*	Пусть имеется таблица с календарным полем created_at.
*	В ней размещены разряженые календарные записи за август 2018 года '2018-08-01', '2016-08-04', '2018-08-16' и 2018-08-17.
*	Составьте запрос, который выводит полный список дат за август, выставляя в соседнем поле значение 1,
*	если дата присутствует в исходном таблице и 0, если она отсутствует.
*/
-- Создадим БД для теста
create database gb_test character set utf8 collate utf8_general_ci;
-- Переключимся на новую БД
use gb_test;
-- Создадим таблицу
create table test (
	id serial primary key,
    created_at date
);
-- Заполним данными
insert into test (created_at) values
	('2018-08-01'),
	('2016-08-04'),
	('2018-08-16'),
	('2018-08-17');

-- Создадим переменную с номером месяца
set @month_num := 8;
-- Выборка по условию задачи
select
	date_format(dates, '%d %b') as dates,
    if (test.id is not null, 1, 0) as exists_rows,
    test.id
from (
	select makedate(year(now()),1) + interval (@month_num - 1) month + interval (d.day_num - 1) day as dates
	from (
		select t*10+u as day_num from
			(select 0 as t union select 1 union select 2 union select 3) as a,
			(select 0 as u union select 1 union select 2 union select 3 union select 4 union select 5 union select 6 union select 7 union select 8 union select 9) as b
		having day_num between 1 and (date_format(LAST_DAY(concat('2020-', @month_num, '-01')), '%d'))
		order by day_num) as d
) as dates
left join test on date_format(test.created_at, '%m-%d') = date_format(dates.dates, '%m-%d')
order by dates;


/**
*	Задача 4.
*	Пусть имеется любая таблица с календарным полем created_at.
*	Создайте запрос, который удаляет устаревшие записи из таблицы, оставляя только 5 самых свежих записей.
*/

