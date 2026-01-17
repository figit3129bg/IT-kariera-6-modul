
CREATE DATABASE tech_store;
USE tech_store;

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(150) NOT NULL,
    email VARCHAR(150)  NOT NULL
    
);

-- customer_profiles e za da se pokaze 1 kum 1 vruzka

CREATE TABLE customer_profiles (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,

    phone VARCHAR(20),
    address VARCHAR(255),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);



CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL
);

CREATE TABLE products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(150) NOT NULL,
     product_description TEXT,
    product_price DECIMAL(10,2) NOT NULL,
     stock_quantity INT NOT NULL,
     product_rating DECIMAL(3,2) DEFAULT 0,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES categories(category_id)
);



CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
     order_date DATE NOT NULL,
     delivered TINYINT(1) NOT NULL DEFAULT 0, -- 0 za nedostavena, 1 za dostavena
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT NOT NULL,
    unit_price DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id),
    FOREIGN KEY (product_id) REFERENCES products(product_id)
    
);




INSERT INTO customers (full_name, email) VALUES
('Иван Петров', 'ivan@gmail.com'),
('Мария Георгиева', 'maria@gmail.com'),
('Петър Иванов', 'petar@gmail.com'),
('Стилян Петров', 'stilqn@gmail.com'),
('Георги Димитров', 'georgi@gmail.com');

INSERT INTO customer_profiles (customer_id, phone, address) VALUES
(1, '0888123456', 'София'),
(2, '0899123456', 'Пловдив'),
(3, '0877123456', 'Варна'),
(4, '0888937452', 'Хасково'),
(5, '0887956234', 'Враца');

INSERT INTO categories (category_name) VALUES
('Лаптопи'),
('Настолни компютри'),
('Таблети'),
('Смартфони'),
('Части за компютри и лаптопи'),
('Аксесоари');

INSERT INTO products (product_name, product_description, product_price, stock_quantity, category_id) VALUES
('Acer Aspire 5', 'Intel i5 13th gen 15.6 inch, 16GB RAM', 1500.00, 10, 1),
('Acer Nitro V 16', 'Intel i7 14th gen 16 inch, 16GB RAM', 2700.00, 5, 1),
('Apple Mac Mini', 'Apple M4 10C 16GB RAM', 1500.00, 11, 2),
('Lenovo ThinkCentre neo 55s Gen 6', 'AMD Ryzen 5 220 16GB RAM', 1300.00, 7, 2),
('Samsung Galaxy S25 Ultra', '512GB 12GB RAM', 2300.00, 9, 4),
(' AMD Ryzen 9 9950X3D', '4.3GHz', 1750.00, 9, 5),
('USB-C Cable', '2.1A charging', 15.00, 25, 6),
('SAMSUNG Galaxy Tab A11 X130 Gray', ' 8.7 inch', 300.00, 10, 3);

INSERT INTO orders (customer_id, order_date, delivered) VALUES
(1, '2025-01-10', 1),
(1, '2025-02-05', 0),
(2, '2025-02-01', 1),
(3, '2025-02-03', 0),
(4, '2025-01-11', 1),
(5, '2025-02-07', 0),
(5, '2025-02-04', 1),
(3, '2025-02-09', 0);

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
(1, 1, 1, 1500.00),
(2, 2, 2, 2700.00),
(3, 3, 2, 1500.00),
(4, 4, 4, 1300.00),
(5, 5, 1, 2300.00),
(6, 7, 1, 15.00),
(7, 8, 1, 300.00),
(8, 7, 1, 15.00);

INSERT INTO products (product_name, product_description, product_price, stock_quantity, category_id) VALUES
('SAMSUNGеGalaxy Tab A17 X130 Gray', ' 8.7 inch', 300.00, 10, 3);

DELETE FROM products
WHERE product_name = 'SAMSUNGе Galaxy Tab A17 X130 Gray';



-- 10 различни заявки


-- 1.Заявка да се покажат всичките поръчки на клиент
SELECT *
FROM orders
WHERE customer_id = 1;

-- 2.Всички клиенти с техните адреси (показване на 1:1 връзка)
SELECT full_name, phone, address
FROM customers c
JOIN customer_profiles p ON c.customer_id = p.customer_id;

-- 3.Клиенти и техните поръчки (1:N)
SELECT c.full_name, o.order_id, o.order_date, o.delivered
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id;


-- 4. Всички поръчки и техните продукти
SELECT o.order_id, pr.product_name, oi.quantity
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products pr ON oi.product_id = pr.product_id;


-- 5.Заявка за обща стойност на всички поръчки
SELECT o.order_id,
       SUM(oi.quantity * oi.unit_price) AS total_price
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY o.order_id;

-- 6.ЗОбщо похарчено от всеки клиент
SELECT cust.full_name,
       SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers cust
JOIN orders o ON cust.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY cust.customer_id;

-- 7.Всички пордукти сортирани по най-продавани
SELECT p.product_name,
       SUM(oi.quantity) AS total_sold
FROM products p
JOIN order_items oi ON p.product_id = oi.product_id
GROUP BY p.product_id
ORDER BY total_sold DESC;

-- 8.Топ 3 клиента по похарчени пари
SELECT c.full_name,
       SUM(oi.quantity * oi.unit_price) AS total_spent
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
GROUP BY c.customer_id
ORDER BY total_spent DESC
LIMIT 3;

-- 9.Клиенти с недоставени поръчки и какво съдържат те
SELECT 
    c.full_name,
    o.order_id,
    p.product_name,
    oi.quantity
FROM customers c
JOIN orders o ON c.customer_id = o.customer_id
JOIN order_items oi ON o.order_id = oi.order_id
JOIN products p ON oi.product_id = p.product_id
WHERE o.delivered = 0;

-- 10. Заявка за маркиране на дадена поръчка като доставена 
UPDATE orders
SET delivered = 1
WHERE order_id = 2;

