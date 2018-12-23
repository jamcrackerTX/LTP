using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Runtime.Serialization;

namespace LTP.Models
{
    public class Person
    {
        public int? Id { get; set; }
        public string FirstName { get; set; }
        public string LastName { get; set; }
        public int StateId { get; set; }
        public string Gender { get; set; }
        public DateTime DOB { get; set; }
    }

    public class State
    {
        public int Id { get; set; }
        public string Code { get; set; }
    }

    public class Gender
    {
        public string Name { get; set; }
        public string Value { get; set; }
    }
}