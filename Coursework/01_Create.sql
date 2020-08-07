/*

В качестве курсовой работы по СУБД решил разработать Базу Данных для системы управления
движением товара и денежных средств магазина спортивных товаров,
и отдельно магазина электронных компанентов. Пока оффлайн, с перспективой на онлайн.

Система управления содержимым - Content Management System (CMS)

В качестве минимального функционала CMS должна хранить данные:
	- Движение денежных средств (ДС):
		- приход;
        - расход;
        - закуп;
        - реализация;
        - займы;
        - инвестиции.
	- Движение товара:
		- цены;
		- наличие на складе;
        - движение от поставщика.
	- Данные по товарам:
		- артикул;
        - бренд;
        - наименование;
        - описание;
        - изображения;
        - характеристики.

Так как БД изначально будет работать только локально, то работа с юзерами пока что не требуется.
Магазинов будет 2, поэтому логичнее сделать 2 копии БД. И т.к. это копии, то разрабатываться будет только одна БД.

Начну с описания товаров, т.к. эта область мне более понятна. С денежными средствами разберусь потом.
*/


-- Создание БД (чистое)
DROP DATABASE IF EXISTS onmove;
CREATE DATABASE onmove character set utf8 collate utf8_general_ci;
USE onmove;


/**
*	Товары
*/
-- Единицы измерения
DROP TABLE IF EXISTS goods_unit;
CREATE TABLE goods_unit (
	id SERIAL PRIMARY KEY,
    unit VARCHAR(30) NOT NULL,
    `name` VARCHAR(255) NOT NULL,
    INDEX (unit)
) COMMENT = 'Единицы измерения для товаров';

-- Таблица брендов
DROP TABLE IF EXISTS brands;
CREATE TABLE brands (
	id SERIAL PRIMARY KEY COMMENT 'Уникальный ID бренда',
    brand VARCHAR(255) UNIQUE NOT NULL COMMENT 'Наименование бренда',
    brand_fix VARCHAR(255) NOT NULL COMMENT 'Бренд: только символы (a-z, а-я) и цифры (0-9), в нижнем регистре',
    UNIQUE KEY (brand)
) COMMENT = 'Таблица брендов';

-- Основная таблица товаров
DROP TABLE IF EXISTS goods;
CREATE TABLE goods (
	id SERIAL PRIMARY KEY COMMENT 'ID и Артикул (для поиска) товара по совместительству',
    article VARCHAR(255) DEFAULT '' COMMENT 'Номер модели товара от производителя',
    article_fix VARCHAR(255) COMMENT 'Тот же номер модели: только символы (a-z, а-я) и цифры (0-9), в нижнем регистре',
    brand_id BIGINT UNSIGNED COMMENT 'ID бренда. Если NULL, то это товар без бренда (NoName)',
    title VARCHAR(255) NOT NULL COMMENT 'Название товара',
    unit_id BIGINT UNSIGNED COMMENT 'ID единицы измерения данного товара',
    INDEX (article_fix),
    FOREIGN KEY (brand_id)
		REFERENCES brands(id)
		ON DELETE SET NULL
        ON UPDATE CASCADE
) COMMENT = 'Таблица товаров';

-- Таблица описаний
DROP TABLE IF EXISTS descriptions;
CREATE TABLE descriptions (
	goods_id BIGINT UNSIGNED NOT NULL,
    description TEXT COMMENT 'Подробное описание товара',
    UNIQUE KEY (goods_id),
    FOREIGN KEY (goods_id)
		REFERENCES goods(id)
        ON DELETE CASCADE
        ON UPDATE CASCADE
) COMMENT = 'Таблица с подробными описаниями товаров.';

-- Таблица изображений
DROP TABLE IF EXISTS pictures;
CREATE TABLE pictures (
	goods_id BIGINT UNSIGNED COMMENT 'ID товара. Если NULL, то данные о товаре были удалены и нужно сначала удалить соответствующие файлы и только после этого удалаять записи',
    picture VARCHAR(255) NOT NULL COMMENT 'Имя файла изображения',
    INDEX (goods_id),
    FOREIGN KEY (goods_id)
		REFERENCES goods(id)
        ON DELETE SET NULL
        ON UPDATE CASCADE
) COMMENT = 'В этой таблице хранятся изобраежния товаров. Для каждого товара может быть несколько изображений';

-- Таблица характеристик (Тут пока сомнительно, т.к. в данном ключе поиск товаров по характеристикам не возможен)
-- Может быть единицы измерения сформировать в отдельной таблице
-- DROP TABLE IF EXISTS properties;
-- CREATE TABLE properties (
-- 	goods_id BIGINT UNSIGNED NOT NULL,
--     property VARCHAR(50) NOT NULL,
--     `value` VARCHAR(50) NOT NULL,
--     unit VARCHAR(10) NOT NULL,
--     INDEX (goods_id),
--     FOREIGN KEY (goods_id) REFERENCES goods(id)
-- );
-- С таблицами характеристик разберусь чуть позже, так как тут сложные отношения будут.


/**
*	Наличие
*/
-- Таблица складов
DROP TABLE IF EXISTS warehouses;
CREATE TABLE warehouses (
	id SERIAL PRIMARY KEY COMMENT 'ID склада',
    `name` VARCHAR(255) NOT NULL COMMENT 'Название склада'
) COMMENT = 'Здесь записываются все склады какие есть и где может храниться товар';

-- Таблица наличия на складах
DROP TABLE IF EXISTS goods_avail;
CREATE TABLE goods_avail (
	goods_id BIGINT UNSIGNED NOT NULL COMMENT 'ID товара.',
    warehouse_id BIGINT UNSIGNED NOT NULL COMMENT 'ID склада.',
    quantity INT UNSIGNED NOT NULL COMMENT 'Количество товара на данном складе. Не может быть отрицательным!',
    factor INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Кратность товара при покупке.',
    price1 DECIMAL(10,2) UNSIGNED NOT NULL COMMENT 'Закупочная стоимость товара',
    price2 DECIMAL(10,2) UNSIGNED NOT NULL COMMENT 'Стоимость розничной реализации',
    FOREIGN KEY (goods_id)
		REFERENCES goods(id)
        ON UPDATE CASCADE,
    FOREIGN KEY (warehouse_id)
		REFERENCES warehouses(id)
        ON UPDATE CASCADE
) COMMENT = 'Наличие на складах с ценами';

-- Таблица поставщиков
DROP TABLES IF EXISTS providers;
CREATE TABLE providers (
	id SERIAL PRIMARY KEY COMMENT 'ID поставщика',
    `name` VARCHAR(255) NOT NULL COMMENT 'Наименование поставщика',
    days_to_delivery INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Среднее количество дней на доставку от этого поставщика',
    days_delta INT(3) UNSIGNED COMMENT 'Погрешность дней доставки в процентах в обе стороны. Т.е. на сколько может быть увеличен или уменьшен срок доставки'
) COMMENT = 'Таблица поставщиков';

-- Таблица движения товара от поставщика
DROP TABLE IF EXISTS goods_transit;
CREATE TABLE goods_transit (
	goods_id BIGINT UNSIGNED NOT NULL COMMENT 'ID товара.',
    provider_id BIGINT UNSIGNED NOT NULL COMMENT 'ID поставщика.',
    quantity INT UNSIGNED NOT NULL COMMENT 'Количество товара которое едет',
    factor INT UNSIGNED NOT NULL DEFAULT 1 COMMENT 'Кратность товара при покупке.',
    price1 DECIMAL(10,2) UNSIGNED NOT NULL COMMENT 'Закупочная стоимость товара',
    price2 DECIMAL(10,2) UNSIGNED NOT NULL COMMENT 'Стоимость розничной реализации',
    shipped_at DATE NOT NULL COMMENT 'Дата отправки товаров от поставщика',
    FOREIGN KEY (goods_id)
		REFERENCES goods(id)
        ON UPDATE CASCADE,
    FOREIGN KEY (provider_id)
		REFERENCES providers(id)
        ON UPDATE CASCADE
) COMMENT = 'Движение товаров от поставщиков с количеством и ценами';


/**
*	Финансы
*/
-- С финансами пока трудно понять как приавильно. Но пока так...

-- Таблицы счетов
DROP TABLE IF EXISTS financial_types;
CREATE TABLE financial_types (
	id SERIAL PRIMARY KEY,
    `account` VARCHAR(7) NOT NULL COMMENT 'Код бухгалтерского счета',
    title VARCHAR(255) NOT NULL COMMENT 'Название счета',
    `comment` TEXT COMMENT 'Подробное описание счета',
    INDEX (`account`)
) COMMENT = 'Типы бухгалтерских счетов с описанием';

-- Таблица сумм
DROP TABLE IF EXISTS financial_operation;
CREATE TABLE financial_operation (
	id SERIAL PRIMARY KEY,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время проведенной денежной операции',
    account_id BIGINT UNSIGNED NOT NULL COMMENT 'ID бухгалтерского счета. Определяет направление операции',
    amount DECIMAL(10,2) UNSIGNED NOT NULL COMMENT 'Сумма операции',
    INDEX (created_at),
    INDEX (account_id),
    FOREIGN KEY (account_id)
		REFERENCES financial_types(id)
        ON UPDATE CASCADE
) COMMENT = 'Финансовые движения (приходы и расходы)';

