-- колонке is_admin с типом данных 
-- BOOL из таблицы users_communities можно присвоить значение по умолчанию 
-- FALSE, т.к. большинство юзеров в группе будут не админами.
alter table users_communities change column `is_admin` `is_admin` tinyint default 0;

-- CRUD

-- create INSERT
-- read SELECT
-- update UPDATE
-- delete delete, TRUNCATE

-- INSERT 1.1
INSERT INTO `users` VALUES (1,'kjaspar0@addtoany.com','970-336-0773','05ca4e4fb4f920ef9eef7315b95478ce3ac0e589');

-- INSERT 1.2
INSERT INTO `users` (email, phone, pass ) 
values ('tseabert1@yellowpages.com','885-270-6713','f32fbcf0821be759a4346028fec386200bbcd8d9');

-- INSERT 1.3
INSERT INTO `users` values
(3,'drudd2@tripadvisor.com','534-711-6937','4f25c59ed96ed8a830b1cabcae4d6f19a387877a'),
(4,'kgaisford3@google.co.jp','972-386-6726','1b14b5bdbdb4e6e3b7941af7475e7891eb248cea'),
(5,'oboagey4@timesonline.co.uk','571-714-2497','9dd0fbbed7cbce4df85dc9280513f3810410c44a'),
(6,'zsutton5@washingtonpost.com','400-172-7693','bd86b1eec80ea467f4aeac07bcc5a60306a29441'),
(7,'fbarbour6@tinyurl.com','127-504-6540','71cf76eecc785f2d5f6102e5e8fa044cda0eef52'),
(8,'prafter7@ca.gov','335-828-3373','d839f0b7c3758e59da25e7aaf5d40860eca15939'),
(9,'kerickssen8@infoseek.co.jp','628-923-6993','ce8e73dab2bf9fdca65c6ae660595f31b1527fc1'),
(10,'ejoubert9@edublogs.org','391-257-0069','0fafa0dc0b39a2db72d3b2aedc9d3c54389df107');

-- INSERT ОШИБКА 

INSERT INTO `users` (email, phone, pass ) 
values ('885-270-6713','f32fbcf0821be759a4346028fec386200bbcd8d9');

-- INSERT 2

INSERT `users` 
	set email = 'mmationa@barnesandnoble.com', 
		phone = '817-403-5120', 
		pass =  '04f12bf833d2d44cf8eaf92163277e1172575535';
	
-- Добавили данные связанные с users по ключу

INSERT INTO `profiles` VALUES (1,1,'m','Сергей','Сергеев','1983-03-21',395,'2020-07-17 19:24:04','Одинцово');

INSERT INTO `profiles` (user_id, gender, name, surname, birthday, photo_id, hometown ) VALUES 
(2,'f','Вера','Клюквина','1987-03-15',652,'Сатка');

-- INSERT 3 (INSERT...SELECT)

INSERT INTO vk0907.`users` (email, phone, pass ) 
select email, phone, pass from snet_v1.`users` where snet_v1.`users`.id between 12 and 100;

INSERT INTO vk0907.`users` (email, phone, pass ) 
select email, phone, pass from snet_v1.`users` where snet_v1.`users`.id between 101 and 150;

INSERT INTO vk0907.profiles (user_id,gender, name, surname,birthday,photo_id, created_at,hometown)
select user_id,gender, name, lastname,birthday,photo_id, created_at,hometown from snet_v1.`profiles` 
where snet_v1.`profiles`.id between 3 and 100;

INSERT INTO vk0907.profiles (user_id,gender, name, surname,birthday,photo_id, created_at,hometown)
select user_id,gender, name, lastname,birthday,photo_id, created_at,hometown from snet_v1.`profiles` 
where snet_v1.`profiles`.id limit 50;


-- update UPDATE

update friend_requests 
	set satus = 'approved'
where initiator_user_id = 1 and target_user_id = 2;

--  SELECT 

select "HELLO!";

select 5+7;

select name, surname from profiles; 

select * from profiles;

select * from profiles limit 10;

select distinct name from profiles;

select * from profiles limit 10 offset 10;

select * from profiles limit 3 offset 6; 
select * from profiles limit 6,3;

select * from profiles where name='Артем';

select * from profiles where name like 'а%а';

select * from profiles where name like 'а__а';

select * from profiles where id>=80 and id<=93;
select * from profiles where id between 80 and 93;

select concat(name,' ',surname) as profiles_list from profiles;

select * from friend_requests where satus = 'approved' or satus ='requested';
select * from friend_requests where satus in ('approved','requested');

select COUNT(*) from profiles where name = 'Анна';
select name, COUNT(*) from profiles group by name;
select name, COUNT(*) as person from profiles group by name order by person DESC;

-- DELETE

delete from profiles where id>89;
delete from profiles;

-- TRUNCATE 
truncate table profiles;

