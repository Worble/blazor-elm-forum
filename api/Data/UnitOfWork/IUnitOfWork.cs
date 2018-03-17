using System;
using System.Collections.Generic;
using System.Text;
using Data.Repositories.Interfaces;

namespace Data.UnitOfWork
{
    public interface IUnitOfWork : IDisposable
    {
        void Save();
        IBoardRepository BoardRepository { get; }
        IPostRepository PostRepository { get; }
        IThreadRepository ThreadRepository { get; }
    }
}
