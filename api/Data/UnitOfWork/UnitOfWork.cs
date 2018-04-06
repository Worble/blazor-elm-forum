using Data.Repositories;
using Data.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore.Storage;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Linq;
using System.Net.WebSockets;

namespace Data.UnitOfWork
{
    public class UnitOfWork : IUnitOfWork
    {
        private readonly TestContext _context;
        private IBoardRepository _boardRepository;
        private IPostRepository _postRepository;
        private IThreadRepository _threadRepository;
        private bool _disposed = false;

        public UnitOfWork(TestContext context)
        {
            _context = context;
        }

        public IBoardRepository BoardRepository => _boardRepository ?? (_boardRepository = new BoardRepository(_context));

        public IPostRepository PostRepository => _postRepository ?? (_postRepository = new PostRepository(_context));

        public IThreadRepository ThreadRepository => _threadRepository ?? (_threadRepository = new ThreadRepository(_context));

        public void Save()
        {
            _context.SaveChanges();
        }

        public IDbContextTransaction BeginTransaction()
        {
            return _context.Database.BeginTransaction();
        }

        public void CommitTransaction()
        {
            _context.Database.CommitTransaction();
        }

        public void RollbackTransaction()
        {
            _context.Database.RollbackTransaction();
        }

        public void Dispose()
        {
            this.Dispose(true);
            GC.SuppressFinalize(this);
        }

        protected virtual void Dispose(bool disposing)
        {
            if (!_disposed)
            {
                if (disposing)
                {
                    _context.Dispose();
                }
            }

            _disposed = true;
        }
    }
}
