-- CTE untuk memilih nomor pesanan dan lini produk dari tabel orderdetails dan products
with prod_sales as
(
SELECT ordernumber, t1.productCode, productLine
from orderdetails t1
INNER JOIN products t2
ON t1.productCode = t2.productCode
)
-- Query untuk menemukan kombinasi lini produk yang berbeda dalam satu pesanan
SELECT DISTINCT t1.orderNumber, t1.productLine as product_one, t2.productLine as product_two
FROM prod_sales t1
LEFT JOIN prod_sales t2
ON t1.ordernumber = t2.ordernumber AND t1.productLine <> t2.productLine