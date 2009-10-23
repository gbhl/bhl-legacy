
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This is part of a data access layer. 
// This partial class IndicatedPageDAL is based upon IndicatedPage.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// The code file you create must be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DAL
// {
// 		public partial class IndicatedPageDAL
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
	partial class IndicatedPageDAL 
	{
 		#region ===== SELECT =====

		/// <summary>
		/// Select values from IndicatedPage by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="pageID">Unique identifier for each Page record.</param>
		/// <param name="sequence">A number to separately identify various series of Indicated Pages.</param>
		/// <returns>Object of type IndicatedPage.</returns>
		public IndicatedPage IndicatedPageSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int pageID,
			short sequence)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("IndicatedPageSelectAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("PageID", SqlDbType.Int, null, false, pageID),
					CustomSqlHelper.CreateInputParameter("Sequence", SqlDbType.SmallInt, null, false, sequence)))
			{
				using (CustomSqlHelper<IndicatedPage> helper = new CustomSqlHelper<IndicatedPage>())
				{
					CustomGenericList<IndicatedPage> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						IndicatedPage o = list[0];
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
		/// Select values from IndicatedPage by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="pageID">Unique identifier for each Page record.</param>
		/// <param name="sequence">A number to separately identify various series of Indicated Pages.</param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> IndicatedPageSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int pageID,
			short sequence)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("IndicatedPageSelectAuto", connection, transaction,
				CustomSqlHelper.CreateInputParameter("PageID", SqlDbType.Int, null, false, pageID),
					CustomSqlHelper.CreateInputParameter("Sequence", SqlDbType.SmallInt, null, false, sequence)))
			{
				return CustomSqlHelper.ExecuteReaderAndReturnRows(command);
			}
		}
		
		#endregion ===== SELECT =====
	
 		#region ===== INSERT =====

		/// <summary>
		/// Insert values into IndicatedPage.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="pageID">Unique identifier for each Page record.</param>
		/// <param name="sequence">A number to separately identify various series of Indicated Pages.</param>
		/// <param name="pagePrefix">Prefix portion of Indicated Page.</param>
		/// <param name="pageNumber">Page Number portion of Indicated Page.</param>
		/// <param name="implied"></param>
		/// <param name="creationUserID"></param>
		/// <param name="lastModifiedUserID"></param>
		/// <returns>Object of type IndicatedPage.</returns>
		public IndicatedPage IndicatedPageInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int pageID,
			short sequence,
			string pagePrefix,
			string pageNumber,
			bool implied,
			int? creationUserID,
			int? lastModifiedUserID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("IndicatedPageInsertAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("PageID", SqlDbType.Int, null, false, pageID),
					CustomSqlHelper.CreateInputParameter("Sequence", SqlDbType.SmallInt, null, false, sequence),
					CustomSqlHelper.CreateInputParameter("PagePrefix", SqlDbType.NVarChar, 20, true, pagePrefix),
					CustomSqlHelper.CreateInputParameter("PageNumber", SqlDbType.NVarChar, 20, true, pageNumber),
					CustomSqlHelper.CreateInputParameter("Implied", SqlDbType.Bit, null, false, implied),
					CustomSqlHelper.CreateInputParameter("CreationUserID", SqlDbType.Int, null, true, creationUserID),
					CustomSqlHelper.CreateInputParameter("LastModifiedUserID", SqlDbType.Int, null, true, lastModifiedUserID), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<IndicatedPage> helper = new CustomSqlHelper<IndicatedPage>())
				{
					CustomGenericList<IndicatedPage> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						IndicatedPage o = list[0];
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
		/// Insert values into IndicatedPage. Returns an object of type IndicatedPage.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type IndicatedPage.</param>
		/// <returns>Object of type IndicatedPage.</returns>
		public IndicatedPage IndicatedPageInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			IndicatedPage value)
		{
			return IndicatedPageInsertAuto(sqlConnection, sqlTransaction, 
				value.PageID,
				value.Sequence,
				value.PagePrefix,
				value.PageNumber,
				value.Implied,
				value.CreationUserID,
				value.LastModifiedUserID);
		}
		
		#endregion ===== INSERT =====

		#region ===== DELETE =====

		/// <summary>
		/// Delete values from IndicatedPage by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="pageID">Unique identifier for each Page record.</param>
		/// <param name="sequence">A number to separately identify various series of Indicated Pages.</param>
		/// <returns>true if successful otherwise false.</returns>
		public bool IndicatedPageDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int pageID,
			short sequence)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("IndicatedPageDeleteAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("PageID", SqlDbType.Int, null, false, pageID),
					CustomSqlHelper.CreateInputParameter("Sequence", SqlDbType.SmallInt, null, false, sequence), 
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
		/// Update values in IndicatedPage. Returns an object of type IndicatedPage.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="pageID">Unique identifier for each Page record.</param>
		/// <param name="sequence">A number to separately identify various series of Indicated Pages.</param>
		/// <param name="pagePrefix">Prefix portion of Indicated Page.</param>
		/// <param name="pageNumber">Page Number portion of Indicated Page.</param>
		/// <param name="implied"></param>
		/// <param name="lastModifiedUserID"></param>
		/// <returns>Object of type IndicatedPage.</returns>
		public IndicatedPage IndicatedPageUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int pageID,
			short sequence,
			string pagePrefix,
			string pageNumber,
			bool implied,
			int? lastModifiedUserID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("IndicatedPageUpdateAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("PageID", SqlDbType.Int, null, false, pageID),
					CustomSqlHelper.CreateInputParameter("Sequence", SqlDbType.SmallInt, null, false, sequence),
					CustomSqlHelper.CreateInputParameter("PagePrefix", SqlDbType.NVarChar, 20, true, pagePrefix),
					CustomSqlHelper.CreateInputParameter("PageNumber", SqlDbType.NVarChar, 20, true, pageNumber),
					CustomSqlHelper.CreateInputParameter("Implied", SqlDbType.Bit, null, false, implied),
					CustomSqlHelper.CreateInputParameter("LastModifiedUserID", SqlDbType.Int, null, true, lastModifiedUserID), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<IndicatedPage> helper = new CustomSqlHelper<IndicatedPage>())
				{
					CustomGenericList<IndicatedPage> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						IndicatedPage o = list[0];
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
		/// Update values in IndicatedPage. Returns an object of type IndicatedPage.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type IndicatedPage.</param>
		/// <returns>Object of type IndicatedPage.</returns>
		public IndicatedPage IndicatedPageUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			IndicatedPage value)
		{
			return IndicatedPageUpdateAuto(sqlConnection, sqlTransaction,
				value.PageID,
				value.Sequence,
				value.PagePrefix,
				value.PageNumber,
				value.Implied,
				value.LastModifiedUserID);
		}
		
		#endregion ===== UPDATE =====

		#region ===== MANAGE =====
		
		/// <summary>
		/// Manage IndicatedPage object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in IndicatedPage.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type IndicatedPage.</param>
		/// <returns>Object of type CustomDataAccessStatus<IndicatedPage>.</returns>
		public CustomDataAccessStatus<IndicatedPage> IndicatedPageManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			IndicatedPage value , int userId )
		{
			if (value.IsNew && !value.IsDeleted)
			{
				value.CreationUserID = userId;
				value.LastModifiedUserID = userId;
				IndicatedPage returnValue = IndicatedPageInsertAuto(sqlConnection, sqlTransaction, 
					value.PageID,
						value.Sequence,
						value.PagePrefix,
						value.PageNumber,
						value.Implied,
						value.CreationUserID,
						value.LastModifiedUserID);
				
				return new CustomDataAccessStatus<IndicatedPage>(
					CustomDataAccessContext.Insert, 
					true, returnValue);
			}
			else if (!value.IsNew && value.IsDeleted)
			{
				if (IndicatedPageDeleteAuto(sqlConnection, sqlTransaction, 
					value.PageID,
						value.Sequence))
				{
				return new CustomDataAccessStatus<IndicatedPage>(
					CustomDataAccessContext.Delete, 
					true, value);
				}
				else
				{
				return new CustomDataAccessStatus<IndicatedPage>(
					CustomDataAccessContext.Delete, 
					false, value);
				}
			}
			else if (value.IsDirty && !value.IsDeleted)
			{
				value.LastModifiedUserID = userId;
				IndicatedPage returnValue = IndicatedPageUpdateAuto(sqlConnection, sqlTransaction, 
					value.PageID,
						value.Sequence,
						value.PagePrefix,
						value.PageNumber,
						value.Implied,
						value.LastModifiedUserID);
					
				return new CustomDataAccessStatus<IndicatedPage>(
					CustomDataAccessContext.Update, 
					true, returnValue);
			}
			else
			{
				return new CustomDataAccessStatus<IndicatedPage>(
					CustomDataAccessContext.NA, 
					false, value);
			}
		}
		
		#endregion ===== MANAGE =====

	}	
}
// end of source generation
