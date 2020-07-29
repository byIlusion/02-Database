-- 1 получение информации о пользователе: имя, фамилия, город, фото, телефон
select p.name, p. lastname, p.hometown, 
(select file from photos where profile_id = p.id ) as 'photo', 
(select phone from users where id = p.user_id) as 'phone' 
from profiles p
where p.id = 1;

-- 2 Выбираем фотографии пользователя, зная email пользователя 'ddinniesg@google.de'

select * from photos 
where profile_id = (select id from profiles where user_id = 
	(select id from users where email = 'ddinniesg@google.de'));

-- 3 Вывести пользователей, у которых несколько профилей
select count(*) profiles_count, user_id  from profiles group by user_id having profiles_count > 1;

-- 4 архив постов по годам

select count(*) total_posts, profile_id  from posts group by profile_id order by total_posts DESC limit 1;

select count(*), year(created_at) as created_year  from posts where profile_id = 780 group by created_year;

-- 5 Среднее постов по профилям

select AVG(total_posts) from (select count(*) total_posts from posts group by profile_id) as total_posts_tbl;

-- 6 Выбираем друзей пользователя (профиля)

select * from friend_requests where (initiator_profile_id = 1 or target_profile_id = 1) and status = 'approved';

-- 7 Посты друзей пользователя (профиля)

-- 1) получить идентификаторы друзей, чтобы использоывть в in
select * from posts where profile_id 
in (
-- 3,4,10
);

-- 2) id друзей которые отправили приглашения
select initiator_profile_id from friend_requests where target_profile_id = 1 and status = 'approved';
-- 3) id друзей которым 1 пользователь отправил приглашение
select target_profile_id from friend_requests where initiator_profile_id = 1 and status = 'approved';

select * from posts where profile_id = 1
union
select * from posts where profile_id 
in (
select initiator_profile_id from friend_requests where target_profile_id = 1 and status = 'approved'
union
select target_profile_id from friend_requests where initiator_profile_id = 1 and status = 'approved'
)
order by created_at DESC;

-- 8 Находим 10 постов с наибольшим количеством лайков и их авторов

select count(profile_id) total_likes , post_id,
(select concat(name,' ',lastname) from profiles where id = (select profile_id from posts where id = post_id)) as 'author' 
from likes_posts group by post_id order by total_likes desc limit 10;

-- 9 Выводим информацию о количестве непрочитанных сообщений пользователя 1

select count(*), (select concat(name,' ',lastname) from profiles where id = from_profile_id) as sender 
from messages where to_profile_id = 1 and is_read = 0 group by from_profile_id;

-- 10 Информация о друзьях с преобразованием пола и возраста
select id, 
case(gender)
		when 'm' then 'Мужчина'
		when 'f' then 'Женщина'
	end as 'gender', 
timestampdiff(year, birthday, now()) as 'age', 
name, lastname from profiles
where id in (
	select initiator_profile_id from friend_requests where target_profile_id = 1 and status = 'approved'
	union
	select target_profile_id from friend_requests where initiator_profile_id = 1 and status = 'approved'
)

-- inner join (можно решать задание №2)

select * from users u join profiles as p on p.user_id = u.id

-- limit во вложенных запросах
select * from profiles where user_id = (select id from users order by id DESC limit 1);
select * from profiles where user_id = (select id from (select id from users order by id DESC limit 1) tbl);
