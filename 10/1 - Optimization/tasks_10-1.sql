/**
*	Задание 1.
*	Создайте таблицу logs типа Archive.
*	Пусть при каждом создании записи в таблицах users, catalogs и products в таблицу logs помещается:
*		время и дата создания записи,
*       название таблицы,
*       идентификатор первичного ключа
*       содержимое поля name.
*/
-- Выбираю по-умолчанию gb_shop
use gb_shop;

-- Саздую с нуля таблицу logs
drop table if exists `logs`;
create table `logs` (
	created_at datetime not null default now() comment 'Дата и время добавления записи',
    `table` varchar(255) not null comment 'Название таблицы в которую была добавлена текущая строка',
    id_row bigint unsigned not null comment 'ID добавленной строки',
    `name` varchar(255) comment 'Содержимое поля name'
)
comment = 'Таблица логирования новых записей из таблиц users, catalogs, products'
engine=ARCHIVE;

DELIMITER //

-- Тепер нужны триггеры на таблицы
-- Сначала удалю если есть
drop trigger if exists log_users_insert//
drop trigger if exists log_catalogs_insert//
drop trigger if exists log_products_insert//

-- Триггер на таблицу users
create trigger log_users_insert after insert on users
for each row
begin
	insert into logs values (now(), 'users', new.id, new.name);
end//
-- Триггер на таблицу catalogs
create trigger log_catalogs_insert after insert on catalogs
for each row
begin
	insert into logs values (now(), 'catalogs', new.id, new.name);
end//
-- Триггер на таблицу products
create trigger log_products_insert after insert on products
for each row
begin
	insert into logs values (now(), 'products', new.id, new.name);
end//

DELIMITER ;

-- Просмотр всех триггеров в текущей БД
SHOW triggers;

-- Проверяю добавление данных
-- users
insert into users values
(null, 'Лёха-1', current_date() - interval 30 year, now(), now()),
(null, 'Лёха-2', current_date() - interval 20 year, now(), now());
-- catalogs
insert into catalogs values
(null, 'SSD');
-- products
select max(id) into @last_id from catalogs;
insert into products values
(null, '120 GB', 'Описание для SSD 1', 2000, @last_id, now(), now()),
(null, '240 GB', 'Описание для SSD 2', 5000, @last_id, now(), now());

-- Смотрим что в логе
select * from `logs`;


/**
*	Задание 2.
*	Создайте SQL-запрос, который помещает в таблицу users миллион записей.
*/
-- Создаю процедуру для генерации и добавления определенного количества юзеров
DELIMITER //
drop procedure if exists create_users//
create procedure create_users(IN users_count INT)
begin
	while users_count > 0 do
		insert into users values (
			null,
            (select `name` from gb_snet_v1.profiles order by rand() limit 1),
            current_date() - interval (round(rand() * 40) + 10) year + interval round(rand() * 365) day,
            now(),
            now()
		);
		set users_count = users_count - 1;
    end while;
end//
DELIMITER ;

-- Выполнение запроса (пока 2)
call create_users(2);

-- Выполнение запроса (теперь 1000000)
call create_users(1000000);

