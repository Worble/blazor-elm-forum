using System;
using System.Collections.Generic;
using System.Text;
using Data.DTO;
using Newtonsoft.Json;

namespace Data.Entities
{
    [JsonObject (IsReference = true)]
    public class Post : BaseEntity
    {
        public string Content { get; set; }
        public virtual Thread Thread { get; set; }
        public int ThreadId { get; set; }
        public bool IsOp { get; set; }
        public string ImagePath { get; set; }
        public string ThumbnailPath { get; set; }
    }
}