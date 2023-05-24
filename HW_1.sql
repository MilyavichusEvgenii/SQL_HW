-- Создайте таблицу с мобильными телефонами, 
-- используя графический интерфейс. Заполните БД данными
USE lesson_1;
CREATE TABLE IF NOT EXISTS phone
(
	id INT PRIMARY KEY AUTO_INCREMENT,
    title VARCHAR(45),
    manufacturer VARCHAR(45),
    price INT,
    quantity INT
);
INSERT phone(title, manufacturer, price, quantity)
VALUES
	("Iphon", "Apple", 30000, 1),
    ("Iphon 5", "Apple", 50000, 3),
    ("Iphon 14", "Apple", 100000, 5),
    ("Galaxy", "Samsung", 30000, 4),
    ("Galaxy 5", "Samsung", 60000, 5),
    ("Galaxy 8", "Samsung", 130000, 5);
-- Выведите название, производителя и цену для товаров, 
-- количество которых превышает 2
SELECT title, manufacturer, price FROM phone
WHERE quantity > 2;
-- Выведите весь ассортимент товаров марки “Samsung”
SELECT * FROM phone
WHERE manufacturer = "Samsung";
-- Выведите информацию о телефонах, 
-- где суммарный чек больше 100 000 и меньше 145 000**
SELECT * FROM phone
WHERE price * quantity BETWEEN 100000 AND 145000;
--  Товары, в которых есть упоминание "Iphone"
SELECT * FROM phone
WHERE title LIKE "Iphon%";
-- "Galaxy"
SELECT * FROM phone
WHERE title LIKE "Galaxy%";
-- Товары, в которых есть ЦИФРЫ
SELECT * FROM phone
WHERE title RLIKE "[0-9]";
-- Товары, в которых есть ЦИФРА "8"
SELECT * FROM phone
WHERE title RLIKE "8";
 

