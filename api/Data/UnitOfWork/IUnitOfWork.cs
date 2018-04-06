using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Net.WebSockets;
using System.Text;
using Data.Repositories.Interfaces;
using Microsoft.EntityFrameworkCore.Storage;

namespace Data.UnitOfWork
{
    public interface IUnitOfWork : IDisposable
    {
        IDbContextTransaction BeginTransaction();
        void Save();
        IBoardRepository BoardRepository { get; }
        IPostRepository PostRepository { get; }
        IThreadRepository ThreadRepository { get; }
        void CommitTransaction();
        void RollbackTransaction();
    }
}
