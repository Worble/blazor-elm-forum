using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Data.DTO;
using Data.UnitOfWork;
using Microsoft.AspNetCore.Mvc;

namespace TestWebApplication.Controllers
{
    [Route("api/boards/{boardId}/threads/{threadID}/[controller]")]
    public class PostsController : Controller
    {
        private readonly IUnitOfWork _work;

        public PostsController(IUnitOfWork work)
        {
            _work = work;
        }

        [HttpGet]
        public IActionResult GetAllForThread(int boardId, int threadId)
        {
            return Json(_work.PostRepository.GetAllForThread(boardId, threadId));
        }

        [HttpPost]
        public IActionResult CreatePost([FromBody]PostDTO post)
        {
            var board = _work.PostRepository.CreatePost(post);
            _work.Save();
            return Json(board);
        }
    }
}
