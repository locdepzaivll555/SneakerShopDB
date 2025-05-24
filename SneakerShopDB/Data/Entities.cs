using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SneakerShopDB.Data.Entities
{
    public class Customer { 
        public int CustomerID { get; set; } 
        public string FullName { get; set; } 
        public string AccountName { get; set; } 
        public string Password { get; set; }
        public string Email { get; set; } 
        public string Phone { get; set; }
        public string Gender { get; set; } }

    public class Product
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; }
        public string Description { get; set; }
        public decimal Price { get; set; }
        public int CategoryID { get; set; }
        public int Quantity { get; set; }
    }

    public class Category
    {
        public int CategoryID { get; set; }
        public string CategoryName { get; set; }
    }

    public class Order
    {
        public int OrderID { get; set; }
        public int CustomerID { get; set; }
        public DateTime OrderDate { get; set; }
        public decimal TotalAmount { get; set; }
        public int AddressID { get; set; }
        public string PaymentStatus { get; set; }
    }

    public class OrderDetail
    {
        public int OrderID { get; set; }
        public int ProductID { get; set; }
        public int Quantity { get; set; }
        public decimal Price { get; set; }
    }

    public class Cart
    {
        public int CartID { get; set; }
        public int? CustomerID { get; set; }
        public string SessionID { get; set; }
        public DateTime CreatedDate { get; set; }
    }

    public class CartDetail
    {
        public int CartDetailID { get; set; }
        public int CartID { get; set; }
        public int ProductID { get; set; }
        public int Quantity { get; set; }
        public string Size { get; set; }
    }

    public class ShippingAddress
    {
        public int AddressID { get; set; }
        public int CustomerID { get; set; }
        public string AddressDetail { get; set; }
        public string City { get; set; }
    }

    public class ProductSize
    {
        public int ProductSizeID { get; set; }
        public int ProductID { get; set; }
        public string Size { get; set; }
        public string Gender { get; set; }
    }

    public class ProductViewDto
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; }
        public decimal Price { get; set; }
        public string CategoryName { get; set; }
    }
}
