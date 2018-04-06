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

        //[HttpGet("ws")]
        //public async Task<IActionResult> GetAsync(int boardId, int threadId)
        //{
        //    if (!this.HttpContext.WebSockets.IsWebSocketRequest) return new StatusCodeResult(400);

        //    var webSocket = await this.HttpContext.WebSockets.AcceptWebSocketAsync();

        //    //await Test(webSocket);

        //    var socketId = Guid.NewGuid().ToString();
        //    //_work.AddWebsocketToThread(threadId, socketId, webSocket);

        //    Websockets.TryAdd(socketId, webSocket);
        //    var ct = HttpContext.RequestAborted;

        //    //while (webSocket.State == WebSocketState.Open)
        //    //{
        //    //    await Echo(HttpContext.RequestAborted, webSocket, socketId, threadId);
        //    //}

        //    while (true)
        //    {
        //        if (ct.IsCancellationRequested)
        //        {
        //            break;
        //        }

        //        var response = await ReceiveStringAsync(webSocket, ct);
        //        if (string.IsNullOrEmpty(response))
        //        {
        //            if (webSocket.State != WebSocketState.Open)
        //            {
        //                break;
        //            }

        //            continue;
        //        }

        //        //var post = JsonConvert.DeserializeObject<PostDTO>(response);
        //        //var board = PostHelper.CreatePost(_work, _env, this.Request, post);

        //        //var data = JsonConvert.SerializeObject(board, new JsonSerializerSettings
        //        //{
        //        //    ContractResolver = new CamelCasePropertyNamesContractResolver()
        //        //});

        //        var data = response;

        //        //foreach (var socket in _work.GetAllSocketsForThread(threadId))
        //        foreach(var socket in Websockets)
        //        {
        //            if (socket.Value.State != WebSocketState.Open)
        //            {
        //                continue;
        //            }

        //            await SendStringAsync(socket.Value, data, ct);
        //        }
        //    }

        //    //_work.RemoveSocketFromThread(threadId, socketId);
        //    Websockets.Remove(socketId, out var dummy);

        //    await webSocket.CloseAsync(WebSocketCloseStatus.NormalClosure, "Closing", ct);
        //    webSocket.Dispose();

        //    return new StatusCodeResult(101);
        //}

        //private async Task Test(WebSocket webSocket)
        //{
        //    var data = Encoding.UTF8.GetBytes("Test");
        //    var buffer = new ArraySegment<byte>(data);

        //    await webSocket.SendAsync(buffer, WebSocketMessageType.Text,
        //        true, CancellationToken.None);
        //}

        //private async Task Echo(CancellationToken ct, WebSocket currentSocket, string socketId, int threadId)
        //{
        //    while (true)
        //    {
        //        if (ct.IsCancellationRequested)
        //        {
        //            break;
        //        }

        //        var response = await ReceiveStringAsync(currentSocket, ct);
        //        if (string.IsNullOrEmpty(response))
        //        {
        //            if (currentSocket.State != WebSocketState.Open)
        //            {
        //                break;
        //            }

        //            continue;
        //        }

        //        //var post = JsonConvert.DeserializeObject<PostDTO>(response);
        //        //var board = PostHelper.CreatePost(_work, _env, this.Request, post);

        //        //var data = JsonConvert.SerializeObject(board, new JsonSerializerSettings
        //        //{
        //        //    ContractResolver = new CamelCasePropertyNamesContractResolver()
        //        //});

        //        var data = response;

        //        foreach (var socket in _work.GetAllSocketsForThread(threadId))
        //        {
        //            if (socket.Value.State != WebSocketState.Open)
        //            {
        //                continue;
        //            }

        //            await SendStringAsync(socket.Value, data, ct);
        //        }
        //    }

        //    _work.RemoveSocketFromThread(threadId, socketId);

        //    await currentSocket.CloseAsync(WebSocketCloseStatus.NormalClosure, "Closing", ct);
        //    currentSocket.Dispose();

        //}

        //private static async Task<string> ReceiveStringAsync(WebSocket socket, CancellationToken ct = default(CancellationToken))
        //{
        //    var buffer = new ArraySegment<byte>(new byte[8192]);
        //    using (var ms = new MemoryStream())
        //    {
        //        WebSocketReceiveResult result;
        //        do
        //        {
        //            ct.ThrowIfCancellationRequested();

        //            result = await socket.ReceiveAsync(buffer, ct);
        //            ms.Write(buffer.Array, buffer.Offset, result.Count);
        //        }
        //        while (!result.EndOfMessage);

        //        ms.Seek(0, SeekOrigin.Begin);
        //        if (result.MessageType != WebSocketMessageType.Text)
        //        {
        //            return null;
        //        }

        //        // Encoding UTF8: https://tools.ietf.org/html/rfc6455#section-5.6
        //        using (var reader = new StreamReader(ms, Encoding.UTF8))
        //        {
        //            return await reader.ReadToEndAsync();
        //        }
        //    }
        //}

        //private static Task SendStringAsync(WebSocket socket, string data, CancellationToken ct = default(CancellationToken))
        //{
        //    var buffer = Encoding.UTF8.GetBytes(data);
        //    var segment = new ArraySegment<byte>(buffer);
        //    return socket.SendAsync(segment, WebSocketMessageType.Text, true, ct);
        //}

        //private async Task Echo(WebSocket webSocket)
        //{
        //    var buffer = new ArraySegment<Byte>(new Byte[1048576]);
        //    WebSocketReceiveResult result =
        //        await webSocket.ReceiveAsync(buffer, CancellationToken.None);

        //    var request = Encoding.UTF8.GetString(buffer.Array,
        //        buffer.Offset,
        //        buffer.Count);

        //    var post = JsonConvert.DeserializeObject<PostDTO>(request);
        //    var board = PostHelper.CreatePost(_work, _env, this.Request, post);

        //    var data = Encoding.UTF8.GetBytes(JsonConvert.SerializeObject(board, new JsonSerializerSettings
        //        {
        //            ContractResolver = new CamelCasePropertyNamesContractResolver()
        //        }));
        //    buffer = new ArraySegment<byte>(data);

        //    while (!result.CloseStatus.HasValue)
        //    {
        //        foreach (var socket in WebSockets)
        //        {
        //            if (socket.Value.State != WebSocketState.Open)
        //            {
        //                continue;
        //            }

        //            await socket.Value.SendAsync(buffer, result.MessageType,
        //                true, CancellationToken.None);

        //            result = await webSocket.ReceiveAsync(buffer, CancellationToken.None);
        //        }
        //    }

        //    await webSocket.CloseAsync(result.CloseStatus.Value, result.CloseStatusDescription, CancellationToken.None);
        //}
    }
}
