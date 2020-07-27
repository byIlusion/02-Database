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
-- На этом шаге выполняю скрипт из файла snet_v1.sql... (Но перед выполнением изменил порядок выполнения команд)
-- Теперь БД gb_snet_v1 заполнена. Буду импортировать данные в свою из этой БД.

-- Опять переключаюсь на свою БД
USE gb_vk;

-- Заполняю таблицу users
INSERT INTO users (email, phone, pass)
	SELECT
		su.email, su.phone, su.pass
	FROM gb_snet_v1.users AS su
	LIMIT 100;

-- Теперь заполняю таблицу profiles
INSERT INTO profiles
	SELECT * FROM gb_snet_v1.profiles AS sp WHERE id BETWEEN 1 and 100;

-- Изменяю режим безопасности чтоб можно было удалять и изменять записиalter
SET SQL_SAFE_UPDATES = 0;

-- Удаляю все записи из profiles, которые моложе 1987 г.р.
DELETE FROM profiles
WHERE birthday > '1987-01-01';

-- Смотрим сколько осталось записей
SELECT COUNT(*) AS count FROM profiles;

-- Удалим все остальное
DELETE FROM profiles;
-- Теперь таблица пустая

-- Еще раз заполняю таблицу users данными
INSERT INTO profiles (user_id, gender, name, surname, birthday, photo_id, created_at, hometown)
	SELECT
		sp.user_id, sp.gender, sp.name, sp.surname, sp.birthday, sp.photo_id, sp.created_at, sp.hometown
    FROM gb_snet_v1.profiles AS sp
    LIMIT 100;

-- Смотрим минимальный и максимальный ID
SELECT MIN(id) AS min, MAX(id) AS max FROM profiles;

-- Полностью очищаю таблицу
TRUNCATE TABLE profiles;

-- Еще раз добавляем данные, только теперь все профили ко всем юзерам
INSERT INTO profiles (user_id, gender, name, surname, birthday, photo_id, created_at, hometown)
	SELECT
		sp.user_id, sp.gender, sp.name, sp.surname, sp.birthday, sp.photo_id, sp.created_at, sp.hometown
    FROM gb_snet_v1.profiles AS sp
    WHERE user_id IN (SELECT id FROM users AS u);

-- Изменим фамилию
UPDATE profiles
	SET surname = 'Клюквина-Сергеева'
	WHERE id = 2;


-- Заполняем остальные таблицы
INSERT INTO communities
	SELECT * FROM gb_snet_v1.communities;

INSERT INTO friend_requests
	SELECT * FROM gb_snet_v1.friend_requests;

INSERT INTO messages
	SELECT * FROM gb_snet_v1.messages AS sm
    WHERE sm.from_profile_id <= 100
    AND sm.to_profile_id <= 100
    LIMIT 100;

INSERT INTO photos
	SELECT * FROM gb_snet_v1.photo AS sp
    WHERE sp.profile_id <= 100
    LIMIT 500;

INSERT INTO posts
	SELECT * FROM gb_snet_v1.posts AS sp
    WHERE sp.profile_id <= 100
    LIMIT 500;

-- Добавим репост
INSERT INTO repost (post_id, reposted_to, reposted_from)
	VALUES (
		(SELECT MIN(p.id) FROM posts AS p),
        (SELECT MAX(u.id) FROM users AS u),
        (SELECT MIN(u2.id) + 5 FROM users AS u2)
    );

