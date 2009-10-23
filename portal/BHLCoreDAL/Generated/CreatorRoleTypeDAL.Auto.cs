
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This is part of a data access layer. 
// This partial class CreatorRoleTypeDAL is based upon CreatorRoleType.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// The code file you create must be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DAL
// {
// 		public partial class CreatorRoleTypeDAL
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
	partial class CreatorRoleTypeDAL 
	{
 		#region ===== SELECT =====

		/// <summary>
		/// Select values from CreatorRoleType by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="creatorRoleTypeID">Unique identifier for each Creator Role Type.</param>
		/// <returns>Object of type CreatorRoleType.</returns>
		public CreatorRoleType CreatorRoleTypeSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int creatorRoleTypeID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorRoleTypeSelectAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("CreatorRoleTypeID", SqlDbType.Int, null, false, creatorRoleTypeID)))
			{
				using (CustomSqlHelper<CreatorRoleType> helper = new CustomSqlHelper<CreatorRoleType>())
				{
					CustomGenericList<CreatorRoleType> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						CreatorRoleType o = list[0];
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
		/// Select values from CreatorRoleType by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="creatorRoleTypeID">Unique identifier for each Creator Role Type.</param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> CreatorRoleTypeSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int creatorRoleTypeID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorRoleTypeSelectAuto", connection, transaction,
				CustomSqlHelper.CreateInputParameter("CreatorRoleTypeID", SqlDbType.Int, null, false, creatorRoleTypeID)))
			{
				return CustomSqlHelper.ExecuteReaderAndReturnRows(command);
			}
		}
		
		#endregion ===== SELECT =====
	
 		#region ===== INSERT =====

		/// <summary>
		/// Insert values into CreatorRoleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="creatorRoleTypeID">Unique identifier for each Creator Role Type.</param>
		/// <param name="creatorRoleType">A type of Role performed by a Creator.</param>
		/// <param name="creatorRoleTypeDescription">Description of a Creator Role Type.</param>
		/// <param name="mARCDataFieldTag">Data Field Tag from MARC XML.</param>
		/// <returns>Object of type CreatorRoleType.</returns>
		public CreatorRoleType CreatorRoleTypeInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int creatorRoleTypeID,
			string creatorRoleType,
			string creatorRoleTypeDescription,
			string mARCDataFieldTag)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorRoleTypeInsertAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("CreatorRoleTypeID", SqlDbType.Int, null, false, creatorRoleTypeID),
					CustomSqlHelper.CreateInputParameter("CreatorRoleType", SqlDbType.NVarChar, 25, false, creatorRoleType),
					CustomSqlHelper.CreateInputParameter("CreatorRoleTypeDescription", SqlDbType.NVarChar, 255, true, creatorRoleTypeDescription),
					CustomSqlHelper.CreateInputParameter("MARCDataFieldTag", SqlDbType.NVarChar, 3, true, mARCDataFieldTag), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<CreatorRoleType> helper = new CustomSqlHelper<CreatorRoleType>())
				{
					CustomGenericList<CreatorRoleType> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						CreatorRoleType o = list[0];
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
		/// Insert values into CreatorRoleType. Returns an object of type CreatorRoleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type CreatorRoleType.</param>
		/// <returns>Object of type CreatorRoleType.</returns>
		public CreatorRoleType CreatorRoleTypeInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			CreatorRoleType value)
		{
			return CreatorRoleTypeInsertAuto(sqlConnection, sqlTransaction, 
				value.CreatorRoleTypeID,
				value.CreatorRoleType,
				value.CreatorRoleTypeDescription,
				value.MARCDataFieldTag);
		}
		
		#endregion ===== INSERT =====

		#region ===== DELETE =====

		/// <summary>
		/// Delete values from CreatorRoleType by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="creatorRoleTypeID">Unique identifier for each Creator Role Type.</param>
		/// <returns>true if successful otherwise false.</returns>
		public bool CreatorRoleTypeDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int creatorRoleTypeID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorRoleTypeDeleteAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("CreatorRoleTypeID", SqlDbType.Int, null, false, creatorRoleTypeID), 
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
		/// Update values in CreatorRoleType. Returns an object of type CreatorRoleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="creatorRoleTypeID">Unique identifier for each Creator Role Type.</param>
		/// <param name="creatorRoleType">A type of Role performed by a Creator.</param>
		/// <param name="creatorRoleTypeDescription">Description of a Creator Role Type.</param>
		/// <param name="mARCDataFieldTag">Data Field Tag from MARC XML.</param>
		/// <returns>Object of type CreatorRoleType.</returns>
		public CreatorRoleType CreatorRoleTypeUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int creatorRoleTypeID,
			string creatorRoleType,
			string creatorRoleTypeDescription,
			string mARCDataFieldTag)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorRoleTypeUpdateAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("CreatorRoleTypeID", SqlDbType.Int, null, false, creatorRoleTypeID),
					CustomSqlHelper.CreateInputParameter("CreatorRoleType", SqlDbType.NVarChar, 25, false, creatorRoleType),
					CustomSqlHelper.CreateInputParameter("CreatorRoleTypeDescription", SqlDbType.NVarChar, 255, true, creatorRoleTypeDescription),
					CustomSqlHelper.CreateInputParameter("MARCDataFieldTag", SqlDbType.NVarChar, 3, true, mARCDataFieldTag), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<CreatorRoleType> helper = new CustomSqlHelper<CreatorRoleType>())
				{
					CustomGenericList<CreatorRoleType> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						CreatorRoleType o = list[0];
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
		/// Update values in CreatorRoleType. Returns an object of type CreatorRoleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type CreatorRoleType.</param>
		/// <returns>Object of type CreatorRoleType.</returns>
		public CreatorRoleType CreatorRoleTypeUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			CreatorRoleType value)
		{
			return CreatorRoleTypeUpdateAuto(sqlConnection, sqlTransaction,
				value.CreatorRoleTypeID,
				value.CreatorRoleType,
				value.CreatorRoleTypeDescription,
				value.MARCDataFieldTag);
		}
		
		#endregion ===== UPDATE =====

		#region ===== MANAGE =====
		
		/// <summary>
		/// Manage CreatorRoleType object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in CreatorRoleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type CreatorRoleType.</param>
		/// <returns>Object of type CustomDataAccessStatus<CreatorRoleType>.</returns>
		public CustomDataAccessStatus<CreatorRoleType> CreatorRoleTypeManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			CreatorRoleType value  )
		{
			if (value.IsNew && !value.IsDeleted)
			{
				
				
				CreatorRoleType returnValue = CreatorRoleTypeInsertAuto(sqlConnection, sqlTransaction, 
					value.CreatorRoleTypeID,
						value.CreatorRoleType,
						value.CreatorRoleTypeDescription,
						value.MARCDataFieldTag);
				
				return new CustomDataAccessStatus<CreatorRoleType>(
					CustomDataAccessContext.Insert, 
					true, returnValue);
			}
			else if (!value.IsNew && value.IsDeleted)
			{
				if (CreatorRoleTypeDeleteAuto(sqlConnection, sqlTransaction, 
					value.CreatorRoleTypeID))
				{
				return new CustomDataAccessStatus<CreatorRoleType>(
					CustomDataAccessContext.Delete, 
					true, value);
				}
				else
				{
				return new CustomDataAccessStatus<CreatorRoleType>(
					CustomDataAccessContext.Delete, 
					false, value);
				}
			}
			else if (value.IsDirty && !value.IsDeleted)
			{
				
				CreatorRoleType returnValue = CreatorRoleTypeUpdateAuto(sqlConnection, sqlTransaction, 
					value.CreatorRoleTypeID,
						value.CreatorRoleType,
						value.CreatorRoleTypeDescription,
						value.MARCDataFieldTag);
					
				return new CustomDataAccessStatus<CreatorRoleType>(
					CustomDataAccessContext.Update, 
					true, returnValue);
			}
			else
			{
				return new CustomDataAccessStatus<CreatorRoleType>(
					CustomDataAccessContext.NA, 
					false, value);
			}
		}
		
		#endregion ===== MANAGE =====

	}	
}
// end of source generation
