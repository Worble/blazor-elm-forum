using System;
using System.Collections.Generic;
using System.Text;
using Data.DTO;
using Data.Entities;

namespace Data.Repositories.Interfaces
{
    public interface IThreadRepository
    {
        BoardDTO GetAllForBoard(int boardId);
        Thread CreateThread(ThreadDTO thread);
        bool ThreadExists(int threadId);
    }
}
