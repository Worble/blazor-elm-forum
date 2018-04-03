using Microsoft.AspNetCore.Blazor.Services;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;

namespace WebApplication1.Store
{
    public class Store
    {
        //members
        private HttpClient _client;
        private IUriHelper _uriHelper;

        private CounterStore counterStore;
        private CommandLineStore commandLineStore;
        private ForumStore forumStore;

        //event
        //public event Action OnChange;
        //private void NotifyStateChanged() => OnChange?.Invoke();

        public Store(HttpClient client, IUriHelper uriHelper)
        {
            this._client = client;
            this._uriHelper = uriHelper;
        }

        //stores
        public CounterStore CounterStore
        {
            get
            {
                if (this.counterStore == null)
                {
                    counterStore = new CounterStore();
                    //counterStore.OnChange += NotifyStateChanged;
                }
                return this.counterStore;
            }
        }

        public CommandLineStore CommandLineStore
        {
            get
            {
                if(commandLineStore == null)
                {
                    commandLineStore = new CommandLineStore();
                    //commandLineStore.OnChange += NotifyStateChanged;
                }
                return this.commandLineStore;
            }
        }

        public ForumStore ForumStore
        {
            get
            {
                if (forumStore == null)
                {
                    forumStore = new ForumStore(_client, _uriHelper);
                    //commandLineStore.OnChange += NotifyStateChanged;
                }
                return this.forumStore;
            }
        }
    }
}
