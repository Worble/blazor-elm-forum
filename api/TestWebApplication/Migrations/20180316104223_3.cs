using Microsoft.EntityFrameworkCore.Migrations;
using System;
using System.Collections.Generic;

namespace TestWebApplication.Migrations
{
    public partial class _3 : Migration
    {
        protected override void Up(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Posts_Threads_ThreadID",
                table: "Posts");

            migrationBuilder.DropForeignKey(
                name: "FK_Threads_Boards_BoardID",
                table: "Threads");

            migrationBuilder.AlterColumn<int>(
                name: "BoardID",
                table: "Threads",
                nullable: false,
                oldClrType: typeof(int),
                oldNullable: true);

            migrationBuilder.AlterColumn<int>(
                name: "ThreadID",
                table: "Posts",
                nullable: false,
                oldClrType: typeof(int),
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Content",
                table: "Posts",
                nullable: false,
                oldClrType: typeof(string),
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "ShorthandName",
                table: "Boards",
                nullable: false,
                oldClrType: typeof(string),
                oldNullable: true);

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Boards",
                nullable: false,
                oldClrType: typeof(string),
                oldNullable: true);

            migrationBuilder.AddForeignKey(
                name: "FK_Posts_Threads_ThreadID",
                table: "Posts",
                column: "ThreadID",
                principalTable: "Threads",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);

            migrationBuilder.AddForeignKey(
                name: "FK_Threads_Boards_BoardID",
                table: "Threads",
                column: "BoardID",
                principalTable: "Boards",
                principalColumn: "ID",
                onDelete: ReferentialAction.Cascade);
        }

        protected override void Down(MigrationBuilder migrationBuilder)
        {
            migrationBuilder.DropForeignKey(
                name: "FK_Posts_Threads_ThreadID",
                table: "Posts");

            migrationBuilder.DropForeignKey(
                name: "FK_Threads_Boards_BoardID",
                table: "Threads");

            migrationBuilder.AlterColumn<int>(
                name: "BoardID",
                table: "Threads",
                nullable: true,
                oldClrType: typeof(int));

            migrationBuilder.AlterColumn<int>(
                name: "ThreadID",
                table: "Posts",
                nullable: true,
                oldClrType: typeof(int));

            migrationBuilder.AlterColumn<string>(
                name: "Content",
                table: "Posts",
                nullable: true,
                oldClrType: typeof(string));

            migrationBuilder.AlterColumn<string>(
                name: "ShorthandName",
                table: "Boards",
                nullable: true,
                oldClrType: typeof(string));

            migrationBuilder.AlterColumn<string>(
                name: "Name",
                table: "Boards",
                nullable: true,
                oldClrType: typeof(string));

            migrationBuilder.AddForeignKey(
                name: "FK_Posts_Threads_ThreadID",
                table: "Posts",
                column: "ThreadID",
                principalTable: "Threads",
                principalColumn: "ID",
                onDelete: ReferentialAction.Restrict);

            migrationBuilder.AddForeignKey(
                name: "FK_Threads_Boards_BoardID",
                table: "Threads",
                column: "BoardID",
                principalTable: "Boards",
                principalColumn: "ID",
                onDelete: ReferentialAction.Restrict);
        }
    }
}
