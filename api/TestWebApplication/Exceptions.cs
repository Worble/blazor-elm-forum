using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace TestWebApplication
{
    public class PostException : Exception
    {
        public PostException()
        {
        }

        public PostException(string message)
            : base(message)
        {
        }

        public PostException(string message, Exception inner)
            : base(message, inner)
        {
        }
    }
}
