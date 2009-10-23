
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This is part of a data access layer. 
// This partial class TitleTypeDAL is based upon TitleType.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// The code file you create must be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DAL
// {
// 		public partial class TitleTypeDAL
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
	partial class TitleTypeDAL 
	{
 		#region ===== SELECT =====

		/// <summary>
		/// Select values from TitleType by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleTypeID">Unique identifier for each Title Type record.</param>
		/// <returns>Object of type TitleType.</returns>
		public TitleType TitleTypeSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleTypeID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleTypeSelectAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("TitleTypeID", SqlDbType.Int, null, false, titleTypeID)))
			{
				using (CustomSqlHelper<TitleType> helper = new CustomSqlHelper<TitleType>())
				{
					CustomGenericList<TitleType> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						TitleType o = list[0];
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
		/// Select values from TitleType by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleTypeID">Unique identifier for each Title Type record.</param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> TitleTypeSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleTypeID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleTypeSelectAuto", connection, transaction,
				CustomSqlHelper.CreateInputParameter("TitleTypeID", SqlDbType.Int, null, false, titleTypeID)))
			{
				return CustomSqlHelper.ExecuteReaderAndReturnRows(command);
			}
		}
		
		#endregion ===== SELECT =====
	
 		#region ===== INSERT =====

		/// <summary>
		/// Insert values into TitleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleTypeID">Unique identifier for each Title Type record.</param>
		/// <param name="titleType">A Type to be associated with a Title.</param>
		/// <param name="titleTypeDescription">Description of a Title Type.</param>
		/// <returns>Object of type TitleType.</returns>
		public TitleType TitleTypeInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleTypeID,
			string titleType,
			string titleTypeDescription)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleTypeInsertAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("TitleTypeID", SqlDbType.Int, null, false, titleTypeID),
					CustomSqlHelper.CreateInputParameter("TitleType", SqlDbType.NVarChar, 25, false, titleType),
					CustomSqlHelper.CreateInputParameter("TitleTypeDescription", SqlDbType.NVarChar, 80, true, titleTypeDescription), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<TitleType> helper = new CustomSqlHelper<TitleType>())
				{
					CustomGenericList<TitleType> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						TitleType o = list[0];
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
		/// Insert values into TitleType. Returns an object of type TitleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type TitleType.</param>
		/// <returns>Object of type TitleType.</returns>
		public TitleType TitleTypeInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			TitleType value)
		{
			return TitleTypeInsertAuto(sqlConnection, sqlTransaction, 
				value.TitleTypeID,
				value.TitleType,
				value.TitleTypeDescription);
		}
		
		#endregion ===== INSERT =====

		#region ===== DELETE =====

		/// <summary>
		/// Delete values from TitleType by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleTypeID">Unique identifier for each Title Type record.</param>
		/// <returns>true if successful otherwise false.</returns>
		public bool TitleTypeDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleTypeID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleTypeDeleteAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("TitleTypeID", SqlDbType.Int, null, false, titleTypeID), 
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
		/// Update values in TitleType. Returns an object of type TitleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleTypeID">Unique identifier for each Title Type record.</param>
		/// <param name="titleType">A Type to be associated with a Title.</param>
		/// <param name="titleTypeDescription">Description of a Title Type.</param>
		/// <returns>Object of type TitleType.</returns>
		public TitleType TitleTypeUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleTypeID,
			string titleType,
			string titleTypeDescription)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleTypeUpdateAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("TitleTypeID", SqlDbType.Int, null, false, titleTypeID),
					CustomSqlHelper.CreateInputParameter("TitleType", SqlDbType.NVarChar, 25, false, titleType),
					CustomSqlHelper.CreateInputParameter("TitleTypeDescription", SqlDbType.NVarChar, 80, true, titleTypeDescription), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<TitleType> helper = new CustomSqlHelper<TitleType>())
				{
					CustomGenericList<TitleType> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						TitleType o = list[0];
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
		/// Update values in TitleType. Returns an object of type TitleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type TitleType.</param>
		/// <returns>Object of type TitleType.</returns>
		public TitleType TitleTypeUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			TitleType value)
		{
			return TitleTypeUpdateAuto(sqlConnection, sqlTransaction,
				value.TitleTypeID,
				value.TitleType,
				value.TitleTypeDescription);
		}
		
		#endregion ===== UPDATE =====

		#region ===== MANAGE =====
		
		/// <summary>
		/// Manage TitleType object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in TitleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type TitleType.</param>
		/// <returns>Object of type CustomDataAccessStatus<TitleType>.</returns>
		public CustomDataAccessStatus<TitleType> TitleTypeManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			TitleType value  )
		{
			if (value.IsNew && !value.IsDeleted)
			{
				
				
				TitleType returnValue = TitleTypeInsertAuto(sqlConnection, sqlTransaction, 
					value.TitleTypeID,
						value.TitleType,
						value.TitleTypeDescription);
				
				return new CustomDataAccessStatus<TitleType>(
					CustomDataAccessContext.Insert, 
					true, returnValue);
			}
			else if (!value.IsNew && value.IsDeleted)
			{
				if (TitleTypeDeleteAuto(sqlConnection, sqlTransaction, 
					value.TitleTypeID))
				{
				return new CustomDataAccessStatus<TitleType>(
					CustomDataAccessContext.Delete, 
					true, value);
				}
				else
				{
				return new CustomDataAccessStatus<TitleType>(
					CustomDataAccessContext.Delete, 
					false, value);
				}
			}
			else if (value.IsDirty && !value.IsDeleted)
			{
				
				TitleType returnValue = TitleTypeUpdateAuto(sqlConnection, sqlTransaction, 
					value.TitleTypeID,
						value.TitleType,
						value.TitleTypeDescription);
					
				return new CustomDataAccessStatus<TitleType>(
					CustomDataAccessContext.Update, 
					true, returnValue);
			}
			else
			{
				return new CustomDataAccessStatus<TitleType>(
					CustomDataAccessContext.NA, 
					false, value);
			}
		}
		
		#endregion ===== MANAGE =====

	}	
}
// end of source generation
