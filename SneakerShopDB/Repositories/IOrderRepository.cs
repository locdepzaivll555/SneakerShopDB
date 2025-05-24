using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using SneakerShopDB.Data;
using SneakerShopDB.Data.Entities;
using SneakerShopDB.Interfaces;
using Serilog;

namespace SneakerShopDB.Data.Repositories
{
    public class OrderRepository : IOrderRepository
    {
        private readonly SneakerShopDbContext _context;

        public OrderRepository(SneakerShopDbContext context)
        {
            _context = context;
        }

        public bool BuyNow(int customerId, int productId, string size, int quantity, int addressId, char confirmPayment)
        {
            if (customerId <= 0)
                throw new ArgumentException("ID khách hàng không hợp lệ.");
            if (productId <= 0)
                throw new ArgumentException("ID sản phẩm không hợp lệ.");
            if (string.IsNullOrWhiteSpace(size))
                throw new ArgumentException("Kích thước không được để trống.");
            if (quantity <= 0)
                throw new ArgumentException("Số lượng phải lớn hơn 0.");
            if (addressId <= 0)
                throw new ArgumentException("ID địa chỉ không hợp lệ.");
            if (confirmPayment != 'Y' && confirmPayment != 'N')
                throw new ArgumentException("Xác nhận thanh toán phải là 'Y' hoặc 'N'.");

            try
            {
                Log.Information("Đang thực hiện BuyNow với dữ liệu: CustomerID={CustomerID}, ProductID={ProductID}", customerId, productId);

                var returnValueParam = new SqlParameter
                {
                    ParameterName = "@ReturnValue",
                    SqlDbType = System.Data.SqlDbType.Int,
                    Direction = System.Data.ParameterDirection.Output
                };

                _context.Database.ExecuteSqlRaw("EXEC @ReturnValue = BuyNow @CustomerID, @ProductID, @Size, @Quantity, @AddressID, @ConfirmPayment",
                    new SqlParameter("@CustomerID", customerId),
                    new SqlParameter("@ProductID", productId),
                    new SqlParameter("@Size", size),
                    new SqlParameter("@Quantity", quantity),
                    new SqlParameter("@AddressID", addressId),
                    new SqlParameter("@ConfirmPayment", confirmPayment),
                    returnValueParam);

                int returnValue = (int)returnValueParam.Value;
                Log.Information("Stored Procedure 'BuyNow' trả về giá trị: {ReturnValue}", returnValue);

                return returnValue == 0;
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi trong quá trình BuyNow.");
                throw new Exception("Lỗi BuyNow: " + ex.Message);
            }
        }

        public bool CheckoutCart(int customerId, string input, int? addressId, char confirmPayment)
        {
            if (customerId <= 0)
                throw new ArgumentException("ID khách hàng không hợp lệ.");
            if (string.IsNullOrWhiteSpace(input))
                throw new ArgumentException("Dữ liệu đầu vào không được để trống.");
            if (confirmPayment != 'Y' && confirmPayment != 'N')
                throw new ArgumentException("Xác nhận thanh toán phải là 'Y' hoặc 'N'.");

            try
            {
                Log.Information("Đang thực hiện CheckoutCart với CustomerID: {CustomerID}", customerId);

                var returnValueParam = new SqlParameter
                {
                    ParameterName = "@ReturnValue",
                    SqlDbType = System.Data.SqlDbType.Int,
                    Direction = System.Data.ParameterDirection.Output
                };

                _context.Database.ExecuteSqlRaw("EXEC @ReturnValue = CheckoutCart @CustomerID, @Input, @AddressID, @ConfirmPayment",
                    new SqlParameter("@CustomerID", customerId),
                    new SqlParameter("@Input", input),
                    new SqlParameter("@AddressID", addressId ?? (object)DBNull.Value),
                    new SqlParameter("@ConfirmPayment", confirmPayment),
                    returnValueParam);

                int returnValue = (int)returnValueParam.Value;
                Log.Information("Stored Procedure 'CheckoutCart' trả về giá trị: {ReturnValue}", returnValue);

                return returnValue == 0;
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi trong quá trình CheckoutCart.");
                throw new Exception("Lỗi CheckoutCart: " + ex.Message);
            }
        }

        public IEnumerable<Order> GetOrderHistory(int customerId)
        {
            if (customerId <= 0)
                throw new ArgumentException("ID khách hàng không hợp lệ.");

            try
            {
                return _context.Orders
                               .FromSqlRaw("EXEC ViewOrderHistory @CustomerID", new SqlParameter("@CustomerID", customerId))
                               .ToList();
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi lấy lịch sử đơn hàng.");
                throw new Exception("Lỗi lấy lịch sử đơn hàng: " + ex.Message);
            }
        }

        public OrderDetail GetOrderDetails(int orderId)
        {
            if (orderId <= 0)
                throw new ArgumentException("ID đơn hàng không hợp lệ.");

            try
            {
                return _context.OrderDetails
                               .FromSqlRaw("EXEC ViewOrderDetails @OrderID", new SqlParameter("@OrderID", orderId))
                               .FirstOrDefault();
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi lấy chi tiết đơn hàng.");
                throw new Exception("Lỗi lấy chi tiết đơn hàng: " + ex.Message);
            }
        }
    }
}