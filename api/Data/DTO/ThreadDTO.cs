using System;
using System.Collections.Generic;
using System.Text;
using Data.Entities;
using Newtonsoft.Json;

namespace Data.DTO
{
    [JsonObject(IsReference = true)]
    public class ThreadDTO : BaseDTO
    {
        public ThreadDTO(Thread thread):base(thread)
        {
            //this.Posts = thread.Posts;
        }
        public virtual IEnumerable<PostDTO> Posts { get; set; }
    }
}
