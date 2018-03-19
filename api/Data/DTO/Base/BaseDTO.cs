using System;
using System.Collections.Generic;
using System.Text;
using Data.Entities;

namespace Data.DTO
{
    public class BaseDTO
    {
        public BaseDTO() { }
        public BaseDTO(BaseEntity baseEntity)
        {
            this.Id = baseEntity.Id;
            this.CreatedDate = baseEntity.CreatedDate;
            this.EditedDate = baseEntity.EditedDate;
        }
        public int Id { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime? EditedDate { get; set; }
    }
}
