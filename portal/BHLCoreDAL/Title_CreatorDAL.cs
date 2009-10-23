using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.DAL
{
	public partial class Title_CreatorDAL
	{
		public static CustomGenericList<Title_Creator> Title_CreatorSelectByTitle( SqlConnection sqlConnection,
				SqlTransaction sqlTransaction, int titleID )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( 
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "Title_CreatorSelectByTitle", connection, transaction,
					CustomSqlHelper.CreateInputParameter( "TitleID", SqlDbType.Int, null, false, titleID ) ) )
			{
				using ( CustomSqlHelper<Title_Creator> helper = new CustomSqlHelper<Title_Creator>() )
				{
					CustomGenericList<Title_Creator> list = helper.ExecuteReader( command );
					return list;
				}
			}
		}
	}
}
