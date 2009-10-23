using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.DAL
{
	public partial class TitleIdentifierDAL
	{
		public CustomGenericList<TitleIdentifier> TitleIdentifierSelectAll( 
            SqlConnection sqlConnection, 
            SqlTransaction sqlTransaction)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleIdentifierSelectAll", connection, transaction))
			{
                using (CustomSqlHelper<TitleIdentifier> helper = new CustomSqlHelper<TitleIdentifier>())
				{
                    CustomGenericList<TitleIdentifier> list = helper.ExecuteReader(command);
					return list;
				}
			}
		}
	}
}
