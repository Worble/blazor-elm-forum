using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Data.Entities;
using Newtonsoft.Json;

namespace Data.DTO
{
    [JsonObject(IsReference = true)]
    public class BoardDTO : BaseDTO
    {
        public BoardDTO() { }
        public BoardDTO(Board board) : base(board)
        {
            Name = board.Name;
            ShorthandName = board.ShorthandName;
        }

        public string Name { get; set; }
        public string ShorthandName { get; set; }
        public IEnumerable<ThreadDTO> Threads { get; set; }
        public ThreadDTO Thread { get; set; }
    }
}
