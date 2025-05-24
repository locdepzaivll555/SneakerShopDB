using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SneakerShopDB.Data.Entities;
using SneakerShopDB.Interfaces;

namespace SneakerShopDB.Services
{
    public class ShippingAddressService : IShippingAddressService
    {
        private readonly IShippingAddressRepository _shippingAddressRepository;

        public ShippingAddressService(IShippingAddressRepository shippingAddressRepository)
        {
            _shippingAddressRepository = shippingAddressRepository;
        }

        public bool ManageShippingAddress(int action, int addressId, string addressDetail = null, string city = null)
        {
            return _shippingAddressRepository.ManageShippingAddress(action, addressId, addressDetail, city);
        }

        public bool UpdateShippingAddress(int addressId, int customerId, string newAddressDetail, string newCity)
        {
            return _shippingAddressRepository.UpdateShippingAddress(addressId, customerId, newAddressDetail, newCity);
        }

        public bool DeleteShippingAddress(int addressId, int customerId)
        {
            return _shippingAddressRepository.DeleteShippingAddress(addressId, customerId);
        }

        public IEnumerable<ShippingAddress> GetShippingAddressesByCustomerId(int customerId)
        {
            return _shippingAddressRepository.GetShippingAddressesByCustomerId(customerId);
        }

        public ShippingAddress GetShippingAddressById(int addressId)
        {
            return _shippingAddressRepository.GetShippingAddressById(addressId);
        }
    }

}