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
-- Таблица брендов (по опыту знаю что лучше отдельно от товаров, т.к. написание бренда может меняться)
DROP TABLE IF EXISTS brands;
CREATE TABLE brands (
	id SERIAL PRIMARY KEY,
    brand VARCHAR(100) UNIQUE NOT NULL,
    brand_fix VARCHAR(100) NOT NULL,
    INDEX (brand)
);

-- Основная таблица товаров
DROP TABLE IF EXISTS goods;
CREATE TABLE goods (
	id serial primary key,
    article VARCHAR(100) NOT NULL,
    article_fix VARCHAR(100) NOT NULL,
    brand_id BIGINT UNSIGNED NOT NULL,
    title VARCHAR(200),
    FOREIGN KEY (brand_id) REFERENCES brands(id)
);

-- Таблица поиска товаров (Вроде тоже нужная...)
DROP TABLE IF EXISTS articlebrands;
CREATE TABLE articlebrands (
	goods_id BIGINT UNSIGNED NOT NULL,
    articlebrand VARCHAR(150) NOT NULL,
    INDEX (articlebrand),
    FOREIGN KEY (goods_id) REFERENCES goods(id)
);

-- Таблица описаний
DROP TABLE IF EXISTS descriptions;
CREATE TABLE descriptions (
	goods_id BIGINT UNSIGNED NOT NULL,
    description TEXT,
    INDEX (goods_id),
    FOREIGN KEY (goods_id) REFERENCES goods(id)
);

-- Таблица изображений
DROP TABLE IF EXISTS pictures;
CREATE TABLE pictures (
	goods_id BIGINT UNSIGNED NOT NULL,
    picture VARCHAR(200) NOT NULL,
    INDEX (goods_id),
    FOREIGN KEY (goods_id) REFERENCES goods(id)
);

-- Таблица характеристик (Тут пока сомнительно, т.к. в данном ключе поиск товаров по характеристикам не возможен)
-- Может быть единицы измерения сформировать в отдельной таблице
DROP TABLE IF EXISTS properties;
CREATE TABLE properties (
	goods_id BIGINT UNSIGNED NOT NULL,
    property VARCHAR(50) NOT NULL,
    `value` VARCHAR(50) NOT NULL,
    unit VARCHAR(10) NOT NULL,
    INDEX (goods_id),
    FOREIGN KEY (goods_id) REFERENCES goods(id)
);

