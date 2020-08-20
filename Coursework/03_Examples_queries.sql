-- Выборка всех характеристик товара
SELECT
	gp.*
FROM goods_properties AS gp
LEFT JOIN properties AS p ON p.id = gp.prop_id
WHERE gp.goods_id = 9;

SELECT
	*
FROM goods_properties AS gp
LEFT JOIN prop_types AS pt ON pt.id = gp.prop_type_id
LEFT JOIN prop_value_types AS pvt ON pvt.id = pt.prop_value_type_id
-- LEFT JOIN pvt.`table_name` AS val ON val.id = gp.prop_value_id
WHERE gp.goods_id = 9;


