using System;
using System.Collections.Generic;
using System.Linq;
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
            this.Archived = thread.Archived;
            this.BumpDate = thread.BumpDate;
        }

        public virtual IEnumerable<PostDTO> Posts { get; set; }
        public virtual PostDTO OpPost { get; set; }
        public virtual PostDTO Post { get; set; }
        public int BoardId { get; set; }
        public bool Archived { get; set; }
        public DateTime BumpDate { get; set; }
    }
}
