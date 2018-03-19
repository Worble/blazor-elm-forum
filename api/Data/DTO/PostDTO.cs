using System;
using System.Collections.Generic;
using System.Text;
using Data.Entities;
using Newtonsoft.Json;

namespace Data.DTO{
    [JsonObject(IsReference = true)]
    public class PostDTO : BaseDTO
    {
        public PostDTO(Post post) : base(post)
        {
            this.Content = post.Content;
            this.ThreadId = post.ThreadId;
            this.IsOp = post.IsOp;
        }
        public string Content { get; set; }
        public int ThreadId { get; set; }
        public bool IsOp { get; set; }
    }
}
