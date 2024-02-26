-- CTE untuk menghitung nilai penjualan (sales) setiap pelanggan dari tabel orders dan orderdetails
with cte_sales as
(
    SELECT orderDate,
           t1.customerNumber,
           t1.orderNumber,
           customerName,
           productCode,
           creditLimit,
           quantityOrdered * priceEach as sales_value
    FROM orders t1
    INNER JOIN orderdetails t2 ON t1.orderNumber = t2.orderNumber
    INNER JOIN customers t3 ON t1.customerNumber = t3.customerNumber
),

-- CTE untuk menghitung total penjualan berjalan (running total) setiap pelanggan
running_total_sales_cte as
(
    SELECT *,
           LEAD(orderDate) OVER(PARTITION BY customerNumber ORDER BY orderDate) as next_orderDate
    FROM
    (
        SELECT orderDate, orderNumber, customerNumber, customerName, creditLimit,
               sum(sales_value) as sales_value
        FROM cte_sales
        GROUP BY orderDate, orderNumber, customerNumber, customerName, creditLimit
    ) subquery
),

-- CTE untuk fokus pada pembayaran/payment dari tabel payments
payments_cte as  /* Berfokus pada pembayaran/payment */
(
    SELECT *
    FROM payments
),

-- CTE utama untuk menggabungkan informasi penjualan dan pembayaran, serta menghitung running total pembayaran
main_cte as
(
    SELECT t1.*,
			SUM(sales_value) OVER(PARTITION BY t1.customerNumber ORDER BY orderDate) as running_total_sales, /* Berfokus pada penjualan */
			SUM(amount) OVER(PARTITION BY t1.customerNumber ORDER BY orderDate) as running_total_payments /* Berfokus pada payment */
           
           /*fungsi di atas akan menghitung value berdasarkan partition dari cusNumber terhadap orderDate,
			lalu akan diulang lagi jika cusNumbernya berbeda(atau menghitung secara partition)*/
            
    FROM running_total_sales_cte t1
    LEFT JOIN payments_cte t2 ON t1.customerNumber = t2.customerNumber AND t2.paymentDate BETWEEN orderDate AND CASE WHEN next_orderDate IS NULL THEN current_date() ELSE next_orderDate END
)

-- Query akhir untuk menampilkan hasil, termasuk kolom money owed dan difference
SELECT *,
       running_total_sales - running_total_payments as money_owed,
       creditLimit - (running_total_sales - running_total_payments) as difference
FROM main_cte;