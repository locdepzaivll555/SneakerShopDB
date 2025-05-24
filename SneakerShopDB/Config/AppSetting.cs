using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Microsoft.Extensions.Configuration;

namespace SneakerShopDB.Config
{
    public class AppSettings
    {
        public string ConnectionString { get; set; }

        public AppSettings(IConfiguration configuration)
        {
            ConnectionString = configuration.GetConnectionString("SneakerShopDB");
        }
    }
}
