
// Generated 7/30/2008 3:15:22 PM
// Do not modify the contents of this code file.
// This is part of a data access layer. 
// This partial class Title_TitleIdentifierDAL is based upon Title_TitleIdentifier.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// The code file you create must be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DAL
// {
// 		public partial class Title_TitleIdentifierDAL
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
	partial class Title_TitleIdentifierDAL 
	{
 		#region ===== SELECT =====

		/// <summary>
		/// Select values from Title_TitleIdentifier by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="title_TitleIdentifierID"></param>
		/// <returns>Object of type Title_TitleIdentifier.</returns>
		public Title_TitleIdentifier Title_TitleIdentifierSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int title_TitleIdentifierID)
		{
			return Title_TitleIdentifierSelectAuto(	sqlConnection, sqlTransaction, "BHL",	title_TitleIdentifierID );
		}
			
		/// <summary>
		/// Select values from Title_TitleIdentifier by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="title_TitleIdentifierID"></param>
		/// <returns>Object of type Title_TitleIdentifier.</returns>
		public Title_TitleIdentifier Title_TitleIdentifierSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			int title_TitleIdentifierID )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings( connectionKeyName ), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_TitleIdentifierSelectAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("Title_TitleIdentifierID", SqlDbType.Int, null, false, title_TitleIdentifierID)))
			{
				using (CustomSqlHelper<Title_TitleIdentifier> helper = new CustomSqlHelper<Title_TitleIdentifier>())
				{
					CustomGenericList<Title_TitleIdentifier> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Title_TitleIdentifier o = list[0];
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
		/// Select values from Title_TitleIdentifier by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="title_TitleIdentifierID"></param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> Title_TitleIdentifierSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int title_TitleIdentifierID)
		{
			return Title_TitleIdentifierSelectAutoRaw( sqlConnection, sqlTransaction, "BHL", title_TitleIdentifierID );
		}
		
		/// <summary>
		/// Select values from Title_TitleIdentifier by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="title_TitleIdentifierID"></param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> Title_TitleIdentifierSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			int title_TitleIdentifierID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings(connectionKeyName), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_TitleIdentifierSelectAuto", connection, transaction,
				CustomSqlHelper.CreateInputParameter("Title_TitleIdentifierID", SqlDbType.Int, null, false, title_TitleIdentifierID)))
			{
				return CustomSqlHelper.ExecuteReaderAndReturnRows(command);
			}
		}
		
		#endregion ===== SELECT =====
	
 		#region ===== INSERT =====

		/// <summary>
		/// Insert values into Title_TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleID"></param>
		/// <param name="titleIdentifierID"></param>
		/// <param name="identifierValue"></param>
		/// <returns>Object of type Title_TitleIdentifier.</returns>
		public Title_TitleIdentifier Title_TitleIdentifierInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleID,
			int titleIdentifierID,
			string identifierValue)
		{
			return Title_TitleIdentifierInsertAuto( sqlConnection, sqlTransaction, "BHL", titleID, titleIdentifierID, identifierValue );
		}
		
		/// <summary>
		/// Insert values into Title_TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="titleID"></param>
		/// <param name="titleIdentifierID"></param>
		/// <param name="identifierValue"></param>
		/// <returns>Object of type Title_TitleIdentifier.</returns>
		public Title_TitleIdentifier Title_TitleIdentifierInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			int titleID,
			int titleIdentifierID,
			string identifierValue)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings(connectionKeyName), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_TitleIdentifierInsertAuto", connection, transaction, 
				CustomSqlHelper.CreateOutputParameter("Title_TitleIdentifierID", SqlDbType.Int, null, false),
					CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID),
					CustomSqlHelper.CreateInputParameter("TitleIdentifierID", SqlDbType.Int, null, false, titleIdentifierID),
					CustomSqlHelper.CreateInputParameter("IdentifierValue", SqlDbType.NVarChar, 125, false, identifierValue), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<Title_TitleIdentifier> helper = new CustomSqlHelper<Title_TitleIdentifier>())
				{
					CustomGenericList<Title_TitleIdentifier> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Title_TitleIdentifier o = list[0];
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
		/// Insert values into Title_TitleIdentifier. Returns an object of type Title_TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Title_TitleIdentifier.</param>
		/// <returns>Object of type Title_TitleIdentifier.</returns>
		public Title_TitleIdentifier Title_TitleIdentifierInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Title_TitleIdentifier value)
		{
			return Title_TitleIdentifierInsertAuto(sqlConnection, sqlTransaction, "BHL", value);
		}
		
		/// <summary>
		/// Insert values into Title_TitleIdentifier. Returns an object of type Title_TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="value">Object of type Title_TitleIdentifier.</param>
		/// <returns>Object of type Title_TitleIdentifier.</returns>
		public Title_TitleIdentifier Title_TitleIdentifierInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			Title_TitleIdentifier value)
		{
			return Title_TitleIdentifierInsertAuto(sqlConnection, sqlTransaction, connectionKeyName,
				value.TitleID,
				value.TitleIdentifierID,
				value.IdentifierValue);
		}
		
		#endregion ===== INSERT =====

		#region ===== DELETE =====

		/// <summary>
		/// Delete values from Title_TitleIdentifier by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="title_TitleIdentifierID"></param>
		/// <returns>true if successful otherwise false.</returns>
		public bool Title_TitleIdentifierDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int title_TitleIdentifierID)
		{
			return Title_TitleIdentifierDeleteAuto( sqlConnection, sqlTransaction, "BHL", title_TitleIdentifierID );
		}
		
		/// <summary>
		/// Delete values from Title_TitleIdentifier by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="title_TitleIdentifierID"></param>
		/// <returns>true if successful otherwise false.</returns>
		public bool Title_TitleIdentifierDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			int title_TitleIdentifierID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings(connectionKeyName), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_TitleIdentifierDeleteAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("Title_TitleIdentifierID", SqlDbType.Int, null, false, title_TitleIdentifierID), 
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
		/// Update values in Title_TitleIdentifier. Returns an object of type Title_TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="title_TitleIdentifierID"></param>
		/// <param name="titleID"></param>
		/// <param name="titleIdentifierID"></param>
		/// <param name="identifierValue"></param>
		/// <returns>Object of type Title_TitleIdentifier.</returns>
		public Title_TitleIdentifier Title_TitleIdentifierUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int title_TitleIdentifierID,
			int titleID,
			int titleIdentifierID,
			string identifierValue)
		{
			return Title_TitleIdentifierUpdateAuto( sqlConnection, sqlTransaction, "BHL", title_TitleIdentifierID, titleID, titleIdentifierID, identifierValue);
		}
		
		/// <summary>
		/// Update values in Title_TitleIdentifier. Returns an object of type Title_TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="title_TitleIdentifierID"></param>
		/// <param name="titleID"></param>
		/// <param name="titleIdentifierID"></param>
		/// <param name="identifierValue"></param>
		/// <returns>Object of type Title_TitleIdentifier.</returns>
		public Title_TitleIdentifier Title_TitleIdentifierUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			int title_TitleIdentifierID,
			int titleID,
			int titleIdentifierID,
			string identifierValue)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings(connectionKeyName), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_TitleIdentifierUpdateAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("Title_TitleIdentifierID", SqlDbType.Int, null, false, title_TitleIdentifierID),
					CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID),
					CustomSqlHelper.CreateInputParameter("TitleIdentifierID", SqlDbType.Int, null, false, titleIdentifierID),
					CustomSqlHelper.CreateInputParameter("IdentifierValue", SqlDbType.NVarChar, 125, false, identifierValue), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<Title_TitleIdentifier> helper = new CustomSqlHelper<Title_TitleIdentifier>())
				{
					CustomGenericList<Title_TitleIdentifier> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Title_TitleIdentifier o = list[0];
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
		/// Update values in Title_TitleIdentifier. Returns an object of type Title_TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Title_TitleIdentifier.</param>
		/// <returns>Object of type Title_TitleIdentifier.</returns>
		public Title_TitleIdentifier Title_TitleIdentifierUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Title_TitleIdentifier value)
		{
			return Title_TitleIdentifierUpdateAuto(sqlConnection, sqlTransaction, "BHL", value );
		}
		
		/// <summary>
		/// Update values in Title_TitleIdentifier. Returns an object of type Title_TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="value">Object of type Title_TitleIdentifier.</param>
		/// <returns>Object of type Title_TitleIdentifier.</returns>
		public Title_TitleIdentifier Title_TitleIdentifierUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			Title_TitleIdentifier value)
		{
			return Title_TitleIdentifierUpdateAuto(sqlConnection, sqlTransaction, connectionKeyName,
				value.Title_TitleIdentifierID,
				value.TitleID,
				value.TitleIdentifierID,
				value.IdentifierValue);
		}
		
		#endregion ===== UPDATE =====

		#region ===== MANAGE =====
		
		/// <summary>
		/// Manage Title_TitleIdentifier object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in Title_TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Title_TitleIdentifier.</param>
		/// <returns>Object of type CustomDataAccessStatus<Title_TitleIdentifier>.</returns>
		public CustomDataAccessStatus<Title_TitleIdentifier> Title_TitleIdentifierManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Title_TitleIdentifier value  )
		{
			return Title_TitleIdentifierManageAuto( sqlConnection, sqlTransaction, "BHL", value  );
		}
		
		/// <summary>
		/// Manage Title_TitleIdentifier object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in Title_TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="value">Object of type Title_TitleIdentifier.</param>
		/// <returns>Object of type CustomDataAccessStatus<Title_TitleIdentifier>.</returns>
		public CustomDataAccessStatus<Title_TitleIdentifier> Title_TitleIdentifierManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			Title_TitleIdentifier value  )
		{
			if (value.IsNew && !value.IsDeleted)
			{
				
				
				Title_TitleIdentifier returnValue = Title_TitleIdentifierInsertAuto(sqlConnection, sqlTransaction, connectionKeyName,
					value.TitleID,
						value.TitleIdentifierID,
						value.IdentifierValue);
				
				return new CustomDataAccessStatus<Title_TitleIdentifier>(
					CustomDataAccessContext.Insert, 
					true, returnValue);
			}
			else if (!value.IsNew && value.IsDeleted)
			{
				if (Title_TitleIdentifierDeleteAuto(sqlConnection, sqlTransaction, connectionKeyName,
					value.Title_TitleIdentifierID))
				{
				return new CustomDataAccessStatus<Title_TitleIdentifier>(
					CustomDataAccessContext.Delete, 
					true, value);
				}
				else
				{
				return new CustomDataAccessStatus<Title_TitleIdentifier>(
					CustomDataAccessContext.Delete, 
					false, value);
				}
			}
			else if (value.IsDirty && !value.IsDeleted)
			{
				
				Title_TitleIdentifier returnValue = Title_TitleIdentifierUpdateAuto(sqlConnection, sqlTransaction, connectionKeyName,
					value.Title_TitleIdentifierID,
						value.TitleID,
						value.TitleIdentifierID,
						value.IdentifierValue);
					
				return new CustomDataAccessStatus<Title_TitleIdentifier>(
					CustomDataAccessContext.Update, 
					true, returnValue);
			}
			else
			{
				return new CustomDataAccessStatus<Title_TitleIdentifier>(
					CustomDataAccessContext.NA, 
					false, value);
			}
		}
		
		#endregion ===== MANAGE =====

	}	
}
// end of source generation
