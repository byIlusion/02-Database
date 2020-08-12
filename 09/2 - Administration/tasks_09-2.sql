/**
*	Задание 1.
*	Создайте двух пользователей которые имеют доступ к базе данных shop.
*	Первому пользователю shop_read должны быть доступны только запросы на чтение данных,
*	второму пользователю shop — любые операции в пределах базы данных shop.
*/
-- Выбираем системную БД mysql
use mysql;
-- Смотрим юзеров
select Host, User from user;

-- Добавляем юзера shop_read
create user shop_read;
-- Даем право на чтение
grant select on *.* to shop_read;

-- Добавляем юзера shop
create user shop@localhost identified with mysql_native_password by '1234';
-- Даем все права на БД shop
grant all on gb_shop.* to shop;

drop user shop;

select * from user;

flush privileges;

select user();

show privileges;