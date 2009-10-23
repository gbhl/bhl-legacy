#region using

using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

#endregion using

namespace MOBOT.BHL.DAL
{
  public partial class PageTitleSummaryDAL
  {
    public PageSummaryView PageTitleSummarySelectByTitleId( SqlConnection sqlConnection, SqlTransaction sqlTransaction,
     int titleId )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection(
        CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageTitleSummarySelectByTitleId", connection, transaction,
          CustomSqlHelper.CreateInputParameter( "TitleID", SqlDbType.Int, null, false, titleId ) ) )
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
    /// Select values from PageTitleSummaryView by MARC Bib Id.
    /// </summary>
    /// <param name="sqlConnection">Sql connection or null.</param>
    /// <param name="sqlTransaction">Sql transaction or null.</param>
    /// <param name="bibID"></param>
    /// <returns>Object of type Title.</returns>
    public PageSummaryView PageTitleSummarySelectByBibId(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        string bibID )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "PageTitleSummarySelectByBibId", connection, transaction,
          CustomSqlHelper.CreateInputParameter( "BibID", SqlDbType.VarChar, 50, false, bibID ) ) )
      {
          using (CustomSqlHelper<PageSummaryView> helper = new CustomSqlHelper<PageSummaryView>())
        {
            CustomGenericList<PageSummaryView> list = helper.ExecuteReader(command);
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
  }
}