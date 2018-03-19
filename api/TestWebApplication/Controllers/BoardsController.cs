using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Data.DTO;
using Data.Entities;
using Data.UnitOfWork;
using Microsoft.AspNetCore.Mvc;

namespace TestWebApplication.Controllers
{
    [Route("api/[controller]")]
    public class BoardsController : Controller
    {
        private readonly IUnitOfWork _work;

        public BoardsController(IUnitOfWork work)
        {
            _work = work;
        }

        // GET api/values
        [HttpGet]
        public IActionResult GetAll()
        {
            return Json(_work.BoardRepository.GetAll());
        }
    }
}
