/**
*	Задание 1.
*	Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
*	С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро",
*	с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
*	с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
*/
-- Выберу БД gb_shop
use gb_shop;

-- Удаляю функцию, если есть
drop function if exists hello;

-- Изменю разделитель
DELIMITER //
-- Создаю функцию hello (предварительно удалив)
CREATE FUNCTION hello()
RETURNS varchar(255) DETERMINISTIC
BEGIN
	DECLARE h int default cast(date_format(now(), '%H') as unsigned);
    IF (h >= 0 and h < 6) THEN
		return 'Доброй ночи!';
    ELSEIF (h >= 6 and h < 12) THEN
		return 'Доброго утра!';
    ELSEIF (h >= 12 and h < 18) THEN
		return 'Добрый день!';
    ELSE
		return 'Добрый вечер!';
    END IF;
END//
-- Изменяем раздилитель
DELIMITER ;

-- Смотрим что возвращает
select hello();


/**
*	Задание 2.
*	В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
*	Допустимо присутствие обоих полей или одно из них.
*	Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
*	Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены.
*	При попытке присвоить полям NULL-значение необходимо отменить операцию.
*/
-- Смотрим что есть в таблице products
select * from products;

-- Изменим разделитель
DELIMITER //

-- Удаляем триггеры, если есть
drop trigger if exists check_products_insert//
drop trigger if exists check_products_update//
-- Создадим треггер на insert
create trigger check_products_insert BEFORE INSERT ON products
FOR EACH ROW
BEGIN
    IF new.name is null and new.description is null THEN
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Хоть какое-то поле (name или description) должно содержать значение!';
    END IF;
END//

-- Создаем триггер на update
create trigger check_products_update before update on products
for each row
begin
    IF new.name is null and new.description is null THEN
			SIGNAL SQLSTATE '45001' SET MESSAGE_TEXT = 'Хоть какое-то поле (name или description) должно содержать значение!';
    END IF;
end//

-- Изменим разделитель
DELIMITER ;

-- Пробуем вставить без значений
insert into products values
	(NULL, NULL, NULL, 1000, 2, NULL, NULL);
-- И со значениями
insert into products values
	(NULL, NULL, 'Материнская плата TEST', 1000, 2, NULL, NULL),
	(NULL, 'TEST', NULL, 1000, 2, NULL, NULL),
	(NULL, 'TEST2', 'Материнская плата TEST2', 1000, 2, NULL, NULL);

-- Возьмем ID последней строки
-- SET @last_id := last_insert_id();
select max(id) into @last_id from products;
select @last_id;

-- Пробуем изменить на пустые значения
update products set name = NULL, description = NULL where id = @last_id;

-- И на другие значения
-- Сработает
update products set name = NULL where id = @last_id;
-- Ошибка
update products set description = NULL where id = @last_id;
-- Сработает
update products set name = 'TEST3', description = NULL where id = @last_id;
-- Ошибка
update products set name = NULL where id = @last_id;
-- Сработает
update products set name = NULL, description = 'Материнская плата TEST3' where id = @last_id;
-- Сработает
update products set name = 'TEST3' where id = @last_id;


/**
*	Задание 3.
*	Напишите хранимую функцию для вычисления произвольного числа Фибоначчи.
*	Числами Фибоначчи называется последовательность в которой число равно сумме двух предыдущих чисел.
*	Вызов функции FIBONACCI(10) должен возвращать число 55.
*/
DELIMITER //
-- Создаю функцию (предварительно удалив)
drop function if exists FIBONACCI//
create function FIBONACCI(num INT)
RETURNS INT DETERMINISTIC
BEGIN
	DECLARE i, n1, n2, n3 INT DEFAULT 0;
	WHILE i < num DO
		SET n1 = n2;
		SET n2 = n3;
		SET n3 = n1 + n2;
        IF i = 0 THEN
			SET n3 = 1;
        END IF;
		SET i = i + 1;
    END WHILE;
    RETURN n3;
END//
DELIMITER ;

-- Вызов функции
select FIBONACCI(0), FIBONACCI(1), FIBONACCI(2), FIBONACCI(3), FIBONACCI(7), FIBONACCI(10);
