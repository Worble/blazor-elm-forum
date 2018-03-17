using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Data.DTO;
using Data.Entities;
using Data.UnitOfWork;
using Microsoft.AspNetCore.Mvc;

namespace TestWebApplication.Controllers
{
    [Route("api/boards/{boardId}/[controller]")]
    public class ThreadsController : Controller
    {
        private readonly IUnitOfWork _work;

        public ThreadsController(IUnitOfWork work)
        {
            _work = work;
        }

        [HttpGet]
        public BoardDTO GetAllForBoard(int boardId)
        {
            return _work.ThreadRepository.GetAllForBoard(boardId);
        }

        [HttpPost]
        public Thread CreateThread(int boardId, [FromBody]Post post)
        {
            var returnThread = _work.ThreadRepository.CreateThread(post, boardId);
            _work.Save();
            return returnThread;
        }
    }
}
