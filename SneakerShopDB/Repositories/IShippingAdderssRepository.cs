using System;
using System.Collections.Generic;
using System.Linq;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Logging;
using SneakerShopDB.Data;
using SneakerShopDB.Data.Entities;
using SneakerShopDB.Interfaces;

namespace SneakerShopDB.Repositories
{
    public class ShippingAddressRepository : IShippingAddressRepository
    {
        private readonly SneakerShopDbContext _context;
        private readonly ILogger<ShippingAddressRepository> _logger;

        public ShippingAddressRepository(SneakerShopDbContext context, ILogger<ShippingAddressRepository> logger)
        {
            _context = context ?? throw new ArgumentNullException(nameof(context));
            _logger = logger ?? throw new ArgumentNullException(nameof(logger));
        }

        public bool ManageShippingAddress(int action, int addressId, string addressDetail = null, string city = null)
        {
            try
            {
                _logger.LogInformation("Managing shipping address with action {Action} for address ID {AddressId}", action, addressId);
                var result = _context.Database.ExecuteSqlRaw("EXEC ManageShippingAddress @Action = {0}, @AddressId = {1}, @AddressDetail = {2}, @City = {3}",
                    action, addressId, addressDetail, city);
                return result > 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error managing shipping address with ID {AddressId}", addressId);
                return false;
            }
        }

        public bool UpdateShippingAddress(int addressId, int customerId, string newAddressDetail, string newCity)
        {
            try
            {
                _logger.LogInformation("Updating shipping address with ID {AddressId} for customer ID {CustomerId}", addressId, customerId);
                var result = _context.Database.ExecuteSqlRaw("EXEC UpdateShippingAddress @AddressId = {0}, @CustomerId = {1}, @NewAddressDetail = {2}, @NewCity = {3}",
                    addressId, customerId, newAddressDetail, newCity);
                return result > 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error updating shipping address with ID {AddressId}", addressId);
                return false;
            }
        }

        public bool DeleteShippingAddress(int addressId, int customerId)
        {
            try
            {
                _logger.LogInformation("Deleting shipping address with ID {AddressId} for customer ID {CustomerId}", addressId, customerId);
                var result = _context.Database.ExecuteSqlRaw("EXEC DeleteShippingAddress @AddressId = {0}, @CustomerId = {1}",
                    addressId, customerId);
                return result > 0;
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error deleting shipping address with ID {AddressId}", addressId);
                return false;
            }
        }

        public IEnumerable<ShippingAddress> GetShippingAddressesByCustomerId(int customerId)
        {
            try
            {
                _logger.LogInformation("Retrieving shipping addresses for customer ID {CustomerId}", customerId);
                return _context.ShippingAddresses
                    .FromSqlRaw("EXEC GetShippingAddressesByCustomerId @CustomerId = {0}", customerId)
                    .ToList();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving shipping addresses for customer ID {CustomerId}", customerId);
                return Enumerable.Empty<ShippingAddress>();
            }
        }

        public ShippingAddress GetShippingAddressById(int addressId)
        {
            try
            {
                _logger.LogInformation("Retrieving shipping address with ID {AddressId}", addressId);
                return _context.ShippingAddresses
                    .FromSqlRaw("EXEC GetShippingAddressById @AddressId = {0}", addressId)
                    .FirstOrDefault();
            }
            catch (Exception ex)
            {
                _logger.LogError(ex, "Error retrieving shipping address with ID {AddressId}", addressId);
                return null;
            }
        }
    }
}