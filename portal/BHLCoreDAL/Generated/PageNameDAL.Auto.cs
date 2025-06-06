
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This is part of a data access layer. 
// This partial class PageNameDAL is based upon PageName.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// The code file you create must be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DAL
// {
// 		public partial class PageNameDAL
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
	partial class PageNameDAL 
	{
 		#region ===== SELECT =====

		/// <summary>
		/// Select values from PageName by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="pageNameID"></param>
		/// <returns>Object of type PageName.</returns>
		public PageName PageNameSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int pageNameID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("PageNameSelectAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("PageNameID", SqlDbType.Int, null, false, pageNameID)))
			{
				using (CustomSqlHelper<PageName> helper = new CustomSqlHelper<PageName>())
				{
					CustomGenericList<PageName> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						PageName o = list[0];
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
		/// Select values from PageName by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="pageNameID"></param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> PageNameSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int pageNameID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("PageNameSelectAuto", connection, transaction,
				CustomSqlHelper.CreateInputParameter("PageNameID", SqlDbType.Int, null, false, pageNameID)))
			{
				return CustomSqlHelper.ExecuteReaderAndReturnRows(command);
			}
		}
		
		#endregion ===== SELECT =====
	
 		#region ===== INSERT =====

		/// <summary>
		/// Insert values into PageName.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="pageID"></param>
		/// <param name="source"></param>
		/// <param name="nameFound"></param>
		/// <param name="nameConfirmed"></param>
		/// <param name="nameBankID"></param>
		/// <param name="active"></param>
		/// <param name="isCommonName"></param>
		/// <returns>Object of type PageName.</returns>
		public PageName PageNameInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int pageID,
			string source,
			string nameFound,
			string nameConfirmed,
			int? nameBankID,
			bool active,
			bool? isCommonName)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("PageNameInsertAuto", connection, transaction, 
				CustomSqlHelper.CreateOutputParameter("PageNameID", SqlDbType.Int, null, false),
					CustomSqlHelper.CreateInputParameter("PageID", SqlDbType.Int, null, false, pageID),
					CustomSqlHelper.CreateInputParameter("Source", SqlDbType.NVarChar, 50, true, source),
					CustomSqlHelper.CreateInputParameter("NameFound", SqlDbType.NVarChar, 100, false, nameFound),
					CustomSqlHelper.CreateInputParameter("NameConfirmed", SqlDbType.NVarChar, 100, true, nameConfirmed),
					CustomSqlHelper.CreateInputParameter("NameBankID", SqlDbType.Int, null, true, nameBankID),
					CustomSqlHelper.CreateInputParameter("Active", SqlDbType.Bit, null, false, active),
					CustomSqlHelper.CreateInputParameter("IsCommonName", SqlDbType.Bit, null, true, isCommonName), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<PageName> helper = new CustomSqlHelper<PageName>())
				{
					CustomGenericList<PageName> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						PageName o = list[0];
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
		/// Insert values into PageName. Returns an object of type PageName.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type PageName.</param>
		/// <returns>Object of type PageName.</returns>
		public PageName PageNameInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			PageName value)
		{
			return PageNameInsertAuto(sqlConnection, sqlTransaction, 
				value.PageID,
				value.Source,
				value.NameFound,
				value.NameConfirmed,
				value.NameBankID,
				value.Active,
				value.IsCommonName);
		}
		
		#endregion ===== INSERT =====

		#region ===== DELETE =====

		/// <summary>
		/// Delete values from PageName by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="pageNameID"></param>
		/// <returns>true if successful otherwise false.</returns>
		public bool PageNameDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int pageNameID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("PageNameDeleteAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("PageNameID", SqlDbType.Int, null, false, pageNameID), 
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
		/// Update values in PageName. Returns an object of type PageName.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="pageNameID"></param>
		/// <param name="pageID"></param>
		/// <param name="source"></param>
		/// <param name="nameFound"></param>
		/// <param name="nameConfirmed"></param>
		/// <param name="nameBankID"></param>
		/// <param name="active"></param>
		/// <param name="isCommonName"></param>
		/// <returns>Object of type PageName.</returns>
		public PageName PageNameUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int pageNameID,
			int pageID,
			string source,
			string nameFound,
			string nameConfirmed,
			int? nameBankID,
			bool active,
			bool? isCommonName)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("PageNameUpdateAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("PageNameID", SqlDbType.Int, null, false, pageNameID),
					CustomSqlHelper.CreateInputParameter("PageID", SqlDbType.Int, null, false, pageID),
					CustomSqlHelper.CreateInputParameter("Source", SqlDbType.NVarChar, 50, true, source),
					CustomSqlHelper.CreateInputParameter("NameFound", SqlDbType.NVarChar, 100, false, nameFound),
					CustomSqlHelper.CreateInputParameter("NameConfirmed", SqlDbType.NVarChar, 100, true, nameConfirmed),
					CustomSqlHelper.CreateInputParameter("NameBankID", SqlDbType.Int, null, true, nameBankID),
					CustomSqlHelper.CreateInputParameter("Active", SqlDbType.Bit, null, false, active),
					CustomSqlHelper.CreateInputParameter("IsCommonName", SqlDbType.Bit, null, true, isCommonName), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<PageName> helper = new CustomSqlHelper<PageName>())
				{
					CustomGenericList<PageName> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						PageName o = list[0];
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
		/// Update values in PageName. Returns an object of type PageName.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type PageName.</param>
		/// <returns>Object of type PageName.</returns>
		public PageName PageNameUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			PageName value)
		{
			return PageNameUpdateAuto(sqlConnection, sqlTransaction,
				value.PageNameID,
				value.PageID,
				value.Source,
				value.NameFound,
				value.NameConfirmed,
				value.NameBankID,
				value.Active,
				value.IsCommonName);
		}
		
		#endregion ===== UPDATE =====

		#region ===== MANAGE =====
		
		/// <summary>
		/// Manage PageName object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in PageName.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type PageName.</param>
		/// <returns>Object of type CustomDataAccessStatus<PageName>.</returns>
		public CustomDataAccessStatus<PageName> PageNameManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			PageName value  )
		{
			if (value.IsNew && !value.IsDeleted)
			{
				
				
				PageName returnValue = PageNameInsertAuto(sqlConnection, sqlTransaction, 
					value.PageID,
						value.Source,
						value.NameFound,
						value.NameConfirmed,
						value.NameBankID,
						value.Active,
						value.IsCommonName);
				
				return new CustomDataAccessStatus<PageName>(
					CustomDataAccessContext.Insert, 
					true, returnValue);
			}
			else if (!value.IsNew && value.IsDeleted)
			{
				if (PageNameDeleteAuto(sqlConnection, sqlTransaction, 
					value.PageNameID))
				{
				return new CustomDataAccessStatus<PageName>(
					CustomDataAccessContext.Delete, 
					true, value);
				}
				else
				{
				return new CustomDataAccessStatus<PageName>(
					CustomDataAccessContext.Delete, 
					false, value);
				}
			}
			else if (value.IsDirty && !value.IsDeleted)
			{
				
				PageName returnValue = PageNameUpdateAuto(sqlConnection, sqlTransaction, 
					value.PageNameID,
						value.PageID,
						value.Source,
						value.NameFound,
						value.NameConfirmed,
						value.NameBankID,
						value.Active,
						value.IsCommonName);
					
				return new CustomDataAccessStatus<PageName>(
					CustomDataAccessContext.Update, 
					true, returnValue);
			}
			else
			{
				return new CustomDataAccessStatus<PageName>(
					CustomDataAccessContext.NA, 
					false, value);
			}
		}
		
		#endregion ===== MANAGE =====

	}	
}
// end of source generation
