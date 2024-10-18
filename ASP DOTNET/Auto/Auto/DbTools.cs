using System;
using System.Collections.Generic;
using System.Data.SqlClient;
using System.Data;
using System.Linq;
using System.Web;

namespace Auto.App_Code {
    public class DbTools {
        private string connectionString;

        public DbTools(string connectionString) {
            this.connectionString = connectionString;
        }

        public DataTable GetDataTable(string sql) {
            using (SqlConnection sqlConnection = new SqlConnection(connectionString)) {
                using (SqlCommand sqlCommand = new SqlCommand(sql, sqlConnection)) {
                    sqlCommand.CommandType = System.Data.CommandType.Text;
                    using (SqlDataAdapter sqlDataAdapter = new SqlDataAdapter(sqlCommand)) {
                        DataTable dataTable = new DataTable();
                        sqlDataAdapter.Fill(dataTable);
                        return dataTable;
                    }
                }
            }
        }

        public readonly string SelectAllAuto = @"SELECT Targa, Marca, Modello, Alimentazione, Prezzo FROM Auto";
    }
}