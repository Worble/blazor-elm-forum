using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Data.DTO;
using Data.UnitOfWork;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Mvc;

namespace TestWebApplication.Controllers
{
    [Route("api/boards/{boardId}/[controller]")]
    public class ThreadsController : Controller
    {
        private readonly IUnitOfWork _work;
        private readonly IHostingEnvironment _env;

        public ThreadsController(IUnitOfWork work, IHostingEnvironment env)
        {
            _work = work;
            _env = env;
        }

        [HttpGet]
        public IActionResult GetAllForBoard(int boardId)
        {
            return Json(_work.ThreadRepository.GetAllForBoard(boardId));
        }

        //[HttpGet]
        //public IActionResult GetAllForBoard(string boardId)
        //{
        //    return Json(_work.ThreadRepository.GetAllForBoardByShorthandName(boardId));
        //}

        [HttpPost]
        public IActionResult CreateThread([FromBody]ThreadDTO thread)
        {
            if (string.IsNullOrWhiteSpace(thread.Post.Content) && string.IsNullOrWhiteSpace(thread.Post.Image))
            {
                return BadRequest();
            }

            using (_work.BeginTransaction())
            {
                try
                {
                    var returnThread = _work.ThreadRepository.CreateThread(thread);
                    _work.Save();

                    thread.Post.ThreadId = returnThread.Id;
                    thread.Post.IsOp = true;

                    if (!string.IsNullOrWhiteSpace(thread.Post.Image))
                    {
                        thread.Post = ImageHelper.SaveImage(thread.Post, _env, this.Request);
                    }

                    _work.PostRepository.CreatePost(thread.Post);
                    _work.Save();
                    _work.CommitTransaction();
                    return RedirectToAction("GetAllForThread", "Posts", new { boardId = returnThread.BoardId, threadId = returnThread.Id });
                }
                catch
                {
                    _work.RollbackTransaction();
                    return BadRequest();
                }
            }

        }
    }
}
