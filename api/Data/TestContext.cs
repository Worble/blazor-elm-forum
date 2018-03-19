using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using Data.Entities;
using Microsoft.EntityFrameworkCore;

namespace Data
{
    public class TestContext : DbContext
    {
        public TestContext(DbContextOptions<TestContext> options) : base(options) { }

        public DbSet<Board> Boards { get; set; }
        public DbSet<Thread> Threads { get; set; }
        public DbSet<Post> Posts { get; set; }

        protected override void OnModelCreating(ModelBuilder builder)
        {
            builder.Entity<Board>().HasMany(e => e.Threads).WithOne(e => e.Board);
            builder.Entity<Board>().Property(e => e.Name).IsRequired();
            builder.Entity<Board>().Property(e => e.ShorthandName).IsRequired();

            builder.Entity<Thread>().HasMany(e => e.Posts).WithOne(e => e.Thread);
            builder.Entity<Thread>().Property(e => e.BoardId).IsRequired();

            builder.Entity<Post>().Property(e => e.Content).IsRequired();
            builder.Entity<Post>().Property(e => e.ThreadId).IsRequired();
        }
        public override int SaveChanges()
        {
            var changes = from e in this.ChangeTracker.Entries<BaseEntity>()
                where e.State != EntityState.Unchanged
                select e;

            foreach (var change in changes)
            {
                if (change.State == EntityState.Added)
                {
                    change.Entity.CreatedDate = DateTime.UtcNow;
                }
                else if (change.State == EntityState.Modified)
                {
                    change.Entity.EditedDate = DateTime.UtcNow;
                }
            }
            return base.SaveChanges();
        }
    }
}
