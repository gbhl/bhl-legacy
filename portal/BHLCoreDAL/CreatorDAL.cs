
#region Using
using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

#endregion Using

namespace MOBOT.BHL.DAL
{
  public partial class CreatorDAL
  {
    public static CustomGenericList<Creator> CreatorSelectAll( SqlConnection sqlConnection, SqlTransaction sqlTransaction )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection(
        CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "CreatorSelectAll", connection, transaction ) )
      {
        using ( CustomSqlHelper<Creator> helper = new CustomSqlHelper<Creator>() )
        {
          CustomGenericList<Creator> list = helper.ExecuteReader( command );
          return list;
        }
      }
    }

    /// <summary>
    /// Select all values from Creator.
    /// </summary>
    /// <param name="sqlConnection">Sql connection or null.</param>
    /// <param name="sqlTransaction">Sql transaction or null.</param>
    /// <returns>Object of type Creator.</returns>
    public CustomGenericList<Creator> CreatorSelectList( SqlConnection sqlConnection, SqlTransaction sqlTransaction )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection(
        CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "CreatorSelectList", connection, transaction ) )
      {
        using ( CustomSqlHelper<Creator> helper = new CustomSqlHelper<Creator>() )
        {
          CustomGenericList<Creator> list = helper.ExecuteReader( command );
          return list;
        }
      }
    }

    public CustomGenericList<Creator> SelectByTitleId( SqlConnection sqlConnection, SqlTransaction sqlTransaction,
      int titleId )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection(
        CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "CreatorSelectByTitleID", connection, transaction,
          CustomSqlHelper.CreateInputParameter( "TitleID", SqlDbType.Int, null, false, titleId ) ) )
      {
        using ( CustomSqlHelper<Creator> helper = new CustomSqlHelper<Creator>() )
        {
          CustomGenericList<Creator> list = helper.ExecuteReader( command );
          return list;
        }
      }
    }

    /// <summary>
    /// Select all Creators associated with title contributed by the specified institution.
    /// </summary>
    /// <param name="sqlConnection">Sql connection or null.</param>
    /// <param name="sqlTransaction">Sql transaction or null.</param>
    /// <returns>Object of type Creator.</returns>
    public CustomGenericList<Creator> CreatorSelectByInstitution(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        string institutionCode,
        string languageCode)
    {
        SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
        SqlTransaction transaction = sqlTransaction;

        using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorSelectByInstitution", connection, transaction,
            CustomSqlHelper.CreateInputParameter("InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode),
            CustomSqlHelper.CreateInputParameter("LanguageCode", SqlDbType.NVarChar, 10, false, languageCode)))
        {
            using (CustomSqlHelper<Creator> helper = new CustomSqlHelper<Creator>())
            {
                CustomGenericList<Creator> list = helper.ExecuteReader(command);
                return list;
            }
        }
    }

    /// <summary>
    /// Select all Creators starting with a certain letter.
    /// </summary>
    /// <param name="sqlConnection">Sql connection or null.</param>
    /// <param name="sqlTransaction">Sql transaction or null.</param>
    /// <returns>Object of type Creator.</returns>
    public CustomGenericList<Creator> CreatorSelectByCreatorNameLike(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        string creatorName,
        string languageCode,
        string includeSecondaryTitles,
        int returnCount)
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "CreatorSelectByCreatorNameLike", connection, transaction,
          CustomSqlHelper.CreateInputParameter("CreatorName", SqlDbType.NVarChar, 255, false, creatorName ),
          CustomSqlHelper.CreateInputParameter("LanguageCode", SqlDbType.NVarChar, 10, false, languageCode),
          CustomSqlHelper.CreateInputParameter("IncludeSecondaryTitles", SqlDbType.Char, 1, false, includeSecondaryTitles),
          CustomSqlHelper.CreateInputParameter("ReturnCount", SqlDbType.Int, null, false, returnCount)))
      {
        using ( CustomSqlHelper<Creator> helper = new CustomSqlHelper<Creator>() )
        {
          CustomGenericList<Creator> list = helper.ExecuteReader( command );
          return list;
        }
      }
    }

    /// <summary>
    /// Select all Creators that start with a certain letter and are associated with
    /// a title contributed by the specified institution.
    /// </summary>
    /// <param name="sqlConnection">Sql connection or null.</param>
    /// <param name="sqlTransaction">Sql transaction or null.</param>
    /// <returns>Object of type Creator.</returns>
    public CustomGenericList<Creator> CreatorSelectByCreatorNameLikeAndInstitution(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        string creatorName,
        string institutionCode,
        string languageCode)
    {
        SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
        SqlTransaction transaction = sqlTransaction;

        using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorSelectByCreatorNameLikeAndInstitution", connection, transaction,
            CustomSqlHelper.CreateInputParameter("CreatorName", SqlDbType.NVarChar, 255, false, creatorName),
            CustomSqlHelper.CreateInputParameter("InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode),
            CustomSqlHelper.CreateInputParameter("LanguageCode", SqlDbType.NVarChar, 10, false, languageCode)))
        {
            using (CustomSqlHelper<Creator> helper = new CustomSqlHelper<Creator>())
            {
                CustomGenericList<Creator> list = helper.ExecuteReader(command);
                return list;
            }
        }
    }

    /// <summary>
    /// Select all Creators starting with a certain letter.
    /// </summary>
    /// <param name="sqlConnection">Sql connection or null.</param>
    /// <param name="sqlTransaction">Sql transaction or null.</param>
    /// <returns>Object of type Creator.</returns>
    public CustomGenericList<Creator> CreatorSelectByCreatorStartsWith(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        string creatorName )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "CreatorSelectNameStartsWith", connection, transaction,
          CustomSqlHelper.CreateInputParameter( "CreatorName", SqlDbType.NVarChar, 255, false, creatorName ) ) )
      {
        using ( CustomSqlHelper<Creator> helper = new CustomSqlHelper<Creator>() )
        {
          CustomGenericList<Creator> list = helper.ExecuteReader( command );
          return list;
        }
      }
    }

    public Creator CreatorSelectByCreatorName(
        SqlConnection sqlConnection,
        SqlTransaction sqlTransaction,
        string creatorName )
    {
      SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
      SqlTransaction transaction = sqlTransaction;

      using ( SqlCommand command = CustomSqlHelper.CreateCommand( "CreatorSelectByCreatorName", connection, transaction,
          CustomSqlHelper.CreateInputParameter( "CreatorName", SqlDbType.NVarChar, 255, false, creatorName ) ) )
      {
        using ( CustomSqlHelper<Creator> helper = new CustomSqlHelper<Creator>() )
        {
          CustomGenericList<Creator> list = helper.ExecuteReader( command );
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

    public static void Save( SqlConnection sqlConnection, SqlTransaction sqlTransaction, Creator creator )
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

        new CreatorDAL().CreatorManageAuto( connection, transaction, creator );

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
    /// Returns a list of creators that have suspected character encoding problems.
    /// </summary>
    /// <param name="sqlConnection"></param>
    /// <param name="sqlTransaction"></param>
    /// <param name="institutionCode">Institution for which to return creators</param>
    /// <param name="maxAge">Age in days of creators to consider (i.e. creators new in the last 30 days)</param>
    /// <returns></returns>
    public CustomGenericList<CreatorSuspectCharacter> CreatorSelectWithSuspectCharacters(
            SqlConnection sqlConnection,
            SqlTransaction sqlTransaction,
            String institutionCode,
            int maxAge)
    {
        SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
        SqlTransaction transaction = sqlTransaction;
        using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorSelectWithSuspectCharacters", connection, transaction,
            CustomSqlHelper.CreateInputParameter("InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode),
            CustomSqlHelper.CreateInputParameter("MaxAge", SqlDbType.Int, null, false, maxAge)))
        {
            using (CustomSqlHelper<CreatorSuspectCharacter> helper = new CustomSqlHelper<CreatorSuspectCharacter>())
            {
                CustomGenericList<CreatorSuspectCharacter> list = helper.ExecuteReader(command);
                return (list);
            }
        }
    }
  }
}
