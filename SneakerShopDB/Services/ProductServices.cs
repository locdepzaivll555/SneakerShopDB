using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SneakerShopDB.Data.Entities;
using SneakerShopDB.Interfaces;

namespace SneakerShopDB.Services
{
    public class ProductService : IProductService
    {
        private readonly IProductRepository _productRepository;

        public ProductService(IProductRepository productRepository)
        {
            _productRepository = productRepository;
        }

        public IEnumerable<Product> GetProducts(string sortOrder = "asc")
        {
            return _productRepository.GetProducts(sortOrder);
        }

        public IEnumerable<Product> GetProductsByCategory(string categoryIds)
        {
            return _productRepository.GetProductsByCategory(categoryIds);
        }

        public IEnumerable<Product> GetProductsByGender(int genderId)
        {
            return _productRepository.GetProductsByGender(genderId);
        }

        public IEnumerable<Product> GetProductsByPriceRange(int priceRangeId)
        {
            return _productRepository.GetProductsByPriceRange(priceRangeId);
        }

        public Product GetProductDetailById(int productId)
        {
            return _productRepository.GetProductDetailById(productId);
        }
        public IEnumerable<Product> GetTopSellingProducts()
        {
            return _productRepository.GetTopSellingProducts();
        }
        public IEnumerable<Product> GetAvailableProducts()
        {
            return _productRepository.GetAvailableProducts();
        }
        
    }

}