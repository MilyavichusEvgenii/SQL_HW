CREATE DATABASE lesson_3;
USE lesson_3;
DROP TABLE IF EXISTS staff;
CREATE TABLE staff
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    firstname VARCHAR(45) NOT NULL,
    lastname VARCHAR(45) NOT NULL,
    post VARCHAR(45) NOT NULL,
    seniority INT,
    salary DECIMAL(8,2),
    age INT
);
INSERT staff(firstname, lastname, post, seniority,salary,age)
VALUES ("Петр", "Петров", "Начальник", 8, 70000, 30); -- id = 1
INSERT staff (firstname, lastname, post, seniority, salary, age)
VALUES
  ('Вася', 'Петров', 'Начальник', 40, 100000, 60),
  ('Петр', 'Власов', 'Начальник', 8, 70000, 30),
  ('Катя', 'Катина', 'Инженер', 2, 70000, 25),
  ('Саша', 'Сасин', 'Инженер', 12, 50000, 35),
  ('Иван', 'Петров', 'Рабочий', 40, 30000, 59),
  ('Петр', 'Петров', 'Рабочий', 20, 55000, 60),
  ('Сидр', 'Сидоров', 'Рабочий', 10, 20000, 35),
  ('Антон', 'Антонов', 'Рабочий', 8, 19000, 28),
  ('Юрий', 'Юрков', 'Рабочий', 5, 15000, 25),
  ('Максим', 'Петров', 'Рабочий', 2, 11000, 19),
  ('Юрий', 'Петров', 'Рабочий', 3, 12000, 24),
  ('Людмила', 'Маркина', 'Уборщик', 10, 10000, 49);
  -- Отсортируйте данные по полю заработная плата (salary) в порядке: убывания; возрастания
SELECT
	id,
    firstname,
    lastname,
    post,
    seniority,
    salary,
    age
FROM staff
    ORDER BY salary;
SELECT
	id,
    firstname,
    lastname,
    post,
    seniority,
    salary,
    age
FROM staff
    ORDER BY salary DESC;
-- Выведите 5 максимальных заработных плат (saraly)
SELECT
	id,
    firstname,
    lastname,
    post,
    seniority,
    salary,
    age
FROM staff
    ORDER BY salary DESC
    LIMIT 5;
-- Посчитайте суммарную зарплату (salary) по каждой специальности (роst)
SELECT
    post,
    SUM(salary) AS SUM
FROM staff
    GROUP BY post;
-- Найдите кол-во сотрудников с специальностью (post) «Рабочий» в возрасте от 24 до 49 лет включительно.
SELECT
    COUNT(post) As Empoyees
FROM staff
	WHERE post = "Рабочий" AND age BETWEEN 24 AND 49
	GROUP BY post;
-- Найдите количество специальностей 
SELECT 
COUNT(DISTINCT post) AS count_posts
FROM staff;
-- Выведите специальности, у которых средний возраст сотрудников меньше 30 лет
SELECT
post
FROM staff
GROUP BY post
HAVING AVG(age) > 30;
-- Внутри каждой должности вывести ТОП-2 по ЗП (2 самых высокооплачиваемых сотрудника по ЗП внутри каждой должности)
WITH top AS (
SELECT lastname, post, salary, ROW_NUMBER() OVER 
(PARTITION BY post
ORDER BY salary DESC) AS id
FROM staff
ORDER BY post, salary DESC
) SELECT * FROM top WHERE id < 3;
-- Посчитать количество документов у каждого пользователя
SELECT
	COUNT(id) AS doc,
    monthname(created_at) AS Month_name,
    month(created_at) AS Month_number
FROM media
    GROUP BY Month_name
    ORDER BY month(created_at);
-- Посчитать лайки для моих документов (моих медиа)
SET sql_mode = (SELECT replace(@@sql_mode, 'ONLY_FULL_GROUP_BY',''));
SELECT 
	id,
	(SELECT COUNT(id) FROM likes WHERE likes.media_id = media.id
		GROUP BY media_id
		ORDER BY COUNT(id)) AS likes
FROM media
	GROUP BY id
	ORDER BY id;


 

    



  