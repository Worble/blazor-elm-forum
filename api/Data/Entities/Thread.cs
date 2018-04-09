using System;
using System.Collections.Generic;
using System.Text;
using Newtonsoft.Json;

namespace Data.Entities
{
    [JsonObject(IsReference = true)]
    public class Thread: BaseEntity
    {
        public virtual ICollection<Post> Posts { get; set; }
        public virtual Board Board { get; set; }
        public int BoardId { get; set; }
        public bool Archived { get; set; } = false;
    }
}
