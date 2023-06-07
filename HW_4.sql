DROP DATABASE IF EXISTS lesson_4_2;
CREATE DATABASE lesson_4_2;
USE lesson_4_2;
DROP TABLE IF EXISTS `shops`;
CREATE TABLE `shops` (
	`id` INT,
    `shopname` VARCHAR (100),
    PRIMARY KEY (id)
);
DROP TABLE IF EXISTS `cats`;
CREATE TABLE `cats` (
	`name` VARCHAR (100),
    `id` INT,
    PRIMARY KEY (id),
    shops_id INT,
    CONSTRAINT fk_cats_shops_id FOREIGN KEY (shops_id)
        REFERENCES `shops` (id)
);

INSERT INTO `shops`
VALUES 
		(1, "Четыре лапы"),
        (2, "Мистер Зоо"),
        (3, "МурзиЛЛа"),
        (4, "Кошки и собаки");

INSERT INTO `cats`
VALUES 
		("Murzik",1,1),
        ("Nemo",2,2),
        ("Vicont",3,1),
        ("Zuza",4,3);

-- Используя JOIN-ы, выполните следующие операции:
-- Вывести всех котиков по магазинам по id (условие соединения shops.id = cats.shops_id)
SELECT c.id,
c.name AS name_cat,
s.shopname
FROM `cats` c
LEFT JOIN `shops` s ON s.id = c.id;
-- Вывести магазин, в котором продается кот “Мурзик” (попробуйте выполнить 2 способами)
-- 1 способ
SELECT
c.id,
c.name AS name_cat,
s.shopname
FROM `cats` c
LEFT JOIN `shops` s ON s.id = c.id
WHERE c.name = "Murzik";
-- 2 способ
SELECT
s.shopname,
cat_name.name
FROM `shops` s
JOIN(SELECT * FROM cats
WHERE `name` = "Murzik") cat_name
ON s.id = cat_name.id;
-- Вывести магазины, в которых НЕ продаются коты “Мурзик” и “Zuza”
SELECT
c.name,
s.shopname
FROM shops s
JOIN cats c 
ON c.id = s.id
WHERE c.name != "Murzik" AND c.name != "Zuza";

DROP TABLE IF EXISTS Analysis;

CREATE TABLE Analysis
(
	an_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	an_name varchar(50),
	an_cost INT,
	an_price INT,
	an_group INT,
    FOREIGN KEY (an_group) REFERENCES GroupsAn (gr_id)
	ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO analysis (an_name, an_cost, an_price, an_group)
VALUES 
	('Общий анализ крови', 30, 50, 1),
	('Биохимия крови', 150, 210, 1),
	('Анализ крови на глюкозу', 110, 130, 1),
	('Общий анализ мочи', 25, 40, 2),
	('Общий анализ кала', 35, 50, 2),
	('Общий анализ мочи', 25, 40, 2),
	('Тест на COVID-19', 160, 210, 3);

DROP TABLE IF EXISTS GroupsAn;

CREATE TABLE GroupsAn
(
	gr_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	gr_name varchar(50),
	gr_temp FLOAT(5,1)
);

INSERT INTO groupsan (gr_name, gr_temp)
VALUES 
	('Анализы крови', -12.2),
	('Общие анализы', -20.0),
	('ПЦР-диагностика', -20.5);

SELECT * FROM groupsan;

DROP TABLE IF EXISTS Orders;
CREATE TABLE Orders
(
	ord_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
	ord_datetime DATETIME,	-- 'YYYY-MM-DD hh:mm:ss'
	ord_an INT,
	FOREIGN KEY (ord_an) REFERENCES Analysis (an_id)
	-- ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Orders (ord_datetime, ord_an)
VALUES 
	('2020-02-04 07:15:25', 1),
	('2020-02-04 07:20:50', 2),
	('2020-02-04 07:30:04', 1),
	('2020-02-04 07:40:57', 1),
	('2020-02-05 07:05:14', 1),
	('2020-02-05 07:15:15', 3),
	('2020-02-05 07:30:49', 3),
	('2020-02-06 07:10:10', 2),
	('2020-02-06 07:20:38', 2),
	('2020-02-07 07:05:09', 1),
	('2020-02-07 07:10:54', 1),
	('2020-02-07 07:15:25', 1),
	('2020-02-08 07:05:44', 1),
	('2020-02-08 07:10:39', 2),
	('2020-02-08 07:20:36', 1),
	('2020-02-08 07:25:26', 3),
	('2020-02-09 07:05:06', 1),
	('2020-02-09 07:10:34', 1),
	('2020-02-09 07:20:19', 2),
	('2020-02-10 07:05:55', 3),
	('2020-02-10 07:15:08', 3),
	('2020-02-10 07:25:07', 1),
	('2020-02-11 07:05:33', 1),
	('2020-02-11 07:10:32', 2),
	('2020-02-11 07:20:17', 3),
	('2020-02-12 07:05:36', 1),
	('2020-02-12 07:10:54', 2),
	('2020-02-12 07:20:19', 3),
	('2020-02-12 07:35:38', 1);
-- Вывести название и цену для всех анализов, которые продавались 5 февраля 2020 и всю следующую неделю.
SELECT
a.an_name,
a.an_cost,
o.ord_datetime,
g.gr_name
FROM Analysis a
JOIN GroupsAn g ON a.an_group = g.gr_id
JOIN Orders o ON a.an_id = o.ord_an
WHERE o.ord_datetime >= '2020-02-05 07:05:14' 
ORDER BY o.ord_datetime;



CREATE TABLE  AUTO 
(       
	REGNUM VARCHAR(10) PRIMARY KEY, 
	MARK VARCHAR(10), 
	COLOR VARCHAR(15),
	RELEASEDT DATE, 
	PHONENUM VARCHAR(15)
);


CREATE TABLE  CITY 
(	
    CITYCODE INT PRIMARY KEY,
	CITYNAME VARCHAR(50), 
	PEOPLES INT 
);


CREATE TABLE  MAN 
(	
	PHONENUM VARCHAR(15) PRIMARY KEY , 
	FIRSTNAME VARCHAR(50),
	LASTNAME VARCHAR(50),  
	CITYCODE INT, 
	YEAROLD INT	 
);


 -- AUTO
INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111114,'LADA', 'КРАСНЫЙ', date'2008-01-01', '9152222221');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111115,'VOLVO', 'КРАСНЫЙ', date'2013-01-01', '9173333334');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111116,'BMW', 'СИНИЙ', date'2015-01-01', '9173333334');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111121,'AUDI', 'СИНИЙ', date'2009-01-01', '9173333332');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111122,'AUDI', 'СИНИЙ', date'2011-01-01', '9213333336');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111113,'BMW', 'ЗЕЛЕНЫЙ', date'2007-01-01', '9214444444');


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111126,'LADA', 'ЗЕЛЕНЫЙ', date'2005-01-01', null);


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111117,'BMW', 'СИНИЙ', date'2005-01-01', null);


INSERT INTO AUTO (REGNUM, MARK,	COLOR, RELEASEDT, PHONENUM )
VALUES(111119,'LADA', 'СИНИЙ', date'2017-01-01', 9213333331);


 -- CITY
INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(1,'Москва', 10000000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(2,'Владимир', 500000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(3, 'Орел', 300000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(4,'Курск', 200000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(5, 'Казань', 2000000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(7, 'Котлас', 110000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(8, 'Мурманск', 400000);


INSERT INTO CITY (CITYCODE,CITYNAME,PEOPLES)
VALUES(9, 'Ярославль', 500000);

-- MAN
INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9152222221','Андрей','Николаев', 1, 22);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9152222222','Максим','Москитов', 1, 31);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9153333333','Олег','Денисов', 3, 34);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9173333334','Алиса','Никина', 4, 31);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9173333335','Таня','Иванова', 4, 31);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9213333336','Алексей','Иванов', 7, 25);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9213333331','Андрей','Некрасов', 2, 27);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9213333332','Миша','Рогозин', 2, 21);


INSERT INTO MAN (PHONENUM,FIRSTNAME,LASTNAME,CITYCODE,YEAROLD)
VALUES('9214444444','Алексей','Галкин', 1, 38);

-- 1. Вывести на экран сколько машин каждого цвета для машин марок BMW и LADA
SELECT DISTINCT
COUNT(color) AS cars,
color,
mark
FROM auto
WHERE mark = "BMW" OR mark = "LADA"
GROUP BY color, mark;


--  Вывести на экран марку авто и количество AUTO не этой марки
SELECT
(SELECT COUNT(mark) FROM auto) - COUNT(mark),
mark
FROM auto
GROUP BY mark;
-- Подсчитать общее количество лайков, которые получили пользователи младше 12 лет включительно.
SELECT 
u.id,
TIMESTAMPDIFF(YEAR, p.birthday, CURDATE()),
COUNT(l.id),
u.firstname
FROM users u
LEFT JOIN `profiles` p ON u.id = p.user_id
LEFT JOIN likes l ON u.id = l.user_id
WHERE TIMESTAMPDIFF(YEAR, p.birthday, CURDATE()) < 12
GROUP BY u.firstname;

-- Определить кто больше поставил лайков (всего): мужчины или женщины.

SELECT
COUNT(l.id) AS likes_weman,
((SELECT COUNT(id) FROM likes) - COUNT(l.id)) difference_likes,
(CASE
WHEN (SELECT COUNT(id) FROM likes) - COUNT(l.id) < 10
	THEN "Weman have more likes"
WHEN (SELECT COUNT(id) FROM likes) - COUNT(l.id) > 10
	THEN "Men have more likes"
WHEN (SELECT COUNT(id) FROM likes) - COUNT(l.id) = 0
 	THEN "Men have equal likes with weman"
END) AS answer
FROM users u
LEFT JOIN `profiles` p ON u.id = p.user_id
LEFT JOIN likes l ON u.id = l.user_id
WHERE p.gender = "f";

-- Вывести всех пользователей, которые не отправляли сообщения.
SELECT
u.firstname,
m.created_at
FROM users u
LEFT JOIN messages m ON u.id = m.from_user_id
WHERE m.created_at is NULL;
-- (по желанию)* Пусть задан некоторый пользователь. Из всех друзей этого пользователя найдите человека, который больше всех написал ему сообщений.
SET sql_mode = (SELECT replace(@@sql_mode, 'ONLY_FULL_GROUP_BY', ''));
SELECT
u.firstname AS user_in,
COUNT(m.from_user_id) messages,
m.from_user_id
FROM users u
JOIN messages m ON u.id = m.to_user_id
WHERE u.id = 1
GROUP BY u.firstname, m.from_user_id
ORDER BY messages DESC
LIMIT 1;