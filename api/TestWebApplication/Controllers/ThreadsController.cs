using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Data.DTO;
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
        public IActionResult GetAllForBoard(int boardId)
        {
            return Json(_work.ThreadRepository.GetAllForBoard(boardId));
        }

        [HttpPost]
        public IActionResult CreateThread([FromBody]ThreadDTO thread)
        {
            var returnThread = _work.ThreadRepository.CreateThread(thread);
            _work.Save();
            return RedirectToAction("GetAllForThread", "Posts", new { boardId = returnThread.BoardId, threadId = returnThread.Id });
        }
    }
}
