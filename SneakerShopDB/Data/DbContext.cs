using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore;
using SneakerShopDB.Config;
using Microsoft.EntityFrameworkCore;
using SneakerShopDB.Data.Entities;


namespace SneakerShopDB.Data
{
    public class SneakerShopDbContext : DbContext
    {
        private readonly string _connectionString;

        public SneakerShopDbContext(string connectionString)
        {
            _connectionString = connectionString;
        }

        protected override void OnConfiguring(DbContextOptionsBuilder optionsBuilder)
        {
            optionsBuilder.UseSqlServer(_connectionString);
        }

        public DbSet<Customer> Customers { get; set; }
        public DbSet<Product> Products { get; set; }
        public DbSet<Category> Categories { get; set; }
        public DbSet<Order> Orders { get; set; }
        public DbSet<OrderDetail> OrderDetails { get; set; }

      
        public DbSet<Cart> Carts { get; set; }
        public DbSet<CartDetail> CartDetails { get; set; }
        public DbSet<ShippingAddress> ShippingAddresses { get; set; }
        public DbSet<ProductSize> ProductSizes { get; set; }

        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<OrderDetail>()
                .HasKey(od => new { od.OrderID, od.ProductID }); // Khóa tổng hợp
            modelBuilder.Entity<ShippingAddress>()
                .HasKey(sa => sa.AddressID);
            modelBuilder.Entity<Customer>()
                .HasKey(c => c.CustomerID);
            modelBuilder.Entity<Product>()
                .HasKey(p => p.ProductID);
            modelBuilder.Entity<Category>()
                .HasKey(c => c.CategoryID);
            modelBuilder.Entity<Cart>()
                .HasKey(c => c.CartID);
            modelBuilder.Entity<CartDetail>()
                .HasKey(cd => cd.CartDetailID);
        }
    }

}
