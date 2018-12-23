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
    /// Summary description for GetStates
    /// </summary>
    public class GetStates : IHttpHandler
    {
        private List<State> _states = new List<State>();

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            
            DataAccess db = new DataAccess();

            _states = db.GetStates().ToList();



            context.Response.Write(JsonConvert.SerializeObject(_states));
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