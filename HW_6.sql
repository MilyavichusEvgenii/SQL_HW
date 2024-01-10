-- Основное ДЗ:
-- Создайте функцию, которая принимает кол-во сек и формат их в кол-во дней, часов, минут и секунд.
-- Пример: 123456 ->'1 days 10 hours 17 minutes 36 seconds '
-- Выведите только четные числа от 1 до 10 (Через цикл).
-- Пример: 2,4,6,8,10
drop database if exists procedures;
create database procedures;
use procedures;
drop procedure if exists converter;
DELIMITER $$
create procedure converter
(
	in seconds int
)
begin
	declare _days int;
    declare _hours int;
    declare _minits int;
    declare _seconds int;
    declare _temp int;
    declare resalt varchar(100);
    declare n int;
    declare x int;
    set _days := seconds / 86400;
    set _temp := seconds % 86400;
    set _hours := _temp / 3600;
    set _temp := _temp % 3600;
    set _minits := _temp / 60;
    set _seconds := _temp % 60;
    set resalt := concat(_days, _hours, _minits, _seconds);
    create temporary table _resalt
    (
		id int auto_increment key,
        days int,
        hours int,
        minits int,
        seconds int
    );
    insert _resalt ( days, hours, minits, seconds) 
    values ( _days, _hours, _minits, _seconds);
    select * from _resalt;
    drop table _resalt;
    end $$
    
call converter(5000000);

drop procedure if exists score;
DELIMITER $$
create procedure score
(
	in numbers int
)
begin
	declare resalt varchar(5000) default "";
    declare n int;
    declare temp int;
    set n = 1;
    repeat
		set temp = n % 2;
		if temp = 0 and n = numbers
			then set resalt := concat(resalt, n);
		elseif temp = 0 and n != numbers
			then set resalt := concat(resalt, n, ",");
		end if;
		set n = n + 1;
        until n > numbers
	end repeat;
    select resalt;
end $$

call score(100);

-- Дополнительное задание: (для ВК: https://www.notion.so/c448e32ae1344f22b1deae7f42c8b57f)
-- Создать процедуру, которая решает следующую задачу
-- Выбрать для одного пользователя 5 пользователей в случайной комбинации, которые удовлетворяют хотя бы одному критерию:
-- а) из одного города
-- б) состоят в одной группе
-- в) друзья друзей

use lesson_4_1;

DROP PROCEDURE IF EXISTS sp_friendship_offers;
DELIMITER //
CREATE PROCEDURE sp_friendship_offers(for_user_id BIGINT)
BEGIN
-- друзья
WITH friends AS (
SELECT initiator_user_id AS id
    FROM friend_requests
    WHERE status = 'approved' AND target_user_id = for_user_id 
    UNION
    SELECT target_user_id 
    FROM friend_requests
    WHERE status = 'approved' AND initiator_user_id = for_user_id 
) 
SELECT p2.user_id FROM profiles p1
JOIN profiles p2 ON p1.hometown = p2.hometown 
WHERE p1.user_id = for_user_id AND p2.user_id <> for_user_id
-- состоят в одной группе
UNION SELECT uc2.user_id FROM users_communities uc1
JOIN users_communities uc2 ON uc1.community_id = uc2.community_id 
WHERE uc1.user_id = for_user_id AND uc2.user_id <> for_user_id
-- друзья друзей
UNION SELECT fr.initiator_user_id FROM friends f
JOIN friend_requests fr ON fr.target_user_id = f.id
WHERE fr.initiator_user_id != for_user_id  AND fr.status = 'approved'
UNION SELECT fr.target_user_id FROM  friends f
JOIN  friend_requests fr ON fr.initiator_user_id = f.id 
WHERE fr.target_user_id != for_user_id  AND status = 'approved'
ORDER BY rand() 
LIMIT 5;
END//
DELIMITER ;

call sp_friendship_offers(1);
		
-- Создать функцию, вычисляющей коэффициент популярности пользователя (по количеству друзей)
DROP FUNCTION IF EXISTS friendship_direction;
DELIMITER //

CREATE FUNCTION friendship_direction(check_user_id BIGINT)
RETURNS FLOAT READS SQL DATA 
BEGIN
 DECLARE requests_to_user INT; -- заявок к пользователю
 DECLARE requests_from_user INT; -- заявок от пользователя
 
 SET requests_to_user = (SELECT count(*) FROM friend_requests
 WHERE target_user_id = check_user_id);

 SELECT count(*) INTO  requests_from_user
 FROM friend_requests WHERE initiator_user_id = check_user_id; 

 RETURN requests_to_user / requests_from_user;
END//
DELIMITER ;

select friendship_direction(6);

-- Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
--  с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".
drop function if exists hello;
DELIMITER $$
create function hello()
returns varchar(50) reads sql data
begin
	declare _hours int;
    declare result varchar(50);
	set _hours = hour(curtime());
	if _hours between 0 and 5
		then set result = "Доброй ночи";
	elseif _hours between 6 and 12
		then set result = "Доброе утро";
	elseif _hours between 13 and 17
		then set result = "Добрый день";
	elseif _hours between 18 and 23
		then set result ="Добрый вечер"; 
    end if;
return result;
end $$
DELIMITER ;

select hello();

-- (по желанию)* Создайте таблицу logs типа Archive. 
-- Пусть при каждом создании записи в таблицах users, communities и messages в таблицу logs помещается время и дата создания записи, 
-- название таблицы, идентификатор первичного ключа.

DROP TABLE IF EXISTS logs;

CREATE TABLE logs (
    created_at DATETIME DEFAULT now(),
    table_name VARCHAR(20) NOT NULL,
    pk_id INT UNSIGNED NOT NULL
)  ENGINE=ARCHIVE;

CREATE 
    TRIGGER  users_log
 AFTER INSERT ON users FOR EACH ROW 
    INSERT INTO logs SET table_name = 'users' , pk_id = NEW.id;

CREATE 
    TRIGGER  communities_log
 AFTER INSERT ON communities FOR EACH ROW 
    INSERT INTO logs SET table_name = 'communities' , pk_id = NEW.id;

CREATE 
    TRIGGER  messages_log
AFTER INSERT ON messages FOR EACH ROW 
    INSERT INTO logs SET table_name = 'messages' , pk_id = NEW.id;


	
