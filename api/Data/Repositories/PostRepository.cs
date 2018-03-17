using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography.X509Certificates;
using System.Text;
using Data.DTO;
using Data.Entities;
using Data.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace Data.Repositories
{
    public class PostRepository : IPostRepository
    {
        private readonly TestContext _context;

        public PostRepository(TestContext context)
        {
            _context = context;
        }
        public BoardDTO GetAllForThread(int boardId, int threadId)
        {
            //return _context.Boards
            //    .Select(e => new BoardDTO(e)
            //    {
            //        Thread = new ThreadDTO(e.Threads.FirstOrDefault(y => y.ID == threadId))
            //    })
            //    .FirstOrDefault(e => e.ID == boardId);

            return _context.Boards
                .Select(e => new BoardDTO(e)
                {
                    Thread = e.Threads.Select(y => new ThreadDTO(y)
                        {
                            Posts = y.Posts.Select(x => new PostDTO(x))
                        })
                        .FirstOrDefault(y => y.ID == threadId)
                })
                .FirstOrDefault(e => e.ID == boardId);

        }
        public Thread CreatePost(Post post, int threadID)
        {
            post.ThreadID = threadID;
            _context.Posts.Add(post);
            return _context.Threads
                .Include(e => e.Posts)
                .Include(e => e.Board)
                .FirstOrDefault(e => e.ID == threadID);
        }
    }
}
