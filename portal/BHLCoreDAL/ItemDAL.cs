using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.DAL
{
	public partial class ItemDAL
	{
		#region Select methods

		public static Item ItemSelectByBarCodeOrItemID( SqlConnection sqlConnection, SqlTransaction sqlTransaction,
			int? itemId, string barCode )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "ItemSelectByBarCodeOrItemID", connection, transaction,
				CustomSqlHelper.CreateInputParameter( "ItemID", SqlDbType.Int, null, true, itemId ),
				CustomSqlHelper.CreateInputParameter( "BarCode", SqlDbType.NVarChar, 40, true, barCode ) ) )
			{
				using ( CustomSqlHelper<Item> helper = new CustomSqlHelper<Item>() )
				{
					CustomGenericList<Item> list = helper.ExecuteReader( command );
					if ( list.Count > 0 )
					{
						Item item = (Item)list[ 0 ];
						item.Pages = new PageDAL().PageSelectByItemID( connection, transaction, item.ItemID );
                        //item.Titles = new TitleDAL().TitleSelectByItem(connection, transaction, item.ItemID);
                        item.TitleItems = new TitleItemDAL().TitleItemSelectByItem(connection, transaction, item.ItemID);
                        item.ItemLanguages = new ItemLanguageDAL().ItemLanguageSelectByItemID(connection, transaction, item.ItemID);
                        return item;
					}
					else
					{
						return null;
					}
				}
			}
		}

		/// <summary>
		/// Select values from Item by barcode.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="barCode">Unique barcode for Item record.</param>
		/// <returns>Object of type Item.</returns>
		public Item ItemSelectByBarCode(
			SqlConnection sqlConnection,
			SqlTransaction sqlTransaction,
			string barCode )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "ItemSelectByBarCode", connection, transaction,
							CustomSqlHelper.CreateInputParameter( "BarCode", SqlDbType.NVarChar, 40, false, barCode ) ) )
			{
				using ( CustomSqlHelper<Item> helper = new CustomSqlHelper<Item>() )
				{
					CustomGenericList<Item> list = helper.ExecuteReader( command );
					if ( list.Count > 0 )
					{
						return list[ 0 ];
					}
					else
					{
						return null;
					}
				}
			}
		}

		/// <summary>
		/// Select all Items for a particular Title.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <returns>Object of type Title.</returns>
		public static CustomGenericList<Item> ItemSelectByTitleID(
				SqlConnection sqlConnection,
				SqlTransaction sqlTransaction,
				int titleID )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( 
        CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "ItemSelectByTitleID", connection, transaction,
					CustomSqlHelper.CreateInputParameter( "TitleID", SqlDbType.Int, null, false, titleID ) ) )
			{
				using ( CustomSqlHelper<Item> helper = new CustomSqlHelper<Item>() )
				{
					CustomGenericList<Item> list = helper.ExecuteReader( command );
					return ( list );
				}
			}
		}

		// This does not filter on item status
		public static CustomGenericList<Item> ItemSelectByMarcBibId( SqlConnection sqlConnection,	SqlTransaction sqlTransaction,
			string marcBibId)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "ItemSelectByMARCBibID", connection, transaction,
					CustomSqlHelper.CreateInputParameter( "MARCBibID", SqlDbType.NVarChar, 50, false, marcBibId) ) )
			{
				using ( CustomSqlHelper<Item> helper = new CustomSqlHelper<Item>() )
				{
					CustomGenericList<Item> list = helper.ExecuteReader( command );
					return ( list );
				}
			}
		}

		/// <summary>
		/// Select all Items that have expired Page Names.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="maxAge">Maximum age (in days) of Page Names.</param>
		/// <returns>List of objects of type Item.</returns>
		/// <remarks>
		/// Page Names are considered to be expired if the LastPageNameLookupDate on the
		/// Item object is older than the specified number of days.
		/// </remarks>
		public CustomGenericList<Item> ItemSelectWithExpiredPageNames(
				SqlConnection sqlConnection,
				SqlTransaction sqlTransaction,
				int maxAge )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "ItemSelectWithExpiredPageNames", connection, transaction,
					CustomSqlHelper.CreateInputParameter( "MaxAge", SqlDbType.Int, null, false, maxAge ) ) )
			{
				using ( CustomSqlHelper<Item> helper = new CustomSqlHelper<Item>() )
				{
					CustomGenericList<Item> list = helper.ExecuteReader( command );
					return ( list );
				}
			}
		}

		/// <summary>
		/// Select all Items that do not have Page Names.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <returns>List of objects of type Item.</returns>
		/// <remarks>
		/// Items are considered to not have page names if the LastPageNameLookupDate 
		/// is null.
		/// </remarks>
		public CustomGenericList<Item> ItemSelectWithoutPageNames(
				SqlConnection sqlConnection,
				SqlTransaction sqlTransaction )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "ItemSelectWithoutPageNames", connection, transaction ) )
			{
				using ( CustomSqlHelper<Item> helper = new CustomSqlHelper<Item>() )
				{
					CustomGenericList<Item> list = helper.ExecuteReader( command );
					return ( list );
				}
			}
		}

		public static CustomGenericList<Item> ItemSelectPaginationReport( SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( 
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "ItemSelectPaginationReport", connection, transaction ) )
			{
				using ( CustomSqlHelper<Item> helper = new CustomSqlHelper<Item>() )
				{
					CustomGenericList<Item> list = helper.ExecuteReader( command );
					return ( list );
				}
			}
		}

		public static Item ItemSelectPagination( SqlConnection sqlConnection,	SqlTransaction sqlTransaction, int itemId )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "ItemSelectPagination", connection, transaction,
				CustomSqlHelper.CreateInputParameter( "ItemID", SqlDbType.Int, null, false, itemId ) ) )
			{
				using ( CustomSqlHelper<Item> helper = new CustomSqlHelper<Item>() )
				{
					CustomGenericList<Item> list = helper.ExecuteReader( command );
					if ( list == null || list.Count == 0 )
					{
						return null;
					}
					else
					{
						return list[ 0 ];
					}
				}
			}
		}

		#endregion

		/// <summary>
		/// Update the LastPageNameLookupDate for the specified Item.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null</param>
		/// <param name="sqlTransaction">Sql transaction or null</param>
		/// <param name="itemID">Identifier of a specific item</param>
		/// <returns>The updated item</returns>
		public Item ItemUpdateLastPageNameLookupDate( SqlConnection sqlConnection, SqlTransaction sqlTransaction, int itemID )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "ItemUpdateLastPageNameLookupDate", connection,
				transaction,
				CustomSqlHelper.CreateInputParameter( "ItemID", SqlDbType.Int, null, false, itemID ) ) )
			{
				using ( CustomSqlHelper<Item> helper = new CustomSqlHelper<Item>() )
				{
					CustomGenericList<Item> list = helper.ExecuteReader( command );
					if ( list.Count > 0 )
						return list[ 0 ];
					else
						return null;
				}
			}
		}

        public Item ItemUpdatePrimaryTitleID(SqlConnection sqlConnection, SqlTransaction sqlTransaction, int itemID, int titleID)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(
                CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("ItemUpdatePrimaryTitleID", connection, transaction,
                CustomSqlHelper.CreateInputParameter("ItemID", SqlDbType.Int, null, false, itemID),
                CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID)))
            {
                using (CustomSqlHelper<Item> helper = new CustomSqlHelper<Item>())
                {
                    CustomGenericList<Item> list = helper.ExecuteReader(command);
                    if (list.Count > 0)
                        return list[0];
                    else
                        return null;
                }
            }
        }

        public static void Save(SqlConnection sqlConnection, SqlTransaction sqlTransaction, Item item, int userId)
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

				new ItemDAL().ItemManageAuto( connection, transaction, item, userId );

				if ( item.Pages.Count > 0 )
				{
					PageDAL pageDAL = new PageDAL();
					foreach ( Page page in item.Pages )
					{
						pageDAL.PageManageAuto( connection, transaction, page, userId );
					}
				}

                if (item.TitleItems.Count > 0)
                {
                    TitleItemDAL titleItemDAL = new TitleItemDAL();
                    foreach (TitleItem titleItem in item.TitleItems)
                    {
                        titleItemDAL.TitleItemManageAuto(connection, transaction, titleItem);
                    }
                }

                if (item.ItemLanguages.Count > 0)
                {
                    ItemLanguageDAL itemLanguageDAL = new ItemLanguageDAL();
                    foreach (ItemLanguage itemLanguage in item.ItemLanguages)
                    {
                        itemLanguageDAL.ItemLanguageManageAuto(connection, transaction, itemLanguage);
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

        /// <summary>
        /// Select recent values from Item.
        /// </summary>
        /// <param name="sqlConnection">Sql connection or null.</param>
        /// <param name="sqlTransaction">Sql transaction or null.</param>
        /// <param name="top">Number of values to return</param>
        /// <param name="languageCode">Language of items to be included</param>
        /// <param name="institutionCode">Contributing institution of items to be included</param>
        /// <returns>List of objects of type Item.</returns>
        public CustomGenericList<Item> ItemSelectRecent(
            SqlConnection sqlConnection,
            SqlTransaction sqlTransaction,
            int top,
            string languageCode,
            string institutionCode)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("ItemSelectRecent", connection, transaction,
                CustomSqlHelper.CreateInputParameter("Top", SqlDbType.Int, null, false, top),
                CustomSqlHelper.CreateInputParameter("LanguageCode", SqlDbType.NVarChar, 10, false, languageCode),
                CustomSqlHelper.CreateInputParameter("InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode)))
            {
                using (CustomSqlHelper<Item> helper = new CustomSqlHelper<Item>())
                {
                    CustomGenericList<Item> list = helper.ExecuteReader(command);
                    return list;
                }
            }
        }

        /// <summary>
        /// Returns a list of items that have suspected character encoding problems.
        /// </summary>
        /// <param name="sqlConnection"></param>
        /// <param name="sqlTransaction"></param>
        /// <param name="institutionCode">Institution for which to return items</param>
        /// <param name="maxAge">Age in days of items to consider (i.e. items new in the last 30 days)</param>
        /// <returns></returns>
        public CustomGenericList<ItemSuspectCharacter> ItemSelectWithSuspectCharacters(
                SqlConnection sqlConnection,
                SqlTransaction sqlTransaction,
                String institutionCode,
                int maxAge)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;
            using (SqlCommand command = CustomSqlHelper.CreateCommand("ItemSelectWithSuspectCharacters", connection, transaction,
                CustomSqlHelper.CreateInputParameter("InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode),
                CustomSqlHelper.CreateInputParameter("MaxAge", SqlDbType.Int, null, false, maxAge)))
            {
                using (CustomSqlHelper<ItemSuspectCharacter> helper = new CustomSqlHelper<ItemSuspectCharacter>())
                {
                    CustomGenericList<ItemSuspectCharacter> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }
    }
}
