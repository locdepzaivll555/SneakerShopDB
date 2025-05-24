using System;
using System.Collections.Generic;
using System.Threading.Tasks;
using SneakerShopDB.Data.Entities;
using SneakerShopDB.Interfaces;

namespace SneakerShopDB.Services
{
    public class CustomerService : ICustomerService
    {
        private readonly ICustomerRepository _customerRepository;

        public CustomerService(ICustomerRepository customerRepository)
        {
            _customerRepository = customerRepository;
        }

        public bool RegisterCustomer(Customer customer)
        {
            return _customerRepository.RegisterCustomer(customer);
        }

        public Customer LoginCustomer(string username, string password)
        {
            return _customerRepository.LoginCustomer(username, password);
        }

        public bool LogoutCustomer(int customerId, string inputValue, int inputType)
        {
            return _customerRepository.LogoutCustomer(customerId, inputValue, inputType);
        }

     
    }

}