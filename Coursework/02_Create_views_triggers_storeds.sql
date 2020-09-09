/*
	Добавление к БД дополнительных инструментов управления
*/
USE onmove;

/**
*	Триггеры
	Триггеры нужны на таблица с категориями и товарами
    чтобы всегда иметь актуальное состояние количества подкатегорий и товаров в каждой категории каталога.
    Это нужно чтобы знать какие категории не стоит показывать при запросах.
*/
DELIMITER //
-- Триггер на добавление категорий
DROP TRIGGER IF EXISTS update_count_categories//
CREATE TRIGGER update_count_categories AFTER INSERT ON categories
FOR EACH ROW
BEGIN
	IF (SELECT COUNT(*) FROM categories_stats WHERE id = NEW.id) = 0 THEN
		INSERT INTO categories_stats (id) VALUES (NEW.id);
    END IF;
    IF NEW.parent_id <> 0 THEN
		UPDATE categories_stats
        -- SET count_child_categories = (SELECT count_child_categories FROM categories WHERE id = NEW.parent_id) + 1
        SET count_child_categories = count_child_categories + 1
        WHERE id = NEW.parent_id;
    END IF;
END//

-- Триггер на добавление товаров
DROP TRIGGER IF EXISTS update_count_goods//
CREATE TRIGGER update_count_goods BEFORE INSERT ON goods
FOR EACH ROW
BEGIN
    IF NEW.parent_id <> 0 THEN
		SET @root := FALSE;
        SET @id := NEW.parent_id;
        WHILE NOT @root DO
			IF NEW.parent_id = @id THEN
				UPDATE categories_stats
				SET count_goods = count_goods + 1,
				count_goods_all = count_goods_all + 1
				WHERE id = @id;
			ELSE
				UPDATE categories_stats
				SET count_goods_all = count_goods_all + 1
				WHERE id = @id;
            END IF;
            SELECT parent_id INTO @id FROM categories WHERE id = @id;
            IF @id = 0 THEN
				SET @root := TRUE;
            END IF;
		END WHILE;
    END IF;
END//
DELIMITER ;


/**
*	Представления
*/
-- Простой доступ к основной информации (описание, цены и наличие) по товарам
DROP VIEW IF EXISTS view_goods_avail;
CREATE VIEW view_goods_avail AS
	SELECT
		g.id,
		g.title,
		IF (b.brand IS NOT NULL, b.brand, '') AS brand,
		IF (g.article IS NOT NULL, article, '') AS `code`,
		c.title AS category,
		ga.quantity,
		ga.price2 AS price,
		CONCAT(ga.quantity, ' ', gu.unit) AS avail,
		w.name AS warehouse
	FROM goods AS g
	LEFT JOIN brands AS b ON b.id = g.brand_id
	JOIN goods_unit AS gu ON gu.id = g.unit_id
	LEFT JOIN categories AS c ON c.id = g.parent_id
	JOIN goods_avail AS ga ON ga.goods_id = g.id
	JOIN warehouses AS w ON w.id = ga.warehouse_id
	WHERE ga.quantity > 0;

-- Представление с просмотром категорий. в которых есть товары
DROP VIEW IF EXISTS view_categories;
CREATE VIEW view_categories AS
	SELECT
		c.id,
		c.title,
		cs.count_child_categories,
		cs.count_goods,
		c.description,
        c.parent_id
	FROM categories AS c
	JOIN categories_stats AS cs ON cs.id = c.id
	WHERE cs.count_goods_all > 0;


/**
*	Хранимые процедуры
*/
-- Запрос характеристик товара

DELIMITER //
-- Создаю функцию (предварительно удалив)
DROP PROCEDURE IF EXISTS pr_goods_properties//
CREATE PROCEDURE pr_goods_properties(IN c_id BIGINT)
BEGIN
	SELECT
		gp.goods_id,
		IF (gp.comment IS NOT NULL, gp.comment, pd.name) AS label,
		CASE
			WHEN pd.prop_type_id = 1 THEN pv.int_value
			WHEN pd.prop_type_id = 2 THEN pv.float_value
			WHEN pd.prop_type_id = 3 THEN pv.string_value
		END AS `value`,
		pd.description,
        pt.`type`
	FROM goods_properties AS gp
	JOIN prop_values AS pv ON pv.id = gp.prop_value_id
	JOIN prop_descriptions AS pd ON pd.id = pv.prop_desc_id
    JOIN prop_types AS pt ON pt.id = pd.prop_type_id
	WHERE goods_id = c_id;
END//
DELIMITER ;

