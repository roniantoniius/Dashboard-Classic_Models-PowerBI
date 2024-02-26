-- CTE untuk menghitung nilai penjualan (sales_value) setiap pemesanan
with main_cte as
(
SELECT orderNumber, orderDate, customerNumber, sum(sales_value) as sales_value
FROM
(SELECT t1.orderNumber, orderDate, customerNumber, productCode, quantityOrdered * priceEach as sales_value
FROM orders t1
INNER JOIN orderdetails t2
ON t1.orderNumber = t2.orderNumber) main
GROUP BY orderNumber, orderDate, customerNumber
),

-- CTE untuk menghitung nomor pembelian (purchase_number) dan nilai penjualan sebelumnya (prev_sales_value)
sales_query as
(
SELECT t1.*, customerName, row_number() OVER(PARTITION BY customerName ORDER BY orderDate) as purchase_number,
LAG(sales_value) OVER(PARTITION BY customerName ORDER BY orderDate) as prev_sales_value
FROM main_cte t1
INNER JOIN customers t2
ON t1.customerNumber = t2.customerNumber)

-- Query untuk menampilkan perubahan nilai pembelian (purchase_value_change)
SELECT *, sales_value - prev_sales_value as purchase_value_change
FROM sales_query
WHERE prev_sales_value is not null
