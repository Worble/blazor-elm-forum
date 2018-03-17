using System;
using System.Collections.Generic;
using System.Text;

namespace Data.Entities
{
    public class BaseEntity
    {
        public int ID { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? EditedDate { get; set; }
    }
}
