/*
	Наполнение БД данными.
*/
USE onmove;

/**
*	Товары
*/
-- Единицы измерения
INSERT INTO goods_unit VALUES
(NULL, 'шт', 'штука'),
(NULL, 'компл', 'комплект');

-- Бренды
INSERT INTO brands VALUES
(NULL, 'Puente', 'puente'),
(NULL, 'UGIN', 'ugin'),
(NULL, 'm-cro', 'mcro'),
(NULL, 'AIELBRO', 'aielbro');

-- Товары
INSERT INTO goods VALUES
(NULL, NULL, NULL, NULL, 'Портативный очиститель велосипедной цепи', 1),
(NULL, NULL, NULL, NULL, 'Вспомогательный инструмент для чистки велосипеда', 1),
(NULL, '8052', '8052', NULL, 'Велосипедные спортивные очки. Цвет синий', 1),
(NULL, '8052', '8052', NULL, 'Велосипедные спортивные очки. Цвет белый', 1),
(NULL, '608RS-ABEC1', '608rsabec1', NULL, 'Подшипники 608RS-ABEC1. Цвет черный. Комплект 10 шт', 2),
(NULL, '608RS-ABEC7', '608rsabec7', NULL, 'Подшипники 608RS-ABEC7. Цвет красный. Комплект 10 шт', 2),
(NULL, '608RS-ABEC9', '608rsabec9', NULL, 'Подшипники 608RS-ABEC9. Цвет синий. Комплект 10 шт', 2),
(NULL, '608ZZ-ABEC7', '608zzabec7', NULL, 'Подшипники 608ZZ-ABEC7. Комплект 10 шт', 2),
(NULL, NULL, NULL, NULL, 'Водонепроницаемый чехол для мобильного телефона. Цвет белый.', 1),
(NULL, NULL, NULL, NULL, 'Водонепроницаемый чехол для мобильного телефона. Цвет черный.', 1),		-- 10
(NULL, NULL, NULL, NULL, 'Водонепроницаемый чехол для мобильного телефона. Цвет зеленый.', 1),
(NULL, NULL, NULL, NULL, 'Водонепроницаемый чехол для мобильного телефона. Цвет фиолетовый.', 1),
(NULL, NULL, NULL, NULL, 'Водонепроницаемый чехол для мобильного телефона. Цвет желтый.', 1),
(NULL, NULL, NULL, NULL, 'Водонепроницаемый чехол для мобильного телефона. Цвет розовый.', 1),
(NULL, NULL, NULL, NULL, 'Водонепроницаемый чехол для мобильного телефона. Цвет синий.', 1),
(NULL, NULL, NULL, NULL, 'Водонепроницаемый чехол для мобильного телефона. Цвет оранжевый.', 1),
(NULL, 'W-E02-B5-104', 'we02b5104', 1, 'Колеса для скейтборда белые с принтом с подшипниками в комплекте', 2),
(NULL, 'Wicked Wolf Wheels', 'wickedwolfwheels', 2, 'Колеса для скейтборда Wicked Wolf Wheels белые с принтом', 2),
(NULL, NULL, NULL, NULL, 'Колеса для скейтборда черные с подшипниками в комплекте', 2),
(NULL, '3A12-6-15', '3a12615', 3, 'Смазка для подшипников. 10 мл.', 1),
(NULL, '161', '161', NULL, 'Велосипедный тросик переключателя скоростей', 1),
(NULL, NULL, NULL, NULL, 'Велосипедный тросик тормозной магистрали', 1);


/**
*	Характеристики
*/
-- Типы характеристик
INSERT INTO prop_types VALUES
	(NULL, 'INT'),
	(NULL, 'FLOAT'),
	(NULL, 'STRING');

-- Характеристики
INSERT INTO prop_descriptions VALUES
	(NULL, 'Цвет', 3, 'Цвет изделия'),
	(NULL, 'Материал', 3, 'Материал изготовления'),
	(NULL, 'Спецификация ABEC', 1, NULL);

-- Значения характеристик
INSERT INTO prop_values VALUES
	(NULL, 1, NULL, NULL, 'Синий'),
	(NULL, 2, NULL, NULL, 'Пластик'),
	(NULL, 1, NULL, NULL, 'Черный'),
	(NULL, 1, NULL, NULL, 'Белый'),
	(NULL, 2, NULL, NULL, 'Металл'),		-- 5
	(NULL, 3, 1, NULL, NULL),
	(NULL, 1, NULL, NULL, 'Красный'),
	(NULL, 3, 7, NULL, NULL),
	(NULL, 3, 9, NULL, NULL),
	(NULL, 2, NULL, NULL, 'Силикон'),	-- 10
	(NULL, 1, NULL, NULL, 'Зеленый'),
	(NULL, 1, NULL, NULL, 'Фиолетовый'),
	(NULL, 1, NULL, NULL, 'Желтый'),
	(NULL, 1, NULL, NULL, 'Розовый'),
	(NULL, 1, NULL, NULL, 'Оранжевый'),	-- 15
	(NULL, 2, NULL, NULL, 'Высокопрочный полиуретан');

-- Связь товара с характеристикой
INSERT INTO goods_properties VALUES
	(1, 1, NULL),
	(1, 2, NULL),
	(2, 2, NULL),
	(2, 3, NULL),
	(3, 2, NULL),
	(3, 1, NULL),
	(4, 2, NULL),
	(4, 4, NULL),
	(5, 5, NULL),
	(5, 3, 'Цвет обоймы'),
	(5, 2, 'Материал обоймы'),
	(5, 6, NULL),
	(6, 5, NULL),
	(6, 7, 'Цвет обоймы'),
	(6, 2, 'Материал обоймы'),
	(6, 8, NULL),
	(7, 5, NULL),
	(7, 1, 'Цвет обоймы'),
	(7, 2, 'Материал обоймы'),
	(7, 9, NULL),
	(8, 5, NULL),
	(8, 5, 'Материал обоймы'),
	(8, 8, NULL),
	(9, 10, NULL),
	(9, 4, 'Цвет вставок'),
	(10, 10, NULL),
	(10, 3, 'Цвет вставок'),
	(11, 10, NULL),
	(11, 11, 'Цвет вставок'),
	(12, 10, NULL),
	(12, 12, 'Цвет вставок'),
	(13, 10, NULL),
	(13, 13, 'Цвет вставок'),
	(14, 10, NULL),
	(14, 14, 'Цвет вставок'),
	(15, 10, NULL),
	(15, 1, 'Цвет вставок'),
	(16, 10, NULL),
	(16, 15, 'Цвет вставок'),
    (17, 16, NULL),
    (17, 4, NULL),
    (18, 16, NULL),
    (18, 4, NULL),
    (19, 16, NULL),
    (19, 3, NULL);


/**
*	Наличие
*/
-- Склады
INSERT INTO warehouses VALUES
(NULL, 'Домашний склад');

-- Наличие на складе
INSERT INTO goods_avail VALUES
(1, 1, 1, 1, 232.92, 400),
(2, 1, 1, 1, 106.40, 150),
(3, 1, 1, 1, 140.22, 270),
(4, 1, 1, 1, 140.22, 270),
-- (5, 1, 0, 1, 233.83, 450),
-- (6, 1, 0, 1, 172.60, 340),
(7, 1, 2, 1, 197.14, 350),
(8, 1, 1, 1, 182.27, 350),
(9, 1, 1, 1, 115.77, 200),
(10, 1, 2, 1, 115.77, 200),
(11, 1, 1, 1, 115.77, 200),
(12, 1, 1, 1, 115.77, 200),
(13, 1, 1, 1, 115.77, 200),
(14, 1, 1, 1, 115.77, 200),
(15, 1, 1, 1, 115.77, 200),
-- (16, 1, 0, 1, 115.77, 200),
-- (17, 1, 0, 1, 769.78, 1100),
(18, 1, 1, 1, 585.32, 900),
(19, 1, 1, 1, 947.38, 1300),
(20, 1, 4, 1, 49.61, 100);
-- (21, 1, 0, 1, 51.59, 100);


/**
*	Финансы
*/
-- Типы бухгалтерских счетов. (тут прям минимум-минимум)
INSERT INTO financial_types VALUES
	(51, 'Расчетный счет', 'Кредит - Оплата с расчетного счета. Дебет - Получение средств на расчетный счет'),
	(60, 'Расчет с поставщиками', 'Кредит - Получение товара от поставщика. Дебет - Оплата товара поставщику'),
	(75, 'Учредители', 'Кредит - Займ средств у учредителя. Дебет - Возврат средств учредителю');

-- Движение средств
INSERT INTO financial_operation VALUES
	(NULL, '2018-08-14 13:04:21', 51, 75, 1000);

