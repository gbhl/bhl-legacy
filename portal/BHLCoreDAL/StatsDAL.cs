#region Using

using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;
#endregion Using

namespace MOBOT.BHL.DAL
{
	public partial class StatsDAL
	{
        public Stats StatsSelect(SqlConnection sqlConnection, SqlTransaction sqlTransaction)
        {
            return this.StatsSelect(sqlConnection, sqlTransaction, false, false);
        }

        public Stats StatsSelectExpanded(SqlConnection sqlConnection, SqlTransaction sqlTransaction)
        {
            return this.StatsSelect(sqlConnection, sqlTransaction, true, false);
        }

        public Stats StatsSelectExpandedNames(SqlConnection sqlConnection, SqlTransaction sqlTransaction)
        {
            return this.StatsSelect(sqlConnection, sqlTransaction, true, true);
        }

        /// <summary>
		/// Select all Creators for a BibId.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <returns>Object of type Creator.</returns>
		private Stats StatsSelect(
				SqlConnection sqlConnection,
				SqlTransaction sqlTransaction,
                bool expanded,
                bool names)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( 
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "StatsSelect", connection, transaction,
                CustomSqlHelper.CreateInputParameter("Expanded", SqlDbType.Bit, null, false, expanded),
                CustomSqlHelper.CreateInputParameter("Names", SqlDbType.Bit, null, false, names)))
			{
				CustomGenericList<CustomDataRow> list = CustomSqlHelper.ExecuteReaderAndReturnRows( command );
				CustomDataRow row = list[ 0 ];
				Stats stats = new Stats();
				stats.TitleCount = (int)row[ "TitleCount" ].Value;
				stats.VolumeCount = (int)row[ "VolumeCount" ].Value;
				stats.PageCount = (int)row[ "PageCount" ].Value;
				stats.PageTotal = (int)row[ "PageTotal" ].Value;
				stats.TitleTotal = (int)row[ "TitleTotal" ].Value;
				stats.VolumeTotal = (int)row[ "VolumeTotal" ].Value;
				stats.UniqueCount = (int)row[ "UniqueCount" ].Value;
				stats.UniqueTotal = (int)row[ "UniqueTotal" ].Value;

				return stats;
			}
		}
	}
}
