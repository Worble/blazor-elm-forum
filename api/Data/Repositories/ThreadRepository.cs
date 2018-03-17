using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Data.DTO;
using Data.Entities;
using Data.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore;

namespace Data.Repositories
{
    public class ThreadRepository : IThreadRepository
    {
        private readonly TestContext _context;

        public ThreadRepository(TestContext context)
        {
            _context = context;
        }
        public BoardDTO GetAllForBoard(int boardID)
        {
            return _context.Boards
                .Select(e => new BoardDTO(e)
                {
                    Threads = e.Threads
                        .Select(y => new ThreadDTO(y)
                        {
                            Posts = y.Posts
                                .Where(x => x.IsOp)
                                .Select(x => new PostDTO(x))
                        })
                })
                .FirstOrDefault(e => e.ID == boardID);
        }

        public Thread CreateThread(Post openingPost, int boardID)
        {
            openingPost.IsOp = true;
            var thread = new Thread()
            {
                Posts = new List<Post>() {openingPost},
                BoardID = boardID
            };
            return _context.Add(thread).Entity;
        }
    }
}
