-- скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
-- --------------------------------------------------------
-- запрос чая по id
SELECT p.name, c.main_cat AS cat, c.parent_cat AS sort, p.price
FROM products AS p
    JOIN category AS c
ON p.category_id = c.id
WHERE c.id = 6 -- 5 белый, 6 зеленый, 7 красный чай, 15 кофе хасиб
;
-- --------------------------------------------------------
-- проверка оплачен ли заказ пользователя и состав заказа
SELECT o.user_id, o.payment, op.product_id 
FROM orders AS o
	JOIN orders_products AS op
ON op.order_id = o.id 
WHERE o.user_id = 2
;
-- --------------------------------------------------------
SELECT users.name, users.surname, orders.payment
FROM orders
	LEFT JOIN users ON users.id = orders.user_id 
	UNION 
SELECT users.name, users.surname, orders.payment
FROM orders
	RIGHT JOIN users ON users.id = orders.user_id; 
-- --------------------------------------------------------
-- представления (минимум 2);
-- --------------------------------------------------------
CREATE OR REPLACE VIEW prods_view AS
SELECT 
	p.name AS prod,
	c.main_cat AS sort
FROM 
	products AS p
JOIN
	category AS c
ON 
	p.category_id = c.id;

SELECT * FROM prods_view
ORDER BY sort;
-- --------------------------------------------------------
CREATE OR REPLACE VIEW prods_view_2 AS
SELECT 
	u.name AS us_name, u.surname,
	p.artikul, p.name AS _prod_name, p.price,
	o.payment
FROM 
	users AS u
JOIN
	orders AS o
JOIN
	products AS p
JOIN
	orders_products AS op
ON 
	u.id = o.user_id
and o.id = op.order_id
and op.product_id = p.id 
;

SELECT * FROM prods_view_2
ORDER BY us_name;
-- __________________________________________________________
-- общая сумма заказа:
SELECT SUM(price) FROM prods_view_2
WHERE us_name = 'Светлана'; -- Александр -- Павел
-- --------------------------------------------------------
CREATE OR REPLACE VIEW prods_view_3 AS
SELECT 
	u.name, u.surname,
	op.order_id,
	o.gift_cards_id,
	d.delivery_type,
	o.payment
FROM 
	users AS u
JOIN
	orders AS o
JOIN
	orders_products AS op
JOIN 
	delivery AS d
ON 
	u.id = o.user_id
and u.id = op.user_id 
and d.id = o.delivery_id 
-- WHERE u.id = 1
;

SELECT * FROM prods_view_3
ORDER BY name;
-- --------------------------------------------------------
-- хранимые процедуры / триггеры 
-- --------------------------------------------------------
-- 1. Транзакция (перевод денег со счета пользователя на счет магазина)
-- --------------------------------------------------------
-- 1 пользователь:
SELECT * FROM store_account; -- пустой
START TRANSACTION;
-- SELECT bill FROM users;
UPDATE users SET bill =
bill - 1485 WHERE id = 1;
UPDATE store_account SET check_bill = 
check_bill + 1485 WHERE from_user_id = 1;
UPDATE prods_view_2 SET payment =
'yes' WHERE us_name = 'Светлана';
-- SELECT * FROM store_account;
-- SELECT * FROM users;
COMMIT;
-- ROLLBACK;


-- 2 пользователь:
START TRANSACTION;
UPDATE users SET bill =
bill - 2210 WHERE id = 2;
UPDATE store_account SET check_bill = 
check_bill + 2210 WHERE from_user_id = 2;
UPDATE prods_view_2 SET payment =
'yes' WHERE us_name = 'Александр';
COMMIT;

-- 3 пользователь:
START TRANSACTION;
UPDATE users SET bill =
bill - 550 WHERE id = 3;
UPDATE store_account SET check_bill = 
check_bill + 550 WHERE from_user_id = 3;
UPDATE prods_view_2 SET payment =
'yes' WHERE us_name = 'Павел';
COMMIT;
SELECT * FROM store_account;
-- SELECT * FROM orders;

-- --------------------------------------------------------
-- проверка оплачены ли заказы пользователей
SELECT concat (name, ' ',  surname) AS name,
	(SELECT payment FROM orders WHERE user_id = users.id) AS payment
FROM users 
;
-- --------------------------------------------------------
-- 2. Триггеры (тригер если отсутсвует имя, фамилия)
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS nullTrigger_name;
delimiter //
CREATE TRIGGER nullTrigger_name BEFORE INSERT ON users
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name) AND ISNULL(NEW.surname)) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Введите имя или фамилию!';
	END IF;
END //
delimiter ;

INSERT INTO users (name, surname, birthday_at, tel)
VALUES (NULL, NULL, '1992-04-13', 89111001010); -- ошибка

INSERT INTO users (name, surname, birthday_at, tel)
VALUES ("test", NULL, '1992-04-13', 89111001012); 

INSERT INTO users (name, surname, birthday_at, tel)
VALUES ("test1", "test2",'1992-04-13', 89111001011); 

-- тригер на обновление

DROP TRIGGER IF EXISTS nullTrigger_name_up;
delimiter //
CREATE TRIGGER nullTrigger_name_up BEFORE INSERT ON users
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.name) AND ISNULL(NEW.surname)) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'Введите имя или фамилию!';
	END IF;
END //
delimiter ;
-- --------------------------------------------------------
-- Тригер на отсутсвие номера телефона для связи
-- --------------------------------------------------------
DROP TRIGGER IF EXISTS nullTrigger_tel;
delimiter //
CREATE TRIGGER nullTrigger_tel BEFORE INSERT ON users
FOR EACH ROW
BEGIN
	IF(ISNULL(NEW.tel)) THEN
		SIGNAL SQLSTATE '45000' 
		SET MESSAGE_TEXT = 'отсутствует номер телефона!';
	END IF;
END //
delimiter ;

INSERT INTO users (name, surname, birthday_at, tel)
VALUES ('Михаил', 'Мишин', '1992-04-13', NULL); -- ошибка

INSERT INTO users (name, surname, birthday_at, tel)
VALUES ('Михаил', 'Мишин', '1992-04-13', 89111001015); 
-- --------------------------------------------------------
-- 3. Хранимые процедуры (
-- --------------------------------------------------------
DROP PROCEDURE IF EXISTS hello;
delimiter //
CREATE PROCEDURE hello()
BEGIN
	CASE 
		WHEN CURTIME() BETWEEN '06:00:00' AND '12:00:00' THEN
			SELECT 'Доброе утро';
		WHEN CURTIME() BETWEEN '12:00:00' AND '18:00:00' THEN
			SELECT 'Добрый день';
		WHEN CURTIME() BETWEEN '18:00:00' AND '00:00:00' THEN
			SELECT 'Добрый вечер';
		ELSE
			SELECT 'Доброй ночи';
	END CASE;
END //
delimiter ;

-- SHOW PROCEDURE STATUS;
-- CALL hello();















