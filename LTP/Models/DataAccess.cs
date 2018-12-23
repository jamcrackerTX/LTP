using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using Dapper;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;

namespace LTP.Models
{
    public class DataAccess
    {
        private static readonly string ConnectionString = ConfigurationManager.ConnectionStrings["LTPDataConnection"].ToString();

        public void UpsertPerson(DynamicParameters parameters)
        {
            using (SqlConnection db = new SqlConnection(ConnectionString))
            {
                db.Open();
                db.Execute("uspPersonUpsert", parameters, commandType: CommandType.StoredProcedure);
                db.Close();
            }
        }

        public IEnumerable<State> GetStates()
        {
            using (SqlConnection db = new SqlConnection(ConnectionString))
            {
                db.Open();
                var states = db.Query<State>("uspStatesList", commandType: CommandType.StoredProcedure);
                db.Close();
                return states;
            }
        }

        public IEnumerable<Person> GetPeople(DynamicParameters parameters = null)
        {
            using (SqlConnection db = new SqlConnection(ConnectionString))
            {
                db.Open();
                var people = db.Query<Person>("uspPersonSearch", parameters, commandType: CommandType.StoredProcedure);
                db.Close();
                return people;
            }
        }

        public IEnumerable<Gender> GetGenders()
        {
            List<Gender> genderList = new List<Gender>();
            genderList.Add(new Gender { Value = "M", Name = "Male" });
            genderList.Add(new Gender { Value = "F", Name = "Female" });
            genderList.Add(new Gender { Value = "O", Name = "Other" });

            return genderList;
        }
    }
}