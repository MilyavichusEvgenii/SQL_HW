DROP DATABASE IF EXISTS lesson_5;
CREATE DATABASE lesson_5;
USE lesson_5;
CREATE TABLE cars
(
	id INT NOT NULL PRIMARY KEY,
    `name` VARCHAR(45),
    cost INT
);

INSERT cars
VALUES
	(1, "Audi", 52642),
    (2, "Mercedes", 57127 ),
    (3, "Skoda", 9000 ),
    (4, "Volvo", 29000),
	(5, "Bentley", 350000),
    (6, "Citroen ", 21000 ), 
    (7, "Hummer", 41400), 
    (8, "Volkswagen ", 21600);
    
-- SELECT *
-- FROM cars;

-- 1.	Создайте представление, в которое попадут автомобили стоимостью  до 25 000 долларов
CREATE OR REPLACE VIEW cars_to_25000 AS
SELECT id, `name`, cost
FROM cars
WHERE cost < 25000;
SELECT * FROM cars_to_25000;

-- 2.	Изменить в существующем представлении порог для стоимости: пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) 
ALTER VIEW cars_to_25000 AS
SELECT id, `name`, cost
FROM cars
WHERE cost < 30000;
SELECT * FROM cars_to_25000;

-- 3. 	Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”
CREATE OR REPLACE VIEW cars_AUDI_SKODA AS
SELECT id, `name`, cost
FROM cars
WHERE `name` = "Audi" OR `name` = "Skoda";
SELECT * FROM cars_AUDI_SKODA;

-- Добавьте новый столбец под названием «время до следующей станции». 
-- Чтобы получить это значение, мы вычитаем время станций для пар смежных станций. 
-- Мы можем вычислить это значение без использования оконной функции SQL, но это может быть очень сложно. 
-- Проще это сделать с помощью оконной функции LEAD . Эта функция сравнивает значения из одной строки со следующей строкой, 
-- чтобы получить результат. В этом случае функция сравнивает значения в столбце «время» для станции со станцией сразу после нее.
DROP TABLE IF EXISTS train;
CREATE TABLE train
(
	train_id INTEGER NOT NULL,
    station CHARACTER VARYING(20),
    station_time TIME
);
INSERT train
VALUES
(110, "Сан-Франциско", '10:00:00'),
(110, "Рекон Сити", '10:54:00'),
(110, "Лас Плагас", '11:02:00'),
(110, "Сан Джойс", '12:35:00'),
(120, "Сан-Франциско", '11:00:00'),
(120, "Лас Плагас", '12:49:00'),
(120, "Сан Джойс", '13:30:00');

SELECT * FROM train;

SELECT 
train_id, 
station, 
station_time,
timediff(LEAD(station_time) OVER w, station_time) AS time_to_next_station
FROM train
WINDOW w AS(PARTITION BY train_id);

-- Для скрипта, поставленного в прошлом уроке.
-- Получите друзей пользователя с id=1
-- (решение задачи с помощью представления “друзья”)

CREATE OR REPLACE VIEW friends_id_1 AS
SELECT 
table_id.id,
table_id.friends,
u.firstname
FROM
(SELECT
id, 
friends
FROM (SELECT u.id AS id, 
	f.target_user_id AS friends
    FROM users u
    LEFT JOIN friend_requests f ON u.id = initiator_user_id
) AS table_f
WHERE id = 1) AS table_id
LEFT JOIN users u ON u.id = friends;

SELECT * FROM friends_id_1;

-- Создайте представление, в котором будут выводится все сообщения, в которых принимал
-- участие пользователь с id = 1.

CREATE OR REPLACE VIEW messages_id_1 AS
SELECT
u.id,
m.id AS message
FROM users u
LEFT JOIN messages m ON m.from_user_id = u.id
WHERE u.id = 1
UNION
SELECT
u.id,
m.id 
FROM users u
LEFT JOIN messages m ON m.to_user_id = u.id
WHERE u.id = 1;
SELECT * FROM messages_id_1;

-- Получите список медиафайлов пользователя с количеством лайков(media m, likes l ,users u)

SELECT
files,
COUNT(l.id) AS likes_f
FROM
(SELECT
m.id AS files
FROM users u
LEFT JOIN media m ON u.id = m.user_id
WHERE u.id = 1) AS tables_a
JOIN likes l ON files = l.media_id
GROUP BY files;

-- Получите количество групп у пользователей
SELECT
u.id,
COUNT(c.community_id) AS group_use
FROM users u
LEFT JOIN users_communities c ON u.id = c.user_id
GROUP BY u.id;

-- 1. Создайте представление, в которое попадет информация о пользователях (имя, фамилия, город и пол), которые не старше 20 лет.
CREATE OR REPLACE VIEW table_user AS
SELECT
u.firstname,
u.lastname,
p.hometown,
p.gender
FROM users u
LEFT JOIN `profiles` p ON u.id = p.user_id;

SELECT * FROM table_user;

-- 2. Найдите кол-во, отправленных сообщений каждым пользователем и выведите ранжированный список пользователей, 
-- указав имя и фамилию пользователя, количество отправленных сообщений и место в рейтинге 
-- (первое место у пользователя с максимальным количеством сообщений) . (используйте DENSE_RANK)

SELECT
id,
mes,
DENSE_RANK() OVER w
FROM
(SELECT
u.id,
COUNT(m.id) AS mes
FROM users u
LEFT JOIN messages m ON u.id = m.from_user_id
GROUP BY u.id) AS table_a
WINDOW w AS(ORDER BY mes DESC);

-- 3. Выберите все сообщения, отсортируйте сообщения по возрастанию даты отправления (created_at) 
-- и найдите разницу дат отправления между соседними сообщениями,
--  получившегося списка. (используйте LEAD или LAG)
CREATE OR REPLACE VIEW table_cr AS
SELECT
*
FROM messages
ORDER BY created_at;
SELECT * FROM table_cr;

SELECT *,
timediff(LEAD(created_at) OVER w, created_at) AS time_diff
FROM table_cr
WINDOW w AS(PARTITION BY from_user_id)
ORDER BY from_user_id;

