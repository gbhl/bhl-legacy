
// Generated 5/6/2009 3:30:24 PM
// Do not modify the contents of this code file.
// This is part of a data access layer. 
// This partial class TitleIdentifierDAL is based upon TitleIdentifier.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// The code file you create must be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DAL
// {
// 		public partial class TitleIdentifierDAL
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
	partial class TitleIdentifierDAL 
	{
 		#region ===== SELECT =====

		/// <summary>
		/// Select values from TitleIdentifier by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleIdentifierID"></param>
		/// <returns>Object of type TitleIdentifier.</returns>
		public TitleIdentifier TitleIdentifierSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleIdentifierID)
		{
			return TitleIdentifierSelectAuto(	sqlConnection, sqlTransaction, "BHL",	titleIdentifierID );
		}
			
		/// <summary>
		/// Select values from TitleIdentifier by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="titleIdentifierID"></param>
		/// <returns>Object of type TitleIdentifier.</returns>
		public TitleIdentifier TitleIdentifierSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			int titleIdentifierID )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings( connectionKeyName ), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleIdentifierSelectAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("TitleIdentifierID", SqlDbType.Int, null, false, titleIdentifierID)))
			{
				using (CustomSqlHelper<TitleIdentifier> helper = new CustomSqlHelper<TitleIdentifier>())
				{
					CustomGenericList<TitleIdentifier> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						TitleIdentifier o = list[0];
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
		/// Select values from TitleIdentifier by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleIdentifierID"></param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> TitleIdentifierSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleIdentifierID)
		{
			return TitleIdentifierSelectAutoRaw( sqlConnection, sqlTransaction, "BHL", titleIdentifierID );
		}
		
		/// <summary>
		/// Select values from TitleIdentifier by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="titleIdentifierID"></param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> TitleIdentifierSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			int titleIdentifierID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings(connectionKeyName), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleIdentifierSelectAuto", connection, transaction,
				CustomSqlHelper.CreateInputParameter("TitleIdentifierID", SqlDbType.Int, null, false, titleIdentifierID)))
			{
				return CustomSqlHelper.ExecuteReaderAndReturnRows(command);
			}
		}
		
		#endregion ===== SELECT =====
	
 		#region ===== INSERT =====

		/// <summary>
		/// Insert values into TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="identifierName"></param>
		/// <param name="marcDataFieldTag"></param>
		/// <param name="marcSubFieldCode"></param>
		/// <returns>Object of type TitleIdentifier.</returns>
		public TitleIdentifier TitleIdentifierInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string identifierName,
			string marcDataFieldTag,
			string marcSubFieldCode)
		{
			return TitleIdentifierInsertAuto( sqlConnection, sqlTransaction, "BHL", identifierName, marcDataFieldTag, marcSubFieldCode );
		}
		
		/// <summary>
		/// Insert values into TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="identifierName"></param>
		/// <param name="marcDataFieldTag"></param>
		/// <param name="marcSubFieldCode"></param>
		/// <returns>Object of type TitleIdentifier.</returns>
		public TitleIdentifier TitleIdentifierInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			string identifierName,
			string marcDataFieldTag,
			string marcSubFieldCode)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings(connectionKeyName), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleIdentifierInsertAuto", connection, transaction, 
				CustomSqlHelper.CreateOutputParameter("TitleIdentifierID", SqlDbType.Int, null, false),
					CustomSqlHelper.CreateInputParameter("IdentifierName", SqlDbType.NVarChar, 40, false, identifierName),
					CustomSqlHelper.CreateInputParameter("MarcDataFieldTag", SqlDbType.NVarChar, 50, false, marcDataFieldTag),
					CustomSqlHelper.CreateInputParameter("MarcSubFieldCode", SqlDbType.NVarChar, 50, false, marcSubFieldCode), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<TitleIdentifier> helper = new CustomSqlHelper<TitleIdentifier>())
				{
					CustomGenericList<TitleIdentifier> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						TitleIdentifier o = list[0];
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
		/// Insert values into TitleIdentifier. Returns an object of type TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type TitleIdentifier.</param>
		/// <returns>Object of type TitleIdentifier.</returns>
		public TitleIdentifier TitleIdentifierInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			TitleIdentifier value)
		{
			return TitleIdentifierInsertAuto(sqlConnection, sqlTransaction, "BHL", value);
		}
		
		/// <summary>
		/// Insert values into TitleIdentifier. Returns an object of type TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="value">Object of type TitleIdentifier.</param>
		/// <returns>Object of type TitleIdentifier.</returns>
		public TitleIdentifier TitleIdentifierInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			TitleIdentifier value)
		{
			return TitleIdentifierInsertAuto(sqlConnection, sqlTransaction, connectionKeyName,
				value.IdentifierName,
				value.MarcDataFieldTag,
				value.MarcSubFieldCode);
		}
		
		#endregion ===== INSERT =====

		#region ===== DELETE =====

		/// <summary>
		/// Delete values from TitleIdentifier by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleIdentifierID"></param>
		/// <returns>true if successful otherwise false.</returns>
		public bool TitleIdentifierDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleIdentifierID)
		{
			return TitleIdentifierDeleteAuto( sqlConnection, sqlTransaction, "BHL", titleIdentifierID );
		}
		
		/// <summary>
		/// Delete values from TitleIdentifier by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="titleIdentifierID"></param>
		/// <returns>true if successful otherwise false.</returns>
		public bool TitleIdentifierDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			int titleIdentifierID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings(connectionKeyName), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleIdentifierDeleteAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("TitleIdentifierID", SqlDbType.Int, null, false, titleIdentifierID), 
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
		/// Update values in TitleIdentifier. Returns an object of type TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleIdentifierID"></param>
		/// <param name="identifierName"></param>
		/// <param name="marcDataFieldTag"></param>
		/// <param name="marcSubFieldCode"></param>
		/// <returns>Object of type TitleIdentifier.</returns>
		public TitleIdentifier TitleIdentifierUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleIdentifierID,
			string identifierName,
			string marcDataFieldTag,
			string marcSubFieldCode)
		{
			return TitleIdentifierUpdateAuto( sqlConnection, sqlTransaction, "BHL", titleIdentifierID, identifierName, marcDataFieldTag, marcSubFieldCode);
		}
		
		/// <summary>
		/// Update values in TitleIdentifier. Returns an object of type TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="titleIdentifierID"></param>
		/// <param name="identifierName"></param>
		/// <param name="marcDataFieldTag"></param>
		/// <param name="marcSubFieldCode"></param>
		/// <returns>Object of type TitleIdentifier.</returns>
		public TitleIdentifier TitleIdentifierUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			int titleIdentifierID,
			string identifierName,
			string marcDataFieldTag,
			string marcSubFieldCode)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings(connectionKeyName), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleIdentifierUpdateAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("TitleIdentifierID", SqlDbType.Int, null, false, titleIdentifierID),
					CustomSqlHelper.CreateInputParameter("IdentifierName", SqlDbType.NVarChar, 40, false, identifierName),
					CustomSqlHelper.CreateInputParameter("MarcDataFieldTag", SqlDbType.NVarChar, 50, false, marcDataFieldTag),
					CustomSqlHelper.CreateInputParameter("MarcSubFieldCode", SqlDbType.NVarChar, 50, false, marcSubFieldCode), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<TitleIdentifier> helper = new CustomSqlHelper<TitleIdentifier>())
				{
					CustomGenericList<TitleIdentifier> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						TitleIdentifier o = list[0];
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
		/// Update values in TitleIdentifier. Returns an object of type TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type TitleIdentifier.</param>
		/// <returns>Object of type TitleIdentifier.</returns>
		public TitleIdentifier TitleIdentifierUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			TitleIdentifier value)
		{
			return TitleIdentifierUpdateAuto(sqlConnection, sqlTransaction, "BHL", value );
		}
		
		/// <summary>
		/// Update values in TitleIdentifier. Returns an object of type TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="value">Object of type TitleIdentifier.</param>
		/// <returns>Object of type TitleIdentifier.</returns>
		public TitleIdentifier TitleIdentifierUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			TitleIdentifier value)
		{
			return TitleIdentifierUpdateAuto(sqlConnection, sqlTransaction, connectionKeyName,
				value.TitleIdentifierID,
				value.IdentifierName,
				value.MarcDataFieldTag,
				value.MarcSubFieldCode);
		}
		
		#endregion ===== UPDATE =====

		#region ===== MANAGE =====
		
		/// <summary>
		/// Manage TitleIdentifier object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type TitleIdentifier.</param>
		/// <returns>Object of type CustomDataAccessStatus<TitleIdentifier>.</returns>
		public CustomDataAccessStatus<TitleIdentifier> TitleIdentifierManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			TitleIdentifier value  )
		{
			return TitleIdentifierManageAuto( sqlConnection, sqlTransaction, "BHL", value  );
		}
		
		/// <summary>
		/// Manage TitleIdentifier object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in TitleIdentifier.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="connectionKeyName">Connection key name located in config file.</param>
		/// <param name="value">Object of type TitleIdentifier.</param>
		/// <returns>Object of type CustomDataAccessStatus<TitleIdentifier>.</returns>
		public CustomDataAccessStatus<TitleIdentifier> TitleIdentifierManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string connectionKeyName,
			TitleIdentifier value  )
		{
			if (value.IsNew && !value.IsDeleted)
			{
				
				
				TitleIdentifier returnValue = TitleIdentifierInsertAuto(sqlConnection, sqlTransaction, connectionKeyName,
					value.IdentifierName,
						value.MarcDataFieldTag,
						value.MarcSubFieldCode);
				
				return new CustomDataAccessStatus<TitleIdentifier>(
					CustomDataAccessContext.Insert, 
					true, returnValue);
			}
			else if (!value.IsNew && value.IsDeleted)
			{
				if (TitleIdentifierDeleteAuto(sqlConnection, sqlTransaction, connectionKeyName,
					value.TitleIdentifierID))
				{
				return new CustomDataAccessStatus<TitleIdentifier>(
					CustomDataAccessContext.Delete, 
					true, value);
				}
				else
				{
				return new CustomDataAccessStatus<TitleIdentifier>(
					CustomDataAccessContext.Delete, 
					false, value);
				}
			}
			else if (value.IsDirty && !value.IsDeleted)
			{
				
				TitleIdentifier returnValue = TitleIdentifierUpdateAuto(sqlConnection, sqlTransaction, connectionKeyName,
					value.TitleIdentifierID,
						value.IdentifierName,
						value.MarcDataFieldTag,
						value.MarcSubFieldCode);
					
				return new CustomDataAccessStatus<TitleIdentifier>(
					CustomDataAccessContext.Update, 
					true, returnValue);
			}
			else
			{
				return new CustomDataAccessStatus<TitleIdentifier>(
					CustomDataAccessContext.NA, 
					false, value);
			}
		}
		
		#endregion ===== MANAGE =====

	}	
}
// end of source generation
