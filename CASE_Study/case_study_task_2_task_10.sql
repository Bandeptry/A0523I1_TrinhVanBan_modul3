-- 2.	Hiển thị thông tin của tất cả nhân viên có trong hệ thống có tên bắt đầu 
-- là một trong các ký tự “H”, “T” hoặc “K” và có tối đa 15 kí tự.
USE furama_management;
SELECT *
FROM nhan_vien
WHERE ho_ten LIKE 'H%' OR ho_ten LIKE 'T%' OR ho_ten LIKE 'K%' AND LENGTH(ho_ten) <= 15;

-- 3.	Hiển thị thông tin của tất cả khách hàng có độ tuổi từ 18 đến 50 tuổi và có địa chỉ ở “Đà Nẵng” hoặc “Quảng Trị”.
SELECT ho_ten kh, YEAR(NOW()) - YEAR(ngay_sinh) AS age, dia_chi
FROM khach_hang kh
WHERE dia_chi LIKE '%Đà Nẵng%' OR dia_chi LIKE '%Quảng Trị%'
HAVING age BETWEEN 18 AND 50;

-- 4.	Đếm xem tương ứng với mỗi khách hàng đã từng đặt phòng bao nhiêu lần. 
-- Kết quả hiển thị được sắp xếp tăng dần theo số lần đặt phòng của khách hàng. 
-- Chỉ đếm những khách hàng nào có Tên loại khách hàng là “Diamond”.
SELECT kh.ma_khach_hang ,ho_ten kh, COUNT(hd.ma_hop_dong) AS 'số lần đặt phòng',  lk.ten_loai_khach
FROM khach_hang kh
JOIN loai_khach lk ON lk.ma_loai_khach = kh.ma_loai_khach
JOIN hop_dong hd ON hd.ma_khach_hang = kh.ma_khach_hang
WHERE lk.ten_loai_khach = 'Diamond'
GROUP BY hd.ma_hop_dong;
-- 5.	Hiển thị ma_khach_hang, ho_ten, ten_loai_khach, ma_hop_dong, ten_dich_vu, ngay_lam_hop_dong, ngay_ket_thuc, tong_tien 
-- (Với tổng tiền được tính theo công thức như sau: Chi Phí Thuê + Số Lượng * Giá, 
-- với Số Lượng và Giá là từ bảng dich_vu_di_kem, hop_dong_chi_tiet) cho tất cả các khách hàng đã từng đặt phòng. 
-- (những khách hàng nào chưa từng đặt phòng cũng phải hiển thị ra). 



-- 6.	Hiển thị ma_dich_vu, ten_dich_vu, dien_tich, chi_phi_thue, ten_loai_dich_vu 
-- của tất cả các loại dịch vụ chưa từng được khách hàng thực hiện đặt từ quý 1 của năm 2021 (Quý 1 là tháng 1, 2, 3).
SELECT dv.ma_dich_vu, dv.ten_dich_vu, dv.dien_tich, dv.chi_phi_thue, ldv.ten_loai_dich
FROM dich_vu dv
JOIN loai_dich_vu ldv ON dv.ma_loai_dich_vu = ldv.ma_loai_dich_vu
WHERE
	dv.ma_dich_vu NOT IN (
    SELECT dv.ma_dich_vu 
    FROM dich_vu dv
    JOIN hop_dong hd ON hd.ma_dich_vu = dv.ma_dich_vu
    WHERE hd.ngay_lam_hop_dong BETWEEN '2021-01-01' AND '2021-03-31')
	GROUP BY dv.ma_dich_vu;

-- 7.	Hiển thị thông tin ma_dich_vu, ten_dich_vu, dien_tich, so_nguoi_toi_da, chi_phi_thue, ten_loai_dich_vu 
-- của tất cả các loại dịch vụ đã từng được khách hàng đặt phòng trong năm 2020 
-- nhưng chưa từng được khách hàng đặt phòng trong năm 2021.
SELECT dv.ma_dich_vu, dv.ten_dich_vu, dv.dien_tich, dv.so_nguoi_toi_da, dv.chi_phi_thue, ldv.ten_loai_dich,hd.ngay_lam_hop_dong
FROM dich_vu dv
JOIN loai_dich_vu ldv ON dv.ma_loai_dich_vu = ldv.ma_loai_dich_vu
WHERE dv.ma_dich_vu IN (
	SELECT dv.ma_dich_vu
    FROM dich_vu dv 
    JOIN hop_dong hd ON dv.ma_dich_vu = hd.ma_dich_vu
    WHERE hd.ngay_lam_hop_dong BETWEEN '2021-01-01' AND '2021-12-31'
)
-- 8.	Hiển thị thông tin ho_ten khách hàng có trong hệ thống, với yêu cầu ho_ten không trùng nhau.
-- Học viên sử dụng theo 3 cách khác nhau để thực hiện yêu cầu trên.

SELECT
	DISTINCT ho_ten
FROM
	khach_hang;
    
SELECT
	ho_ten
FROM
	khach_hang
GROUP BY
	ho_ten;
    
SELECT
	ho_ten
FROM
	khach_hang
UNION
SELECT
	ho_ten
FROM
	khach_hang;

-- 9.	Thực hiện thống kê doanh thu theo tháng, nghĩa là tương ứng với mỗi tháng trong năm 2021 thì sẽ có bao nhiêu khách hàng thực hiện đặt phòng.

SELECT
	COUNT(ma_khach_hang) AS so_khach_dat_hang,
    month(ngay_lam_hop_dong) AS thang
FROM
	hop_dong
WHERE
	year(ngay_lam_hop_dong) = 2021
GROUP BY
	month(ngay_lam_hop_dong)
ORDER BY
	thang;

-- 10.	Hiển thị thông tin tương ứng với từng hợp đồng thì đã sử dụng bao nhiêu dịch vụ đi kèm. 
-- Kết quả hiển thị bao gồm ma_hop_dong, ngay_lam_hop_dong, ngay_ket_thuc, tien_dat_coc, so_luong_dich_vu_di_kem (được tính dựa trên việc sum so_luong ở dich_vu_di_kem).

SELECT
	hop_dong.ma_hop_dong,
    hop_dong.ngay_lam_hop_dong,
    hop_dong.ngay_ket_thuc,
    hop_dong.tien_dat_coc,
    sum(ifnull(hop_dong_chi_tiet.so_luong,0)) AS so_luong_dich_vu_di_kem
FROM
	hop_dong LEFT JOIN hop_dong_chi_tiet ON hop_dong.ma_hop_dong = hop_dong_chi_tiet.ma_hop_dong
GROUP BY
	hop_dong.ma_hop_dong;