using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace WebApplication1.Store
{
    public class CommandLineStore
    {
        public event Action OnChange;
        private void NotifyStateChanged() => OnChange?.Invoke();


    }
}
