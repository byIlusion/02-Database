-- Выбираем нужную БД
USE gb_vk;

-- Изменяю режим безопасности чтоб можно было удалять и изменять записиalter
SET SQL_SAFE_UPDATES = 0;

-- Смотрим что есть
SELECT * FROM profiles;


/**
*	Задание 1.
*	Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.
*	(в данном случае таблица profiles)
*/
-- Добавим столбец update_at в таблицу profiles
ALTER TABLE profiles
ADD COLUMN update_at DATETIME
AFTER created_at;

-- Не правильно назвал столбец - переименую
ALTER TABLE profiles
CHANGE COLUMN update_at updated_at DATETIME;


-- Уберем некоторые даты cretaed_at из profiles
UPDATE profiles
SET created_at = NULL
ORDER BY RAND()
LIMIT 20;

-- Заполняем пропущенные даты
UPDATE profiles
SET created_at = NOW()
WHERE created_at is NULL;

UPDATE profiles
SET updated_at = NOW()
WHERE updated_at is NULL;


/**
*	Задание 2.
*	Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы типом VARCHAR
*	и в них долгое время помещались значения в формате 20.10.2017 8:10. Необходимо преобразовать поля к типу DATETIME,
*	сохранив введённые ранее значения.
*/
-- Добавим в таблицу users столбец created_at (для примера)
ALTER TABLE users
ADD COLUMN created_at VARCHAR(20);

-- Смотрим таблицу users
SELECT * FROM users;

-- Забиваем столбец неверными данными
UPDATE users
SET created_at = CONCAT(CEIL(RAND() * 30), '.', CEIL(RAND() * 12), '.', CEIL(RAND() * 10) + 2010, ' ', FLOOR(RAND() * 24), ':', FLOOR(RAND() * 60)) 
WHERE created_at IS NULL;

-- Изменяем написание даты
UPDATE users
SET created_at = STR_TO_DATE(created_at, '%e.%c.%Y %k:%i')
WHERE LENGTH(created_at) <= 16;

-- Изменяем тип столбца
ALTER TABLE users
CHANGE COLUMN created_at created_at DATETIME;

-- Смотрим столбец в новом формате
SELECT u.id, u.email, u.created_at, DATE_FORMAT(u.created_at, '%d.%m.%Y %H:%i') AS formated_date FROM users AS u;

-- Убираем ненужный столбец
ALTER TABLE users
DROP COLUMN created_at;


/**
*	Задание 3.
*	В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры: 0,
*	если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом,
*	чтобы они выводились в порядке увеличения значения value. Однако нулевые запасы должны выводиться в конце, после всех записей.
*/
-- Сначала создам БД gb_shop (с чистого листа...)
DROP DATABASE IF EXISTS gb_shop;
CREATE DATABASE gb_shop CHARACTER SET utf8 COLLATE utf8_general_ci;

-- Переключаюсь на новую БД
USE gb_shop;

-- На этом шаге выполняю скрипт shop.sql

-- Добавим 1 склад
INSERT INTO storehouses (name)
VALUES ('Склад 1');

-- Добавим наличие на склад
INSERT INTO storehouses_products (storehouse_id, product_id, value)
VALUES
	(1, 1, 0),
	(1, 2, 0),
	(1, 3, 0),
	(1, 4, 0),
	(1, 5, 0),
	(1, 6, 0),
	(1, 7, 0);

-- Сделаем случайное наличие для некоторых позиций
UPDATE storehouses_products
SET value = CEIL(RAND() * 100)
ORDER BY RAND()
LIMIT 5;

-- Теперь сортируем по наличию
SELECT *, IF (value > 0, 1, 0) AS in_stock
FROM storehouses_products
ORDER BY in_stock DESC, value ASC;


/**
*	Задание 4.
*	Из таблицы users необходимо извлечь пользователей, родившихся в августе и мае.
*	Месяцы заданы в виде списка английских названий (may, august)
*/
-- Переключаемся обратно на БД gb_vk
USE gb_vk;

-- Выбираем нужных пользователей (из profiles)
SELECT *, DATE_FORMAT(birthday, '%M') AS month_of_birthday
FROM profiles
WHERE DATE_FORMAT(birthday, '%m') = '05'
OR DATE_FORMAT(birthday, '%m') = '08';


/**
*	Задание 5.
*	Из таблицы catalogs извлекаются записи при помощи запроса. SELECT * FROM catalogs WHERE id IN (5, 1, 2);
*	Отсортируйте записи в порядке, заданном в списке IN
*/
-- Переключаемся на БД vk_shop
USE gb_shop;

-- Выбираем из таблицы нужные записи в нужном порядке
SELECT * FROM catalogs
WHERE id IN (5, 1, 2)
ORDER BY FIELD(id, 5, 1, 2);
