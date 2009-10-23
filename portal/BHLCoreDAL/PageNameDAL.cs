
#region Using

using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

#endregion Using

namespace MOBOT.BHL.DAL
{
	public partial class PageNameDAL
	{
		public PageName PageNameSelectByPageIDAndNameFound( SqlConnection sqlConnection, SqlTransaction sqlTransaction, int pageID, string nameFound )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageNameSelectByPageIDAndNameFound", connection, transaction,
					CustomSqlHelper.CreateInputParameter( "PageID", SqlDbType.Int, null, false, pageID ),
					CustomSqlHelper.CreateInputParameter( "NameFound", SqlDbType.NVarChar, 100, false, nameFound ) ) )
			{
				using ( CustomSqlHelper<PageName> helper = new CustomSqlHelper<PageName>() )
				{
					CustomGenericList<PageName> list = helper.ExecuteReader( command );
					if ( list.Count > 0 )
						return list[ 0 ];
					else
						return null;
				}
			}
		}

		public CustomGenericList<PageName> PageNameSelectByPageID( SqlConnection sqlConnection, SqlTransaction sqlTransaction, int pageID )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageNameSelectByPageID", connection, transaction,
					CustomSqlHelper.CreateInputParameter( "PageID", SqlDbType.Int, null, false, pageID ) ) )
			{
				using ( CustomSqlHelper<PageName> helper = new CustomSqlHelper<PageName>() )
				{
					return helper.ExecuteReader( command );
				}
			}
		}

		public PageName PageNameSelectByNameBankID( SqlConnection sqlConnection, SqlTransaction sqlTransaction, int nameBankID )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageNameSelectByNameBankID", connection, transaction,
					CustomSqlHelper.CreateInputParameter( "NameBankID", SqlDbType.Int, null, false, nameBankID ) ) )
			{
				using ( CustomSqlHelper<PageName> helper = new CustomSqlHelper<PageName>() )
				{
					CustomGenericList<PageName> list = helper.ExecuteReader( command );
					if ( list.Count > 0 )
						return list[ 0 ];
					else
						return null;
				}
			}
		}

		public CustomGenericList<CustomDataRow> PageNameSearch( SqlConnection sqlConnection, SqlTransaction sqlTransaction,
			string name, int titleID, string languageCode )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageNameSearch", connection, transaction,
				CustomSqlHelper.CreateInputParameter( "NameConfirmed", SqlDbType.NVarChar, 100, false, name ),
                CustomSqlHelper.CreateInputParameter( "TitleID", SqlDbType.Int, null, false, titleID),
                CustomSqlHelper.CreateInputParameter( "LanguageCode", SqlDbType.NVarChar, 10, false, languageCode)))
			{
				CustomGenericList<CustomDataRow> list = CustomSqlHelper.ExecuteReaderAndReturnRows( command );
				return list;
			}
		}

        public CustomGenericList<CustomDataRow> PageNameSearchForTitles( SqlConnection sqlConnection,
            SqlTransaction sqlTransaction, string name, string languageCode )
        {
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageNameSearchForTitles", connection, transaction,
				CustomSqlHelper.CreateInputParameter( "NameConfirmed", SqlDbType.NVarChar, 100, false, name ),
				CustomSqlHelper.CreateInputParameter( "LanguageCode", SqlDbType.NVarChar, 10, false, languageCode)))
			{
				CustomGenericList<CustomDataRow> list = CustomSqlHelper.ExecuteReaderAndReturnRows( command );
				return list;
			}
        }

		public CustomGenericList<CustomDataRow> PageNameSearchByPageType( SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, string name, int pageTypeId, string languageCode )
		{
			if ( pageTypeId == 0 )
			{
				return PageNameSearch( sqlConnection, sqlTransaction, name, 0, languageCode );
			}
			else
			{
				SqlConnection connection = CustomSqlHelper.CreateConnection(
					CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
				SqlTransaction transaction = sqlTransaction;

				using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageNameSearchByPageType", connection, transaction,
					CustomSqlHelper.CreateInputParameter( "NameConfirmed", SqlDbType.NVarChar, 100, false, name ),
					CustomSqlHelper.CreateInputParameter( "PageTypeID", SqlDbType.Int, null, false, pageTypeId ),
                    CustomSqlHelper.CreateInputParameter( "LanguageCode", SqlDbType.NVarChar, 10, false, languageCode)))
				{
					CustomGenericList<CustomDataRow> list = CustomSqlHelper.ExecuteReaderAndReturnRows( command );
					return list;
				}
			}
		}

        public CustomGenericList<CustomDataRow> PageNameSearchByPageTypeAndTitle(SqlConnection sqlConnection,
            SqlTransaction sqlTransaction, string name, int pageTypeId, int titleID, string languageCode)
        {
            if (pageTypeId == 0)
            {
                return PageNameSearch(sqlConnection, sqlTransaction, name, titleID, languageCode);
            }
            else
            {
                SqlConnection connection = CustomSqlHelper.CreateConnection(
                    CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
                SqlTransaction transaction = sqlTransaction;

                using (SqlCommand command = CustomSqlHelper.CreateCommand("PageNameSearchByPageTypeAndTitle", connection, transaction,
                    CustomSqlHelper.CreateInputParameter("NameConfirmed", SqlDbType.NVarChar, 100, false, name),
                    CustomSqlHelper.CreateInputParameter("PageTypeID", SqlDbType.Int, null, false, pageTypeId),
                    CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID),
                    CustomSqlHelper.CreateInputParameter("LanguageCode", SqlDbType.NVarChar, 10, false, languageCode)))
                {
                    CustomGenericList<CustomDataRow> list = CustomSqlHelper.ExecuteReaderAndReturnRows(command);
                    return list;
                }
            }
        }

        public static CustomGenericList<NameCloud> PageNameSelectTop(SqlConnection sqlConnection,
			SqlTransaction sqlTransaction, int top )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageNameSelectTop", connection, transaction,
				CustomSqlHelper.CreateInputParameter( "Number", SqlDbType.Int, null, false, top ) ) )
			{
				using ( CustomSqlHelper<NameCloud> helper = new CustomSqlHelper<NameCloud>() )
				{
					return helper.ExecuteReader( command );
				}
			}
		}

		public CustomGenericList<PageName> PageNameSelectByNameLike( SqlConnection sqlConnection,
			SqlTransaction sqlTransaction, string name, string languageCode, int returnCount )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageNameSelectByNameLike", connection, transaction,
				CustomSqlHelper.CreateInputParameter( "NameConfirmed", SqlDbType.NVarChar, 100, false, name ),
                CustomSqlHelper.CreateInputParameter( "LanguageCode", SqlDbType.NVarChar, 10, false, languageCode),
                CustomSqlHelper.CreateInputParameter( "ReturnCount", SqlDbType.Int, null, false, returnCount)))
			{
				using ( CustomSqlHelper<PageName> helper = new CustomSqlHelper<PageName>() )
				{
					return helper.ExecuteReader( command );
				}
			}
		}

		public CustomGenericList<PageName> PageNameSelectByConfirmedName( SqlConnection sqlConnection,
			SqlTransaction sqlTransaction, string name, string languageCode )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageNameSelectByConfirmedName", connection, transaction,
				CustomSqlHelper.CreateInputParameter( "NameConfirmed", SqlDbType.NVarChar, 100, false, name ),
                CustomSqlHelper.CreateInputParameter( "LanguageCode", SqlDbType.NVarChar, 10, false, languageCode)))
			{
				using ( CustomSqlHelper<PageName> helper = new CustomSqlHelper<PageName>() )
				{
					return helper.ExecuteReader( command );
				}
			}
		}

		public static void SaveList( SqlConnection sqlConnection, SqlTransaction sqlTransaction,
	CustomGenericList<PageName> pageNames )
		{
			SqlConnection connection = sqlConnection;
			SqlTransaction transaction = sqlTransaction;

			if ( connection == null )
			{
				connection =
					CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ) );
			}

			bool isTransactionCoordinator = CustomSqlHelper.IsTransactionCoordinator( transaction );

			try
			{
				transaction = CustomSqlHelper.BeginTransaction( connection, transaction, isTransactionCoordinator );

				if ( pageNames.Count > 0 )
				{
					PageNameDAL pageNameDAL = new PageNameDAL();
					foreach ( PageName pageName in pageNames )
					{
						pageNameDAL.PageNameManageAuto( connection, transaction, pageName );
					}
				}

				CustomSqlHelper.CommitTransaction( transaction, isTransactionCoordinator );
			}
			catch ( Exception ex )
			{
				CustomSqlHelper.RollbackTransaction( transaction, isTransactionCoordinator );

				throw new Exception( "Exception in Save", ex );
			}
			finally
			{
				CustomSqlHelper.CloseConnection( connection, isTransactionCoordinator );
			}
		}
	}
}
