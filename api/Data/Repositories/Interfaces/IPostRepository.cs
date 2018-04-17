using System;
using System.Collections.Generic;
using System.Text;
using Data.DTO;
using Data.Entities;

namespace Data.Repositories.Interfaces
{
    public interface IPostRepository
    {
        //BoardDTO GetAllForThread(int boardId, int threadId);
        BoardDTO GetAllForThread(string boardName, int postId);
        BoardDTO CreatePost(PostDTO post);
        bool ImageUniqueToThread(PostDTO post);
        BoardDTO GetOneForThread(string boardName, int threadId, int postId);
    }
}
