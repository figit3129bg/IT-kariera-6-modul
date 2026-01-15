
-- 10 различни заявки


-- 1.Заявка да се покажат всияките поръчки на клиент
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











