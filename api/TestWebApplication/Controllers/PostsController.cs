using Data.DTO;
using Data.UnitOfWork;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using System;
using System.IO;
using System.Net.WebSockets;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading;
using System.Threading.Tasks;

namespace TestWebApplication.Controllers
{
    [Route("api/boards/{boardId}/threads/{threadId}/[controller]")]
    public class PostsController : Controller
    {
        private readonly IUnitOfWork _work;
        private readonly IHostingEnvironment _env;

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

        [HttpPost]
        public IActionResult CreatePost(int threadId, [FromBody]PostDTO post)
        {
            if (string.IsNullOrWhiteSpace(post.Content) && string.IsNullOrWhiteSpace(post.Image))
            {
                return BadRequest(new { message = "Empty Post" });
            }

            if (!string.IsNullOrWhiteSpace(post.Image))
            {
                try
                {
                    post.Checksum = ImageHelper.GenerateChecksum(post);
                    if (_work.PostRepository.ImageUniqueToThread(post))
                    {
                        post = ImageHelper.SaveImage(post, _env, this.Request);
                    }
                    else
                    {
                        return BadRequest(new { message = "Duplicate Image" });
                    }
                }
                catch
                {
                    return BadRequest(new { message = "Image failed to upload" });
                }
            }
            post.ThreadId = threadId;
            post.IsOp = false;
            var board = _work.PostRepository.CreatePost(post);
            _work.Save();
            return Json(board);
        }

        [HttpGet("ws")]
        public async Task<IActionResult> GetAsync(int boardId, int thwreadId)
        {
            if (!this.HttpContext.WebSockets.IsWebSocketRequest) return new StatusCodeResult(101);

            //var webSocket = await this.HttpContext.WebSockets.AcceptWebSocketAsync();
            //if (webSocket == null || webSocket.State != WebSocketState.Open) return new StatusCodeResult(101);

            //while (!HttpContext.RequestAborted.IsCancellationRequested)
            //{
            //    var response = string.Format("Hello! Time {0}", DateTime.Now.ToString(CultureInfo.InvariantCulture));
            //    var bytes = System.Text.Encoding.UTF8.GetBytes(response);

            //    await webSocket.SendAsync(new ArraySegment<byte>(bytes),
            //        WebSocketMessageType.Text, true, CancellationToken.None);

            //    var buffer = new byte[1024 * 4];
            //    WebSocketReceiveResult result = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);
            //    while (!result.CloseStatus.HasValue)
            //    {
            //        await webSocket.SendAsync(new ArraySegment<byte>(buffer, 0, result.Count), result.MessageType, result.EndOfMessage, CancellationToken.None);

            //        result = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);
            //    }
            //    await webSocket.CloseAsync(result.CloseStatus.Value, result.CloseStatusDescription, CancellationToken.None);
            //}

            var webSocket = await this.HttpContext.WebSockets.AcceptWebSocketAsync();
            await Echo(HttpContext, webSocket);

            return new StatusCodeResult(101);
        }

        private async Task Echo(HttpContext context, WebSocket webSocket)
        {
            var buffer = new Byte[4096];
            var buffer2 = new ArraySegment<Byte>(new Byte[4096]);
            WebSocketReceiveResult result =
                await webSocket.ReceiveAsync(buffer2, CancellationToken.None);

            var request = Encoding.UTF8.GetString(buffer2.Array,
                buffer2.Offset,
                buffer2.Count);
            while (!result.CloseStatus.HasValue)
            {
                await webSocket.SendAsync(new ArraySegment<byte>(buffer, 0, result.Count), result.MessageType,
                    result.EndOfMessage, CancellationToken.None);

                result = await webSocket.ReceiveAsync(new ArraySegment<byte>(buffer), CancellationToken.None);
            }

            await webSocket.CloseAsync(result.CloseStatus.Value, result.CloseStatusDescription, CancellationToken.None);
        }


    }
}
