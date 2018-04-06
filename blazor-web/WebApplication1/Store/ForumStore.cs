using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using Microsoft.AspNetCore.Blazor;
using Microsoft.AspNetCore.Blazor.Services;

namespace WebApplication1.Store
{
    public class ForumStore
    {
        private HttpClient _client;
        private IUriHelper _uriHelper;
        const string API = "http://localhost:14190/api/";

        public ForumStore(HttpClient client, IUriHelper uriHelper)
        {
            this._client = client;
            this._uriHelper = uriHelper;
        }

        public BoardDTO[] Boards { get; private set; }
        public BoardDTO Board { get; private set; }

        public event Action OnChange;
        private void NotifyStateChanged() => OnChange?.Invoke();

        public async Task GetAllBoards() { 
            Boards = await _client.GetJsonAsync<BoardDTO[]>(API + "boards/");
            NotifyStateChanged();
        }

        public async Task GetAllThreadsForBoard(int boardId)
        {
            var result = await _client.GetJsonAsync<BoardDTO>(API + "boards/" + boardId + "/threads/");

            if (result == null)
            {
                _uriHelper.NavigateTo("/404");
                return;
            } 

            if (Board != null && Board.thread != null && Board.id == result.id)
            {
                result.thread = Board.thread;
            }

            result.threads = result.threads.OrderByDescending(e => e.editedDate);
            Board = result;
            NotifyStateChanged();
            return;
        }

        public async Task GetAllPostsForThread(int boardId, int threadId)
        {
            var result = await _client.GetJsonAsync<BoardDTO>(API + "boards/" + boardId + "/threads/" + threadId + "/posts/");

            if (result.thread == null)
            {
                _uriHelper.NavigateTo("/404");
                return;
            }

            if (Board != null && Board.threads != null)
            {
                result.threads = Board.threads;
            }
            Board = result;
            NotifyStateChanged();
            return;
        }

        public async Task PostThread(int boardId, string content, string image)
        {
            var result = await _client.SendJsonAsync<BoardDTO>(
                HttpMethod.Post,
                API + "boards/" + boardId + "/threads/",
                new ThreadDTO()
                {
                    boardId = boardId,
                    post = new PostDTO() { content = content, image = image }
                });

            if (Board == null)
            {
                Board = result;
            }
            else
            {
                Board.id = result.id;
                Board.thread = result.thread;
            }
            NotifyStateChanged();
        }

        public async Task PostPost(int boardId, int threadId, string content, string image)
        {
            var result = await _client.SendJsonAsync<BoardDTO>(
                HttpMethod.Post,
                API + "boards/" + boardId + "/threads/" + threadId + "/posts/",
                new PostDTO() { content = content, threadId = threadId, image = image }
                );

            if (Board == null)
            {
                Board = result;
            }
            else
            {
                Board.id = result.id;
                Board.thread = result.thread;
            }
            NotifyStateChanged();
        }
    }

    public class BoardDTO : BaseDTO
    {
        public string name;
        public string shorthandName;
        public IEnumerable<ThreadDTO> threads;
        public ThreadDTO thread;
    }

    public class ThreadDTO : BaseDTO
    {
        public IEnumerable<PostDTO> posts;
        public PostDTO post;
        public int boardId;
    }

    public class PostDTO : BaseDTO
    {
        public string content;
        public int threadId;
        public bool isOp;
        public string image;
        public string imagePath;
        public string thumbnailPath;
    }

    public class BaseDTO
    {
        public int id;
        public DateTime createdDate;
        public DateTime? editedDate;
    }
}
