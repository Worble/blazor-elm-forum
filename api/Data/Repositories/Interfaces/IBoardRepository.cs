using System;
using System.Collections.Generic;
using System.Text;
using Data.DTO;
using Data.Entities;

namespace Data.Repositories.Interfaces
{
    public interface IBoardRepository
    {
        IEnumerable<BoardDTO> GetAll();
    }
}
