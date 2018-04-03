﻿using System;
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
        public BoardDTO GetAllForBoard(int boardId)
        {
            return _context.Boards
                .Select(e => new BoardDTO(e)
                {
                    Threads = e.Threads
                        .Select(y => new ThreadDTO(y)
                        {
                            Post = new PostDTO(y.Posts.FirstOrDefault(p => p.IsOp))
                        })
                })
                .FirstOrDefault(e => e.Id == boardId);
        }

        public Thread CreateThread(ThreadDTO thread)
        {
            var threadToAdd = new Thread()
            {
                BoardId = thread.BoardId,
                //Posts = new List<Post>()
                //{
                //    new Post()
                //    {
                //        Content = thread.Post.Content,
                //        ImagePath = thread.Post.ImagePath,
                //        IsOp = true
                //    }
                //}
            };

            return _context.Add(threadToAdd).Entity;
        }

        public BoardDTO GetAllForBoardByShorthandName(string boardId)
        {
            return _context.Boards
                .Select(e => new BoardDTO(e)
                {
                    Threads = e.Threads
                        .Select(y => new ThreadDTO(y)
                        {
                            Post = new PostDTO(y.Posts.FirstOrDefault(p => p.IsOp))
                        })
                })
                .FirstOrDefault(e => e.ShorthandName == boardId);
        }
    }
}