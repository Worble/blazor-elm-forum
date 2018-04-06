using System;
using System.Collections.Generic;
using System.IO;
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
            return _context.Boards
                .Select(e => new BoardDTO(e)
                {
                    Thread = e.Threads
                        .Select(y => new ThreadDTO(y)
                        {
                            Posts = y.Posts.Select(x => new PostDTO(x))
                        })
                        .FirstOrDefault(y => y.Id == threadId)
                })
                .FirstOrDefault(e => e.Id == boardId);
        }
        public BoardDTO CreatePost(PostDTO post)
        {
            var postToAdd = new Post()
            {
                Content = post.Content,
                ThreadId = post.ThreadId,
                ImagePath = post.ImagePath,
                ThumbnailPath = post.ThumbnailPath,
                IsOp = post.IsOp,
                ImageChecksum = post.Checksum
            };
            _context.Posts.Add(postToAdd);

            var thread = _context.Threads.Find(post.ThreadId);
            thread.EditedDate = DateTime.Now;
            _context.Threads.Attach(thread);
            _context.Entry(thread).State = EntityState.Modified;

            var test = _context.Boards
                .Select(e => new BoardDTO(e)
                {
                    Thread = e.Threads
                        .Select(y => new ThreadDTO(y)
                        {
                            Posts = y.Posts.Select(x => new PostDTO(x))
                        })
                        .FirstOrDefault(y => y.Id == post.ThreadId)
                })
                .FirstOrDefault(e => e.Thread != null);

            return test;
        }

        public bool ImageUniqueToThread(PostDTO post)
        {
            try
            {
                return _context.Threads
                    .Include(e => e.Posts)
                    .First(e => e.Id == post.ThreadId)
                    .Posts.All(e => e.ImageChecksum != post.Checksum);
            }
            catch (ArgumentNullException)
            {
                return false;
            }
        }
    }
}