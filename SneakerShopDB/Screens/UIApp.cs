using System;
using System.Threading;
using Spectre.Console;
using SneakerShopDB.Data.Entities;
using SneakerShopDB.Interfaces;

namespace SneakerShopUI
{
    public class ConsoleUI
    {
        private readonly ICustomerService _customerService;
        private readonly IProductService _productService;
        private readonly IOrderService _orderService;
        private readonly ICartService _cartService;
        private readonly IShippingAddressService _shippingAddressService;

        private Customer _currentCustomer;
        private Layout _layout;
        private int _leftPanelWidth;
        private int _rightPanelWidth;
        private string _sessionId;

        public ConsoleUI(
            ICustomerService customerService,
            IProductService productService,
            IOrderService orderService,
            ICartService cartService,
            IShippingAddressService shippingAddressService)
        {
            _customerService = customerService;
            _productService = productService;
            _orderService = orderService;
            _cartService = cartService;
            _shippingAddressService = shippingAddressService;
            _currentCustomer = null;
            _sessionId = Guid.NewGuid().ToString();
            InitializeLayout();
        }

        private void InitializeLayout()
        {
            _layout = new Layout("Root")
                .SplitColumns(
                    new Layout("Left").Ratio(3),
                    new Layout("Right").Ratio(7)
                );
            UpdatePanelWidths();
        }

        private void UpdatePanelWidths()
        {
            int consoleWidth = Console.WindowWidth;
            _leftPanelWidth = (int)(consoleWidth * 0.3);
            _rightPanelWidth = consoleWidth - _leftPanelWidth;
        }

        public void Run()
        {
            while (true)
            {
                UpdatePanelWidths();
                DrawUI();
                ProcessInput(GetInput());
            }
        }

        private void DrawUI()
        {
            AnsiConsole.Clear();
            AnsiConsole.Write(new FigletText("SneakerShop").Centered().Color(Color.Yellow));

            string userStatus = _currentCustomer != null ? $"Đã đăng nhập: {_currentCustomer.FullName}" : "Chưa đăng nhập";

            var leftPanel = new Panel($"[bold white on blue]=== MENU ===[/]\n{userStatus}\n1. Đăng ký\n2. Đăng nhập\n3. Thoát\n\n[yellow]Nhập lựa chọn:[/] ")
                .Border(BoxBorder.Rounded)
                .BorderColor(Color.Blue)
                .Padding(1, 1);

            var rightPanel = new Panel("[bold white on blue]=== KẾT QUẢ ===[/]\nChọn một chức năng từ menu để xem kết quả.\nNhập 'exit' để quay lại, 'exits' để thoát hoàn toàn.")
                .Border(BoxBorder.Rounded)
                .BorderColor(Color.Blue)
                .Padding(1, 1);

            if (_currentCustomer != null)
            {
                rightPanel = new Panel("[bold white on blue]=== MENU CHÍNH ===[/]\n1. CÁ NHÂN\n2. SẢN PHẨM\n3. GIỎ HÀNG\n4. Đăng xuất\nNhập 'exit' để quay lại, 'exits' để thoát hoàn toàn.")
                    .Border(BoxBorder.Rounded)
                    .BorderColor(Color.Blue)
                    .Padding(1, 1);
            }

            _layout["Left"].Update(leftPanel);
            _layout["Right"].Update(rightPanel);
            AnsiConsole.Write(_layout);
        }

        private string GetInput()
        {
            return AnsiConsole.Prompt(
                new TextPrompt<string>("")
                    .PromptStyle("yellow")
                    .ShowDefaultValue(false));
        }

        private void ProcessInput(string input)
        {
            if (_currentCustomer == null)
            {
                switch (input)
                {
                    case "1":
                        RegisterCustomer();
                        break;
                    case "2":
                        LoginCustomer();
                        break;
                    case "3":
                        Environment.Exit(0);
                        break;
                    default:
                        UpdateRightPanel("[red]Lựa chọn không hợp lệ.[/]");
                        Thread.Sleep(2000);
                        break;
                }
            }
            else
            {
                switch (input)
                {
                    case "1":
                        ShowPersonalMenu();
                        break;
                    case "2":
                        ShowProductMenu();
                        break;
                    case "3":
                        ShowCartMenu();
                        break;
                    case "4":
                        _currentCustomer = null;
                        UpdateRightPanel("[green]Đăng xuất thành công![/]");
                        Thread.Sleep(2000);
                        break;
                    default:
                        UpdateRightPanel("[red]Lựa chọn không hợp lệ.[/]");
                        Thread.Sleep(2000);
                        break;
                }
            }
        }

        private string PromptInput(string prompt)
        {
            string input = AnsiConsole.Prompt(
                new TextPrompt<string>(prompt)
                    .PromptStyle("yellow")
                    .ShowDefaultValue(false));
            if (input.ToLower() == "exit")
            {
                throw new OperationCanceledException("Người dùng đã chọn quay lại.");
            }
            if (input.ToLower() == "exits")
            {
                Environment.Exit(0);
                return null;
            }
            return input;
        }

        public void RegisterCustomer()
        {
            bool success = false;
            while (!success)
            {
                try
                {
                    UpdateRightPanel("[green]Đăng ký khách hàng...[/]");
                    string fullName = PromptInput("Nhập họ tên: ");
                    string accountName = PromptInput("Nhập tên tài khoản: ");
                    string password = PromptInput("Nhập mật khẩu: ");
                    string email = PromptInput("Nhập email: ");
                    string phone = PromptInput("Nhập số điện thoại: ");
                    string gender = PromptInput("Nhập giới tính: ");

                    var customer = new Customer
                    {
                        FullName = fullName,
                        AccountName = accountName,
                        Password = password,
                        Email = email,
                        Phone = phone,
                        Gender = gender
                    };
                    success = _customerService.RegisterCustomer(customer);
                    if (success)
                    {
                        UpdateRightPanel("[green]Đăng ký thành công![/]");
                        Thread.Sleep(2000);
                    }
                }
                catch (OperationCanceledException)
                {
                    UpdateRightPanel("[yellow]Đã hủy đăng ký.[/]");
                    Thread.Sleep(2000);
                    return;
                }
                catch (Exception ex)
                {
                    UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                    Thread.Sleep(2000);
                }
            }
        }

        private void LoginCustomer()
        {
            try
            {
                UpdateRightPanel("[green]Đăng nhập...[/]");
                string accountName = PromptInput("Nhập tên tài khoản: ");
                string password = PromptInput("Nhập mật khẩu: ");

                _currentCustomer = _customerService.LoginCustomer(accountName, password);
                if (_currentCustomer != null)
                {
                    UpdateRightPanel("[green]Đăng nhập thành công![/]");
                    Thread.Sleep(2000);
                    ShowMainMenu();
                }
                else
                {
                    UpdateRightPanel("[red]Đăng nhập thất bại. Vui lòng thử lại.[/]");
                    Thread.Sleep(2000);
                }
            }
            catch (OperationCanceledException)
            {
                UpdateRightPanel("[yellow]Đã hủy đăng nhập.[/]");
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void ShowMainMenu()
        {
            DrawUI();
        }

        private void ShowPersonalMenu()
        {
            while (true)
            {
                UpdateRightPanel("[green]Menu CÁ NHÂN[/]\n1. Thao tác với địa chỉ\n2. Lịch sử đơn hàng\n3. Đăng xuất\nNhập 'exit' để quay lại");
                string choice = GetInput();
                switch (choice)
                {
                    case "1":
                        ShowAddressMenu();
                        break;
                    case "2":
                        ShowOrderHistory();
                        break;
                    case "3":
                        _currentCustomer = null;
                        UpdateRightPanel("[green]Đăng xuất thành công![/]");
                        Thread.Sleep(2000);
                        return;
                    case "exit":
                        return;
                    default:
                        UpdateRightPanel("[red]Lựa chọn không hợp lệ.[/]");
                        Thread.Sleep(2000);
                        break;
                }
            }
        }

        private void ShowAddressMenu()
        {
            while (true)
            {
                UpdateRightPanel("[green]Thao tác với địa chỉ[/]\n1. Thêm địa chỉ\n2. Sửa địa chỉ\n3. Xóa địa chỉ\n4. Quay lại\nNhập 'exit' để quay lại");
                string choice = GetInput();
                switch (choice)
                {
                    case "1":
                        AddAddress();
                        break;
                    case "2":
                        UpdateAddress();
                        break;
                    case "3":
                        DeleteAddress();
                        break;
                    case "4":
                    case "exit":
                        return;
                    default:
                        UpdateRightPanel("[red]Lựa chọn không hợp lệ.[/]");
                        Thread.Sleep(2000);
                        break;
                }
            }
        }

        private void AddAddress()
        {
            try
            {
                UpdateRightPanel("[green]Thêm địa chỉ mới...[/]");
                string addressDetail = PromptInput("Nhập chi tiết địa chỉ: ");
                string city = PromptInput("Nhập thành phố: ");

                bool success = _shippingAddressService.ManageShippingAddress(1, 0, addressDetail, city);
                UpdateRightPanel(success ? "[green]Thêm địa chỉ thành công![/]" : "[red]Thêm địa chỉ thất bại.[/]");
                Thread.Sleep(2000);
            }
            catch (OperationCanceledException)
            {
                UpdateRightPanel("[yellow]Đã hủy thêm địa chỉ.[/]");
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void UpdateAddress()
        {
            try
            {
                UpdateRightPanel("[green]Sửa địa chỉ...[/]");
                string addressIdStr = PromptInput("Nhập ID địa chỉ cần sửa: ");
                int addressId = int.Parse(addressIdStr);
                string newAddressDetail = PromptInput("Nhập chi tiết địa chỉ mới: ");
                string newCity = PromptInput("Nhập thành phố mới: ");

                bool success = _shippingAddressService.UpdateShippingAddress(addressId, _currentCustomer.CustomerID, newAddressDetail, newCity);
                UpdateRightPanel(success ? "[green]Sửa địa chỉ thành công![/]" : "[red]Sửa địa chỉ thất bại.[/]");
                Thread.Sleep(2000);
            }
            catch (OperationCanceledException)
            {
                UpdateRightPanel("[yellow]Đã hủy sửa địa chỉ.[/]");
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void DeleteAddress()
        {
            try
            {
                UpdateRightPanel("[green]Xóa địa chỉ...[/]");
                string addressIdStr = PromptInput("Nhập ID địa chỉ cần xóa: ");
                int addressId = int.Parse(addressIdStr);

                bool success = _shippingAddressService.DeleteShippingAddress(addressId, _currentCustomer.CustomerID);
                UpdateRightPanel(success ? "[green]Xóa địa chỉ thành công![/]" : "[red]Xóa địa chỉ thất bại.[/]");
                Thread.Sleep(2000);
            }
            catch (OperationCanceledException)
            {
                UpdateRightPanel("[yellow]Đã hủy xóa địa chỉ.[/]");
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void ShowOrderHistory()
        {
            try
            {
                UpdateRightPanel("[green]Lịch sử đơn hàng...[/]");
                var orders = _orderService.GetOrderHistory(_currentCustomer.CustomerID);
                if (orders.Any())
                {
                    var table = new Table()
                        .AddColumn("ID Đơn hàng")
                        .AddColumn("Tổng tiền");

                    foreach (var order in orders)
                    {
                        table.AddRow(order.OrderID.ToString(), order.TotalAmount.ToString());
                    }
                    _layout["Right"].Update(
                        new Panel(table)
                            .Border(BoxBorder.Rounded)
                            .BorderColor(Color.Blue)
                            .Padding(1, 1));
                    AnsiConsole.Write(_layout);
                    Thread.Sleep(2000);
                }
                else
                {
                    UpdateRightPanel("[yellow]Không có đơn hàng nào.[/]");
                    Thread.Sleep(2000);
                }
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void ShowProductMenu()
        {
            while (true)
            {
                UpdateRightPanel("[green]Menu SẢN PHẨM[/]\n1. Xem danh sách sản phẩm (theo thứ tự)\n2. Xem sản phẩm theo danh mục\n3. Xem sản phẩm theo giới tính\n4. Xem sản phẩm theo khoảng giá\n5. Xem chi tiết sản phẩm\n6. Xem sản phẩm bán chạy nhất\n7. Xem sản phẩm còn hàng\n8. Quay lại");
                string choice = GetInput();
                switch (choice)
                {
                    case "1":
                        ShowProductList();
                        break;
                    case "2":
                        ShowProductsByCategory();
                        break;
                    case "3":
                        ShowProductsByGender();
                        break;
                    case "4":
                        ShowProductsByPriceRange();
                        break;
                    case "5":
                        ShowProductDetail();
                        break;
                    case "6":
                        ShowTopSellingProducts();
                        break;
                    case "7":
                        ShowAvailableProducts();
                        break;
                    case "8":
                    case "exit":
                        return;
                    default:
                        UpdateRightPanel("[red]Lựa chọn không hợp lệ.[/]");
                        Thread.Sleep(2000);
                        break;
                }
            }
        }

        private void ShowProductList()
        {
            try
            {
                string sortOrder = PromptInput("Nhập thứ tự sắp xếp (asc/desc): ");
                var products = _productService.GetProducts(sortOrder);
                DisplayProductTable(products);
            }
            catch (OperationCanceledException)
            {
                UpdateRightPanel("[yellow]Đã hủy xem danh sách.[/]");
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void ShowProductsByCategory()
        {
            try
            {
                string categoryIds = PromptInput("Nhập ID danh mục (cách nhau bằng dấu phẩy): ");
                var products = _productService.GetProductsByCategory(categoryIds);
                DisplayProductTable(products);
            }
            catch (OperationCanceledException)
            {
                UpdateRightPanel("[yellow]Đã hủy xem theo danh mục.[/]");
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void ShowProductsByGender()
        {
            try
            {
                string genderIdStr = PromptInput("Nhập ID giới tính (1-Nam, 2-Nữ, 3-Unisex): ");
                int genderId = int.Parse(genderIdStr);
                var products = _productService.GetProductsByGender(genderId);
                DisplayProductTable(products);
            }
            catch (OperationCanceledException)
            {
                UpdateRightPanel("[yellow]Đã hủy xem theo giới tính.[/]");
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void ShowProductsByPriceRange()
        {
            try
            {
                string priceRangeIdStr = PromptInput("Nhập ID khoảng giá (1-<3M, 2-3M-5M, 3->5M): ");
                int priceRangeId = int.Parse(priceRangeIdStr);
                var products = _productService.GetProductsByPriceRange(priceRangeId);
                DisplayProductTable(products);
            }
            catch (OperationCanceledException)
            {
                UpdateRightPanel("[yellow]Đã hủy xem theo khoảng giá.[/]");
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void ShowProductDetail()
        {
            try
            {
                string productIdStr = PromptInput("Nhập ID sản phẩm: ");
                int productId = int.Parse(productIdStr);
                var product = _productService.GetProductDetailById(productId);
                if (product != null)
                {
                    UpdateRightPanel($"[green]Chi tiết sản phẩm:[/]\nID: {product.ProductID}\nTên: {product.ProductName}\nGiá: {product.Price}\nMô tả: {product.Description}");
                }
                else
                {
                    UpdateRightPanel("[red]Không tìm thấy sản phẩm.[/]");
                }
                Thread.Sleep(2000);
            }
            catch (OperationCanceledException)
            {
                UpdateRightPanel("[yellow]Đã hủy xem chi tiết.[/]");
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void ShowTopSellingProducts()
        {
            try
            {
                var products = _productService.GetTopSellingProducts();
                DisplayProductTable(products);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void ShowAvailableProducts()
        {
            try
            {
                var products = _productService.GetAvailableProducts();
                DisplayProductTable(products);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void DisplayProductTable(IEnumerable<Product> products)
        {
            var table = new Table()
                .AddColumn("ID")
                .AddColumn("Tên sản phẩm")
                .AddColumn("Giá")
                .AddColumn("Số lượng");

            foreach (var p in products)
            {
                table.AddRow(p.ProductID.ToString(), p.ProductName, p.Price.ToString(), p.Quantity.ToString());
            }

            _layout["Right"].Update(
                new Panel(table)
                    .Border(BoxBorder.Rounded)
                    .BorderColor(Color.Blue)
                    .Padding(1, 1));
            AnsiConsole.Write(_layout);
            Thread.Sleep(2000);
        }

        private void ShowCartMenu()
        {
            UpdateRightPanel("[green]Menu GIỎ HÀNG[/]\n1. Thêm sản phẩm\n2. Xóa sản phẩm\n3. Thanh toán\n4. Quay lại");
            string choice = GetInput();
            switch (choice)
            {
                case "1":
                    AddToCart();
                    break;
                case "2":
                    RemoveFromCart();
                    break;
                case "3":
                    CheckoutCart();
                    break;
                case "4":
                    return;
                default:
                    UpdateRightPanel("[red]Lựa chọn không hợp lệ.[/]");
                    Thread.Sleep(2000);
                    break;
            }
        }

        private void AddToCart()
        {
            try
            {
                UpdateRightPanel("[green]Thêm sản phẩm vào giỏ hàng...[/]");
                string productIdStr = PromptInput("Nhập ID sản phẩm: ");
                int productId = int.Parse(productIdStr);
                string size = PromptInput("Nhập kích thước: ");
                string quantityStr = PromptInput("Nhập số lượng: ");
                int quantity = int.Parse(quantityStr);

                bool success = _cartService.AddToCart(
                    _currentCustomer?.CustomerID,
                    _currentCustomer == null ? _sessionId : null,
                    productId,
                    size,
                    quantity,
                    'Y'
                );
                UpdateRightPanel(success ? "[green]Thêm vào giỏ hàng thành công![/]" : "[red]Thêm thất bại.[/]");
                Thread.Sleep(2000);
            }
            catch (OperationCanceledException)
            {
                UpdateRightPanel("[yellow]Đã hủy thêm sản phẩm.[/]");
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void RemoveFromCart()
        {
            try
            {
                UpdateRightPanel("[green]Xóa sản phẩm khỏi giỏ hàng...[/]");
                string productIdStr = PromptInput("Nhập ID sản phẩm: ");
                int productId = int.Parse(productIdStr);
                string size = PromptInput("Nhập kích thước: ");

                bool success = _cartService.RemoveFromCart(
                    _currentCustomer?.CustomerID,
                    _currentCustomer == null ? _sessionId : null,
                    productId,
                    size
                );
                UpdateRightPanel(success ? "[green]Xóa khỏi giỏ hàng thành công![/]" : "[red]Xóa thất bại.[/]");
                Thread.Sleep(2000);
            }
            catch (OperationCanceledException)
            {
                UpdateRightPanel("[yellow]Đã hủy xóa sản phẩm.[/]");
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void CheckoutCart()
        {
            try
            {
                UpdateRightPanel("[green]Thanh toán giỏ hàng...[/]");
                string addressIdStr = PromptInput("Nhập ID địa chỉ giao hàng: ");
                int addressId = int.Parse(addressIdStr);

                bool success = _orderService.CheckoutCart(
                    _currentCustomer.CustomerID,
                    "all",
                    addressId,
                    'Y'
                );
                UpdateRightPanel(success ? "[green]Thanh toán thành công![/]" : "[red]Thanh toán thất bại.[/]");
                Thread.Sleep(2000);
            }
            catch (OperationCanceledException)
            {
                UpdateRightPanel("[yellow]Đã hủy thanh toán.[/]");
                Thread.Sleep(2000);
            }
            catch (Exception ex)
            {
                UpdateRightPanel($"[red]Lỗi: {ex.Message}[/]");
                Thread.Sleep(2000);
            }
        }

        private void UpdateRightPanel(string content)
        {
            var panel = new Panel(content)
                .Border(BoxBorder.Rounded)
                .BorderColor(Color.Blue)
                .Padding(1, 1);
            _layout["Right"].Update(panel);
            AnsiConsole.Write(_layout);
        }
    }
}