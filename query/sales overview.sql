-- Menampilkan data order tahun 2004
SELECT t1.orderDate, t1.orderNumber, t2.quantityOrdered, t2.priceEach, t3.productName, t3.productLine, t3.buyPrice, t4.city, t4.country
FROM orders t1
INNER JOIN orderdetails t2
ON t1.ordernumber = t2.ordernumber
INNER JOIN products t3
ON t2.productCode = t3.productCode
INNER JOIN customers t4
ON t1.customerNumber = t4.customerNumber
WHERE year(orderDate) = 2004