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
        private const int MAXIMUM_ALLOWED_THREADS = 10;

        public ThreadRepository(TestContext context)
        {
            _context = context;
        }
        //public BoardDTO GetAllForBoard(int boardId)
        //{
        //    return _context.Boards
        //        .Select(e => new BoardDTO(e)
        //        {
        //            Threads = e.Threads
        //                .Where(y => !y.Archived)
        //                .Select(y => new ThreadDTO(y)
        //                {
        //                    Post = new PostDTO(y.Posts.FirstOrDefault(p => p.IsOp))
        //                })
        //        })
        //        .FirstOrDefault(e => e.Id == boardId);
        //}

        public BoardDTO GetAllForBoard(string boardName)
        {
            return _context.Boards
                .Select(e => new BoardDTO(e)
                {
                    Threads = e.Threads
                        .Where(y => !y.Archived)
                        .Select(y => new ThreadDTO(y)
                        {
                            OpPost = y.Posts.Select(x => new PostDTO(x)).FirstOrDefault(x => x.IsOp)
                        })
                })
                .FirstOrDefault(e => e.ShorthandName == boardName);
        }

        public Thread CreateThread(ThreadDTO thread)
        {
            var threadToAdd = new Thread()
            {
                BoardId = thread.BoardId,
                BumpDate = DateTime.Now
            };

            var entity = _context.Add(threadToAdd).Entity;

            ArchiveOldThreads(thread.BoardId);

            return entity;
        }

        private void ArchiveOldThreads(int boardId)
        {
            var threadsToRemove = _context.Threads
                .Where(e => e.BoardId == boardId && !e.Archived)
                .OrderByDescending(e => e.BumpDate)
                .Skip(MAXIMUM_ALLOWED_THREADS - 1);

            foreach (var item in threadsToRemove)
            {
                item.Archived = true;

                _context.Threads.Attach(item);
                _context.Entry(item).State = EntityState.Modified;
            }
        }

        public bool ThreadExists(int threadId)
        {
            var thread = _context.Threads.Find(threadId);
            return thread != null && !thread.Archived;
        }
    }
}