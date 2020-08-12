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

-- Добавляем юзера shop_read с доступом с любого хоста
create user 'shop_read'@'%';
-- Даем право только на чтение со всех БД и всех таблиц
grant select on *.* to 'shop_read'@'%';

-- Добавляем юзера shop с доступом только с локального хоста
create user 'shop'@'localhost' identified by '1234';
-- Даем все права на БД gb_shop
grant all on gb_shop.* to 'shop'@'localhost';


/**
*	Задание 2.
*	Пусть имеется таблица accounts содержащая три столбца id, name, password,
*	содержащие первичный ключ, имя пользователя и его пароль.
*	Создайте представление username таблицы accounts, предоставляющий доступ к столбца id и name.
*	Создайте пользователя user_read, который бы не имел доступа к таблице accounts,
*	однако, мог бы извлекать записи из представления username.
*/
-- Представление (назову accounts_view) буду добавлять в БД gb_vk, которое будет объединять значения таблиц users и profiles.

-- Поэтому выбираю БД gb_vk
use gb_vk;
-- Создаю представление
create or replace view accounts_view as
	select
		u.id,
		p.id as profile_id,
		p.name,
		p.surname,
		u.email,
		u.phone,
		p.birthday
	from users as u
	left join profiles as p on p.user_id = u.id;

-- Проверяю что отдает представление
select * from accounts_view;

-- Теперь создаю пользователя user_read в mysql без пароля
create user 'user_read'@'%';
-- Даю пользователю право только на чтение в БД gb_vk только представления accounts_view
grant select on gb_vk.accounts_view to 'user_read'@'%';
-- Проверяю из консоли...
-- Пример в скриншотах приложен.
