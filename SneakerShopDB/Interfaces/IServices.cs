using System.Collections.Generic;
using System.Threading.Tasks;
using SneakerShopDB.Data.Entities;

namespace SneakerShopDB.Interfaces
{
    public interface ICustomerService
    {
        bool RegisterCustomer(Customer customer); // Đăng ký khách hàng
        Customer LoginCustomer(string username, string password); // Đăng nhập khách hàng
        bool LogoutCustomer(int customerId, string inputValue, int inputType); // Đăng xuất khách hàng
       
    }


    public interface IProductService
    {
        IEnumerable<Product> GetProducts(string sortOrder = "asc"); // Lấy tất cả sản phẩm với sắp xếp
        IEnumerable<Product> GetProductsByCategory(string categoryIds); // Lấy sản phẩm theo danh mục
        IEnumerable<Product> GetProductsByGender(int genderId); // Lấy sản phẩm theo giới tính
        IEnumerable<Product> GetProductsByPriceRange(int priceRangeId); // Lấy sản phẩm theo khoảng giá
        Product GetProductDetailById(int productId); // Lấy chi tiết sản phẩm theo ID
        IEnumerable<Product> GetTopSellingProducts(); // Lấy sản phẩm bán chạy nhất
        IEnumerable<Product> GetAvailableProducts(); // Lấy sản phẩm còn hàng
     
    }


    public interface IOrderService
    {
        bool BuyNow(int customerId, int productId, string size, int quantity, int addressId, char confirmPayment); // Mua ngay
        bool CheckoutCart(int customerId, string input, int? addressId, char confirmPayment); // Thanh toán giỏ hàng
        IEnumerable<Order> GetOrderHistory(int customerId); // Lịch sử đơn hàng của khách hàng
        OrderDetail GetOrderDetails(int orderId); // Chi tiết đơn hàng
     
    }


    public interface ICartService
    {
        bool AddToCart(int? customerId, string sessionId, int productId, string size, int quantity, char? confirmation);
        bool RemoveFromCart(int? customerId, string sessionId, int productId, string size);
        bool EditCartItem(int customerId, int productId, string sessionId, string currentSize, string newSize, int newQuantity, char confirmation);
    }


    public interface IShippingAddressService
    {
        bool ManageShippingAddress(int action, int addressId, string addressDetail = null, string city = null); // Quản lý địa chỉ giao hàng (Cập nhật, Xóa)
        bool UpdateShippingAddress(int addressId, int customerId, string newAddressDetail, string newCity); // Cập nhật địa chỉ giao hàng
        bool DeleteShippingAddress(int addressId, int customerId); // Xóa địa chỉ giao hàng
        IEnumerable<ShippingAddress> GetShippingAddressesByCustomerId(int customerId); // Lấy địa chỉ giao hàng của khách hàng
        ShippingAddress GetShippingAddressById(int addressId); // Lấy địa chỉ giao hàng theo ID
    }


   

}