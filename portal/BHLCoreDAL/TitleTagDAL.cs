
#region Using

using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

#endregion Using

namespace MOBOT.BHL.DAL
{
	public partial class TitleTagDAL
	{
		public static CustomGenericList<TitleTag> TitleTagSelectLikeTag( SqlConnection sqlConnection,
			SqlTransaction sqlTransaction, 
            string tag, 
            string languageCode, 
            string includeSecondaryTitles, 
            int returnCount )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleTagSelectLikeTag", connection, transaction,
					CustomSqlHelper.CreateInputParameter( "TagText", SqlDbType.NVarChar, 50, false, tag ),
                    CustomSqlHelper.CreateInputParameter( "LanguageCode", SqlDbType.NVarChar, 10, false, languageCode),
                    CustomSqlHelper.CreateInputParameter("IncludeSecondaryTitles", SqlDbType.Char, 1, false, includeSecondaryTitles),
                    CustomSqlHelper.CreateInputParameter("ReturnCount", SqlDbType.Int, null, false, returnCount)))
			{
				using ( CustomSqlHelper<TitleTag> helper = new CustomSqlHelper<TitleTag>() )
				{
					CustomGenericList<TitleTag> list = helper.ExecuteReader( command );
					return list;
				}
			}
		}

		public CustomGenericList<CustomDataRow> TitleTagSelectCountByInstitution( SqlConnection sqlConnection,
			SqlTransaction sqlTransaction, int numberToReturn, string institutionCode, string languageCode )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleTagSelectCountByInstitution", connection,
				transaction,
				CustomSqlHelper.CreateInputParameter( "Number", SqlDbType.Int, null, false, numberToReturn ),
				CustomSqlHelper.CreateInputParameter( "InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode ),
                CustomSqlHelper.CreateInputParameter("LanguageCode", SqlDbType.NVarChar, 10, false, languageCode)))
			{
				CustomGenericList<CustomDataRow> list = CustomSqlHelper.ExecuteReaderAndReturnRows( command );
				return list;
			}
		}

		public CustomGenericList<CustomDataRow> TitleTagSelectNewLocations( SqlConnection sqlConnection,
			SqlTransaction sqlTransaction )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleTagSelectNewLocations", connection, transaction ) )
			{
				return CustomSqlHelper.ExecuteReaderAndReturnRows( command );
			}
		}

		public static CustomGenericList<TitleTag> TitleTagSelectByTitle( SqlConnection sqlConnection, SqlTransaction sqlTransaction,
			int titleId )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleTagSelectByTitleID", connection, transaction,
				CustomSqlHelper.CreateInputParameter( "TitleID", SqlDbType.Int, null, false, titleId ) ) )
			{
				using ( CustomSqlHelper<TitleTag> helper = new CustomSqlHelper<TitleTag>() )
				{
					CustomGenericList<TitleTag> list = helper.ExecuteReader( command );
					return list;
				}
			}
		}

        public static CustomGenericList<TitleTag> TitleTagSelectTagTextByTitle(SqlConnection sqlConnection, SqlTransaction sqlTransaction,
            int titleId)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(
                CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleTagSelectTagTextByTitleID", connection, transaction,
                CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleId)))
            {
                using (CustomSqlHelper<TitleTag> helper = new CustomSqlHelper<TitleTag>())
                {
                    CustomGenericList<TitleTag> list = helper.ExecuteReader(command);
                    return list;
                }
            }
        }

        /// <summary>
        /// Returns a list of title tags that have suspected character encoding problems.
        /// </summary>
        /// <param name="sqlConnection"></param>
        /// <param name="sqlTransaction"></param>
        /// <param name="institutionCode">Institution for which to return title tags</param>
        /// <param name="maxAge">Age in days of title tags to consider (i.e. title tags new in the last 30 days)</param>
        /// <returns></returns>
        public CustomGenericList<TitleTagSuspectCharacter> TitleTagSelectWithSuspectCharacters(
                SqlConnection sqlConnection,
                SqlTransaction sqlTransaction,
                String institutionCode,
                int maxAge)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;
            using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleTagSelectWithSuspectCharacters", connection, transaction,
                CustomSqlHelper.CreateInputParameter("InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode),
                CustomSqlHelper.CreateInputParameter("MaxAge", SqlDbType.Int, null, false, maxAge)))
            {
                using (CustomSqlHelper<TitleTagSuspectCharacter> helper = new CustomSqlHelper<TitleTagSuspectCharacter>())
                {
                    CustomGenericList<TitleTagSuspectCharacter> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }
    }
}
