using System;
using SneakerShopDB.Interfaces;

namespace SneakerShopDB.Services
{
    public class CartService : ICartService
    {
        private readonly ICartRepository _cartRepository;

        public CartService(ICartRepository cartRepository)
        {
            _cartRepository = cartRepository;
        }

        public bool AddToCart(int? customerId, string sessionId, int productId, string size, int quantity, char? confirmation)
        {
            return _cartRepository.AddToCart(customerId, sessionId, productId, size, quantity, confirmation);
        }

        public bool RemoveFromCart(int? customerId, string sessionId, int productId, string size)
        {
            return _cartRepository.RemoveFromCart(customerId, sessionId, productId, size);
        }

        public bool EditCartItem(int customerId, int productId, string sessionId, string currentSize, string newSize, int newQuantity, char confirmation)
        {
            return _cartRepository.EditCartItem(customerId, productId, sessionId, currentSize, newSize, newQuantity, confirmation);
        }
    }
}