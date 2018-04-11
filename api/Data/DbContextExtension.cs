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
            if (!context.Boards.Any())
            {
                var boards =
                    JsonConvert.DeserializeObject<List<Board>>(
                        File.ReadAllText("seed" + Path.DirectorySeparatorChar + "boards.json"));
                foreach (var board in boards)
                {
                    context.Boards.Add(board);
                }
                context.SaveChanges();
            }

            //threads
            if (!context.Threads.Any())
            {
                var threads =
                    JsonConvert.DeserializeObject<List<Thread>>(
                        File.ReadAllText("seed" + Path.DirectorySeparatorChar + "threads.json"));
                foreach (var thread in threads)
                {
                    thread.BumpDate = DateTime.Now;
                    context.Threads.Add(thread);
                }
                context.SaveChanges();
            }

            //posts
            if (!context.Posts.Any())
            {
                var posts =
                    JsonConvert.DeserializeObject<List<Post>>(
                        File.ReadAllText("seed" + Path.DirectorySeparatorChar + "posts.json"));
                foreach (var post in posts)
                {

                    context.Posts.Add(post);
                }
                context.SaveChanges();
            }
        }
    }
}