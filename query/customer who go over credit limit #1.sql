-- CTE untuk menghitung nilai penjualan (sales) setiap pelanggan dari tabel orders dan orderdetails
with main_cte as
(
SELECT orderDate,
t1.customerNumber,
t1.orderNumber,
customerName,
productCode,
creditLimit,
quantityOrdered * priceEach as sales_value
FROM orders t1
INNER JOIN orderdetails t2
ON t1.orderNumber = t2.orderNumber
INNER JOIN customers t3
ON t1.customerNumber = t3.customerNumber
),

-- CTE untuk menghitung total penjualan setiap pelanggan
running_total_sales_cte as
(
SELECT orderDate, orderNumber, customerNumber, customerName, creditLimit,
sum(sales_value) as sales_value
FROM main_cte
GROUP BY orderDate, customerNumber, orderNumber, creditLimit
)

-- Query untuk menghitung total pembelian (purch_num) setiap pelanggan
SELECT *,
SUM(sales_value) OVER(PARTITION BY customerNumber ORDER BY orderDate) as purch_num
/*fungsi di atas akan menghitung value berdasarkan partition dari cusNumber terhadap orderDate,
lalu akan diulang lagi jika cusNumbernya berbeda(atau menghitung secara partition)*/
FROM running_total_sales_cte