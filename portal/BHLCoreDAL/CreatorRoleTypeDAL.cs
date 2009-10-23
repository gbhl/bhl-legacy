using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.DAL
{
	public partial class CreatorRoleTypeDAL
	{
		public static CustomGenericList<CreatorRoleType> CreatorRoleTypeSelectAll( SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "CreatorRoleTypeSelectAll", connection, transaction ) )
			{
				using ( CustomSqlHelper<CreatorRoleType> helper = new CustomSqlHelper<CreatorRoleType>() )
				{
					CustomGenericList<CreatorRoleType> list = helper.ExecuteReader( command );
					return list;
				}
			}
		}
	}
}
