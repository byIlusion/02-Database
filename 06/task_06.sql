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
-- Поиск будет относительно пользователя с id=1
set @p_id = 1;
-- Найдем друзей для пользователя с profile_id = 1
select
    if (initiator_profile_id = @p_id, target_profile_id, initiator_profile_id) as profile_id
from friend_requests
where (initiator_profile_id = @p_id or target_profile_id = @p_id) and status = 'approved';

-- Найдем все переписки с нашим пользователем
select
	*
from messages
where (to_profile_id = @p_id or from_profile_id = @p_id)
and (from_profile_id in (
	select
		if (initiator_profile_id = @p_id, target_profile_id, initiator_profile_id) as profile_id
	from friend_requests
	where (initiator_profile_id = @p_id or target_profile_id = @p_id) and status = 'approved'
));

-- Найдем самого общительного
select
	from_profile_id as profile_id,
	count(from_profile_id) as count
from messages
where (to_profile_id = @p_id or from_profile_id = @p_id)
and (from_profile_id in (
	select
		if (initiator_profile_id = @p_id, target_profile_id, initiator_profile_id) as profile_id
	from friend_requests
	where (initiator_profile_id = @p_id or target_profile_id = @p_id) and status = 'approved'
))
group by from_profile_id
order by count desc
limit 1;

-- Теперь найдем профиль того кто больше всех писал нашему пользователю
select
	*
from profiles
where id in (select profile_id from (
	select
		from_profile_id as profile_id,
		count(from_profile_id) as count
	from messages
	where (to_profile_id = @p_id or from_profile_id = @p_id)
	and (from_profile_id in (
		select
			if (initiator_profile_id = @p_id, target_profile_id, initiator_profile_id) as profile_id
		from friend_requests
		where (initiator_profile_id = @p_id or target_profile_id = @p_id) and status = 'approved'
	))
	group by from_profile_id
	order by count desc
	limit 1
) as tbl);


/**
*	Задание 3.
*	Подсчитать общее количество лайков, которые получили 10 самых молодых пользователей.
*/
-- Смотрим профили 10 пользователей (отсортированных по возрасту) и сколько лайков получил каждый пользователь за посты
select
	pr.*,
    count(lp.id) as count
from profiles as pr
left join posts as p on p.profile_id = pr.id
left join likes_posts as lp on lp.post_id = p.id
group by pr.id
order by pr.birthday desc
limit 10;

-- Теперь найдем сумму лайков этих 10-ти пользователей
select
	sum(tbl.count) as sum_likes
from (
	select
		pr.*,
		count(lp.id) as count
	from profiles as pr
	left join posts as p on p.profile_id = pr.id
	left join likes_posts as lp on lp.post_id = p.id
	group by pr.id
	order by pr.birthday desc
	limit 10
) as tbl;


/**
*	Задание 4.
*	Определить кто больше поставил лайков (всего) - мужчины или женщины?
*/
-- Количество лайков постов сгруппированные по полу
select
	pr.gender,
    count(*) as count
from likes_posts as lp
inner join profiles as pr on pr.id = lp.id
group by pr.gender;

-- Количество лайков фото сгруппированные по полу
select
	pr.gender,
    count(*) as count
from likes_photo as lph
inner join profiles as pr on pr.id = lph.id
group by pr.gender;

-- Общее количество лайков
select
    if (tbl1.gender = 'f', 'Женский', 'Мужской') as gender,
	tbl1.count as count_likes_posts,
	tbl2.count as count_likes_photo,
    tbl1.count + tbl2.count as count_all
from (
	select
		pr.gender,
		count(*) as count
	from likes_posts as lp
	inner join profiles as pr on pr.id = lp.id
	group by pr.gender
) as tbl1
left join (
	select
		pr.gender,
		count(*) as count
	from likes_photo as lph
	inner join profiles as pr on pr.id = lph.id
	group by pr.gender
) as tbl2 on tbl2.gender = tbl1.gender
order by count_all desc;


/**
*	Задание 5.
*	Найти 10 пользователей, которые проявляют наименьшую активность в использовании социальной сети.
*
*	Предположим что активность будем измерять в баллах за каждое действие:
*		- пост - 1;
*		- репост - 0.5;
*		- фото - 0.6;
*		- комментарий - 0.2;
*		- лайк - 0.1;
*		- состояние в сообществах - 0.2;
*/
-- Количество постов с группировкой по пользователям
select profile_id, count(*) as post_active from posts group by profile_id;

-- репосты
select reposted_from as profile_id, count(*) * 0.5 as repost_active from reposts group by reposted_from;

-- фото
select profile_id, count(*) * 0.6 as photo_active from photos group by profile_id;

-- комментарии
select profile_id, count(*) * 0.2 as comments_active from comments group by profile_id;

-- лайки
select profile_id, count(*) * 0.1 as likes_posts_active from likes_posts group by profile_id;
select profile_id, count(*) * 0.1 as likes_photo_active from likes_photo group by profile_id;

-- сообщества
select profile_id, count(*) * 0.2 as communities_active from users_communities group by profile_id;

-- Теперь с активностью
select
	pr.*,
    /*if (t_p.post_active is null, 0, t_p.post_active) as post_active,
    if (t_rp.repost_active is null, 0, t_rp.repost_active) as repost_active,
    if (t_ph.photo_active is null, 0, t_ph.photo_active) as photo_active,
    if (t_c.comments_active is null, 0, t_c.comments_active) as comments_active,
    if (t_lp.likes_posts_active is null, 0, t_lp.likes_posts_active) as likes_posts_active,
    if (t_lph.likes_photo_active is null, 0, t_lph.likes_photo_active) as likes_photo_active,
    if (t_com.communities_active is null, 0, t_com.communities_active) as communities_active,*/
    if (t_p.post_active is null, 0, t_p.post_active) +
    if (t_rp.repost_active is null, 0, t_rp.repost_active) +
    if (t_ph.photo_active is null, 0, t_ph.photo_active) +
    if (t_c.comments_active is null, 0, t_c.comments_active) +
    if (t_lp.likes_posts_active is null, 0, t_lp.likes_posts_active) +
    if (t_lph.likes_photo_active is null, 0, t_lph.likes_photo_active) +
    if (t_com.communities_active is null, 0, t_com.communities_active) as active
from profiles as pr
left join (
	select profile_id, count(*) as post_active from posts group by profile_id
) as t_p on t_p.profile_id = pr.id
left join (
	select reposted_from as profile_id, count(*) * 0.5 as repost_active from reposts group by reposted_from
) as t_rp on t_rp.profile_id = pr.id
left join (
	select profile_id, count(*) * 0.6 as photo_active from photos group by profile_id
) as t_ph on t_ph.profile_id = pr.id
left join (
	select profile_id, count(*) * 0.2 as comments_active from comments group by profile_id
) as t_c on t_c.profile_id = pr.id
left join (
	select profile_id, count(*) * 0.1 as likes_posts_active from likes_posts group by profile_id
) as t_lp on t_lp.profile_id = pr.id
left join (
	select profile_id, count(*) * 0.1 as likes_photo_active from likes_photo group by profile_id
) as t_lph on t_lph.profile_id = pr.id
left join (
	select profile_id, count(*) * 0.2 as communities_active from users_communities group by profile_id
) as t_com on t_com.profile_id = pr.id
order by active
limit 10;

