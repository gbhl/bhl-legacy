
// Generated 4/30/2008 10:05:00 AM
// Do not modify the contents of this code file.
// This is part of a data access layer. 
// This partial class LocationDAL is based upon Location.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// The code file you create must be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DAL
// {
// 		public partial class LocationDAL
//		{
//		}
// }

#endregion How To Implement

#region using

using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

#endregion using

namespace MOBOT.BHL.DAL
{
	partial class LocationDAL 
	{
 		#region ===== SELECT =====

		/// <summary>
		/// Select values from Location by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="locationName"></param>
		/// <returns>Object of type Location.</returns>
		public Location LocationSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string locationName)
		{
			return LocationSelectAuto(	sqlConnection, sqlTransaction, "BHL",	locationName );
		}
			
		/// <summary>
		/// Select values from Location by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="locationName"></param>
		/// <returns>Object of type Location.</returns>
		public Location LocationSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			string locationName )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings( connectionKeyName ), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("LocationSelectAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("LocationName", SqlDbType.NVarChar, 50, false, locationName)))
			{
				using (CustomSqlHelper<Location> helper = new CustomSqlHelper<Location>())
				{
					CustomGenericList<Location> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Location o = list[0];
						list = null;
						return o;
					}
					else
					{
						return null;
					}
				}
			}
		}
		
		/// <summary>
		/// Select values from Location by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="locationName"></param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> LocationSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string locationName)
		{
			return LocationSelectAutoRaw( sqlConnection, sqlTransaction, "BHL", locationName );
		}
		
		/// <summary>
		/// Select values from Location by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="locationName"></param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> LocationSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			string locationName)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings(connectionKeyName), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("LocationSelectAuto", connection, transaction,
				CustomSqlHelper.CreateInputParameter("LocationName", SqlDbType.NVarChar, 50, false, locationName)))
			{
				return CustomSqlHelper.ExecuteReaderAndReturnRows(command);
			}
		}
		
		#endregion ===== SELECT =====
	
 		#region ===== INSERT =====

		/// <summary>
		/// Insert values into Location.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="locationName"></param>
		/// <param name="latitude"></param>
		/// <param name="longitude"></param>
		/// <param name="nextAttemptDate"></param>
		/// <param name="includeInUI"></param>
		/// <returns>Object of type Location.</returns>
		public Location LocationInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string locationName,
			string latitude,
			string longitude,
			DateTime? nextAttemptDate,
			bool includeInUI)
		{
			return LocationInsertAuto( sqlConnection, sqlTransaction, "BHL", locationName, latitude, longitude, nextAttemptDate, includeInUI );
		}
		
		/// <summary>
		/// Insert values into Location.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="locationName"></param>
		/// <param name="latitude"></param>
		/// <param name="longitude"></param>
		/// <param name="nextAttemptDate"></param>
		/// <param name="includeInUI"></param>
		/// <returns>Object of type Location.</returns>
		public Location LocationInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			string locationName,
			string latitude,
			string longitude,
			DateTime? nextAttemptDate,
			bool includeInUI)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings(connectionKeyName), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("LocationInsertAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("LocationName", SqlDbType.NVarChar, 50, false, locationName),
					CustomSqlHelper.CreateInputParameter("Latitude", SqlDbType.VarChar, 20, true, latitude),
					CustomSqlHelper.CreateInputParameter("Longitude", SqlDbType.VarChar, 20, true, longitude),
					CustomSqlHelper.CreateInputParameter("NextAttemptDate", SqlDbType.DateTime, null, true, nextAttemptDate),
					CustomSqlHelper.CreateInputParameter("IncludeInUI", SqlDbType.Bit, null, false, includeInUI), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<Location> helper = new CustomSqlHelper<Location>())
				{
					CustomGenericList<Location> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Location o = list[0];
						list = null;
						return o;
					}
					else
					{
						return null;
					}
				}
			}
		}

		/// <summary>
		/// Insert values into Location. Returns an object of type Location.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Location.</param>
		/// <returns>Object of type Location.</returns>
		public Location LocationInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Location value)
		{
			return LocationInsertAuto(sqlConnection, sqlTransaction, "BHL", value);
		}
		
		/// <summary>
		/// Insert values into Location. Returns an object of type Location.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="value">Object of type Location.</param>
		/// <returns>Object of type Location.</returns>
		public Location LocationInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			Location value)
		{
			return LocationInsertAuto(sqlConnection, sqlTransaction, connectionKeyName,
				value.LocationName,
				value.Latitude,
				value.Longitude,
				value.NextAttemptDate,
				value.IncludeInUI);
		}
		
		#endregion ===== INSERT =====

		#region ===== DELETE =====

		/// <summary>
		/// Delete values from Location by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="locationName"></param>
		/// <returns>true if successful otherwise false.</returns>
		public bool LocationDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string locationName)
		{
			return LocationDeleteAuto( sqlConnection, sqlTransaction, "BHL", locationName );
		}
		
		/// <summary>
		/// Delete values from Location by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="locationName"></param>
		/// <returns>true if successful otherwise false.</returns>
		public bool LocationDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			string locationName)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings(connectionKeyName), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("LocationDeleteAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("LocationName", SqlDbType.NVarChar, 50, false, locationName), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				int returnCode = CustomSqlHelper.ExecuteNonQuery(command, "ReturnCode");
				
				if (transaction == null)
				{
					CustomSqlHelper.CloseConnection(connection);
				}
				
				if (returnCode == 0)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
		}
		
		#endregion ===== DELETE =====

 		#region ===== UPDATE =====

		/// <summary>
		/// Update values in Location. Returns an object of type Location.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="locationName"></param>
		/// <param name="latitude"></param>
		/// <param name="longitude"></param>
		/// <param name="nextAttemptDate"></param>
		/// <param name="includeInUI"></param>
		/// <returns>Object of type Location.</returns>
		public Location LocationUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string locationName,
			string latitude,
			string longitude,
			DateTime? nextAttemptDate,
			bool includeInUI)
		{
			return LocationUpdateAuto( sqlConnection, sqlTransaction, "BHL", locationName, latitude, longitude, nextAttemptDate, includeInUI);
		}
		
		/// <summary>
		/// Update values in Location. Returns an object of type Location.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="locationName"></param>
		/// <param name="latitude"></param>
		/// <param name="longitude"></param>
		/// <param name="nextAttemptDate"></param>
		/// <param name="includeInUI"></param>
		/// <returns>Object of type Location.</returns>
		public Location LocationUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			string locationName,
			string latitude,
			string longitude,
			DateTime? nextAttemptDate,
			bool includeInUI)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings(connectionKeyName), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("LocationUpdateAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("LocationName", SqlDbType.NVarChar, 50, false, locationName),
					CustomSqlHelper.CreateInputParameter("Latitude", SqlDbType.VarChar, 20, true, latitude),
					CustomSqlHelper.CreateInputParameter("Longitude", SqlDbType.VarChar, 20, true, longitude),
					CustomSqlHelper.CreateInputParameter("NextAttemptDate", SqlDbType.DateTime, null, true, nextAttemptDate),
					CustomSqlHelper.CreateInputParameter("IncludeInUI", SqlDbType.Bit, null, false, includeInUI), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<Location> helper = new CustomSqlHelper<Location>())
				{
					CustomGenericList<Location> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Location o = list[0];
						list = null;
						return o;
					}
					else
					{
						return null;
					}
				}
			}
		}
		
		/// <summary>
		/// Update values in Location. Returns an object of type Location.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Location.</param>
		/// <returns>Object of type Location.</returns>
		public Location LocationUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Location value)
		{
			return LocationUpdateAuto(sqlConnection, sqlTransaction, "BHL", value );
		}
		
		/// <summary>
		/// Update values in Location. Returns an object of type Location.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="value">Object of type Location.</param>
		/// <returns>Object of type Location.</returns>
		public Location LocationUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			Location value)
		{
			return LocationUpdateAuto(sqlConnection, sqlTransaction, connectionKeyName,
				value.LocationName,
				value.Latitude,
				value.Longitude,
				value.NextAttemptDate,
				value.IncludeInUI);
		}
		
		#endregion ===== UPDATE =====

		#region ===== MANAGE =====
		
		/// <summary>
		/// Manage Location object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in Location.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Location.</param>
		/// <returns>Object of type CustomDataAccessStatus<Location>.</returns>
		public CustomDataAccessStatus<Location> LocationManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Location value  )
		{
			return LocationManageAuto( sqlConnection, sqlTransaction, "BHL", value  );
		}
		
		/// <summary>
		/// Manage Location object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in Location.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="value">Object of type Location.</param>
		/// <returns>Object of type CustomDataAccessStatus<Location>.</returns>
		public CustomDataAccessStatus<Location> LocationManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			Location value  )
		{
			if (value.IsNew && !value.IsDeleted)
			{
				
				
				Location returnValue = LocationInsertAuto(sqlConnection, sqlTransaction, connectionKeyName,
					value.LocationName,
						value.Latitude,
						value.Longitude,
						value.NextAttemptDate,
						value.IncludeInUI);
				
				return new CustomDataAccessStatus<Location>(
					CustomDataAccessContext.Insert, 
					true, returnValue);
			}
			else if (!value.IsNew && value.IsDeleted)
			{
				if (LocationDeleteAuto(sqlConnection, sqlTransaction, connectionKeyName,
					value.LocationName))
				{
				return new CustomDataAccessStatus<Location>(
					CustomDataAccessContext.Delete, 
					true, value);
				}
				else
				{
				return new CustomDataAccessStatus<Location>(
					CustomDataAccessContext.Delete, 
					false, value);
				}
			}
			else if (value.IsDirty && !value.IsDeleted)
			{
				
				Location returnValue = LocationUpdateAuto(sqlConnection, sqlTransaction, connectionKeyName,
					value.LocationName,
						value.Latitude,
						value.Longitude,
						value.NextAttemptDate,
						value.IncludeInUI);
					
				return new CustomDataAccessStatus<Location>(
					CustomDataAccessContext.Update, 
					true, returnValue);
			}
			else
			{
				return new CustomDataAccessStatus<Location>(
					CustomDataAccessContext.NA, 
					false, value);
			}
		}
		
		#endregion ===== MANAGE =====

	}	
}
// end of source generation
