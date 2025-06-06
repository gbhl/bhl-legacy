using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.DAL
{
	public partial class IndicatedPageDAL
	{
		public bool IndicatedPageInsertNext( SqlConnection sqlConnection, SqlTransaction sqlTransaction, int pageID,
			string pagePrefix, string pageNumber, bool implied, int userId )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "IndicatedPageInsertNext", connection, transaction,
				CustomSqlHelper.CreateInputParameter( "PageID", SqlDbType.Int, null, false, pageID ),
				CustomSqlHelper.CreateInputParameter( "PagePrefix", SqlDbType.NVarChar, 20, true, pagePrefix ),
				CustomSqlHelper.CreateInputParameter( "PageNumber", SqlDbType.NVarChar, 20, true, pageNumber ),
				CustomSqlHelper.CreateInputParameter( "Implied", SqlDbType.Bit, null, false, implied ),
				CustomSqlHelper.CreateInputParameter( "CreationUserID", SqlDbType.Int, null, false, userId ),
				CustomSqlHelper.CreateInputParameter( "LastModifiedUserID", SqlDbType.Int, null, false, userId ),
				CustomSqlHelper.CreateReturnValueParameter( "ReturnCode", SqlDbType.Int, null, false ) ) )
			{
				int returnCode = CustomSqlHelper.ExecuteNonQuery( command, "ReturnCode" );

				if ( transaction == null )
				{
					CustomSqlHelper.CloseConnection( connection );
				}

				if ( returnCode == 0 )
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}

		public bool IndicatedPageDeleteAllForPage( SqlConnection sqlConnection, SqlTransaction sqlTransaction, int pageID )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( 
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			try
			{
				using ( SqlCommand command = 
					CustomSqlHelper.CreateCommand( "IndicatedPageDeleteAllForPage", connection,sqlTransaction,
					CustomSqlHelper.CreateInputParameter( "PageID", SqlDbType.Int, null, false, pageID ),
					CustomSqlHelper.CreateReturnValueParameter( "ReturnCode", SqlDbType.Int, null, false ) ) )
				{
					int returnCode = CustomSqlHelper.ExecuteNonQuery( command, "ReturnCode" );

					if ( transaction == null )
					{
						CustomSqlHelper.CloseConnection( connection );
					}

					if ( returnCode == 0 )
					{
						return true;
					}
					else
					{
						return false;
					}
				}
			}
			catch ( Exception ex )
			{
				throw new Exception( "Exception in IndicatedPageDeleteAllForPage", ex );
			}
		}

    }
}
