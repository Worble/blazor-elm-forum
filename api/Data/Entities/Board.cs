using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace Data.Entities
{
    [JsonObject(IsReference = true)]
    public class Board : BaseEntity
    {
        public string Name { get; set; }
        public string ShorthandName { get; set; }
        public virtual ICollection<Thread> Threads { get; set; }
    }
}
