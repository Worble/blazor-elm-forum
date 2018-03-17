using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace Data.Entities
{
    [JsonObject(IsReference = true)]
    public class Post : BaseEntity
    {
        public string Content { get; set; }
        public virtual Thread Thread { get; set; }
        public int ThreadID { get; set; }
        public bool IsOp { get; set; }
    }
}
