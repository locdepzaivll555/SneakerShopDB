using System;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using Serilog;
using SneakerShopDB.Data;
using SneakerShopDB.Interfaces;

namespace SneakerShopDB.Repositories
{
    public class CartRepository : ICartRepository
    {
        private readonly SneakerShopDbContext _context;

        public CartRepository(SneakerShopDbContext context)
        {
            _context = context;
        }

        public bool AddToCart(int? customerId, string sessionId, int productId, string size, int quantity, char? confirmation)
        {
            if (customerId == null && string.IsNullOrWhiteSpace(sessionId))
                throw new ArgumentException("Phải cung cấp CustomerID hoặc SessionID.");
            if (productId <= 0)
                throw new ArgumentException("ID sản phẩm không hợp lệ.");
            if (string.IsNullOrWhiteSpace(size))
                throw new ArgumentException("Kích thước không được để trống.");
            if (quantity <= 0)
                throw new ArgumentException("Số lượng phải lớn hơn 0.");
            if (confirmation.HasValue && confirmation != 'Y' && confirmation != 'N')
                throw new ArgumentException("Xác nhận phải là 'Y' hoặc 'N'.");

            try
            {
                Log.Information("Đang thêm sản phẩm vào giỏ hàng: ProductID={ProductID}, Size={Size}", productId, size);

                var returnValueParam = new SqlParameter
                {
                    ParameterName = "@ReturnValue",
                    SqlDbType = System.Data.SqlDbType.Int,
                    Direction = System.Data.ParameterDirection.Output
                };

                _context.Database.ExecuteSqlRaw("EXEC @ReturnValue = AddToCart @CustomerID, @SessionID, @ProductID, @Size, @Quantity, @Confirmation",
                    new SqlParameter("@CustomerID", customerId ?? (object)DBNull.Value),
                    new SqlParameter("@SessionID", string.IsNullOrWhiteSpace(sessionId) ? (object)DBNull.Value : sessionId),
                    new SqlParameter("@ProductID", productId),
                    new SqlParameter("@Size", size),
                    new SqlParameter("@Quantity", quantity),
                    new SqlParameter("@Confirmation", confirmation ?? (object)DBNull.Value),
                    returnValueParam);

                int returnValue = (int)returnValueParam.Value;
                Log.Information("Stored Procedure 'AddToCart' trả về giá trị: {ReturnValue}", returnValue);

                return returnValue == 0;
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi trong quá trình thêm vào giỏ hàng.");
                throw new Exception("Lỗi thêm vào giỏ hàng: " + ex.Message);
            }
        }

        public bool RemoveFromCart(int? customerId, string sessionId, int productId, string size)
        {
            if (customerId == null && string.IsNullOrWhiteSpace(sessionId))
                throw new ArgumentException("Phải cung cấp CustomerID hoặc SessionID.");
            if (productId <= 0)
                throw new ArgumentException("ID sản phẩm không hợp lệ.");
            if (string.IsNullOrWhiteSpace(size))
                throw new ArgumentException("Kích thước không được để trống.");

            try
            {
                Log.Information("Đang xóa sản phẩm khỏi giỏ hàng: ProductID={ProductID}, Size={Size}", productId, size);

                var returnValueParam = new SqlParameter
                {
                    ParameterName = "@ReturnValue",
                    SqlDbType = System.Data.SqlDbType.Int,
                    Direction = System.Data.ParameterDirection.Output
                };

                _context.Database.ExecuteSqlRaw("EXEC @ReturnValue = RemoveFromCart @CustomerID, @SessionID, @ProductID, @Size",
                    new SqlParameter("@CustomerID", customerId ?? (object)DBNull.Value),
                    new SqlParameter("@SessionID", string.IsNullOrWhiteSpace(sessionId) ? (object)DBNull.Value : sessionId),
                    new SqlParameter("@ProductID", productId),
                    new SqlParameter("@Size", size),
                    returnValueParam);

                int returnValue = (int)returnValueParam.Value;
                Log.Information("Stored Procedure 'RemoveFromCart' trả về giá trị: {ReturnValue}", returnValue);

                return returnValue == 0;
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi trong quá trình xóa khỏi giỏ hàng.");
                throw new Exception("Lỗi xóa khỏi giỏ hàng: " + ex.Message);
            }
        }

        public bool EditCartItem(int customerId, int productId, string sessionId, string currentSize, string newSize, int newQuantity, char confirmation)
        {
            if (customerId <= 0)
                throw new ArgumentException("ID khách hàng không hợp lệ.");
            if (productId <= 0)
                throw new ArgumentException("ID sản phẩm không hợp lệ.");
            if (string.IsNullOrWhiteSpace(currentSize))
                throw new ArgumentException("Kích thước hiện tại không được để trống.");
            if (string.IsNullOrWhiteSpace(newSize))
                throw new ArgumentException("Kích thước mới không được để trống.");
            if (newQuantity < 0)
                throw new ArgumentException("Số lượng không được âm.");
            if (confirmation != 'Y' && confirmation != 'N')
                throw new ArgumentException("Xác nhận phải là 'Y' hoặc 'N'.");

            try
            {
                Log.Information("Đang chỉnh sửa sản phẩm trong giỏ hàng: ProductID={ProductID}, CurrentSize={CurrentSize}", productId, currentSize);

                var returnValueParam = new SqlParameter
                {
                    ParameterName = "@ReturnValue",
                    SqlDbType = System.Data.SqlDbType.Int,
                    Direction = System.Data.ParameterDirection.Output
                };

                _context.Database.ExecuteSqlRaw("EXEC @ReturnValue = EditCartItem @CustomerID, @ProductID, @SessionID, @CurrentSize, @NewSize, @NewQuantity, @Confirmation",
                    new SqlParameter("@CustomerID", customerId),
                    new SqlParameter("@ProductID", productId),
                    new SqlParameter("@SessionID", string.IsNullOrWhiteSpace(sessionId) ? (object)DBNull.Value : sessionId),
                    new SqlParameter("@CurrentSize", currentSize),
                    new SqlParameter("@NewSize", newSize),
                    new SqlParameter("@NewQuantity", newQuantity),
                    new SqlParameter("@Confirmation", confirmation),
                    returnValueParam);

                int returnValue = (int)returnValueParam.Value;
                Log.Information("Stored Procedure 'EditCartItem' trả về giá trị: {ReturnValue}", returnValue);

                return returnValue == 0;
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi trong quá trình chỉnh sửa giỏ hàng.");
                throw new Exception("Lỗi chỉnh sửa giỏ hàng: " + ex.Message);
            }
        }
    }
}