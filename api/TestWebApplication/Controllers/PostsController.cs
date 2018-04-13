using Data.DTO;
using Data.UnitOfWork;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.IO;
using System.Net.WebSockets;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace TestWebApplication.Controllers
{
    [Route("api/boards/{boardId}/threads/{threadId}/[controller]")]
    public class PostsController : Controller
    {
        private readonly IUnitOfWork _work;
        private readonly IHostingEnvironment _env;
        private Dictionary<string, WebSocket> _webSockets;

        private Dictionary<string, WebSocket> Websockets =>
            _webSockets ?? (_webSockets = new Dictionary<string, WebSocket>());
        public PostsController(IUnitOfWork work, IHostingEnvironment env)
        {
            _work = work;
            _env = env;
        }

        [HttpGet]
        public IActionResult GetAllForThread(int boardId, int threadId)
        {
            return Json(_work.PostRepository.GetAllForThread(boardId, threadId));
        }

        [HttpGet("{postId}")]
        public IActionResult GetOneForThread(int boardId, int threadId, int postId)
        {
            return Json(_work.PostRepository.GetOneForThread(boardId, threadId, postId));
        }

        [HttpPost]
        public IActionResult CreatePost(int threadId, [FromBody]PostDTO post)
        {
            post.ThreadId = threadId;
            post.IsOp = false;

            BoardDTO board;

            try
            {
                board = PostHelper.CreatePost(_work, _env, this.Request, post);
            }
            catch(PostException e)
            {
                return BadRequest(new { message = e.Message });
            }

            return Json(board);
        }
    }
}
