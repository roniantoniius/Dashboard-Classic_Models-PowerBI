-- CTE untuk menghitung nilai penjualan (sales) setiap pelanggan dari tabel orders dan orderdetails
with sales as
(
SELECT t1.orderNumber, t1.customerNumber, productCode, quantityOrdered, priceEach, priceEach * quantityOrdered as salesValue, creditLimit
FROM orders t1
INNER JOIN orderdetails t2
ON t1.orderNumber = t2.orderNumber
INNER JOIN customers t3
ON t1.customerNumber = t3.customerNumber
)
-- Query untuk mengelompokkan penjualan berdasarkan nomor pemesanan, nomor pelanggan, dan kelompok batas kredit
SELECT orderNumber, customerNumber, 
CASE WHEN creditLimit < 75000 then 'a: Less than $75k'
WHEN creditLimit between 75000 and 100000 then 'b: $75k - $100k'
WHEN creditLimit between 100000 and 150000 then 'c: $100k - $150k'
WHEN creditLimit > 150000 then 'd: Over $150k'
END AS creditLimit_group,
sum(salesValue) as salesValue
FROM sales
GROUP BY orderNumber, customerNumber, creditLimit_group