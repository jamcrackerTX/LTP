using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using LTP.Models;
using Dapper;

namespace LTP.Services
{
    /// <summary>
    /// Summary description for GetPeople
    /// </summary>
    public class GetPeople : IHttpHandler
    {

        private List<Person> _people = new List<Person>();

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            string searchQueryString = context.Request["s"];
            DynamicParameters nameQuery = new DynamicParameters();
            if (searchQueryString != null && searchQueryString.Length > 0)
            {
                nameQuery.Add("searchTerm", searchQueryString);
            }

            DataAccess db = new DataAccess();

            _people = db.GetPeople(nameQuery).ToList();

            

            context.Response.Write(JsonConvert.SerializeObject(_people));
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}