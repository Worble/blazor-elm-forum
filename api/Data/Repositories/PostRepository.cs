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
        private const int BUMPLIMIT = 5;

        public PostRepository(TestContext context)
        {
            _context = context;
        }
        //public BoardDTO GetAllForThread(int boardId, int threadId)
        //{
        //    return _context.Boards
        //        .Select(e => new BoardDTO(e)
        //        {
        //            Thread = e.Threads
        //                .Select(y => new ThreadDTO(y)
        //                {
        //                    Posts = y.Posts.Select(x => new PostDTO(x))
        //                })
        //                .FirstOrDefault(y => y.Id == threadId)
        //        })
        //        .FirstOrDefault(e => e.Id == boardId);
        //}

        public BoardDTO GetAllForThread(string boardName, int postId)
        {
            return _context.Boards
                .Select(e => new BoardDTO(e)
                {
                    Thread = e.Threads
                        .Select(y => new ThreadDTO(y)
                        {
                            Posts = y.Posts.Select(x => new PostDTO(x)),
                            OpPost = y.Posts.Select(x => new PostDTO(x)).FirstOrDefault(x => x.IsOp),
                            Post = y.Posts.Select(x => new PostDTO(x)).FirstOrDefault(x => x.Id == postId)
                        })
                        .FirstOrDefault(y => y.Posts.Any(x => x.Id == postId))
                })
                .FirstOrDefault(e => e.ShorthandName == boardName);
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

            var thread = _context.Threads
                .Include(e => e.Posts)
                .FirstOrDefault(e => e.Id == post.ThreadId);

            thread.EditedDate = DateTime.Now;
            if (thread.Posts.Count <= BUMPLIMIT)
            {
                thread.BumpDate = DateTime.Now;
            }
            _context.Threads.Attach(thread);
            _context.Entry(thread).State = EntityState.Modified;

            return _context.Boards
                .Select(e => new BoardDTO(e)
                {
                    Thread = e.Threads
                        .Select(y => new ThreadDTO(y)
                        {
                            Posts = y.Posts.Select(x => new PostDTO(x)),
                            OpPost = y.Posts.Select(x => new PostDTO(x)).FirstOrDefault(x => x.IsOp)
                        })
                        .FirstOrDefault(y => y.Id == post.ThreadId)
                })
                .FirstOrDefault(e => e.Thread != null);

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

        public BoardDTO GetOneForThread(string boardName, int threadId, int postId)
        {
            return _context.Boards
                .Select(e => new BoardDTO(e)
                {
                    Thread = e.Threads
                        .Select(y => new ThreadDTO(y)
                        {
                            Posts = y.Posts.Select(x => new PostDTO(x)),
                            Post = y.Posts.Select(x => new PostDTO(x)).FirstOrDefault(x => x.Id == postId),
                            OpPost = y.Posts.Select(x => new PostDTO(x)).FirstOrDefault(x => x.IsOp)

                        })
                        .FirstOrDefault(y => y.Posts.Any(x => x.Id == threadId))
                })
                .FirstOrDefault(e => e.ShorthandName == boardName);
        }
    }
}