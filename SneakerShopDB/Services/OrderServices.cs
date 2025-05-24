using SneakerShopDB.Data.Entities;
using SneakerShopDB.Interfaces;

namespace SneakerShopDB.Services
{
    public class OrderService : IOrderService
    {
        private readonly IOrderRepository _orderRepository;

        public OrderService(IOrderRepository orderRepository)
        {
            _orderRepository = orderRepository;
        }

        // Các phương thức khác của OrderService
        public bool BuyNow(int customerId, int productId, string size, int quantity, int addressId, char confirmPayment)
        {
            return _orderRepository.BuyNow(customerId, productId, size, quantity, addressId, confirmPayment);
        }

        public bool CheckoutCart(int customerId, string input, int? addressId, char confirmPayment)
        {
            return _orderRepository.CheckoutCart(customerId, input, addressId, confirmPayment);
        }

        public IEnumerable<Order> GetOrderHistory(int customerId)
        {
            return _orderRepository.GetOrderHistory(customerId);
        }

        public OrderDetail GetOrderDetails(int orderId)
        {
            return _orderRepository.GetOrderDetails(orderId);
        }
    }
}