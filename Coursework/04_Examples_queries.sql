-- Вывод характеристик товара по его ID (Используя хранимую процедуру)
CALL pr_goods_properties(5);


-- Поиск товаров по цвету
SELECT
	g.id,
    g.title,
    IF (gp.comment IS NOT NULL, gp.comment, pd.name) AS label,
    CASE
		WHEN pd.prop_type_id = 1 THEN pv.int_value
		WHEN pd.prop_type_id = 2 THEN pv.float_value
		WHEN pd.prop_type_id = 3 THEN pv.string_value
    END AS `value`
FROM prop_values AS pv
LEFT JOIN goods_properties AS gp ON gp.prop_value_id = pv.id
JOIN goods AS g ON g.id = gp.goods_id
JOIN prop_descriptions AS pd ON pd.id = pv.prop_desc_id
WHERE pv.string_value = 'Синий';


-- Просмотр товаров с категориями и ценами, тех что есть в наличии (Используя представление)
SELECT * FROM view_goods_avail;

-- Просмотр категорий (Используя представление)
SELECT * FROM view_categories;

