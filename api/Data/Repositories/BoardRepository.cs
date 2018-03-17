using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Data.DTO;
using Data.Entities;
using Data.Repositories.Interfaces;

namespace Data.Repositories
{
    public class BoardRepository : IBoardRepository
    {
        private readonly TestContext _context;
        public BoardRepository(TestContext context)
        {
            _context = context;
        }
        public IEnumerable<BoardDTO> GetAll()
        {
            return _context.Boards
                        .Select(e => new BoardDTO(e));
        }
    }
}
