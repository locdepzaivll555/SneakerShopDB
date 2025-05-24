using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.Logging;
using SneakerShopDB.Repositories;
using Microsoft.Extensions.Logging;
using SneakerShopDB.Run;

class Program
{
    static async Task Main(string[] args)
    {
        Console.OutputEncoding = System.Text.Encoding.UTF8;
        Console.InputEncoding = System.Text.Encoding.UTF8;

        // Đọc cấu hình từ appsettings.json
        var configuration = new ConfigurationBuilder()
            .SetBasePath(AppDomain.CurrentDomain.BaseDirectory)
            .AddJsonFile("Appsettings.json", optional: false, reloadOnChange: true)
            .Build();

        // Lấy chuỗi kết nối từ appsettings.json
        string connectionString = configuration.GetConnectionString("SneakerShopDB");

        // Tạo logger factory
        using var loggerFactory = LoggerFactory.Create(builder =>
        {
            builder.AddConsole(); // Thêm logging vào console
        });

        // Tạo logger cho ShippingAddressRepository
        var logger = loggerFactory.CreateLogger<ShippingAddressRepository>();

        // Khởi tạo App với chuỗi kết nối và logger
        var app = new App(connectionString, logger);
        app.Run();
    }
}