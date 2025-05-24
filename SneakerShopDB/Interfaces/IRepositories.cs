using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using SneakerShopDB.Data.Entities;

namespace SneakerShopDB.Interfaces
{
    public interface ICustomerRepository
    {
        bool RegisterCustomer(Customer customer);
        Customer LoginCustomer(string username, string password);
        bool LogoutCustomer(int customerId, string inputValue, int inputType);
    }


    public interface IProductRepository
    {
        IEnumerable<Product> GetProducts(string sortOrder = "asc"); // Lấy tất cả sản phẩm với sắp xếp
        IEnumerable<Product> GetProductsByCategory(string categoryIds); // Lấy sản phẩm theo danh mục
        IEnumerable<Product> GetProductsByGender(int genderId); // Lấy sản phẩm theo giới tính
        IEnumerable<Product> GetProductsByPriceRange(int priceRangeId); // Lấy sản phẩm theo khoảng giá
        Product GetProductDetailById(int productId); // Lấy chi tiết sản phẩm theo ID
        IEnumerable<Product> GetTopSellingProducts(); // Lấy sản phẩm bán chạy nhất
        IEnumerable<Product> GetAvailableProducts(); // Lấy sản phẩm còn hàng
        
    }


    public interface IOrderRepository
    {
        bool BuyNow(int customerId, int productId, string size, int quantity, int addressId, char confirmPayment);
        bool CheckoutCart(int customerId, string input, int? addressId, char confirmPayment);
        IEnumerable<Order> GetOrderHistory(int customerId);
        OrderDetail GetOrderDetails(int orderId);
    }

    public interface ICartRepository
    {
        bool AddToCart(int? customerId, string sessionId, int productId, string size, int quantity, char? confirmation);
        bool RemoveFromCart(int? customerId, string sessionId, int productId, string size);
        bool EditCartItem(int customerId, int productId, string sessionId, string currentSize, string newSize, int newQuantity, char confirmation);
    }


    public interface IShippingAddressRepository
    {
        bool ManageShippingAddress(int action, int addressId, string addressDetail = null, string city = null);
        bool UpdateShippingAddress(int addressId, int customerId, string newAddressDetail, string newCity);
        bool DeleteShippingAddress(int addressId, int customerId);
        IEnumerable<ShippingAddress> GetShippingAddressesByCustomerId(int customerId);
        ShippingAddress GetShippingAddressById(int addressId);
    }



}
