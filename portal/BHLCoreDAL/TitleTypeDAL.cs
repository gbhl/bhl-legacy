using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.DAL
{
	public partial class TitleTypeDAL
	{
		public static CustomGenericList<TitleType> SelectAll( SqlConnection sqlConnection, SqlTransaction sqlTransaction )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleTypeSelectAll", connection, transaction ) )
			{
				using ( CustomSqlHelper<TitleType> helper = new CustomSqlHelper<TitleType>() )
				{
					CustomGenericList<TitleType> list = helper.ExecuteReader( command );
					return list;
				}
			}
		}
	}
}
