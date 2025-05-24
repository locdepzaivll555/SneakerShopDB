using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.Data.SqlClient;
using Microsoft.EntityFrameworkCore;
using SneakerShopDB.Data.Entities;
using SneakerShopDB.Interfaces;
using Serilog;
using ConsoleTables;

namespace SneakerShopDB.Data.Repositories
{
    public class ProductRepository : IProductRepository
    {
        private readonly SneakerShopDbContext _context;

        public ProductRepository(SneakerShopDbContext context)
        {
            _context = context;
        }


        public IEnumerable<Product> GetProducts(string sortOrder = "asc")
        {
            try
            {
                var procedureName = sortOrder.ToLower() == "desc" ? "ShowProductsDESC" : "ShowProductsASC";
                var products = _context.Products
                                       .FromSqlRaw($"EXEC {procedureName}")
                                       .ToList();

                // Lấy danh sách danh mục để ánh xạ CategoryID sang CategoryName
                var categories = _context.Categories.ToDictionary(c => c.CategoryID, c => c.CategoryName);

                // Hiển thị dữ liệu bằng ConsoleTable với CategoryName
                var table = new ConsoleTable("ProductID", "ProductName", "Price", "CategoryName");
                foreach (var product in products)
                {
                    string categoryName = categories.ContainsKey(product.CategoryID) ? categories[product.CategoryID] : "Unknown";
                    table.AddRow(product.ProductID, product.ProductName, product.Price, categoryName);
                }
                table.Write(Format.Alternative);

                return products;
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi lấy danh sách sản phẩm.");
                throw new Exception("Lỗi lấy danh sách sản phẩm: " + ex.Message);
            }
        }

        public IEnumerable<Product> GetProductsByCategory(string categoryIds)
        {
            if (string.IsNullOrWhiteSpace(categoryIds))
                throw new ArgumentException("Danh sách ID danh mục không được để trống.");

            try
            {
                // Sử dụng FromSqlRaw vì SP trả về dữ liệu ánh xạ vào Product
                return _context.Products
                               .FromSqlRaw("EXEC ShowProductsByCategory @cateID", new SqlParameter("@cateID", categoryIds))
                               .ToList();
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi lấy sản phẩm theo danh mục.");
                throw new Exception("Lỗi lấy sản phẩm theo danh mục: " + ex.Message);
            }
        }

        public IEnumerable<Product> GetProductsByGender(int genderId)
        {
            if (genderId < 1 || genderId > 3)
                throw new ArgumentException("ID giới tính không hợp lệ. Phải là 1 (Nam), 2 (Nữ), hoặc 3 (Unisex).");

            try
            {
                // Sử dụng FromSqlRaw vì SP trả về dữ liệu ánh xạ vào Product
                return _context.Products
                               .FromSqlRaw("EXEC ShowProductsByGender @GenderID", new SqlParameter("@GenderID", genderId))
                               .ToList();
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi lấy sản phẩm theo giới tính.");
                throw new Exception("Lỗi lấy sản phẩm theo giới tính: " + ex.Message);
            }
        }

        public IEnumerable<Product> GetProductsByPriceRange(int priceRangeId)
        {
            if (priceRangeId < 1 || priceRangeId > 3)
                throw new ArgumentException("ID khoảng giá không hợp lệ. Phải là 1 (<3M), 2 (3M-5M), hoặc 3 (>5M).");

            try
            {
                // Sử dụng FromSqlRaw vì SP trả về dữ liệu ánh xạ vào Product
                return _context.Products
                               .FromSqlRaw("EXEC ShowProductsByPriceRange @PriceRangeID", new SqlParameter("@PriceRangeID", priceRangeId))
                               .ToList();
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi lấy sản phẩm theo khoảng giá.");
                throw new Exception("Lỗi lấy sản phẩm theo khoảng giá: " + ex.Message);
            }
        }

        public Product GetProductDetailById(int productId)
        {
            if (productId <= 0)
                throw new ArgumentException("ID sản phẩm không hợp lệ.");

            try
            {
                // Sử dụng FromSqlRaw vì SP trả về dữ liệu ánh xạ vào Product
                return _context.Products
                               .FromSqlRaw("EXEC GetProductDetailByID @prodID", new SqlParameter("@prodID", productId))
                               .FirstOrDefault();
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi lấy chi tiết sản phẩm.");
                throw new Exception("Lỗi lấy chi tiết sản phẩm: " + ex.Message);
            }
        }

        public IEnumerable<Product> GetAvailableProducts()
        {
            try
            {
                // Sử dụng FromSqlRaw vì SP trả về dữ liệu ánh xạ vào Product
                return _context.Products
                               .FromSqlRaw("EXEC ShowAvailableProducts")
                               .ToList();
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi lấy danh sách sản phẩm còn hàng.");
                throw new Exception("Lỗi lấy danh sách sản phẩm còn hàng: " + ex.Message);
            }
        }

        public IEnumerable<Product> GetTopSellingProducts()
        {
            try
            {
                // Sử dụng FromSqlRaw vì SP trả về dữ liệu ánh xạ vào Product
                return _context.Products
                               .FromSqlRaw("EXEC GetTopSellingProducts")
                               .ToList();
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi lấy danh sách sản phẩm bán chạy nhất.");
                throw new Exception("Lỗi lấy danh sách sản phẩm bán chạy nhất: " + ex.Message);
            }
        }

        // Ví dụ thêm phương thức sử dụng ExecuteSqlRaw cho SP không trả về dữ liệu
        public void ExecuteCustomProcedure(int someParameter)
        {
            try
            {
                _context.Database.ExecuteSqlRaw("EXEC CustomProcedure @Param",
                    new SqlParameter("@Param", someParameter));
            }
            catch (Exception ex)
            {
                Log.Error(ex, "Lỗi thực thi stored procedure tùy chỉnh.");
                throw new Exception("Lỗi thực thi stored procedure tùy chỉnh: " + ex.Message);
            }
        }
    }
}