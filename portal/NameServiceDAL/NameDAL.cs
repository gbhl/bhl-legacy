using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.Services.NameServiceDataObjects;

namespace MOBOT.Services.NameServiceDAL
{
    public class NameServiceDAL
    {
        public static int PageNameCountUniqueConfirmed(SqlConnection sqlConnection, SqlTransaction sqlTransaction)
        {
            SqlConnection connection = sqlConnection;
            SqlTransaction transaction = sqlTransaction;

            if (connection == null)
            {
                connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"));
            }

            using (SqlCommand command = CustomSqlHelper.CreateCommand("PageNameCountUniqueConfirmed", connection, transaction))
            {
                using (CustomSqlHelper<int> helper = new CustomSqlHelper<int>())
                {
                    CustomGenericList<int> list = helper.ExecuteReader(command);

                    if (list.Count == 0)
                    {
                        return default(int);
                    }
                    else
                    {
                        return list[0];
                    }
                }
            }
        }

        public static int PageNameCountUniqueConfirmedBetweenDates(SqlConnection sqlConnection, SqlTransaction sqlTransaction, 
            DateTime startDate, DateTime endDate)
        {
            SqlConnection connection = sqlConnection;
            SqlTransaction transaction = sqlTransaction;

            if (connection == null)
            {
                connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"));
            }

            using (SqlCommand command = CustomSqlHelper.CreateCommand("PageNameCountUniqueConfirmedBetweenDates", connection, transaction,
                CustomSqlHelper.CreateInputParameter("StartDate", SqlDbType.DateTime, null, false, startDate),
                CustomSqlHelper.CreateInputParameter("EndDate", SqlDbType.DateTime, null, false, endDate)))
            {
                using (CustomSqlHelper<int> helper = new CustomSqlHelper<int>())
                {
                    CustomGenericList<int> list = helper.ExecuteReader(command);

                    if (list.Count == 0)
                    {
                        return default(int);
                    }
                    else
                    {
                        return list[0];
                    }
                }
            }
        }

        public static CustomGenericList<Name> PageNameListActive(SqlConnection sqlConnection, SqlTransaction sqlTransaction,
            int startRow, int batchSize)
        {
            SqlConnection connection = sqlConnection;
            SqlTransaction transaction = sqlTransaction;

            if (connection == null)
            {
                connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"));
            }

            using (SqlCommand command = CustomSqlHelper.CreateCommand("PageNameListActive", connection, transaction,
                CustomSqlHelper.CreateInputParameter("StartRow", SqlDbType.Int, null, false, startRow),
                CustomSqlHelper.CreateInputParameter("BatchSize", SqlDbType.Int, null, false, batchSize)))

            {
                using (CustomSqlHelper<Name> helper = new CustomSqlHelper<Name>())
                {
                    return helper.ExecuteReader(command);
                }
            }
        }

        public static CustomGenericList<Name> PageNameListActiveBetweenDates(SqlConnection sqlConnection, SqlTransaction sqlTransaction,
            int startRow, int batchSize, DateTime startDate, DateTime endDate)
        {
            SqlConnection connection = sqlConnection;
            SqlTransaction transaction = sqlTransaction;

            if (connection == null)
            {
                connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"));
            }

            using (SqlCommand command = CustomSqlHelper.CreateCommand("PageNameListActiveBetweenDates", connection, transaction,
                CustomSqlHelper.CreateInputParameter("StartRow", SqlDbType.Int, null, false, startRow),
                CustomSqlHelper.CreateInputParameter("BatchSize", SqlDbType.Int, null, false, batchSize),
                CustomSqlHelper.CreateInputParameter("StartDate", SqlDbType.DateTime, null, false, startDate),
                CustomSqlHelper.CreateInputParameter("EndDate", SqlDbType.DateTime, null, false, endDate)))
            {
                using (CustomSqlHelper<Name> helper = new CustomSqlHelper<Name>())
                {
                    return helper.ExecuteReader(command);
                }
            }
        }

        public static CustomGenericList<PageDetail> PageSelectByNameBankID(SqlConnection sqlConnection, SqlTransaction sqlTransaction,
            int nameBankID)
        {
            SqlConnection connection = sqlConnection;
            SqlTransaction transaction = sqlTransaction;

            if (connection == null)
            {
                connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"));
            }

            using (SqlCommand command = CustomSqlHelper.CreateCommand("PageSelectByNameBankID", connection, transaction,
                CustomSqlHelper.CreateInputParameter("NameBankID", SqlDbType.Int, null, false, nameBankID)))
            {
                using (CustomSqlHelper<PageDetail> helper = new CustomSqlHelper<PageDetail>())
                {
                    return helper.ExecuteReader(command);
                }
            }
        }

    }
}
