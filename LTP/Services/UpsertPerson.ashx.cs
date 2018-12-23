using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Newtonsoft.Json;
using LTP.Models;
using Dapper;
using System.IO;

namespace LTP.Services
{
    /// <summary>
    /// Summary description for UpsertPerson
    /// </summary>
    public class UpsertPerson : IHttpHandler
    {
        private Person _person = new Person();

        public void ProcessRequest(HttpContext context)
        {
            context.Response.ContentType = "application/json";
            string data = new StreamReader(context.Request.InputStream).ReadToEnd();
            _person = JsonConvert.DeserializeObject<Person>(data);
            
            DynamicParameters personDetails = new DynamicParameters();
            personDetails.Add("personId", _person.Id);
            personDetails.Add("firstName", _person.FirstName);
            personDetails.Add("lastName", _person.LastName);
            personDetails.Add("stateId", _person.StateId);
            personDetails.Add("gender", _person.Gender);
            personDetails.Add("dob", _person.DOB);

            DataAccess db = new DataAccess();
            db.UpsertPerson(personDetails);

            context.Response.Write("{\"success\":true}");
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