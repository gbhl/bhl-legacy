
#region Using

using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

#endregion Using

namespace MOBOT.BHL.DAL
{
	public partial class ConfigurationDAL
	{
        public static Configuration ConfigurationSelectByName(
            SqlConnection sqlConnection, 
            SqlTransaction sqlTransaction,
            String configurationName)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(
              CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("ConfigurationSelectByName", connection, transaction,
                CustomSqlHelper.CreateInputParameter("ConfigurationName", SqlDbType.NVarChar, 50, false, configurationName)))
            {
                using (CustomSqlHelper<Configuration> helper = new CustomSqlHelper<Configuration>())
                {
                    CustomGenericList<Configuration> list = helper.ExecuteReader(command);
                    if (list.Count > 0)
                        return list[0];
                    else
                        return null;
                }
            }
        }
    }
}
