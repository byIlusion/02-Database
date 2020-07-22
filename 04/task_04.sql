-- NOTE. Префикс «gb_» у баз данных означает «GeekBrains», т.е. выделяю среди прочих своих базы связанные с обучением.

-- Сделаем активной нужную для нас БД
USE gb_vk;

-- В таблице users_communities столбцу is_admin зададим занчение по умолчанию
ALTER TABLE users_communities CHANGE COLUMN is_admin is_admin TINYINT DEFAULT 0;

-- Теперь нужно заполнить БД gb_vk данными из файла snet_v1.sql
-- Для этого пойдем путем не самым простым, т.е. сначала создаю отдельную БД gb_snet_v1, в которую и буду импортировать данные.
-- Дропаю БД, на случай если она уже есть
DROP DATABASE IF EXISTS gb_snet_v1;
-- Создаем БД gb_snet_v1
CREATE DATABASE gb_snet_v1 CHARACTER SET utf8 COLLATE utf8_general_ci;
-- Переключаюсь на новую БД (В случае с Workbench такая операция имеет место быть. В DBeaver все равно нужно выбирать БД)
USE gb_snet_v1;
-- На этом шаге выполняю скрипт из файла snet_v1.sql...
-- Теперь БД gb_snet_v1 заполнена. Буду импортировать данные в свою из этой БД.

-- Опять переключаюсь на свою БД
USE gb_vk;

-- Заполняю таблицу users
INSERT INTO users (email, phone, pass)
	SELECT
		su.email, su.phone, su.pass
	FROM gb_snet_v1.users AS su
	LIMIT 100;

-- Удаляю все записи у которых номер телефона начинается с 9
DELETE FROM users
WHERE phone LIKE '9%';

-- Смотрим сколько осталось записей
SELECT COUNT(*) AS count FROM users;

-- Удалим все остальное
DELETE FROM users;
-- Теперь таблица пустая

-- Еще раз заполняю таблицу users данными
INSERT INTO users (email, phone, pass)
	SELECT
		su.email, su.phone, su.pass
	FROM gb_snet_v1.users AS su
	LIMIT 100, 50;

-- Смотрим минимальный и максимальный ID
SELECT MIN(id) AS min, MAX(id) AS max FROM users;

-- Полностью очищаю таблицу (Тут у меня ничего не вышло из-за ограничения внешнего ключа...)
-- TRUNCATE TABLE users;
-- Поэтому сношу БД и пересоздаю и заполняю заново...


-- Теперь заполняю таблицу profiles
INSERT INTO profiles
	SELECT * FROM gb_snet_v1.profiles AS sp WHERE id BETWEEN 1 and 100;

-- Обновим пароль у юзера с ID = 1
UPDATE users
	SET pass = 'f32fbcf0821be759a4346028fec386200bbcd8d9'
	WHERE id = 1;

