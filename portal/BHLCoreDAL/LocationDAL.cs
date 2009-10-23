
#region Using

using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

#endregion Using

namespace MOBOT.BHL.DAL
{
	public partial class LocationDAL
	{
        public CustomGenericList<Location> LocationSelectAll(SqlConnection sqlConnection, SqlTransaction sqlTransaction)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("LocationSelectAll", connection, transaction))
            {
                using (CustomSqlHelper<Location> helper = new CustomSqlHelper<Location>())
                {
                    CustomGenericList<Location> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }

        public CustomGenericList<Location> LocationSelectAllValid(SqlConnection sqlConnection, SqlTransaction sqlTransaction)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("LocationSelectAllValid", connection, transaction))
            {
                using (CustomSqlHelper<Location> helper = new CustomSqlHelper<Location>())
                {
                    CustomGenericList<Location> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }

        public CustomGenericList<Location> LocationSelectAllInvalid(SqlConnection sqlConnection, SqlTransaction sqlTransaction)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("LocationSelectAllInvalid", connection, transaction))
            {
                using (CustomSqlHelper<Location> helper = new CustomSqlHelper<Location>())
                {
                    CustomGenericList<Location> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }

        public CustomGenericList<Location> LocationSelectValidByInstitution(SqlConnection sqlConnection, SqlTransaction sqlTransaction, string institutionCode, string languageCode)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("LocationSelectValidByInstitution", connection, transaction,
                CustomSqlHelper.CreateInputParameter("InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode),
                CustomSqlHelper.CreateInputParameter("LanguageCode", SqlDbType.NVarChar, 10, false, languageCode)))
            {
                using (CustomSqlHelper<Location> helper = new CustomSqlHelper<Location>())
                {
                    CustomGenericList<Location> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }

        public void Save(SqlConnection sqlConnection, SqlTransaction sqlTransaction, Location location)
        {
            SqlConnection connection = sqlConnection;
            SqlTransaction transaction = sqlTransaction;

            if (connection == null)
            {
                connection =
                    CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"));
            }

            bool isTransactionCoordinator = CustomSqlHelper.IsTransactionCoordinator(transaction);

            try
            {
                transaction = CustomSqlHelper.BeginTransaction(connection, transaction, isTransactionCoordinator);

                new LocationDAL().LocationManageAuto(connection, transaction, location);

                CustomSqlHelper.CommitTransaction(transaction, isTransactionCoordinator);
            }
            catch (Exception ex)
            {
                CustomSqlHelper.RollbackTransaction(transaction, isTransactionCoordinator);

                throw new Exception("Exception in Save", ex);
            }
            finally
            {
                CustomSqlHelper.CloseConnection(connection, isTransactionCoordinator);
            }
        }
    }
}
