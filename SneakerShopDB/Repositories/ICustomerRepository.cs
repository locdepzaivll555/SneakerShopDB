using System;
using System.Linq;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using SneakerShopDB.Data.Entities;
using SneakerShopDB.Interfaces;
using Serilog;

namespace SneakerShopDB.Data.Repositories
{
    public class CustomerRepository : ICustomerRepository
    {
        private readonly SneakerShopDbContext _context;

        public CustomerRepository(SneakerShopDbContext context)
        {
            _context = context;
        }

        public bool RegisterCustomer(Customer customer)
        {
            try
            {
                // Định nghĩa tham số đầu ra để lấy giá trị trả về từ stored procedure
                var returnValueParam = new SqlParameter
                {
                    ParameterName = "@ReturnValue",
                    SqlDbType = System.Data.SqlDbType.Int,
                    Direction = System.Data.ParameterDirection.Output
                };

                // Thực thi stored procedure với ExecuteSqlRaw
                _context.Database.ExecuteSqlRaw(
                    "EXEC @ReturnValue = RegisterAccount @FullName, @AccountName, @Password, @Email, @Phone, @Gender",
                    new SqlParameter("@FullName", customer.FullName),
                    new SqlParameter("@AccountName", customer.AccountName),
                    new SqlParameter("@Password", customer.Password),
                    new SqlParameter("@Email", customer.Email),
                    new SqlParameter("@Phone", customer.Phone),
                    new SqlParameter("@Gender", customer.Gender),
                    returnValueParam
                );

                // Lấy giá trị trả về từ tham số đầu ra
                int returnValue = (int)returnValueParam.Value;

                // Xử lý logic dựa trên giá trị trả về
                switch (returnValue)
                {
                    case 0:
                        return true; // Đăng ký thành công
                    case 1:
                        throw new Exception("Email đã tồn tại.");
                    case 2:
                        throw new Exception("Số điện thoại đã tồn tại.");
                    case 3:
                        throw new Exception("Email không hợp lệ.");
                    case 4:
                        throw new Exception("Mật khẩu không hợp lệ (độ dài từ 8 đến dưới 15 ký tự).");
                    case 5:
                        throw new Exception("Giới tính không hợp lệ.");
                    case 6:
                        throw new Exception("Tên tài khoản đã tồn tại.");
                    default:
                        throw new Exception("Lỗi không xác định.");
                }
            }
            catch (Exception ex)
            {
                throw new Exception("Đã xảy ra lỗi trong quá trình đăng ký: " + ex.Message);
            }
        }

        public Customer LoginCustomer(string username, string password)
        {
            if (string.IsNullOrWhiteSpace(username))
                throw new ArgumentException("Tên tài khoản hoặc email không được để trống.");
            if (string.IsNullOrWhiteSpace(password))
                throw new ArgumentException("Mật khẩu không được để trống.");

            try
            {
                // Định nghĩa tham số đầu ra
                var returnValueParam = new SqlParameter
                {
                    ParameterName = "@ReturnValue",
                    SqlDbType = System.Data.SqlDbType.Int,
                    Direction = System.Data.ParameterDirection.Output
                };

                // Thực thi stored procedure
                _context.Database.ExecuteSqlRaw(
                    "EXEC @ReturnValue = LoginAccount @Username, @Password",
                    new SqlParameter("@Username", username),
                    new SqlParameter("@Password", password),
                    returnValueParam
                );

                // Lấy giá trị trả về
                int returnValue = (int)returnValueParam.Value;

                // Xử lý kết quả
                if (returnValue == 0)
                {
                    var customer = _context.Customers
                        .FirstOrDefault(c => (c.AccountName == username || c.Email == username) && c.Password == password);
                    if (customer != null)
                        return customer;
                }
                throw new Exception("Tên tài khoản/email hoặc mật khẩu không đúng.");
            }
            catch (Exception ex)
            {
                throw new Exception("Lỗi đăng nhập: " + ex.Message);
            }
        }

        public bool LogoutCustomer(int customerId, string inputValue, int inputType)
        {
            if (customerId <= 0)
                throw new ArgumentException("ID khách hàng không hợp lệ.");
            if (string.IsNullOrWhiteSpace(inputValue))
                throw new ArgumentException("Giá trị đầu vào không được để trống.");
            if (inputType < 1 || inputType > 3)
                throw new ArgumentException("Loại đầu vào không hợp lệ. Phải là 1 (Mật khẩu), 2 (Số điện thoại), hoặc 3 (Email).");

            try
            {
                Log.Information("Đang đăng xuất với CustomerID: {CustomerID}", customerId);

                var result = _context.Database.ExecuteSqlRaw(
                    "EXEC LogoutAccount @CustomerID, @InputValue, @InputType",
                    new SqlParameter("@CustomerID", customerId),
                    new SqlParameter("@InputValue", inputValue),
                    new SqlParameter("@InputType", inputType)
                );

                Log.Information("Stored Procedure 'LogoutAccount' thực thi thành công.");
                return true; // Thành công nếu không có lỗi
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi trong quá trình đăng xuất.");
                throw new Exception("Lỗi đăng xuất: " + ex.Message);
            }
        }
    }
}