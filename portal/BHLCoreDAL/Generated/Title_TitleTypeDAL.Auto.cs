
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This is part of a data access layer. 
// This partial class Title_TitleTypeDAL is based upon Title_TitleType.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// The code file you create must be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DAL
// {
// 		public partial class Title_TitleTypeDAL
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
	partial class Title_TitleTypeDAL 
	{
 		#region ===== SELECT =====

		/// <summary>
		/// Select values from Title_TitleType by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="title_TitleTypeID"></param>
		/// <returns>Object of type Title_TitleType.</returns>
		public Title_TitleType Title_TitleTypeSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int title_TitleTypeID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_TitleTypeSelectAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("Title_TitleTypeID", SqlDbType.Int, null, false, title_TitleTypeID)))
			{
				using (CustomSqlHelper<Title_TitleType> helper = new CustomSqlHelper<Title_TitleType>())
				{
					CustomGenericList<Title_TitleType> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Title_TitleType o = list[0];
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
		/// Select values from Title_TitleType by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="title_TitleTypeID"></param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> Title_TitleTypeSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int title_TitleTypeID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_TitleTypeSelectAuto", connection, transaction,
				CustomSqlHelper.CreateInputParameter("Title_TitleTypeID", SqlDbType.Int, null, false, title_TitleTypeID)))
			{
				return CustomSqlHelper.ExecuteReaderAndReturnRows(command);
			}
		}
		
		#endregion ===== SELECT =====
	
 		#region ===== INSERT =====

		/// <summary>
		/// Insert values into Title_TitleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleID">Unique identifier for each Title record.</param>
		/// <param name="titleTypeID">Unique identifier for each Title Type record.</param>
		/// <returns>Object of type Title_TitleType.</returns>
		public Title_TitleType Title_TitleTypeInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleID,
			int titleTypeID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_TitleTypeInsertAuto", connection, transaction, 
				CustomSqlHelper.CreateOutputParameter("Title_TitleTypeID", SqlDbType.Int, null, false),
					CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID),
					CustomSqlHelper.CreateInputParameter("TitleTypeID", SqlDbType.Int, null, false, titleTypeID), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<Title_TitleType> helper = new CustomSqlHelper<Title_TitleType>())
				{
					CustomGenericList<Title_TitleType> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Title_TitleType o = list[0];
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
		/// Insert values into Title_TitleType. Returns an object of type Title_TitleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Title_TitleType.</param>
		/// <returns>Object of type Title_TitleType.</returns>
		public Title_TitleType Title_TitleTypeInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Title_TitleType value)
		{
			return Title_TitleTypeInsertAuto(sqlConnection, sqlTransaction, 
				value.TitleID,
				value.TitleTypeID);
		}
		
		#endregion ===== INSERT =====

		#region ===== DELETE =====

		/// <summary>
		/// Delete values from Title_TitleType by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="title_TitleTypeID"></param>
		/// <returns>true if successful otherwise false.</returns>
		public bool Title_TitleTypeDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int title_TitleTypeID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_TitleTypeDeleteAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("Title_TitleTypeID", SqlDbType.Int, null, false, title_TitleTypeID), 
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
		/// Update values in Title_TitleType. Returns an object of type Title_TitleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="title_TitleTypeID"></param>
		/// <param name="titleID">Unique identifier for each Title record.</param>
		/// <param name="titleTypeID">Unique identifier for each Title Type record.</param>
		/// <returns>Object of type Title_TitleType.</returns>
		public Title_TitleType Title_TitleTypeUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int title_TitleTypeID,
			int titleID,
			int titleTypeID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_TitleTypeUpdateAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("Title_TitleTypeID", SqlDbType.Int, null, false, title_TitleTypeID),
					CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID),
					CustomSqlHelper.CreateInputParameter("TitleTypeID", SqlDbType.Int, null, false, titleTypeID), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<Title_TitleType> helper = new CustomSqlHelper<Title_TitleType>())
				{
					CustomGenericList<Title_TitleType> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Title_TitleType o = list[0];
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
		/// Update values in Title_TitleType. Returns an object of type Title_TitleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Title_TitleType.</param>
		/// <returns>Object of type Title_TitleType.</returns>
		public Title_TitleType Title_TitleTypeUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Title_TitleType value)
		{
			return Title_TitleTypeUpdateAuto(sqlConnection, sqlTransaction,
				value.Title_TitleTypeID,
				value.TitleID,
				value.TitleTypeID);
		}
		
		#endregion ===== UPDATE =====

		#region ===== MANAGE =====
		
		/// <summary>
		/// Manage Title_TitleType object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in Title_TitleType.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Title_TitleType.</param>
		/// <returns>Object of type CustomDataAccessStatus<Title_TitleType>.</returns>
		public CustomDataAccessStatus<Title_TitleType> Title_TitleTypeManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Title_TitleType value  )
		{
			if (value.IsNew && !value.IsDeleted)
			{
				
				
				Title_TitleType returnValue = Title_TitleTypeInsertAuto(sqlConnection, sqlTransaction, 
					value.TitleID,
						value.TitleTypeID);
				
				return new CustomDataAccessStatus<Title_TitleType>(
					CustomDataAccessContext.Insert, 
					true, returnValue);
			}
			else if (!value.IsNew && value.IsDeleted)
			{
				if (Title_TitleTypeDeleteAuto(sqlConnection, sqlTransaction, 
					value.Title_TitleTypeID))
				{
				return new CustomDataAccessStatus<Title_TitleType>(
					CustomDataAccessContext.Delete, 
					true, value);
				}
				else
				{
				return new CustomDataAccessStatus<Title_TitleType>(
					CustomDataAccessContext.Delete, 
					false, value);
				}
			}
			else if (value.IsDirty && !value.IsDeleted)
			{
				
				Title_TitleType returnValue = Title_TitleTypeUpdateAuto(sqlConnection, sqlTransaction, 
					value.Title_TitleTypeID,
						value.TitleID,
						value.TitleTypeID);
					
				return new CustomDataAccessStatus<Title_TitleType>(
					CustomDataAccessContext.Update, 
					true, returnValue);
			}
			else
			{
				return new CustomDataAccessStatus<Title_TitleType>(
					CustomDataAccessContext.NA, 
					false, value);
			}
		}
		
		#endregion ===== MANAGE =====

	}	
}
// end of source generation
