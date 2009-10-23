
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This is part of a data access layer. 
// This partial class Title_CreatorDAL is based upon Title_Creator.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// The code file you create must be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DAL
// {
// 		public partial class Title_CreatorDAL
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
	partial class Title_CreatorDAL 
	{
 		#region ===== SELECT =====

		/// <summary>
		/// Select values from Title_Creator by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="title_CreatorID"></param>
		/// <returns>Object of type Title_Creator.</returns>
		public Title_Creator Title_CreatorSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int title_CreatorID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_CreatorSelectAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("Title_CreatorID", SqlDbType.Int, null, false, title_CreatorID)))
			{
				using (CustomSqlHelper<Title_Creator> helper = new CustomSqlHelper<Title_Creator>())
				{
					CustomGenericList<Title_Creator> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Title_Creator o = list[0];
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
		/// Select values from Title_Creator by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="title_CreatorID"></param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> Title_CreatorSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int title_CreatorID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_CreatorSelectAuto", connection, transaction,
				CustomSqlHelper.CreateInputParameter("Title_CreatorID", SqlDbType.Int, null, false, title_CreatorID)))
			{
				return CustomSqlHelper.ExecuteReaderAndReturnRows(command);
			}
		}
		
		#endregion ===== SELECT =====
	
 		#region ===== INSERT =====

		/// <summary>
		/// Insert values into Title_Creator.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleID">Unique identifier for each Title record.</param>
		/// <param name="creatorID">Unique identifier for each Creator record.</param>
		/// <param name="creatorRoleTypeID">Unique identifier for each Creator Role Type.</param>
		/// <param name="creationUserID"></param>
		/// <param name="lastModifiedUserID"></param>
		/// <returns>Object of type Title_Creator.</returns>
		public Title_Creator Title_CreatorInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleID,
			int creatorID,
			int creatorRoleTypeID,
			int? creationUserID,
			int? lastModifiedUserID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_CreatorInsertAuto", connection, transaction, 
				CustomSqlHelper.CreateOutputParameter("Title_CreatorID", SqlDbType.Int, null, false),
					CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID),
					CustomSqlHelper.CreateInputParameter("CreatorID", SqlDbType.Int, null, false, creatorID),
					CustomSqlHelper.CreateInputParameter("CreatorRoleTypeID", SqlDbType.Int, null, false, creatorRoleTypeID),
					CustomSqlHelper.CreateInputParameter("CreationUserID", SqlDbType.Int, null, true, creationUserID),
					CustomSqlHelper.CreateInputParameter("LastModifiedUserID", SqlDbType.Int, null, true, lastModifiedUserID), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<Title_Creator> helper = new CustomSqlHelper<Title_Creator>())
				{
					CustomGenericList<Title_Creator> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Title_Creator o = list[0];
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
		/// Insert values into Title_Creator. Returns an object of type Title_Creator.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Title_Creator.</param>
		/// <returns>Object of type Title_Creator.</returns>
		public Title_Creator Title_CreatorInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Title_Creator value)
		{
			return Title_CreatorInsertAuto(sqlConnection, sqlTransaction, 
				value.TitleID,
				value.CreatorID,
				value.CreatorRoleTypeID,
				value.CreationUserID,
				value.LastModifiedUserID);
		}
		
		#endregion ===== INSERT =====

		#region ===== DELETE =====

		/// <summary>
		/// Delete values from Title_Creator by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="title_CreatorID"></param>
		/// <returns>true if successful otherwise false.</returns>
		public bool Title_CreatorDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int title_CreatorID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_CreatorDeleteAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("Title_CreatorID", SqlDbType.Int, null, false, title_CreatorID), 
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
		/// Update values in Title_Creator. Returns an object of type Title_Creator.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="title_CreatorID"></param>
		/// <param name="titleID">Unique identifier for each Title record.</param>
		/// <param name="creatorID">Unique identifier for each Creator record.</param>
		/// <param name="creatorRoleTypeID">Unique identifier for each Creator Role Type.</param>
		/// <param name="lastModifiedUserID"></param>
		/// <returns>Object of type Title_Creator.</returns>
		public Title_Creator Title_CreatorUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int title_CreatorID,
			int titleID,
			int creatorID,
			int creatorRoleTypeID,
			int? lastModifiedUserID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("Title_CreatorUpdateAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("Title_CreatorID", SqlDbType.Int, null, false, title_CreatorID),
					CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID),
					CustomSqlHelper.CreateInputParameter("CreatorID", SqlDbType.Int, null, false, creatorID),
					CustomSqlHelper.CreateInputParameter("CreatorRoleTypeID", SqlDbType.Int, null, false, creatorRoleTypeID),
					CustomSqlHelper.CreateInputParameter("LastModifiedUserID", SqlDbType.Int, null, true, lastModifiedUserID), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<Title_Creator> helper = new CustomSqlHelper<Title_Creator>())
				{
					CustomGenericList<Title_Creator> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Title_Creator o = list[0];
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
		/// Update values in Title_Creator. Returns an object of type Title_Creator.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Title_Creator.</param>
		/// <returns>Object of type Title_Creator.</returns>
		public Title_Creator Title_CreatorUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Title_Creator value)
		{
			return Title_CreatorUpdateAuto(sqlConnection, sqlTransaction,
				value.Title_CreatorID,
				value.TitleID,
				value.CreatorID,
				value.CreatorRoleTypeID,
				value.LastModifiedUserID);
		}
		
		#endregion ===== UPDATE =====

		#region ===== MANAGE =====
		
		/// <summary>
		/// Manage Title_Creator object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in Title_Creator.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Title_Creator.</param>
		/// <returns>Object of type CustomDataAccessStatus<Title_Creator>.</returns>
		public CustomDataAccessStatus<Title_Creator> Title_CreatorManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Title_Creator value , int userId )
		{
			if (value.IsNew && !value.IsDeleted)
			{
				value.CreationUserID = userId;
				value.LastModifiedUserID = userId;
				Title_Creator returnValue = Title_CreatorInsertAuto(sqlConnection, sqlTransaction, 
					value.TitleID,
						value.CreatorID,
						value.CreatorRoleTypeID,
						value.CreationUserID,
						value.LastModifiedUserID);
				
				return new CustomDataAccessStatus<Title_Creator>(
					CustomDataAccessContext.Insert, 
					true, returnValue);
			}
			else if (!value.IsNew && value.IsDeleted)
			{
				if (Title_CreatorDeleteAuto(sqlConnection, sqlTransaction, 
					value.Title_CreatorID))
				{
				return new CustomDataAccessStatus<Title_Creator>(
					CustomDataAccessContext.Delete, 
					true, value);
				}
				else
				{
				return new CustomDataAccessStatus<Title_Creator>(
					CustomDataAccessContext.Delete, 
					false, value);
				}
			}
			else if (value.IsDirty && !value.IsDeleted)
			{
				value.LastModifiedUserID = userId;
				Title_Creator returnValue = Title_CreatorUpdateAuto(sqlConnection, sqlTransaction, 
					value.Title_CreatorID,
						value.TitleID,
						value.CreatorID,
						value.CreatorRoleTypeID,
						value.LastModifiedUserID);
					
				return new CustomDataAccessStatus<Title_Creator>(
					CustomDataAccessContext.Update, 
					true, returnValue);
			}
			else
			{
				return new CustomDataAccessStatus<Title_Creator>(
					CustomDataAccessContext.NA, 
					false, value);
			}
		}
		
		#endregion ===== MANAGE =====

	}	
}
// end of source generation
