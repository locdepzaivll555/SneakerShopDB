-- Tạo db
create database SneakerShopDB
Use SneakerShopDB
Go
-- Tạo bảng Customers
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FullName NVARCHAR(100),
	AccountName nvarchar(100) not null unique,
    Password NVARCHAR(15) not null,
    Email NVARCHAR(100) not null ,
    Phone NVARCHAR(15)not null,
    Gender NVARCHAR(10) CHECK (Gender IN (N'Nam', N'Nữ')),
    CONSTRAINT chk_passwordlength CHECK (LEN(Password) >= 8 AND LEN(Password) < 15),
	CONSTRAINT chk_Email CHECK (Email LIKE '%@%.%');
);

-- Tạo bảng Categories
CREATE or ALTER TABLE Categories (
    CategoryID INT IDENTITY(1,1) PRIMARY KEY,
    CategoryName NVARCHAR(50)
);

-- Tạo bảng Products
CREATE or ALTER TABLE Products (
    ProductID INT IDENTITY(1,1) PRIMARY KEY,
    ProductName NVARCHAR(100),
    Description NVARCHAR(MAX),
    Price DECIMAL(10, 3),
    CategoryID INT,
    Quantity INT DEFAULT 0
    FOREIGN KEY (CategoryID) REFERENCES Categories(CategoryID)
);

-- Tạo bảng ProductSizes với Gender bao gồm Nam, Nữ, Unisex
CREATE or ALTER TABLE ProductSizes (
    ProductSizeID INT IDENTITY(1,1) PRIMARY KEY,
    ProductID INT,
    Size NVARCHAR(10),
    Gender NVARCHAR(10) CHECK (Gender IN (N'Nam', N'Nữ', N'Unisex')),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Tạo bảng ShippingAddresses
CREATE or ALTER TABLE ShippingAddresses (
    AddressID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    AddressDetail NVARCHAR(200),
    City NVARCHAR(50),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Tạo bảng Orders
CREATE or ALTER TABLE Orders (
    OrderID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT,
    OrderDate DATETIME,
    TotalAmount DECIMAL(10, 3),
    AddressID INT,
    PaymentStatus NVARCHAR(20) DEFAULT N'Chưa thanh toán',
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    FOREIGN KEY (AddressID) REFERENCES ShippingAddresses(AddressID)
);

-- Tạo bảng OrderDetails
CREATE or ALTER TABLE OrderDetails (
    OrderID INT,
    ProductID INT,
    Quantity INT,
    Price DECIMAL(10, 3),
    PRIMARY KEY (OrderID, ProductID),
    FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);

-- Tạo bảng Cart (Giỏ hàng)
CREATE or ALTER TABLE Cart (
    CartID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NULL,  -- Có thể NULL nếu khách chưa đăng nhập
    SessionID NVARCHAR(50) NULL,  -- Để theo dõi giỏ hàng của khách chưa đăng nhập
    CreatedDate DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID)
);

-- Tạo bảng CartDetails (Chi tiết giỏ hàng)
CREATE or ALTER TABLE CartDetails (
    CartDetailID INT IDENTITY(1,1) PRIMARY KEY,
    CartID INT NOT NULL,
    ProductID INT NOT NULL,
    Quantity INT NOT NULL,
    Size NVARCHAR(10) NOT NULL;  -- Nếu sản phẩm có kích cỡ
    FOREIGN KEY (CartID) REFERENCES Cart(CartID),
    FOREIGN KEY (ProductID) REFERENCES Products(ProductID)
);
go

-- Nhập dữ liệu vào bảng Categories
INSERT INTO Categories (CategoryName) VALUES (N'Chạy Bộ');
INSERT INTO Categories (CategoryName) VALUES (N'Bóng Rổ');
INSERT INTO Categories (CategoryName) VALUES (N'Thời Trang');
INSERT INTO Categories (CategoryName) VALUES (N'Bóng Đá');
INSERT INTO Categories (CategoryName) VALUES (N'Quần Vợt');
go
-- Nhập dữ liệu vào bảng Products
-- Insert dữ liệu cho danh mục Chạy Bộ (CategoryID = 1)
INSERT INTO Products (ProductName, Description, Price, CategoryID, Quantity)
VALUES
(N'Nike Pegasus 41', N'Giày chạy bộ với công nghệ ReactX, phản hồi năng lượng cao, upper mesh thoáng khí.', 3829, 1, 50),
(N'Adidas Adios Pro 4', N'Giày đua với ENERGYRODS 2.0, đế LIGHTSTRIKE PRO, chuyển đổi mượt mà, êm ái.', 6500, 1, 60),
(N'Asics Metaspeed Sky', N'Giày chạy đua siêu nhẹ, đế FF BLAST TURBO, hỗ trợ tăng tốc, upper thoáng khí.', 5800, 1, 70),
(N'Puma Deviate Nitro', N'Giày chạy bộ với đế NITRO FOAM, tăng độ đàn hồi, upper nhẹ, bám đường tốt.', 4200, 1, 80),
(N'New Balance FuelCell', N'Giày chạy hiệu suất cao, đế FuelCell êm ái, upper Hypoknit, hỗ trợ chạy dài.', 3900, 1, 90),
(N'Brooks Ghost 16', N'Giày chạy bộ với đế DNA LOFT v3, giảm chấn tốt, upper mềm mại, thoải mái.', 3600, 1, 100);

-- Insert dữ liệu cho danh mục Bóng Rổ (CategoryID = 2)
INSERT INTO Products (ProductName, Description, Price, CategoryID, Quantity)
VALUES
(N'Nike Lebron XXI', N'Giày bóng rổ cao cấp, Zoom Air, Flywire, hỗ trợ bật nhảy mạnh, bám sàn tốt.', 5000, 2, 50),
(N'Adidas Harden Vol 8', N'Giày bóng rổ với đế BOOST, upper nhẹ, hỗ trợ di chuyển nhanh, phong cách hiện đại.', 4500, 2, 60),
(N'Puma MB.01', N'Giày bóng rổ với đế NITRO, upper ôm chân, tăng độ bám, phù hợp chơi mạnh.', 3800, 2, 70),
(N'Li-Ning Wade 808', N'Giày bóng rổ với đế Cloud, upper thoáng khí, hỗ trợ bật nhảy, thiết kế độc đáo.', 3200, 2, 80),
(N'Nike G.T. Jump 2', N'Giày bóng rổ với Zoom Air kép, đế phản hồi tốt, upper bền, tối ưu nhảy cao.', 4800, 2, 90),
(N'Jordan Zion 3', N'Giày bóng rổ với công nghệ Air Strobel, upper nhẹ, hỗ trợ đa hướng, phong cách trẻ.', 4300, 2, 100);

-- Insert dữ liệu cho danh mục Thời Trang (CategoryID = 3)
INSERT INTO Products (ProductName, Description, Price, CategoryID, Quantity)
VALUES
(N'New Balance 990 v6', N'Giày phong cách, đế ENCAP, upper suede, thoải mái hàng ngày, thiết kế cổ điển.', 4500, 3, 50),
(N'Nike Air Force 1', N'Giày thời trang kinh điển, upper da, đế Air, phong cách đường phố, dễ phối đồ.', 2900, 3, 60),
(N'Adidas Stan Smith', N'Giày thời trang tối giản, upper da, đế cao su, phong cách thanh lịch, đa dụng.', 2500, 3, 70),
(N'Vans Old Skool', N'Giày phong cách skate, upper vải và da, đế waffle, trẻ trung, năng động.', 1800, 3, 80),
(N'Converse Chuck Taylor', N'Giày thời trang cổ điển, upper vải, đế cao su, phong cách unisex, dễ phối đồ.', 1600, 3, 90),
(N'Puma Suede Classic', N'Giày phong cách retro, upper da lộn, đế cao su, thoải mái, phù hợp hàng ngày.', 2200, 3, 100);

-- Insert dữ liệu cho danh mục Bóng Đá (CategoryID = 4)
INSERT INTO Products (ProductName, Description, Price, CategoryID, Quantity)
VALUES
(N'Nike Mercurial Superfly', N'Giày bóng đá với Flyknit, đế carbon, hỗ trợ tốc độ, bám sân cỏ tốt, nhẹ.', 6000, 4, 50),
(N'Adidas Predator Elite', N'Giày bóng đá với đế CONTROLFRAME, upper Demonskin, tăng lực sút, bám sân tốt.', 5500, 4, 60),
(N'Puma Future Z', N'Giày bóng đá với upper FUZIONFIT+, đế nhẹ, hỗ trợ kiểm soát bóng, linh hoạt.', 4200, 4, 70),
(N'New Balance Furon', N'Giày bóng đá với upper Hypoknit, đế siêu nhẹ, tăng tốc độ, bám sân tốt.', 3800, 4, 80),
(N'Li-Ning Speed Star', N'Giày bóng đá với upper TPU, đế chống trượt, hỗ trợ tốc độ, giá cả hợp lý.', 2800, 4, 90),
(N'Nike Tiempo Legend', N'Giày bóng đá với upper da kangaroo, đế linh hoạt, kiểm soát bóng tốt, bền bỉ.', 5200, 4, 100);

-- Insert dữ liệu cho danh mục Quần Vợt (CategoryID = 5)
INSERT INTO Products (ProductName, Description, Price, CategoryID, Quantity)
VALUES
(N'Asics Gel-Resolution 9', N'Giày quần vợt với GEL, upper Flexion Fit, hỗ trợ di chuyển, bám sân tốt.', 3500, 5, 50),
(N'Nike Vapor Pro', N'Giày quần vợt nhẹ, đế Zoom Air, upper thoáng khí, hỗ trợ di chuyển nhanh.', 3200, 5, 60),
(N'Adidas Barricade', N'Giày quần vợt với đế Bounce, upper bền, hỗ trợ ổn định, phù hợp sân cứng.', 3400, 5, 70),
(N'New Balance Lav v2', N'Giày quần vợt với đế FuelCell, upper thoáng khí, hỗ trợ bật nhảy, bền bỉ.', 3100, 5, 80),
(N'Wilson Kaos Swift', N'Giày quần vợt với đế Duralast, upper nhẹ, tăng tốc độ, phù hợp mọi sân.', 2900, 5, 90),
(N'Li-Ning Ace Pro', N'Giày quần vợt với đế TUFF RB, upper thoáng khí, hỗ trợ di chuyển, giá tốt.', 2700, 5, 100);
-- Nhập dữ liệu vào bảng ProductSizes
-- 1. Nike Pegasus 41 (ProductID = 1, Nam: 41-46, Nữ: 36-40)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (1, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (1, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (1, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (1, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (1, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (1, N'46', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (1, N'36', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (1, N'37', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (1, N'38', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (1, N'39', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (1, N'40', N'Nữ');

-- 2. Adidas Adios Pro 4 (ProductID = 2, Nam: 41-46, Nữ: 36-40)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (2, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (2, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (2, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (2, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (2, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (2, N'46', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (2, N'36', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (2, N'37', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (2, N'38', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (2, N'39', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (2, N'40', N'Nữ');

-- 3. Asics Metaspeed Sky (ProductID = 3, Nam: 41-46, Nữ: 36-40)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (3, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (3, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (3, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (3, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (3, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (3, N'46', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (3, N'36', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (3, N'37', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (3, N'38', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (3, N'39', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (3, N'40', N'Nữ');

-- 4. Puma Deviate Nitro (ProductID = 4, Nam: 41-46, Nữ: 36-40)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (4, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (4, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (4, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (4, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (4, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (4, N'46', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (4, N'36', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (4, N'37', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (4, N'38', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (4, N'39', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (4, N'40', N'Nữ');

-- 5. New Balance FuelCell (ProductID = 5, Nam: 41-46, Nữ: 36-40)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (5, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (5, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (5, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (5, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (5, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (5, N'46', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (5, N'36', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (5, N'37', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (5, N'38', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (5, N'39', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (5, N'40', N'Nữ');

-- 6. Brooks Ghost 16 (ProductID = 6, Nam: 41-46, Nữ: 36-40)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (6, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (6, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (6, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (6, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (6, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (6, N'46', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (6, N'36', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (6, N'37', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (6, N'38', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (6, N'39', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (6, N'40', N'Nữ');

-- 7. Nike Lebron XXI (ProductID = 7, Nam: 41-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (7, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (7, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (7, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (7, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (7, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (7, N'46', N'Nam');

-- 8. Adidas Harden Vol 8 (ProductID = 8, Nam: 41-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (8, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (8, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (8, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (8, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (8, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (8, N'46', N'Nam');

-- 9. Puma MB.01 (ProductID = 9, Nam: 41-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (9, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (9, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (9, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (9, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (9, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (9, N'46', N'Nam');

-- 10. Li-Ning Wade 808 (ProductID = 10, Nam: 41-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (10, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (10, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (10, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (10, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (10, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (10, N'46', N'Nam');

-- 11. Nike G.T. Jump 2 (ProductID = 11, Nam: 41-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (11, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (11, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (11, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (11, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (11, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (11, N'46', N'Nam');

-- 12. Jordan Zion 3 (ProductID = 12, Nam: 41-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (12, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (12, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (12, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (12, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (12, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (12, N'46', N'Nam');

-- 13. New Balance 990 v6 (ProductID = 13, Unisex: 36-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (13, N'36', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (13, N'37', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (13, N'38', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (13, N'39', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (13, N'40', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (13, N'41', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (13, N'42', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (13, N'43', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (13, N'44', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (13, N'45', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (13, N'46', N'Unisex');

-- 14. Nike Air Force 1 (ProductID = 14, Unisex: 36-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (14, N'36', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (14, N'37', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (14, N'38', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (14, N'39', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (14, N'40', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (14, N'41', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (14, N'42', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (14, N'43', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (14, N'44', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (14, N'45', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (14, N'46', N'Unisex');

-- 15. Adidas Stan Smith (ProductID = 15, Unisex: 36-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (15, N'36', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (15, N'37', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (15, N'38', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (15, N'39', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (15, N'40', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (15, N'41', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (15, N'42', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (15, N'43', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (15, N'44', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (15, N'45', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (15, N'46', N'Unisex');

-- 16. Vans Old Skool (ProductID = 16, Unisex: 36-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (16, N'36', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (16, N'37', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (16, N'38', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (16, N'39', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (16, N'40', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (16, N'41', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (16, N'42', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (16, N'43', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (16, N'44', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (16, N'45', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (16, N'46', N'Unisex');

-- 17. Converse Chuck Taylor (ProductID = 17, Unisex: 36-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (17, N'36', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (17, N'37', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (17, N'38', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (17, N'39', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (17, N'40', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (17, N'41', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (17, N'42', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (17, N'43', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (17, N'44', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (17, N'45', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (17, N'46', N'Unisex');

-- 18. Puma Suede Classic (ProductID = 18, Unisex: 36-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (18, N'36', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (18, N'37', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (18, N'38', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (18, N'39', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (18, N'40', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (18, N'41', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (18, N'42', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (18, N'43', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (18, N'44', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (18, N'45', N'Unisex');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (18, N'46', N'Unisex');

-- 19. Nike Mercurial Superfly (ProductID = 19, Nam: 41-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (19, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (19, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (19, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (19, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (19, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (19, N'46', N'Nam');

-- 20. Adidas Predator Elite (ProductID = 20, Nam: 41-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (20, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (20, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (20, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (20, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (20, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (20, N'46', N'Nam');

-- 21. Puma Future Z (ProductID = 21, Nam: 41-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (21, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (21, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (21, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (21, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (21, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (21, N'46', N'Nam');

-- 22. New Balance Furon (ProductID = 22, Nam: 41-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (22, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (22, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (22, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (22, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (22, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (22, N'46', N'Nam');

-- 23. Li-Ning Speed Star (ProductID = 23, Nam: 41-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (23, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (23, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (23, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (23, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (23, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (23, N'46', N'Nam');

-- 24. Nike Tiempo Legend (ProductID = 24, Nam: 41-46)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (24, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (24, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (24, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (24, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (24, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (24, N'46', N'Nam');

-- 25. Asics Gel-Resolution 9 (ProductID = 25, Nam: 41-46, Nữ: 36-40)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (25, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (25, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (25, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (25, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (25, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (25, N'46', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (25, N'36', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (25, N'37', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (25, N'38', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (25, N'39', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (25, N'40', N'Nữ');

-- 26. Nike Vapor Pro (ProductID = 26, Nam: 41-46, Nữ: 36-40)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (26, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (26, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (26, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (26, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (26, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (26, N'46', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (26, N'36', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (26, N'37', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (26, N'38', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (26, N'39', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (26, N'40', N'Nữ');

-- 27. Adidas Barricade (ProductID = 27, Nam: 41-46, Nữ: 36-40)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (27, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (27, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (27, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (27, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (27, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (27, N'46', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (27, N'36', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (27, N'37', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (27, N'38', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (27, N'39', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (27, N'40', N'Nữ');

-- 28. New Balance Lav v2 (ProductID = 28, Nam: 41-46, Nữ: 36-40)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (28, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (28, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (28, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (28, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (28, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (28, N'46', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (28, N'36', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (28, N'37', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (28, N'38', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (28, N'39', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (28, N'40', N'Nữ');

-- 29. Wilson Kaos Swift (ProductID = 29, Nam: 41-46, Nữ: 36-40)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (29, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (29, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (29, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (29, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (29, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (29, N'46', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (29, N'36', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (29, N'37', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (29, N'38', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (29, N'39', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (29, N'40', N'Nữ');

-- 30. Li-Ning Ace Pro (ProductID = 30, Nam: 41-46, Nữ: 36-40)
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (30, N'41', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (30, N'42', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (30, N'43', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (30, N'44', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (30, N'45', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (30, N'46', N'Nam');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (30, N'36', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (30, N'37', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (30, N'38', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (30, N'39', N'Nữ');
INSERT INTO ProductSizes (ProductID, Size, Gender) VALUES (30, N'40', N'Nữ');
go
----------------------------------------------------VIEW----------------------------------------------

-- 1.Tạo view hiển thị danh sách sản phẩm khi bắt đầu mua hàng
CREATE or ALTER view ShowProducts1 as
Select P.ProductID,
	   p.ProductName,
       p.Price,
       c.CategoryName
FROM Products p
Join categories c on p.CategoryID= c.CategoryID

---2.Tạo VIEW hiển thị chi tiết sản phẩm sau khi chọn xem
CREATE OR ALTER VIEW ShowDetailProducts AS
SELECT 
    p.ProductID,
    p.ProductName,
    p.Price,
    p.Description,
    c.CategoryName,
    ps.Gender,
    ps.Size,
    p.Quantity  -- Thêm cột Quantity
FROM 
    Products p
JOIN 
    Categories c ON p.CategoryID = c.CategoryID
JOIN 
    ProductSizes ps ON p.ProductID = ps.ProductID;

---3.Tạo View hiển thị sp có giá dưới 3m
CREATE or ALTER VIEW ProductsUnder3M AS
SELECT p.ProductID,p.ProductName,c.CategoryName, p.Price
FROM Products p
join Categories c on p.CategoryID = c.CategoryID
WHERE Price < 3000.000;

---4.Tạo View hiển thị sp có giá từ 2m-5m
CREATE or ALTER VIEW Products3MTo5M AS
SELECT p.ProductID,p.ProductName,c.CategoryName, p.Price
FROM Products p
join Categories c on p.CategoryID = c.CategoryID
WHERE Price BETWEEN 3000.000 AND 5000.000;

---5.Tạo View hiển thị sp có giá >5m
CREATE or ALTER VIEW ProductsOver5M AS
SELECT p.ProductID,p.ProductName,c.CategoryName, p.Price
FROM Products p
join Categories c on p.CategoryID = c.CategoryID
WHERE Price > 5000.000;

---6.Tạo View hiển thị sp theo unisex
CREATE or ALTER VIEW UnisexProducts AS
SELECT p.ProductID,p.ProductName, ps.Gender,c.CategoryName,p.Price
FROM Products p
JOIN ProductSizes ps ON p.ProductID = ps.ProductID
Join Categories c on p.CategoryID = c.CategoryID
WHERE ps.Gender = N'Unisex';

---7.Tạo View hiển thị sp theo giới tính nam
CREATE or ALTER VIEW ProductsForMen AS
SELECT p.ProductID,p.ProductName, ps.Gender,c.CategoryName,p.Price
FROM Products p
JOIN ProductSizes ps ON p.ProductID = ps.ProductID
Join Categories c on p.CategoryID = c.CategoryID
WHERE ps.Gender = N'Nam';

---8.Tạo View hiển thị sp theo giới tính nữ
CREATE or ALTER VIEW ProductsForWomen AS
SELECT p.ProductID,p.ProductName, ps.Gender,c.CategoryName,p.Price
FROM Products p
JOIN ProductSizes ps ON p.ProductID = ps.ProductID
Join Categories c on p.CategoryID = c.CategoryID
WHERE ps.Gender = N'Nữ';

---9.Tạo view hiển thị đầy đủ địa chỉ nhận hàng đã lưu
CREATE or ALTER VIEW ViewShippingAddresses AS
SELECT 
    sa.CustomerID,
    c.FullName,
    sa.AddressDetail,
    sa.City
FROM 
    ShippingAddresses sa
JOIN 
    Customers c ON sa.CustomerID = c.CustomerID;

	---10. Tạo view hiển thị toàn bộ giỏ hàng
CREATE OR ALTER VIEW ShowCart AS
SELECT 
    cd.CartID,
    p.ProductName,
    cd.Size,
    cd.Quantity,
    (p.Price * cd.Quantity) AS TotalPrice
FROM 
    CartDetails cd
JOIN 
    Products p ON cd.ProductID = p.ProductID;
go
--------------------------------------------------TRIGGER---------------------------------------------

-- Tạo trigger để cập nhật số lượng tồn kho sau khi thêm OrderDetails
CREATE TRIGGER UpdateInventory
ON OrderDetails
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    -- Cập nhật số lượng tồn kho
    UPDATE p
    SET p.Quantity = p.Quantity - i.Quantity
    FROM Products p
    JOIN inserted i ON p.ProductID = i.ProductID
    WHERE p.Quantity >= i.Quantity;

    -- Kiểm tra nếu số lượng tồn kho âm
    IF EXISTS (SELECT 1 FROM Products WHERE Quantity < 0)
    BEGIN
        RAISERROR('Số lượng tồn kho không thể âm.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;
go

--------------------------------------------------PROCEDURE-------------------------------------------

---1. TẠO PROCEDURE HIỂN THỊ BAN ĐẦU SẮP XẾP TĂNG DẦN
CREATE or ALTER procedure ShowProductsASC
As
begin
select * from ShowProducts1
order by  price asc;
End
go

---2. Tạo Prodedure hiện thị ban đầu sắp xếp giảm dần
CREATE or ALTER PROCEDURE ShowProductsDESC
As
Begin
Select * from ShowProducts1
Order by price desc;
End
go

---3. Procedure Tạo tài khoàn(không bị trùng)
CREATE or ALTER PROCEDURE RegisterAccount
    @FullName NVARCHAR(100),
	@AccountName Nvarchar(100),
    @Password NVARCHAR(15),
    @Email NVARCHAR(100),
    @Phone NVARCHAR(15),
    @Gender NVARCHAR(10)
AS
BEGIN
    -- Kiểm tra email đã tồn tại
    IF EXISTS (SELECT 1 FROM Customers WHERE Email = @Email)
    BEGIN
        RETURN 1; -- Email đã tồn tại
    END
    -- Kiểm tra số điện thoại đã tồn tại
    IF EXISTS (SELECT 1 FROM Customers WHERE Phone = @Phone)
    BEGIN
        RETURN 2; -- Số điện thoại đã tồn tại
    END

    -- Kiểm tra định dạng email (cơ bản)
    IF @Email NOT LIKE '%@%.%'
    BEGIN
        RETURN 3; -- Định dạng email không hợp lệ
    END

    -- Kiểm tra độ dài mật khẩu
    IF LEN(@Password) < 8 OR LEN(@Password) >= 15
    BEGIN
        RETURN 4; -- Mật khẩu không đúng độ dài
    END

    -- Kiểm tra giới tính
    IF @Gender NOT IN (N'Nam', N'Nữ')
    BEGIN
        RETURN 5; -- Giới tính không hợp lệ
    END
		-- Kiểm tra tên tài khoản đã tồn tại
	If exists (select 1 from Customers Where AccountName = @AccountName)
	Begin
		return 6; -- Tên tk đã tồn tại
	end

    -- Chèn dữ liệu vào bảng Customers nếu tất cả điều kiện đều thỏa mãn
    INSERT INTO Customers (FullName,AccountName, Password, Email, Phone, Gender)
    VALUES (@FullName,@AccountName, @Password, @Email, @Phone, @Gender);

    RETURN 0; -- Thành công
END;
go

---4. PROCEDURE đăng nhập tk
CREATE or ALTER PROCEDURE LoginAccount
    @Username NVARCHAR(100),
    @Password NVARCHAR(15)
AS
BEGIN
    DECLARE @CustomerID INT;
    DECLARE @FullName NVARCHAR(100);

    -- Kiểm tra xem có bản ghi nào khớp với Username (AccountName hoặc Email) và Password không
    SELECT @CustomerID = CustomerID, @FullName = FullName
    FROM Customers
    WHERE (AccountName = @Username OR Email = @Username) AND Password = @Password;

    -- Nếu tìm thấy, trả về thông tin người dùng và RETURN 0
    IF @CustomerID IS NOT NULL
    BEGIN
        SELECT @CustomerID AS CustomerID, @FullName AS FullName;
        RETURN 0;  -- Thành công
    END
    ELSE
    BEGIN
        RETURN 1;  -- Sai mật khẩu hoặc tên tài khoản/email
    END
END;
go

----5. TẠO PROCEDURE HIỂN THỊ GIÀY THEO DANH MỤC TUỲ CHỌN---
CREATE or ALTER PROCEDURE ShowProductsByCategory
@cateID varchar(100)
As
Begin
select p.ProductID,p.ProductName, p.Price, c.CategoryName
from Products p
join Categories c on p.CategoryID = c.CategoryID
WHERE p.CategoryID in (select value from string_split(@cateID,','))
End

---6. Procedure chọn giới tính hiển thị sp
CREATE or ALTER PROCEDURE ShowProductsByGender
    @GenderID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @GenderID = 1 -- Nam và Unisex
        SELECT * FROM ProductsForMen
        UNION
        SELECT * FROM UnisexProducts
    ELSE IF @GenderID = 2 -- Nữ và Unisex
        SELECT * FROM ProductsForWomen
        UNION
        SELECT * FROM UnisexProducts
    ELSE IF @GenderID = 3 -- Chỉ Unisex
        SELECT * FROM UnisexProducts
    ELSE
        SELECT 'Hãy chỉ lựa chọn 1(Nam),2(Nữ),3(Unisex)' AS ErrorMessage;
END;
go

---7. SP hiển thị sản phẩm theo mức giá
CREATE OR ALTER PROCEDURE ShowProductsByPriceRange
    @PriceRangeID INT
AS
BEGIN
    SET NOCOUNT ON;

    IF @PriceRangeID = 1
        SELECT * FROM ProductsUnder3M ORDER BY Price ASC;-- dưới 3m
    ELSE IF @PriceRangeID = 2
        SELECT * FROM Products3MTo5M ORDER BY Price ASC;-- 2m-5m
    ELSE IF @PriceRangeID = 3
        SELECT * FROM ProductsOver5M ORDER BY Price ASC;-- >5m
    ELSE
        SELECT 'Hãy chỉ lựa chọn 1(<3M),2(3M-5M),3(>5M)' AS ErrorMessage;
END;
go

---8. Tạo PROCEDURE để lấy thông tin chi tiết của sản phẩm theo id
CREATE OR ALTER PROCEDURE GetProductDetailByID
    @prodID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem ProductID có tồn tại trong bảng Products hay không
    IF NOT EXISTS (SELECT 1 FROM Products WHERE ProductID = @prodID)
    BEGIN
        RAISERROR('ProductID không tôn tại. Vui lòng nhập lại ProductID.', 16, 1);
        RETURN;
    END

    -- Hiển thị thông tin chi tiết nếu ProductID hợp lệ
    SELECT 
        ProductID,
        ProductName,
        Price,
        Description,
        CategoryName,
        Gender,
        Size
    FROM 
        ShowDetailProducts
    WHERE 
        ProductID = @prodID;
END;
go

---9. Tạo SP cho phép nhập địa chỉ nhận hàng và lưu với điều kiện không trùng lặp
CREATE OR ALTER PROCEDURE ManageShippingAddress
    @Action INT,  -- 1 cho UPDATE, 2 cho DELETE
    @AddressID INT,
    @AddressDetail NVARCHAR(200) = NULL,  -- Chỉ cần khi UPDATE
    @City NVARCHAR(50) = NULL             -- Chỉ cần khi UPDATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra hành động hợp lệ
    IF @Action NOT IN (1, 2)
    BEGIN
        RAISERROR('Hành động không hợp lệ. Sử dụng 1 cho UPDATE hoặc 2 cho DELETE.', 16, 1);
        RETURN;
    END

    -- Kiểm tra sự tồn tại của AddressID
    IF NOT EXISTS (SELECT 1 FROM ShippingAddresses WHERE AddressID = @AddressID)
    BEGIN
        RAISERROR('AddressID không tồn tại.', 16, 1);
        RETURN;
    END

    -- Thực hiện hành động UPDATE
    IF @Action = 1
    BEGIN
        -- Kiểm tra xem @AddressDetail và @City có được cung cấp hay không
        IF @AddressDetail IS NULL OR @City IS NULL
        BEGIN
            RAISERROR('Cần cung cấp AddressDetail và City để cập nhật.', 16, 1);
            RETURN;
        END

        -- Cập nhật địa chỉ
        UPDATE ShippingAddresses
        SET AddressDetail = @AddressDetail,
            City = @City
        WHERE AddressID = @AddressID;
    END
    -- Thực hiện hành động DELETE
    ELSE IF @Action = 2
    BEGIN
        DELETE FROM ShippingAddresses
        WHERE AddressID = @AddressID;
    END
END;
go

---10. Tạo stored procedure BuyNow để kiểm tra và xử lý đơn hàng
CREATE OR ALTER PROCEDURE BuyNow
    @CustomerID INT,
    @ProductID INT,
    @Size NVARCHAR(10),
    @Quantity INT,
    @AddressID INT,
    @ConfirmPayment CHAR(1)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        -- Kiểm tra đầu vào
        IF @Quantity <= 0
        BEGIN
            RAISERROR('Số lượng phải lớn hơn 0.', 16, 1);
            RETURN;
        END
        IF @ConfirmPayment NOT IN ('Y', 'N')
        BEGIN
            RAISERROR('Xác nhận thanh toán phải là ''Y'' hoặc ''N''.', 16, 1);
            RETURN;
        END

        -- Kiểm tra sự tồn tại của ProductID và Size
        IF NOT EXISTS (
            SELECT 1 
            FROM Products p
            JOIN ProductSizes ps ON p.ProductID = ps.ProductID
            WHERE p.ProductID = @ProductID AND ps.Size = @Size
        )
        BEGIN
            RAISERROR('Sản phẩm hoặc kích cỡ không tồn tại.', 16, 1);
            RETURN;
        END

        -- Kiểm tra địa chỉ có thuộc về khách hàng không
        IF NOT EXISTS (
            SELECT 1 
            FROM ShippingAddresses 
            WHERE AddressID = @AddressID AND CustomerID = @CustomerID
        )
        BEGIN
            RAISERROR('Địa chỉ không tồn tại hoặc không thuộc về khách hàng.', 16, 1);
            RETURN;
        END

        -- Kiểm tra số lượng tồn kho
        DECLARE @AvailableQuantity INT;
        SELECT @AvailableQuantity = Quantity
        FROM Products
        WHERE ProductID = @ProductID;

        IF @AvailableQuantity < @Quantity
        BEGIN
            RAISERROR('Số lượng tồn kho không đủ.', 16, 1);
            RETURN;
        END

        -- Lấy thông tin sản phẩm
        DECLARE @ProductName NVARCHAR(100);
        DECLARE @Price DECIMAL(10, 3);
        DECLARE @Gender NVARCHAR(10);
        DECLARE @TotalPrice DECIMAL(10, 3);

        SELECT @ProductName = p.ProductName, @Price = p.Price, @Gender = ps.Gender
        FROM Products p
        JOIN ProductSizes ps ON p.ProductID = ps.ProductID
        WHERE p.ProductID = @ProductID AND ps.Size = @Size;

        SET @TotalPrice = @Price * @Quantity;

        -- Hiển thị thông tin sản phẩm
        SELECT 
            @ProductID AS ProductID,
            @ProductName AS ProductName,
            @Size + '-' + @Gender AS SizeGender,
            @Quantity AS Quantity,
            @Price AS UnitPrice,
            @TotalPrice AS TotalPrice;

        -- Xác nhận thanh toán
        IF @ConfirmPayment = 'Y'
        BEGIN
            BEGIN TRANSACTION;
            DECLARE @OrderID INT;
            INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, AddressID, PaymentStatus)
            VALUES (@CustomerID, GETDATE(), @TotalPrice, @AddressID, N'Đã thanh toán');
            SET @OrderID = SCOPE_IDENTITY();

            INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price)
            VALUES (@OrderID, @ProductID, @Quantity, @Price);

            SELECT 
                @OrderID AS OrderID,
                @ProductName AS ProductName,
                @Size + '-' + @Gender AS SizeGender,
                @Quantity AS Quantity,
                @TotalPrice AS TotalAmount,
                N'Đã thanh toán' AS PaymentStatus;

            COMMIT TRANSACTION;
        END
        ELSE
        BEGIN
            SELECT 'Đã hủy thanh toán.' AS Message;
        END
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Có lỗi xảy ra: %s', 16, 1, @ErrorMessage);
    END CATCH
END;
GO

---11. SP hiển thị top 5 sản phẩm bán cao nhất, nếu không có đưa ra thông báo
CREATE OR ALTER PROCEDURE GetTopSellingProducts
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem có sản phẩm nào được bán không
    IF NOT EXISTS (SELECT 1 FROM OrderDetails)
    BEGIN
        SELECT 'Không có sản phẩm nào được bán.' AS Message;
        RETURN;
    END

    -- Lấy top 5 sản phẩm bán chạy nhất với thông tin yêu cầu
    SELECT TOP 5 
        p.ProductID,
        p.ProductName,
        c.CategoryName,
        p.Price,
        SUM(od.Quantity) AS TotalSold
    FROM 
        Products p
    JOIN 
        Categories c ON p.CategoryID = c.CategoryID
    JOIN 
        OrderDetails od ON p.ProductID = od.ProductID
    GROUP BY 
        p.ProductID, p.ProductName, c.CategoryName, p.Price
    ORDER BY 
        TotalSold DESC;
END;
GO
---12. SP đăng xuất tài khoản
CREATE OR ALTER PROCEDURE LogoutAccount
    @CustomerID INT,
    @InputValue NVARCHAR(100),
    @InputType INT  -- 1: Password, 2: Phone, 3: Email
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StoredValue NVARCHAR(100);

    -- Lấy thông tin từ bảng Customers dựa trên InputType
    IF @InputType = 1  -- Password
        SELECT @StoredValue = Password FROM Customers WHERE CustomerID = @CustomerID;
    ELSE IF @InputType = 2  -- Phone
        SELECT @StoredValue = Phone FROM Customers WHERE CustomerID = @CustomerID;
    ELSE IF @InputType = 3  -- Email
        SELECT @StoredValue = Email FROM Customers WHERE CustomerID = @CustomerID;
    ELSE
    BEGIN
        SELECT 'Loại thông tin không hợp lệ. Vui lòng chọn 1 (Mật khẩu), 2 (Số điện thoại), hoặc 3 (Email).' AS Message;
        RETURN;
    END

    -- Kiểm tra xem thông tin nhập có khớp không
    IF @StoredValue IS NULL
    BEGIN
        SELECT 'Khách hàng không tồn tại.' AS Message;
        RETURN;
    END

    IF @StoredValue = @InputValue
    BEGIN
        SELECT 'Đăng xuất thành công.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 'Thông tin không chính xác. Vui lòng nhập lại.' AS Message;
    END
END;
GO
 
 ---13.SP thêm sản phẩm vào giỏ hàng 
CREATE OR ALTER PROCEDURE AddToCart
    @CustomerID INT = NULL,
    @SessionID NVARCHAR(50) = NULL,
    @ProductID INT,
    @Size NVARCHAR(10),
    @Quantity INT,
    @Confirmation CHAR(1) = NULL  -- 'Y' để xác nhận, 'N' để hủy
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem có SessionID hoặc CustomerID không
    IF @CustomerID IS NULL AND @SessionID IS NULL
    BEGIN
        SELECT 'Vui lòng cung cấp CustomerID hoặc SessionID.' AS Message;
        RETURN;
    END

    -- Lấy CartID từ CustomerID hoặc SessionID
    DECLARE @CartID INT;
    IF @CustomerID IS NOT NULL
    BEGIN
        SELECT @CartID = CartID FROM Cart WHERE CustomerID = @CustomerID;
    END
    ELSE
    BEGIN
        SELECT @CartID = CartID FROM Cart WHERE SessionID = @SessionID;
    END

    -- Nếu không có giỏ hàng, tạo mới
    IF @CartID IS NULL
    BEGIN
        INSERT INTO Cart (CustomerID, SessionID, CreatedDate)
        VALUES (@CustomerID, @SessionID, GETDATE());
        SET @CartID = SCOPE_IDENTITY();
    END

    -- Kiểm tra sự tồn tại của ProductID và Size
    IF NOT EXISTS (
        SELECT 1 
        FROM Products p
        JOIN ProductSizes ps ON p.ProductID = ps.ProductID
        WHERE p.ProductID = @ProductID AND ps.Size = @Size
    )
    BEGIN
        SELECT 'Sản phẩm hoặc kích cỡ không tồn tại.' AS Message;
        RETURN;
    END

    -- Kiểm tra số lượng tồn kho
    DECLARE @AvailableQuantity INT;
    SELECT @AvailableQuantity = Quantity
    FROM Products
    WHERE ProductID = @ProductID;

    IF @AvailableQuantity < @Quantity
    BEGIN
        SELECT 'Số lượng tồn kho không đủ.' AS Message;
        RETURN;
    END

    -- Lấy thông tin sản phẩm và tính tổng giá
    DECLARE @ProductName NVARCHAR(100);
    DECLARE @Price DECIMAL(10, 3);
    DECLARE @TotalPrice DECIMAL(10, 3);

    SELECT @ProductName = p.ProductName, @Price = p.Price
    FROM Products p
    WHERE p.ProductID = @ProductID;

    SET @TotalPrice = @Price * @Quantity;

    -- Hiển thị thông tin sản phẩm và yêu cầu xác nhận
    IF @Confirmation IS NULL
    BEGIN
        SELECT 
            @ProductID AS ProductID,
            @ProductName AS ProductName,
            @Size AS Size,
            @Quantity AS Quantity,
            @Price AS UnitPrice,
            @TotalPrice AS TotalPrice,
            'Xác nhận thêm vào giỏ hàng? (Y/N)' AS ConfirmationPrompt;
        RETURN;
    END

    -- Xử lý xác nhận từ người dùng
    IF @Confirmation = 'Y'
    BEGIN
        INSERT INTO CartDetails (CartID, ProductID, Quantity, Size)
        VALUES (@CartID, @ProductID, @Quantity, @Size);

        SELECT 'Sản phẩm đã được thêm vào giỏ hàng.' AS Message;
    END
    ELSE IF @Confirmation = 'N'
    BEGIN
        SELECT 'Hủy thêm vào giỏ hàng.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 'Xác nhận không hợp lệ. Vui lòng chọn Y hoặc N.' AS Message;
    END
END;
GO

---14. Tạo stored procedure để xóa sản phẩm khỏi giỏ hàng
CREATE OR ALTER PROCEDURE RemoveFromCart
    @CustomerID INT = NULL,
    @SessionID NVARCHAR(50) = NULL,
    @ProductID INT,
    @Size NVARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CartID INT;
    IF @CustomerID IS NOT NULL
        SELECT @CartID = CartID FROM Cart WHERE CustomerID = @CustomerID;
    ELSE IF @SessionID IS NOT NULL
        SELECT @CartID = CartID FROM Cart WHERE SessionID = @SessionID;
    ELSE
    BEGIN
        SELECT 'Vui lòng cung cấp CustomerID hoặc SessionID.' AS Message;
        RETURN;
    END

    IF @CartID IS NULL
    BEGIN
        SELECT 'Giỏ hàng không tồn tại.' AS Message;
        RETURN;
    END

    DELETE FROM CartDetails
    WHERE CartID = @CartID AND ProductID = @ProductID AND Size = @Size;

    IF @@ROWCOUNT = 0
        SELECT 'Sản phẩm không tồn tại trong giỏ hàng.' AS Message;
    ELSE
        SELECT 'Sản phẩm đã được xóa khỏi giỏ hàng.' AS Message;
END;
GO

---15. SP sửa sản phẩm bên trong giỏ hàng
CREATE OR ALTER PROCEDURE EditCartItem
    @CustomerID INT,
    @ProductID INT,
	@SessionID NVARCHAR(50) = NULL,
    @CurrentSize NVARCHAR(10),  -- Kích cỡ hiện tại trong giỏ hàng
    @NewSize NVARCHAR(10),      -- Kích cỡ mới (nếu thay đổi)
    @NewQuantity INT,           -- Số lượng mới
    @Confirmation CHAR(1)       -- 'Y' để xác nhận, 'N' để hủy
AS
BEGIN
    SET NOCOUNT ON;

	   DECLARE @CartID INT;
    IF @CustomerID IS NOT NULL
        SELECT @CartID = CartID FROM Cart WHERE CustomerID = @CustomerID;
    ELSE IF @SessionID IS NOT NULL
        SELECT @CartID = CartID FROM Cart WHERE SessionID = @SessionID;
    ELSE
    BEGIN
        SELECT 'Vui lòng cung cấp CustomerID hoặc SessionID.' AS Message;
        RETURN;
    END

	IF @CartID IS NULL
    BEGIN
        SELECT 'Giỏ hàng không tồn tại.' AS Message;
        RETURN;
    END

    -- Kiểm tra xem sản phẩm có trong giỏ hàng không
    IF NOT EXISTS (
        SELECT 1 
        FROM CartDetails 
        WHERE CartID = @CustomerID AND ProductID = @ProductID AND Size = @CurrentSize
    )
    BEGIN
        SELECT 'Sản phẩm không tồn tại trong giỏ hàng.' AS Message;
        RETURN;
    END

    -- Kiểm tra xem NewSize có hợp lệ không (nếu thay đổi)
    IF @NewSize != @CurrentSize AND NOT EXISTS (
        SELECT 1 
        FROM ProductSizes 
        WHERE ProductID = @ProductID AND Size = @NewSize
    )
    BEGIN
        SELECT 'Kích cỡ mới không hợp lệ.' AS Message;
        RETURN;
    END

    -- Kiểm tra số lượng tồn kho
    DECLARE @AvailableQuantity INT;
    SELECT @AvailableQuantity = Quantity
    FROM Products
    WHERE ProductID = @ProductID;

    IF @AvailableQuantity < @NewQuantity
    BEGIN
        SELECT 'Số lượng tồn kho không đủ.' AS Message;
        RETURN;
    END

    -- Lấy thông tin sản phẩm hiện tại
    DECLARE @ProductName NVARCHAR(100);
    DECLARE @Price DECIMAL(10, 3);
    SELECT @ProductName = p.ProductName, @Price = p.Price
    FROM Products p
    WHERE p.ProductID = @ProductID;

    -- Hiển thị thông tin sản phẩm hiện tại và thông tin mới
    SELECT 
        @ProductID AS ProductID,
        @ProductName AS ProductName,
        @CurrentSize AS CurrentSize,
        @NewSize AS NewSize,
        (SELECT Quantity FROM CartDetails WHERE CartID = @CustomerID AND ProductID = @ProductID AND Size = @CurrentSize) AS CurrentQuantity,
        @NewQuantity AS NewQuantity,
        (@Price * @NewQuantity) AS NewTotalPrice,
        'Xác nhận lưu thay đổi? (Y/N)' AS ConfirmationPrompt;

    -- Xử lý xác nhận từ người dùng
    IF @Confirmation = 'Y'
    BEGIN
        -- Cập nhật giỏ hàng với thông tin mới
        UPDATE CartDetails
        SET Size = @NewSize,
            Quantity = @NewQuantity
        WHERE CartID = @CustomerID AND ProductID = @ProductID AND Size = @CurrentSize;

        SELECT 'Thay đổi đã được lưu.' AS Message;
    END
    ELSE IF @Confirmation = 'N'
    BEGIN
        SELECT 'Hủy lưu thay đổi.' AS Message;
    END
    ELSE
    BEGIN
        SELECT 'Xác nhận không hợp lệ. Vui lòng chọn 1(Xác nhận) hoặc 2(Huỷ).' AS Message;
    END
END;
GO

---16. SP thanh toán giỏ hàng

-- Định nghĩa kiểu bảng SelectedProductsType
CREATE TYPE SelectedProductsType AS TABLE (
    ProductID INT,
    Size NVARCHAR(10)
);
GO

-- Định nghĩa stored procedure CheckoutCart sử dụng kiểu bảng
CREATE OR ALTER PROCEDURE CheckoutCart
    @CustomerID INT,
    @Input NVARCHAR(MAX),  -- "all" hoặc danh sách sản phẩm "1-35,2-45"
    @AddressID INT = NULL,  -- Địa chỉ giao hàng, bắt buộc cho "all", tùy chọn cho sản phẩm cụ thể
    @ConfirmPayment CHAR(1)  -- 'Y' để xác nhận, 'N' để hủy
AS
BEGIN
    SET NOCOUNT ON;

    -- Khai báo bảng tạm để lưu danh sách sản phẩm
    DECLARE @SelectedProducts SelectedProductsType;

    -- Kiểm tra nếu đầu vào là "all"
    IF @Input = 'all'
    BEGIN
        -- Lấy toàn bộ giỏ hàng
        INSERT INTO @SelectedProducts (ProductID, Size)
        SELECT ProductID, Size FROM CartDetails WHERE CartID = @CustomerID;

        -- Yêu cầu AddressID ngay từ đầu
        IF @AddressID IS NULL
        BEGIN
            RAISERROR('Vui lòng cung cấp AddressID khi thanh toán toàn bộ giỏ hàng.', 16, 1);
            RETURN;
        END
    END
    ELSE
    BEGIN
        -- Tách chuỗi đầu vào thành các cặp ProductID-Size
        DECLARE @Items NVARCHAR(MAX) = @Input;
        DECLARE @Pair NVARCHAR(50);
        DECLARE @Pos INT;
        WHILE CHARINDEX(',', @Items) > 0
        BEGIN
            SET @Pos = CHARINDEX(',', @Items);
            SET @Pair = LEFT(@Items, @Pos - 1);
            SET @Items = SUBSTRING(@Items, @Pos + 1, LEN(@Items));
            INSERT INTO @SelectedProducts (ProductID, Size)
            VALUES (CAST(LEFT(@Pair, CHARINDEX('-', @Pair) - 1) AS INT), SUBSTRING(@Pair, CHARINDEX('-', @Pair) + 1, LEN(@Pair)));
        END
        -- Thêm cặp cuối cùng
        INSERT INTO @SelectedProducts (ProductID, Size)
        VALUES (CAST(LEFT(@Items, CHARINDEX('-', @Items) - 1) AS INT), SUBSTRING(@Items, CHARINDEX('-', @Items) + 1, LEN(@Items)));
    END

    -- Kiểm tra sản phẩm có trong giỏ hàng không
    IF EXISTS (
        SELECT 1 
        FROM @SelectedProducts sp
        LEFT JOIN CartDetails cd ON sp.ProductID = cd.ProductID AND sp.Size = cd.Size AND cd.CartID = @CustomerID
        WHERE cd.ProductID IS NULL
    )
    BEGIN
        RAISERROR('Một hoặc nhiều sản phẩm không có trong giỏ hàng.', 16, 1);
        RETURN;
    END

    -- Tính tổng giá tiền
    DECLARE @TotalAmount DECIMAL(10, 3);
    SELECT @TotalAmount = SUM(p.Price * cd.Quantity)
    FROM CartDetails cd
    JOIN Products p ON cd.ProductID = p.ProductID
    JOIN @SelectedProducts sp ON cd.ProductID = sp.ProductID AND cd.Size = sp.Size
    WHERE cd.CartID = @CustomerID;

    -- Hiển thị thông tin chi tiết và tổng tiền
    SELECT 
        cd.ProductID,
        p.ProductName,
        cd.Size,
        cd.Quantity,
        p.Price AS UnitPrice,
        (p.Price * cd.Quantity) AS TotalPrice,
        @TotalAmount AS TotalAmount
    FROM CartDetails cd
    JOIN Products p ON cd.ProductID = p.ProductID
    JOIN @SelectedProducts sp ON cd.ProductID = sp.ProductID AND cd.Size = sp.Size
    WHERE cd.CartID = @CustomerID;

    -- Xử lý xác nhận thanh toán
    IF @ConfirmPayment = 'Y'
    BEGIN
        -- Nếu không phải "all" và chưa có AddressID, yêu cầu nhập sau
        IF @Input != 'all' AND @AddressID IS NULL
        BEGIN
            RAISERROR('Vui lòng cung cấp AddressID để hoàn tất thanh toán.', 16, 1);
            RETURN;
        END

        BEGIN TRANSACTION;
        BEGIN TRY
            -- Tạo đơn hàng mới
            DECLARE @OrderID INT;
            INSERT INTO Orders (CustomerID, OrderDate, TotalAmount, AddressID, PaymentStatus)
            VALUES (@CustomerID, GETDATE(), @TotalAmount, @AddressID, N'Đã thanh toán');
            SET @OrderID = SCOPE_IDENTITY();

            -- Lưu chi tiết đơn hàng
            INSERT INTO OrderDetails (OrderID, ProductID, Quantity, Price)
            SELECT @OrderID, cd.ProductID, cd.Quantity, p.Price
            FROM CartDetails cd
            JOIN Products p ON cd.ProductID = p.ProductID
            JOIN @SelectedProducts sp ON cd.ProductID = sp.ProductID AND cd.Size = sp.Size
            WHERE cd.CartID = @CustomerID;

            -- Xóa các sản phẩm đã thanh toán khỏi giỏ hàng
            DELETE FROM CartDetails
            WHERE CartID = @CustomerID
            AND ProductID IN (SELECT ProductID FROM @SelectedProducts)
            AND Size IN (SELECT Size FROM @SelectedProducts);

            SELECT 'Thanh toán thành công. Mã đơn hàng: ' + CAST(@OrderID AS NVARCHAR(10)) AS Message;
            COMMIT TRANSACTION;
        END TRY
        BEGIN CATCH
            ROLLBACK TRANSACTION;
            RAISERROR('Có lỗi xảy ra khi tạo đơn hàng.', 16, 1);
        END CATCH
    END
    ELSE
    BEGIN
        SELECT 'Đã hủy thanh toán.' AS Message;
    END
END;
GO

---17. SP hiển thị lịch sử giao dịch tối giản
CREATE OR ALTER PROCEDURE ViewOrderHistory
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem có đơn hàng nào cho khách hàng này không
    IF NOT EXISTS (SELECT 1 FROM Orders WHERE CustomerID = @CustomerID)
    BEGIN
        SELECT 'Không có đơn hàng nào.' AS Message;
        RETURN;
    END

    -- Hiển thị danh sách đơn hàng nếu có
    SELECT 
        o.OrderID,
        o.TotalAmount,
        CASE 
            WHEN EXISTS (SELECT 1 FROM OrderDetails od WHERE od.OrderID = o.OrderID GROUP BY od.OrderID HAVING COUNT(*) > 1) 
            THEN 'G'  -- Đơn hàng từ giỏ hàng (nhiều sản phẩm)
            ELSE 'M'  -- Đơn hàng mua ngay (chỉ một sản phẩm)
        END AS OrderType
    FROM 
        Orders o
    WHERE 
        o.CustomerID = @CustomerID
    ORDER BY 
        o.OrderDate DESC;
END;
GO

---18. SP xem chi tiết đơn hàng bên trong lịch sử đơn hàng thông qua id
CREATE OR ALTER PROCEDURE ViewOrderDetails
    @OrderID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem đơn hàng có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM Orders WHERE OrderID = @OrderID)
    BEGIN
        RAISERROR('Đơn hàng không tồn tại.', 16, 1);
        RETURN;
    END

    -- Xác định loại đơn hàng: mua ngay (1 sản phẩm) hay từ giỏ hàng (nhiều sản phẩm)
    DECLARE @OrderType CHAR(1);
    SELECT @OrderType = CASE 
                            WHEN COUNT(*) > 1 THEN 'G'  -- Nhiều sản phẩm (từ giỏ hàng)
                            ELSE 'M'  -- Một sản phẩm (mua ngay)
                        END
    FROM OrderDetails
    WHERE OrderID = @OrderID;

    -- Nếu là đơn hàng mua ngay (một sản phẩm)
    IF @OrderType = 'M'
    BEGIN
        SELECT 
            o.OrderID,
            od.ProductID,
            p.ProductName,
            c.CategoryName,
            ps.Size + '-' + ps.Gender AS SizeGender,
            od.Quantity,
            od.Price * od.Quantity AS TotalPrice
        FROM 
            Orders o
        JOIN 
            OrderDetails od ON o.OrderID = od.OrderID
        JOIN 
            Products p ON od.ProductID = p.ProductID
        JOIN 
            Categories c ON p.CategoryID = c.CategoryID
        JOIN 
            ProductSizes ps ON p.ProductID = ps.ProductID
        WHERE 
            o.OrderID = @OrderID;
    END
    -- Nếu là đơn hàng từ giỏ hàng (nhiều sản phẩm)
    ELSE
    BEGIN
        SELECT 
            od.ProductID,
            p.ProductName,
            c.CategoryName,
            ps.Size,
            od.Price,
            od.Quantity,
            od.Price * od.Quantity AS TotalPrice
        FROM 
            OrderDetails od
        JOIN 
            Products p ON od.ProductID = p.ProductID
        JOIN 
            Categories c ON p.CategoryID = c.CategoryID
        JOIN 
            ProductSizes ps ON p.ProductID = ps.ProductID
        WHERE 
            od.OrderID = @OrderID;
    END
END;
GO

---19. SP hiển thị sản phẩm còn hàng
CREATE OR ALTER PROCEDURE ShowAvailableProducts
AS
BEGIN
    SET NOCOUNT ON;

    -- Lấy danh sách sản phẩm còn hàng (Quantity > 0)
    SELECT 
        p.ProductID,
        p.ProductName,
        c.CategoryName,
        p.Price,
        p.Quantity
    FROM 
        Products p
    JOIN 
        Categories c ON p.CategoryID = c.CategoryID
    WHERE 
        p.Quantity > 0
    ORDER BY 
        p.ProductID;
END;
GO

---20. Stored Procedure để cập nhật địa chỉ nhận hàng
CREATE OR ALTER PROCEDURE UpdateShippingAddress
    @AddressID INT,
    @CustomerID INT,
    @NewAddressDetail NVARCHAR(200),
    @NewCity NVARCHAR(50)
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem AddressID có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM ShippingAddresses WHERE AddressID = @AddressID AND CustomerID = @CustomerID)
    BEGIN
        SELECT 'Địa chỉ không tồn tại hoặc không thuộc về khách hàng.' AS Message;
        RETURN;
    END

    -- Cập nhật địa chỉ
    UPDATE ShippingAddresses
    SET AddressDetail = @NewAddressDetail,
        City = @NewCity
    WHERE AddressID = @AddressID AND CustomerID = @CustomerID;

    SELECT 'Cập nhật địa chỉ thành công.' AS Message;
END;
GO

---21. Stored Procedure để xóa địa chỉ nhận hàng
CREATE OR ALTER PROCEDURE DeleteShippingAddress
    @AddressID INT,
    @CustomerID INT
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem AddressID có tồn tại không
    IF NOT EXISTS (SELECT 1 FROM ShippingAddresses WHERE AddressID = @AddressID AND CustomerID = @CustomerID)
    BEGIN
        SELECT 'Địa chỉ không tồn tại hoặc không thuộc về khách hàng.' AS Message;
        RETURN;
    END

    -- Xóa địa chỉ
    DELETE FROM ShippingAddresses
    WHERE AddressID = @AddressID AND CustomerID = @CustomerID;

    SELECT 'Xóa địa chỉ thành công.' AS Message;
END;
GO