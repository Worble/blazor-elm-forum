using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text.RegularExpressions;
using System.Threading.Tasks;
using Data.DTO;
using Data.UnitOfWork;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Http;
using SixLabors.ImageSharp;
using SixLabors.ImageSharp.MetaData;
using SixLabors.ImageSharp.Processing;
using SixLabors.ImageSharp.Processing.Transforms;
using SixLabors.Primitives;

namespace TestWebApplication
{
    public class ImageHelper
    {
        public static PostDTO SaveImage(PostDTO post, IHostingEnvironment env, HttpRequest req)
        {
            var regex = Regex.Match(post.Image, @"data:image/(?<type>.+?);base64,(?<data>.+)");
            var base64 = regex.Groups["data"].Value;
            var binData = Convert.FromBase64String(base64);

            if (binData.Length / 1048576 > 3)
            {
                throw new Exception();
            }

            string name = DateTimeOffset.Now.ToUnixTimeSeconds().ToString();

            string imageName = name + "." + regex.Groups["type"].Value;
            string thumbnailName = name + ".jpeg";

            string imagePath = "/Images/" + post.ThreadId + "/";
            string thumbnailPath = "/Thumbnails/" + post.ThreadId + "/";

            string localImagePath = Path.Combine(env.WebRootPath + imagePath, imageName);
            string localThumbnailPath = Path.Combine(env.WebRootPath + thumbnailPath, thumbnailName);

            string webImagePath = req.Scheme + "://" + req.Host + req.PathBase + imagePath + imageName;
            string webThumbnailPath = req.Scheme + "://" + req.Host + req.PathBase + thumbnailPath + thumbnailName;

            var image = Image.Load(binData);
            var thumbnail = image.Clone();
            thumbnail.Mutate(i => i.Resize(new ResizeOptions()
                {
                    Mode = ResizeMode.Max, Size = new Size() {Width = 100, Height = 100}
                })
            );


            if (!File.Exists(localImagePath) || !File.Exists(localThumbnailPath))
            {
                FileInfo file = new FileInfo(localImagePath);
                file.Directory?.Create();
                file = new FileInfo(localThumbnailPath);
                file.Directory?.Create();
                //System.IO.File.WriteAllBytes(localname, binData);
                image.Save(localImagePath);
                thumbnail.Save(localThumbnailPath);
            }

            post.ImagePath = webImagePath;
            post.ThumbnailPath = webThumbnailPath;
            return post;
        }

        public static string GenerateChecksum(PostDTO post)
        {
            var regex = Regex.Match(post.Image, @"data:image/(?<type>.+?);base64,(?<data>.+)");
            var base64 = regex.Groups["data"].Value;
            var binData = Convert.FromBase64String(base64);

            using (var md5 = MD5.Create())
            {
                var hash = md5.ComputeHash(binData);
                return BitConverter.ToString(hash).Replace("-", "").ToLowerInvariant();
            }
        }
    }
}
