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
        ON UPDATE CASCADE,
	FOREIGN KEY (unit_id)
		REFERENCES goods_unit(id)
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


/**
*	Характеристики товаров
*/
-- Типы характеристик
DROP TABLE IF EXISTS prop_types;
CREATE TABLE prop_types (
	id INT UNSIGNED NOT NULL AUTO_INCREMENT UNIQUE PRIMARY KEY,
    `type` VARCHAR(255) NOT NULL
);

-- Описание конкретных видов характеристик
DROP TABLE IF EXISTS prop_descriptions;
CREATE TABLE prop_descriptions (
	id SERIAL PRIMARY KEY,
    `name` VARCHAR(255) NOT NULL COMMENT 'Наименование характеристики',
    prop_type_id INT UNSIGNED NOT NULL COMMENT 'ID типа характеристики',
    description TEXT COMMENT 'Описание характеристики',
    FOREIGN KEY (prop_type_id)
		REFERENCES prop_types(id)
        ON UPDATE CASCADE
);

-- Значения характеристик
DROP TABLE IF EXISTS prop_values;
CREATE TABLE prop_values (
	id SERIAL PRIMARY KEY,
    prop_desc_id BIGINT UNSIGNED NOT NULL COMMENT 'ID характеристики',
    -- prop_type_id BIGINT UNSIGNED NOT NULL COMMENT 'ID типа характеристики',
    int_value INT,
    float_value FLOAT,
    string_value VARCHAR(255),
    INDEX (prop_desc_id),
    INDEX (int_value),
    INDEX (float_value),
    INDEX (string_value),
	FOREIGN KEY (prop_desc_id)
		REFERENCES prop_descriptions(id)
        ON UPDATE CASCADE
	-- FOREIGN KEY (prop_type_id)
-- 		REFERENCES prop_types(id)
--         ON UPDATE CASCADE
) COMMENT = 'Таблица значений характеристик для товаров';

-- Связь характеристик с товарами
DROP TABLE IF EXISTS goods_properties;
CREATE TABLE goods_properties (
    goods_id BIGINT UNSIGNED NOT NULL,
    prop_value_id BIGINT UNSIGNED NOT NULL,
    `comment` VARCHAR(255) COMMENT 'Краткий дополнительный комментарий по данной характеристике',
    FOREIGN KEY (goods_id)
		REFERENCES goods(id)
        ON UPDATE CASCADE
        ON DELETE CASCADE,
    FOREIGN KEY (prop_value_id)
		REFERENCES prop_values(id)
        ON UPDATE CASCADE
) COMMENT = 'Таблица связывает товар со значениями характеристики';


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
    -- account_type TINYINT NOT NULL COMMENT 'Дебет(1) или Кредит(0)',
    account_code INT UNSIGNED PRIMARY KEY NOT NULL COMMENT 'Код бухгалтерского счета',
    title VARCHAR(255) NOT NULL COMMENT 'Название счета',
    `comment` TEXT COMMENT 'Подробное описание счета'
    -- CONSTRAINT `account` PRIMARY KEY (account_type, account_code)
    -- CONSTRAINT `account` PRIMARY KEY (account_code)
) COMMENT = 'Типы бухгалтерских счетов с описанием';

-- Таблица сумм
DROP TABLE IF EXISTS financial_operation;
CREATE TABLE financial_operation (
	id SERIAL PRIMARY KEY,
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT 'Время проведенной денежной операции',
    account_debet INT UNSIGNED NOT NULL COMMENT 'Код дебетового счета',
    account_credit INT UNSIGNED NOT NULL COMMENT 'Код кредитового счета',
    amount DECIMAL(10,2) UNSIGNED NOT NULL COMMENT 'Сумма операции',
    INDEX (created_at),
    INDEX (account_debet, account_credit),
    FOREIGN KEY (account_debet)
		REFERENCES financial_types(account_code)
        ON UPDATE CASCADE,
    FOREIGN KEY (account_credit)
		REFERENCES financial_types(account_code)
        ON UPDATE CASCADE
) COMMENT = 'Финансовые движения (приходы и расходы)';


-- Операции с товарами и деньгами
DROP TABLE IF EXISTS goods_operations;
CREATE TABLE goods_operations (
	id SERIAL PRIMARY KEY,
    fo_id BIGINT UNSIGNED NOT NULL COMMENT 'ID финансовой операции',
    goods_id BIGINT UNSIGNED NOT NULL COMMENT 'ID товара',
    FOREIGN KEY (fo_id)
		REFERENCES financial_operation(id)
        ON UPDATE CASCADE,
	FOREIGN KEY (goods_id)
		REFERENCES goods(id)
        ON UPDATE CASCADE
) COMMENT = 'Таблица для связи операций с товарами и денежными операциями';

