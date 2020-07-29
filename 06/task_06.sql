-- Пересоздам БД gb_snet_v1, т.к. нет уверености что у меня она в актуальном состоянии
-- Дропаю БД
DROP DATABASE IF EXISTS gb_snet_v1;
-- Создаем БД gb_snet_v1
CREATE DATABASE gb_snet_v1 CHARACTER SET utf8 COLLATE utf8_general_ci;
-- Переключаюсь на новую БД (В случае с Workbench такая операция имеет место быть. В DBeaver все равно нужно выбирать БД)
USE gb_snet_v1;

-- На этом шаге выполняю скрипт из файла snet_v1.sql... (Но перед выполнением изменил порядок выполнения команд)

-- Теперь БД gb_snet_v1 заполнена. Буду импортировать данные в свою из этой БД.


/**
*	Задание 1.
*	Проанализировать запросы, которые выполнялись на занятии,
*	определить возможные корректировки и/или улучшения (JOIN пока не применять).
*/


/**
*	Задание 2.
*	Пусть задан некоторый пользователь. 
*	Из всех друзей этого пользователя найдите человека, который больше всех общался с нашим пользователем.
*/
-- Для начала определимся с пользователем. То есть найдем пользователя у которого больше всего друзей
/*SELECT
	target_profile_id,
	count(*) as count
FROM friend_requests
-- group by initiator_profile_id
group by target_profile_id
order by count desc;*/

SELECT
	-- count(target_profile_id) as count
    *
from friend_requests
where (initiator_profile_id = 1 or target_profile_id = 1) and status = 'approved';
