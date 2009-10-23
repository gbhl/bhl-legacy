using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.DAL
{
	public partial class Title_TitleIdentifierDAL
	{
		public CustomGenericList<Title_TitleIdentifier> Title_TitleIdentifierSelectByTitleID( 
            SqlConnection sqlConnection, 
            SqlTransaction sqlTransaction,
            int titleID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_TitleIdentifierSelectByTitleID", connection, transaction,
                CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID)))
			{
                using (CustomSqlHelper<Title_TitleIdentifier> helper = new CustomSqlHelper<Title_TitleIdentifier>())
				{
                    CustomGenericList<Title_TitleIdentifier> list = helper.ExecuteReader(command);
					return list;
				}
			}
		}

        public Title_TitleIdentifier Title_TitleIdentifierSelectByIdentifierValue(
            SqlConnection sqlConnection,
            SqlTransaction sqlTransaction,
            string identifierValue)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(
                CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_TitleIdentifierSelectByIdentifierValue", connection, transaction,
                CustomSqlHelper.CreateInputParameter("IdentifierValue", SqlDbType.NVarChar, 125, false, identifierValue)))
            {
                using (CustomSqlHelper<Title_TitleIdentifier> helper = new CustomSqlHelper<Title_TitleIdentifier>())
                {
                    CustomGenericList<Title_TitleIdentifier> list = helper.ExecuteReader(command);
                    if (list.Count > 0)
                        return list[0];
                    else
                        return null;
                }
            }
        }
    }
}
