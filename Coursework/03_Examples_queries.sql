-- Вывод характеристик товара
SELECT
	gp.goods_id,
    IF (gp.comment IS NOT NULL, gp.comment, pd.name) AS label,
    CASE
		WHEN pd.prop_type_id = 1 THEN pv.int_value
		WHEN pd.prop_type_id = 2 THEN pv.float_value
		WHEN pd.prop_type_id = 3 THEN pv.string_value
    END AS `value`,
    pd.description
FROM goods_properties AS gp
JOIN prop_values AS pv ON pv.id = gp.prop_value_id
JOIN prop_descriptions AS pd ON pd.id = pv.prop_desc_id
WHERE goods_id = 5;


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
