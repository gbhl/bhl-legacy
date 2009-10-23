using System;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Collections.Generic;
using System.Text;
using CustomDataAccess;

namespace MOBOT.BHL.DAL
{
    public class TransactionController : IDisposable
    {
        private SqlConnection connection;
        private SqlTransaction transaction;

        public TransactionController()
        {
            connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"));
            transaction = null;
        }

        public SqlConnection Connection
        {
            get
            {
                return connection;
            }
        }

        public SqlTransaction Transaction
        {
            get
            {
                return transaction;
            }
        }

        public void BeginTransaction()
        {
            transaction = CustomSqlHelper.BeginTransaction(connection);
        }

        public void RollbackTransaction()
        {
            CustomSqlHelper.RollbackTransaction(transaction);
        }

        public void CommitTransaction()
        {
            CustomSqlHelper.CommitTransaction(transaction);
        }

        #region IDisposable Members

        public void Dispose()
        {
            if (connection != null)
            {
                CustomSqlHelper.CloseConnection(connection);
            }
        }

        #endregion
    }
}
