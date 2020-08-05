/**
*	Задание 1.
*	Составьте список пользователей users, которые осуществили хотя бы один заказ orders в интернет магазине.
*/
-- 1) Для начала переключаемся на таблицу gb_shop
USE gb_shop;

-- 2) Перезаполню БД новыми данными, выпонив скрипт shop.sql

-- 3) Смотрим что вообще есть в orders и в orders_products
select * from orders as o
join orders_products as op on op.order_id = o.id;

-- Таблицы пустые, по этому нужно сгенерировать какие-то данные.
-- 4) Генерирую данные на сайте filldb.info
-- 5) Полученный файл fulldb-03-08-2020-03-19-beta.sql модифицирую и загружаю в БД

-- 6) Выбираем пользователей, у которых есть хотя бы один заказ
select
	u.id,
    u.name,
    count(u.id) as orders_count
from users as u
inner join orders as o on o.user_id = u.id
group by u.id;

/**
*	Задание 2.
*	Выведите список товаров products и разделов catalogs, который соответствует товару.
*/
select
	op.order_id,
    p.name,
    p.description,
    c.name as catalog
from orders_products as op
left join products as p on p.id = op.product_id
left join catalogs as c on c.id = p.catalog_id
order by op.order_id, p.name;

/**
*	Задание 3.
*	Пусть имеется таблица рейсов flights (id, from, to) и таблица городов cities (label, name).
*	Поля from, to и label содержат английские названия городов, поле name — русское.
*	Выведите список рейсов flights с русскими названиями городов.
*/
-- Для этого нужно сначала создать временную БД
drop database if exists gb_temp;
create database gb_temp CHARACTER SET utf8 COLLATE utf8_general_ci;
-- Переключаюсь
use gb_temp;

-- Теперь создаю и заполняю таблицы данными
drop table if exists flights;
create table flights (
	id serial primary key,
    `from` varchar(255),
    `to` varchar(255)
);
insert into flights values
(null, 'moscow', 'omsk'),
(null, 'novgorod', 'kazan'),
(null, 'irkutsk', 'moscow'),
(null, 'omsk', 'irkutsk'),
(null, 'moscow', 'kazan');

drop table if exists cities;
create table cities (
	label varchar(255) primary key,
    `name` varchar(255)
);
insert into cities values
('moscow', 'Москва'),
('irkutsk', 'Иркутск'),
('novgorod', 'Новгород'),
('kazan', 'Казань'),
('omsk', 'Омск');

-- Вывод рейсов
-- Способ 1
select
	f.id,
    cf.name as `from`,
    ct.name as `to`
from flights as f
join cities as cf on cf.label = f.from
join cities as ct on ct.label = f.to;

-- Способ 2
select
	f.id,
    (select `name` from cities where label = f.`from`) as `from`,
    (select `name` from cities where label = f.`to`) as `to`
from flights as f;
