using System;
using System.Collections.Generic;
using System.Text;
using Data.Entities;

namespace Data.DTO
{
    public class BaseDTO
    {
        public BaseDTO(BaseEntity baseEntity)
        {
            this.ID = baseEntity.ID;
            this.CreatedDate = baseEntity.CreatedDate;
            this.EditedDate = baseEntity.EditedDate;
        }
        public int ID { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? EditedDate { get; set; }
    }
}
