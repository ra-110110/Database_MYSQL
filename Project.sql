-- проект подготовлен по данным чайного сайта: https://realteacoffee.com/

DROP DATABASE IF EXISTS tea_project;
CREATE DATABASE tea_project;
USE tea_project;

-- --------------------------------------------------------
DROP TABLE IF EXISTS category; -- категория 1
CREATE TABLE category (
	id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	main_cat VARCHAR(50),
	parent_cat VARCHAR(50)	
) COMMENT 'категория';

-- ALTER TABLE category ADD CONSTRAINT fk_category_id
-- FOREIGN KEY (parent_cat) REFERENCES category(id);

INSERT INTO category VALUES
	(1, 'каталог', 0),
	(2, 'чай', 1),
	(3, 'кофе', 1),
	(4, 'китайский', 2),
	(5, 'белый', 4),
 	(6, 'зеленый', 4),
 	(7, 'красный', 4),
 	(8, 'индийский', 2),
 	(9, 'ассам', 8), 
 	(10, 'цейлон', 8),  
 	(11, 'Молотый', 3),
 	(12, 'В зернах', 3),
 	(13, 'Gutenberg', 12), 
 	(14, 'Mehmet Efendi', 11),  
 	(15, 'Haseeb', 11),  
 	(16, 'Perrero', 12) 
 ;
-- --------------------------------------------------------
DROP TABLE IF EXISTS packing; -- фасовка, вес 2
CREATE TABLE packing (
	id SERIAL PRIMARY KEY,
	weight VARCHAR(10)
) COMMENT 'вес';

INSERT INTO packing VALUES
	(1, '100 гр'),
	(2, '200 гр'),
	(3, '500 гр'),
	(4, '1000 гр')
;
-- --------------------------------------------------------
DROP TABLE IF EXISTS type_of_packaging; -- тип упаковки 3
CREATE TABLE type_of_packaging (
	id SERIAL PRIMARY KEY,
	type_of_pack VARCHAR(50)
) COMMENT 'тип упаковки';

INSERT INTO type_of_packaging VALUES
	(1, 'мягкая вакуумная'),
	(2, 'бумажная'),
	(3, 'жестянная'),
	(4, 'дой-пак')
;
-- --------------------------------------------------------
DROP TABLE IF EXISTS products; -- общий каталог 4
CREATE TABLE products (
	id BIGINT UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY, 
 	artikul BIGINT UNSIGNED NULL UNIQUE,
    name VARCHAR(50),
    category_id BIGINT UNSIGNED NOT NULL, -- категория
    type_of_pack_id BIGINT UNSIGNED NOT NULL, -- тип упаковки
    price DECIMAL(12, 2) NOT NULL,
    KEY index_of_category_id (category_id),
    FOREIGN KEY (category_id) REFERENCES category(id),
    FOREIGN KEY (type_of_pack_id) REFERENCES type_of_packaging(id)
) COMMENT 'каталог';


    INSERT INTO products
  (artikul, name, category_id, type_of_pack_id, price)
VALUES
  (0000001, 'Ассам Бехора TGFOPI', 9, 2, 294.00),
  (0000002, 'Цейлон ОРA Грин Флауер', 10, 2, 200.00),
  (0000003, 'Бай Лун Чжу (Белая жемчужина дракона)', 5, 2, 800.00),
  (0000004, 'Лу Инь Ло (Изумрудный жемчуг)', 6, 2, 282.00),
  (0000005, 'Красный чай Юннань', 7, 2, 248.00),
  (0000006, 'Кофе в зёрнах с ароматом "Трюфель"', 13, 2, 350.00),
  (0000007, 'Кофе молотый', 14, 1, 143.00),
  (0000008, 'Кофе Хасиб (Haseeb) Bahiya Plus Cardamon"', 15, 1, 360.00),
  (0000009, 'Эспресо-смесь Perrero Brown (Италия)', 16, 1, 1850.00),
  (00000010, 'Бай Му Дань "Белый пион"', 5, 1, 250.00),
  (00000011, 'Чай Сенча (Китай)', 6, 1, 70.00),
  (00000012, 'Чунь Ми (Чжень Мэй)', 6, 1, 150.00),
  (00000013, 'Кимун ОР1 красный с серебряными типсами', 7, 1, 248.00),
  (00000014, 'Лапсанг Сушонг (Копчёный чай)', 7, 1, 257.00),
  (00000015, 'Хун Чжень Луо (Золотая ракушка)', 7, 1, 350.00),
  (00000016, 'Цзин Хао (Золотой пух)', 7, 1, 900.00),
  (00000017, 'Най Сян Чжень Чжу (Молочная жемчужина)', 6, 1, 550.00),
  (00000018, 'Кофе Хасиб (без кардамона)', 15, 1, 330.00),
  (00000019, 'Кофе Хасиб (средний кардамон)', 15, 1, 330.00),
  (00000020, 'Кофе Хасиб (Haseeb) Santana Extra Cardamon', 15, 1, 390.00)
 ;
-- --------------------------------------------------------
DROP TABLE IF EXISTS gift_cards; -- подарочные карты 5
CREATE TABLE gift_cards (
	id SERIAL PRIMARY KEY,
	rating VARCHAR(10),
	design ENUM('1', '2', '3', '4')
) COMMENT 'подарочные карты';

INSERT INTO gift_cards VALUES
	(1, '500', 1),
	(2, '1000', 2),
	(3, '2000', 3),
	(4, '3000', 4),
	(5, '5000', 4)
;
-- --------------------------------------------------------
DROP TABLE IF EXISTS delivery; -- доставка 6
CREATE TABLE delivery (
	id SERIAL PRIMARY KEY,
	delivery_type VARCHAR(8)
) COMMENT 'доставка';

INSERT INTO delivery VALUES
	(1, 'курьером'),
	(2, 'почтой')
;
-- --------------------------------------------------------
DROP TABLE IF EXISTS users; -- покупатели 7
CREATE TABLE users (
	id SERIAL PRIMARY KEY,
	name VARCHAR(255) COMMENT 'Имя покупателя',
 	surname VARCHAR(255) COMMENT 'Фамилия покупателя',
 	bill DECIMAL(12, 2) UNSIGNED DEFAULT 0.00 COMMENT 'Счет пользователя',
	birthday_at DATE COMMENT 'Дата рождения',
	tel BIGINT(20) UNSIGNED NOT NULL UNIQUE,
	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Покупатели';

INSERT INTO users (name, surname, bill, birthday_at, tel) VALUES
	('Светлана', 'Петровна', 5000.00, '1990-10-05', 89999999999),
	('Александр', 'Сидоров', 7000.00, '1987-12-08', 89999999991),
	('Павел', 'Пупкин', 1000.00, '1985-03-21', 89999999992),
	('Мария', 'Петровна', DEFAULT, '1991-09-28', 89999999993)
  ;
-- --------------------------------------------------------
DROP TABLE IF EXISTS orders; -- заказы 8
CREATE TABLE orders (
 	id SERIAL PRIMARY KEY,
 	user_id BIGINT UNSIGNED NOT NULL,
 	gift_cards_id BIGINT UNSIGNED,
 	delivery_id BIGINT UNSIGNED NOT NULL,
 	payment CHAR(3),
 	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
 	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 	KEY index_of_user_id(user_id),
 	FOREIGN KEY (user_id) REFERENCES users(id),
 	FOREIGN KEY (gift_cards_id) REFERENCES gift_cards(id),
 	FOREIGN KEY (delivery_id) REFERENCES delivery(id)
) COMMENT = 'Заказы';

INSERT INTO orders (id, user_id, gift_cards_id, delivery_id, payment) VALUES
	(1, 1, NULL, 1, 'no'),
	(2, 2, NULL, 2, 'no'),
	(3, 3, 2, 1, 'no'),
	(4, 4, 5, 2, 'no')
;
-- --------------------------------------------------------
DROP TABLE IF EXISTS orders_products; -- состав заказа 9
CREATE TABLE orders_products (
 	-- id SERIAL PRIMARY KEY,
 	order_id BIGINT UNSIGNED NOT NULL,
 	user_id BIGINT UNSIGNED NOT NULL,
 	product_id BIGINT UNSIGNED NOT NULL,
 	packing_id BIGINT UNSIGNED NOT NULL DEFAULT 1, -- фасовка, вес
 	created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
 	updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
 	KEY index_of_packing_id (packing_id),
 	KEY index_of_order_id (order_id),
 	KEY index_of_product_id (product_id),
 	PRIMARY KEY (order_id, product_id),
 	FOREIGN KEY (user_id) REFERENCES users(id),
 	FOREIGN KEY (product_id) REFERENCES products(id),
 	FOREIGN KEY (packing_id) REFERENCES packing(id),
 	FOREIGN KEY (order_id) REFERENCES orders(id)
) COMMENT = 'Состав заказа';

INSERT INTO orders_products (user_id, order_id, product_id, packing_id) VALUES 
	(1, 1, 1, 1),
	(1, 1, 3, 3),
	(1, 1, 5, 2),
	(1, 1, 7, 1),
	(2, 2, 9, 3),
	(2, 2, 8, 2),
	(3, 3, 2, 1),
	(3, 3, 6, 3),
	(4, 4, 4, 4)
;
-- --------------------------------------------------------
DROP TABLE IF EXISTS store_account;  -- счет магазина 10
CREATE TABLE store_account (
	id SERIAL PRIMARY KEY,
	from_user_id BIGINT UNSIGNED NOT NULL,
	check_bill DECIMAL(11,2) UNSIGNED DEFAULT 0.00,
	FOREIGN KEY (from_user_id) REFERENCES users(id)
);
INSERT INTO store_account (from_user_id) VALUES 
	(1),
	(2),
	(3),
	(4)
;
-- --------------------------------------------------------
-- временная таблица 1
CREATE TEMPORARY TABLE tmp_table_1 (
	id INT(11) UNSIGNED NOT NULL AUTO_INCREMENT PRIMARY KEY,
	name VARCHAR(255) NOT NULL,
	price DECIMAL(11,2) UNSIGNED NOT NULL DEFAULT '0.00'
);

-- --------------------------------------------------------
-- временная таблица 2
CREATE TEMPORARY TABLE tmp_table_2 LIKE gift_cards

-- --------------------------------------------------------

-- скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);
-- представления (минимум 2);
-- и хранимые процедуры / триггеры в отдельном файле


