﻿// <auto-generated />
using Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Metadata;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage;
using Microsoft.EntityFrameworkCore.Storage.Internal;
using System;

namespace TestWebApplication.Migrations
{
    [DbContext(typeof(TestContext))]
    [Migration("20180315134755_init")]
    partial class init
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder
                .HasAnnotation("Npgsql:ValueGenerationStrategy", NpgsqlValueGenerationStrategy.SerialColumn)
                .HasAnnotation("ProductVersion", "2.0.2-rtm-10011");

            modelBuilder.Entity("Data.Entities.Board", b =>
                {
                    b.Property<int>("ID")
                        .ValueGeneratedOnAdd();

                    b.Property<string>("Name");

                    b.Property<string>("ShorthandName");

                    b.HasKey("ID");

                    b.ToTable("Boards");
                });

            modelBuilder.Entity("Data.Entities.Post", b =>
                {
                    b.Property<int>("ID")
                        .ValueGeneratedOnAdd();

                    b.Property<string>("Content");

                    b.Property<bool>("IsOp");

                    b.Property<int?>("ThreadID");

                    b.HasKey("ID");

                    b.HasIndex("ThreadID");

                    b.ToTable("Posts");
                });

            modelBuilder.Entity("Data.Entities.Thread", b =>
                {
                    b.Property<int>("ID")
                        .ValueGeneratedOnAdd();

                    b.Property<int?>("BoardID");

                    b.HasKey("ID");

                    b.HasIndex("BoardID");

                    b.ToTable("Threads");
                });

            modelBuilder.Entity("Data.Entities.Post", b =>
                {
                    b.HasOne("Data.Entities.Thread", "Thread")
                        .WithMany("Posts")
                        .HasForeignKey("ThreadID");
                });

            modelBuilder.Entity("Data.Entities.Thread", b =>
                {
                    b.HasOne("Data.Entities.Board", "Board")
                        .WithMany("Threads")
                        .HasForeignKey("BoardID");
                });
#pragma warning restore 612, 618
        }
    }
}
