-- Menampilkan data order yang terlambat
SELECT *,
date_add(shippedDate, interval 3 day) as latest_date,
-- Menentukan flag keterlambatan (1: terlambat, 0: tepat waktu)
CASE WHEN date_add(shippedDate, interval 3 day) > requiredDate THEN 1 ELSE 0 end as late_flag
FROM orders
-- Menampilkan hanya order yang terlambat (late_flag = 1)
WHERE (CASE WHEN date_add(shippedDate, interval 3 day) > requiredDate THEN 1 ELSE 0 end) = 1
/* Jadi fungsi WHERE ini bertujuan untuk menampilkan hanya si kolom 'late_flag' yang bernilai 1*/