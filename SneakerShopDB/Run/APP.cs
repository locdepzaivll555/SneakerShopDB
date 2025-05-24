using Microsoft.Extensions.Logging;
using SneakerShopDB.Data;
using SneakerShopDB.Data.Repositories;
using SneakerShopDB.Repositories;
using SneakerShopDB.Services;
using SneakerShopUI;

namespace SneakerShopDB.Run
{
    public class App
    {
        private readonly ConsoleUI _consoleUI;

        public App(string connectionString, ILogger<ShippingAddressRepository> logger)
        {
            // Khởi tạo DbContext với chuỗi kết nối
            var dbContext = new SneakerShopDbContext(connectionString);

            // Khởi tạo các repository
            var customerRepository = new CustomerRepository(dbContext);
            var productRepository = new ProductRepository(dbContext);
            var orderRepository = new OrderRepository(dbContext);
            var cartRepository = new CartRepository(dbContext);
            var shippingAddressRepository = new ShippingAddressRepository(dbContext, logger);

            // Khởi tạo các service
            var customerService = new CustomerService(customerRepository);
            var productService = new ProductService(productRepository);
            var orderService = new OrderService(orderRepository);
            var cartService = new CartService(cartRepository);
            var shippingAddressService = new ShippingAddressService(shippingAddressRepository);

            // Khởi tạo ConsoleUI với các service
            _consoleUI = new ConsoleUI(customerService, productService, orderService, cartService, shippingAddressService);
        }

        public void Run()
        {
            _consoleUI.Run();
        }
    }
}