using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.DAL
{
	public partial class Title_TitleTypeDAL
	{
		public static CustomGenericList<Title_TitleType> SelectByTitle( SqlConnection sqlConnection,
			SqlTransaction sqlTransaction, int titleId )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "Title_TitleTypeSelectByTitle", connection, transaction,
							CustomSqlHelper.CreateInputParameter( "TitleID", SqlDbType.Int, null, false, titleId ) ) )
			{
				using ( CustomSqlHelper<Title_TitleType> helper = new CustomSqlHelper<Title_TitleType>() )
				{
					CustomGenericList<Title_TitleType> list = helper.ExecuteReader( command );
					return list;
				}
			}
		}

	}
}
