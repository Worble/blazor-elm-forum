using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using Data.Entities;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Newtonsoft.Json;

namespace Data
{
    public static class DbContextExtension
    {
        public static bool AllMigrationsApplied(this DbContext context)
        {
            var applied = context.GetService<IHistoryRepository>()
                .GetAppliedMigrations()
                .Select(m => m.MigrationId);

            var total = context.GetService<IMigrationsAssembly>()
                .Migrations
                .Select(m => m.Key);

            return !total.Except(applied).Any();
        }

        public static void EnsureSeeded(this TestContext context)
        {
            //boards
            var boards =
                JsonConvert.DeserializeObject<List<Board>>(
                    File.ReadAllText("seed" + Path.DirectorySeparatorChar + "boards.json"));
            foreach (var board in boards)
            {
                if (context.Boards.Find(board.ID) == null)
                {
                    context.Boards.Add(board);
                }
            }
            context.SaveChanges();

            //threads
            var threads =
                JsonConvert.DeserializeObject<List<Thread>>(
                    File.ReadAllText("seed" + Path.DirectorySeparatorChar + "threads.json"));
            foreach (var thread in threads)
            {
                if (context.Threads.Find(thread.ID) == null)
                {
                    context.Threads.Add(thread);
                }
            }
            context.SaveChanges();

            //posts
            var posts =
                JsonConvert.DeserializeObject<List<Post>>(
                    File.ReadAllText("seed" + Path.DirectorySeparatorChar + "posts.json"));
            foreach (var post in posts)
            {
                if (context.Posts.Find(post.ID) == null)
                {
                    context.Posts.Add(post);
                }
            }
            context.SaveChanges();
        }

    }
}