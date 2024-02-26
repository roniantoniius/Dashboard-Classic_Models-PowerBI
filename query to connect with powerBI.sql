CREATE OR REPLACE VIEW sales_data_for_power_bi as -- menyiapkan data untuk powerBI

SELECT 
orderDate, -- Tanggal pesanan
ord.orderNumber, -- Nomor pesanan
p.productName, -- Nama produk
p.productLine, -- Line produk
c.customerName, -- Nama pelanggan
c.city as customer_city, -- Kota pelanggan
c.country as customer_country, -- Negara pelanggan
o.city as office_city, -- Kota kantor
o.country as office_country, -- Negara kantor
buyPrice, -- Harga beli produk
priceEach, -- Harga setiap produk
quantityOrdered, -- Jumlah produk yang dipesan
quantityOrdered * priceEach as sales_value, -- Nilai penjualan (jumlah produk yang dipesan dikalikan dengan harga setiap produk)
quantityOrdered * buyPrice as cost_of_sales -- Biaya penjualan (jumlah produk yang dipesan dikalikan dengan harga beli produk)


FROM orders ord
INNER JOIN orderdetails orddet
ON ord.orderNumber = orddet.orderNumber
INNER JOIN customers c
ON ord.customerNumber = c.customerNumber
INNER JOIN products p
ON orddet.productCode = p.productCode
INNER JOIN employees emp
ON c.salesRepEmployeeNumber = emp.employeeNumber
INNER JOIN offices o
ON emp.officeCode = o.officeCode