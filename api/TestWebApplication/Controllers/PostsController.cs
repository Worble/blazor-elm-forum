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
    [Route("api/boards/{boardId}/threads/{threadID}/[controller]")]
    public class PostsController : Controller
    {
        private readonly IUnitOfWork _work;

        public PostsController(IUnitOfWork work)
        {
            _work = work;
        }

        [HttpGet]
        public BoardDTO GetAllForThread(int boardID, int threadID)
        {
            return _work.PostRepository.GetAllForThread(boardID, threadID);
        }

        [HttpPost]
        public Thread CreatePost(int threadID, [FromBody]Post post)
        {
            var thread = _work.PostRepository.CreatePost(post, threadID);
            _work.Save();
            return thread;
        }
    }
}
