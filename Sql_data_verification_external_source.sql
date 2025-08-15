-- Проверим на дубликаты
WITH dupl AS (
    SELECT order_id, craftsman_id, product_id, COUNT(*)
    FROM external_source.craft_products_orders
    GROUP BY order_id, craftsman_id, product_id
    HAVING COUNT(*) > 1
)
SELECT *
FROM dupl;

-- Проверим на пропуски
SELECT
    SUM(CASE WHEN order_id IS NULL THEN 1 ELSE 0 END) AS mis_order,
    SUM(CASE WHEN craftsman_id IS NULL THEN 1 ELSE 0 END) AS mis_customer,
    SUM(CASE WHEN product_id IS NULL THEN 1 ELSE 0 END) AS mis_product
FROM external_source.craft_products_orders;

-- Клиенты, на которых нет информации 
SELECT o.customer_id
FROM external_source.craft_products_orders o
LEFT JOIN external_source.customers c ON o.customer_id = c.customer_id
WHERE c.customer_id IS NULL;

-- Заказы с нереальными суммами
SELECT *
FROM external_source.craft_products_orders
WHERE product_price <= 0 OR product_price >= 1000000;