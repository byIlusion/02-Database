/**
*	Задание 1.
*	Подсчитайте средний возраст пользователей в таблице users.
*/
-- Выбираем нужную БД (gb_vk)
USE gb_vk;

-- Посмотрим возраст полных лет каждого пользователя
SELECT
	*,
    (FLOOR((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(birthday)) / (60*60*24*365.25))) AS age
FROM profiles;

-- Смотрим средний возраст пользователей в таблице profiles
SELECT
    -- ROUND(SUM(FLOOR((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(birthday)) / (60*60*24*365.25))) / COUNT(*), 1) AS middle_age
    ROUND(AVG(FLOOR((UNIX_TIMESTAMP(NOW()) - UNIX_TIMESTAMP(birthday)) / (60*60*24*365.25))), 1) AS middle_age
FROM profiles;


/**
*	Задание 2.
*	Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
*	Следует учесть, что необходимы дни недели текущего года, а не года рождения.
*/
SELECT
	DATE_FORMAT(p.birthday + INTERVAL (DATE_FORMAT(NOW(), '%Y') - DATE_FORMAT(p.birthday, '%Y')) YEAR, '%w') AS day_num,
    COUNT(*) AS total
FROM profiles AS p
WHERE birthday IS NOT NULL
GROUP BY day_num;


/**
*	Задание 3.
*	Подсчитайте произведение чисел в столбце таблицы.
*/
-- 
-- Будем брать произведение значений из колонки id в таблице gb_shop.catalogs
SELECT
    ROUND(EXP(SUM(LOG(id)))) AS mul
FROM gb_shop.catalogs;
