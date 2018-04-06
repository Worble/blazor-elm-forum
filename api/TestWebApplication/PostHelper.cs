using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Data.DTO;
using Data.UnitOfWork;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;

namespace TestWebApplication
{
    public class PostHelper
    {
        public static BoardDTO CreatePost(IUnitOfWork work, IHostingEnvironment env, HttpRequest req,PostDTO post)
        {
            if (string.IsNullOrWhiteSpace(post.Content) && string.IsNullOrWhiteSpace(post.Image))
            {
                throw new PostException("Post was empty");
            }

            if (!work.ThreadRepository.ThreadExists(post.ThreadId))
            {
                throw new PostException("Specified thread does not exist");
            }

            if (!string.IsNullOrWhiteSpace(post.Image))
            {
                try
                {
                    post.Checksum = ImageHelper.GenerateChecksum(post);
                    if (work.PostRepository.ImageUniqueToThread(post))
                    {
                        post = ImageHelper.SaveImage(post, env, req);
                    }
                    else
                    {
                        throw new PostException("Duplicate Image");
                    }
                }
                catch (PostException)
                {
                    throw;
                }
                catch
                {
                    throw new PostException("Image failed to upload");
                }
            }

            var board = work.PostRepository.CreatePost(post);
            work.Save();
            return board;
        }
    }
}
