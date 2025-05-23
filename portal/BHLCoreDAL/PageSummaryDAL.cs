#region using

using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

#endregion using

namespace MOBOT.BHL.DAL
{
  public partial class PageSummaryDAL
  {
    public PageSummaryView PageSummarySelectByItemId( SqlConnection sqlConnection, SqlTransaction sqlTransaction,
     int itemId )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection( 
        CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageSummarySelectByItemID", connection, transaction,
          CustomSqlHelper.CreateInputParameter( "ItemID", SqlDbType.Int, null, false, itemId ) ) )
      {
        using ( CustomSqlHelper<PageSummaryView> helper = new CustomSqlHelper<PageSummaryView>() )
        {
          CustomGenericList<PageSummaryView> list = helper.ExecuteReader( command );
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

    public CustomGenericList<PageSummaryView> PageSummarySelectForViewerByItemID(SqlConnection sqlConnection, SqlTransaction sqlTransaction,
        int itemId)
    {
        SqlConnection connection = CustomSqlHelper.CreateConnection(
          CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
        SqlTransaction transaction = sqlTransaction;

        using (SqlCommand command = CustomSqlHelper.CreateCommand("PageSummarySelectForViewerByItemID", connection, transaction,
            CustomSqlHelper.CreateInputParameter("ItemID", SqlDbType.Int, null, false, itemId)))
        {
            using (CustomSqlHelper<PageSummaryView> helper = new CustomSqlHelper<PageSummaryView>())
            {
                CustomGenericList<PageSummaryView> list = helper.ExecuteReader(command);
                if (list.Count > 0)
                {
                    return list;
                }
                else
                {
                    return null;
                }
            }
        }
    }

    /// <summary>
    /// Select values from PageSummaryView by Barcode.
    /// </summary>
    /// <param name="sqlConnection">Sql connection or null.</param>
    /// <param name="sqlTransaction">Sql transaction or null.</param>
    /// <param name="barcode"></param>
    /// <returns>Object of type Title.</returns>
    public PageSummaryView PageSummarySelectByBarcode(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        string barcode )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageSummarySelectByBarcode", connection, transaction,
          CustomSqlHelper.CreateInputParameter( "Barcode", SqlDbType.VarChar, 40, false, barcode ) ) )
      {
        using ( CustomSqlHelper<PageSummaryView> helper = new CustomSqlHelper<PageSummaryView>() )
        {
          CustomGenericList<PageSummaryView> list = helper.ExecuteReader( command );
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
    /// Select values from PageSummaryView by Page Id.
    /// </summary>
    /// <param name="sqlConnection">Sql connection or null.</param>
    /// <param name="sqlTransaction">Sql transaction or null.</param>
    /// <param name="pageId"></param>
    /// <returns>Object of type Title.</returns>
    public PageSummaryView PageSummarySelectByPageId(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        int pageId )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageSummarySelectByPageId", connection, transaction,
          CustomSqlHelper.CreateInputParameter( "PageId", SqlDbType.Int, null, false, pageId ) ) )
      {
        using ( CustomSqlHelper<PageSummaryView> helper = new CustomSqlHelper<PageSummaryView>() )
        {
          CustomGenericList<PageSummaryView> list = helper.ExecuteReader( command );
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
    /// Select values from PageSummaryView by File Name Prefix.
    /// </summary>
    /// <param name="sqlConnection">Sql connection or null.</param>
    /// <param name="sqlTransaction">Sql transaction or null.</param>
    /// <param name="prefix"></param>
    /// <returns>Object of type Title.</returns>
    public PageSummaryView PageSummarySelectByPrefix(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        string prefix )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageSummarySelectByPrefix", connection, transaction,
          CustomSqlHelper.CreateInputParameter( "Prefix", SqlDbType.VarChar, 50, false, prefix ) ) )
      {
        using ( CustomSqlHelper<PageSummaryView> helper = new CustomSqlHelper<PageSummaryView>() )
        {
          CustomGenericList<PageSummaryView> list = helper.ExecuteReader( command );
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
    /// Select values from PageSummaryView by File Name Prefix.
    /// </summary>
    /// <param name="sqlConnection">Sql connection or null.</param>
    /// <param name="sqlTransaction">Sql transaction or null.</param>
    /// <param name="prefixList"></param>
    /// <returns>Object of type Title.</returns>
    public CustomGenericList<PageSummaryView> PageSummarySelectByPrefixList(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        string prefixList )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageSummarySelectByPrefixes", connection, transaction,
          CustomSqlHelper.CreateInputParameter( "Prefixes", SqlDbType.Text, 1073741823, false, prefixList ) ) )
      {
        using ( CustomSqlHelper<PageSummaryView> helper = new CustomSqlHelper<PageSummaryView>() )
        {
          CustomGenericList<PageSummaryView> list = helper.ExecuteReader( command );
          return list;
        }
      }
    }

    /// <summary>
    /// Select values from PageSummaryView by Item and Sequence
    /// </summary>
    /// <param name="sqlConnection">Sql connection or null.</param>
    /// <param name="sqlTransaction">Sql transaction or null.</param>
    /// <param name="itemID"></param>
    /// <param name="sequence"></param>
    /// <returns>Object of type Title.</returns>
    public PageSummaryView PageSummarySelectByItemAndSequence(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        int itemID,
        int sequence )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageSummarySelectByItemAndSequence", connection, transaction,
          CustomSqlHelper.CreateInputParameter( "ItemID", SqlDbType.Int, null, false, itemID ),
          CustomSqlHelper.CreateInputParameter( "Sequence", SqlDbType.Int, null, false, sequence ) ) )
      {
        using ( CustomSqlHelper<PageSummaryView> helper = new CustomSqlHelper<PageSummaryView>() )
        {
          CustomGenericList<PageSummaryView> list = helper.ExecuteReader( command );
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

    public CustomGenericList<PageSummaryView> PageSummarySelectBarcodeForTitleID(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        int titleID)
    {
        SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
        SqlTransaction transaction = sqlTransaction;

        using (SqlCommand command = CustomSqlHelper.CreateCommand("PageSummarySelectBarcodeForTitleID", connection, transaction,
            CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID)))
        {
            using (CustomSqlHelper<PageSummaryView> helper = new CustomSqlHelper<PageSummaryView>())
            {
                CustomGenericList<PageSummaryView> list = helper.ExecuteReader(command);
                return list;
            }
        }
    }

    public CustomGenericList<PageSummaryView> PageSummarySelectFoldersForTitleID(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        int titleID)
    {
        SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
        SqlTransaction transaction = sqlTransaction;

        using (SqlCommand command = CustomSqlHelper.CreateCommand("PageSummarySelectFoldersForTitleID", connection, transaction,
            CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID)))
        {
            using (CustomSqlHelper<PageSummaryView> helper = new CustomSqlHelper<PageSummaryView>())
            {
                CustomGenericList<PageSummaryView> list = helper.ExecuteReader(command);
                return list;
            }
        }
    }
  }
}