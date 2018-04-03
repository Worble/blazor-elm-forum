using Microsoft.AspNetCore.Blazor.Browser.Rendering;
using Microsoft.AspNetCore.Blazor.Browser.Services;
using Microsoft.Extensions.DependencyInjection;
using System;
using WebApplication1.Store;

namespace WebApplication1
{
    class Program
    {
        static void Main(string[] args)
        {
            var serviceProvider = new BrowserServiceProvider(configure =>
            {
                configure.Add(ServiceDescriptor.Singleton<Store.Store, Store.Store>());
            });

            new BrowserRenderer(serviceProvider).AddComponent<App>("app");
        }
    }
}
