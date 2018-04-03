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
        public ThreadDTO() { }
        public ThreadDTO(Thread thread) : base(thread)
        {
            this.BoardId = thread.BoardId;
        }

        public virtual IEnumerable<PostDTO> Posts { get; set; }
        public virtual PostDTO Post { get; set; }
        public int BoardId { get; set; }
    }
}
