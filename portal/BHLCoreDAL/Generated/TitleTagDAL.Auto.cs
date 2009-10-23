
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This is part of a data access layer. 
// This partial class TitleTagDAL is based upon TitleTag.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// The code file you create must be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DAL
// {
// 		public partial class TitleTagDAL
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
	partial class TitleTagDAL 
	{
 		#region ===== SELECT =====

		/// <summary>
		/// Select values from TitleTag by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleID"></param>
		/// <param name="tagText"></param>
		/// <returns>Object of type TitleTag.</returns>
		public TitleTag TitleTagSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleID,
			string tagText)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleTagSelectAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID),
					CustomSqlHelper.CreateInputParameter("TagText", SqlDbType.NVarChar, 50, false, tagText)))
			{
				using (CustomSqlHelper<TitleTag> helper = new CustomSqlHelper<TitleTag>())
				{
					CustomGenericList<TitleTag> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						TitleTag o = list[0];
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
		/// Select values from TitleTag by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleID"></param>
		/// <param name="tagText"></param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> TitleTagSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleID,
			string tagText)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleTagSelectAuto", connection, transaction,
				CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID),
					CustomSqlHelper.CreateInputParameter("TagText", SqlDbType.NVarChar, 50, false, tagText)))
			{
				return CustomSqlHelper.ExecuteReaderAndReturnRows(command);
			}
		}
		
		#endregion ===== SELECT =====
	
 		#region ===== INSERT =====

		/// <summary>
		/// Insert values into TitleTag.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleID"></param>
		/// <param name="tagText"></param>
		/// <param name="marcDataFieldTag"></param>
		/// <param name="marcSubFieldCode"></param>
		/// <returns>Object of type TitleTag.</returns>
		public TitleTag TitleTagInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleID,
			string tagText,
			string marcDataFieldTag,
			string marcSubFieldCode)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleTagInsertAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID),
					CustomSqlHelper.CreateInputParameter("TagText", SqlDbType.NVarChar, 50, false, tagText),
					CustomSqlHelper.CreateInputParameter("MarcDataFieldTag", SqlDbType.NVarChar, 50, true, marcDataFieldTag),
					CustomSqlHelper.CreateInputParameter("MarcSubFieldCode", SqlDbType.NVarChar, 50, true, marcSubFieldCode), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<TitleTag> helper = new CustomSqlHelper<TitleTag>())
				{
					CustomGenericList<TitleTag> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						TitleTag o = list[0];
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
		/// Insert values into TitleTag. Returns an object of type TitleTag.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type TitleTag.</param>
		/// <returns>Object of type TitleTag.</returns>
		public TitleTag TitleTagInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			TitleTag value)
		{
			return TitleTagInsertAuto(sqlConnection, sqlTransaction, 
				value.TitleID,
				value.TagText,
				value.MarcDataFieldTag,
				value.MarcSubFieldCode);
		}
		
		#endregion ===== INSERT =====

		#region ===== DELETE =====

		/// <summary>
		/// Delete values from TitleTag by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleID"></param>
		/// <param name="tagText"></param>
		/// <returns>true if successful otherwise false.</returns>
		public bool TitleTagDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleID,
			string tagText)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleTagDeleteAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID),
					CustomSqlHelper.CreateInputParameter("TagText", SqlDbType.NVarChar, 50, false, tagText), 
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
		/// Update values in TitleTag. Returns an object of type TitleTag.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="titleID"></param>
		/// <param name="tagText"></param>
		/// <param name="marcDataFieldTag"></param>
		/// <param name="marcSubFieldCode"></param>
		/// <returns>Object of type TitleTag.</returns>
		public TitleTag TitleTagUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int titleID,
			string tagText,
			string marcDataFieldTag,
			string marcSubFieldCode)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleTagUpdateAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleID),
					CustomSqlHelper.CreateInputParameter("TagText", SqlDbType.NVarChar, 50, false, tagText),
					CustomSqlHelper.CreateInputParameter("MarcDataFieldTag", SqlDbType.NVarChar, 50, true, marcDataFieldTag),
					CustomSqlHelper.CreateInputParameter("MarcSubFieldCode", SqlDbType.NVarChar, 50, true, marcSubFieldCode), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<TitleTag> helper = new CustomSqlHelper<TitleTag>())
				{
					CustomGenericList<TitleTag> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						TitleTag o = list[0];
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
		/// Update values in TitleTag. Returns an object of type TitleTag.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type TitleTag.</param>
		/// <returns>Object of type TitleTag.</returns>
		public TitleTag TitleTagUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			TitleTag value)
		{
			return TitleTagUpdateAuto(sqlConnection, sqlTransaction,
				value.TitleID,
				value.TagText,
				value.MarcDataFieldTag,
				value.MarcSubFieldCode);
		}
		
		#endregion ===== UPDATE =====

		#region ===== MANAGE =====
		
		/// <summary>
		/// Manage TitleTag object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in TitleTag.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type TitleTag.</param>
		/// <returns>Object of type CustomDataAccessStatus<TitleTag>.</returns>
		public CustomDataAccessStatus<TitleTag> TitleTagManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			TitleTag value  )
		{
			if (value.IsNew && !value.IsDeleted)
			{
				
				
				TitleTag returnValue = TitleTagInsertAuto(sqlConnection, sqlTransaction, 
					value.TitleID,
						value.TagText,
						value.MarcDataFieldTag,
						value.MarcSubFieldCode);
				
				return new CustomDataAccessStatus<TitleTag>(
					CustomDataAccessContext.Insert, 
					true, returnValue);
			}
			else if (!value.IsNew && value.IsDeleted)
			{
				if (TitleTagDeleteAuto(sqlConnection, sqlTransaction, 
					value.TitleID,
						value.TagText))
				{
				return new CustomDataAccessStatus<TitleTag>(
					CustomDataAccessContext.Delete, 
					true, value);
				}
				else
				{
				return new CustomDataAccessStatus<TitleTag>(
					CustomDataAccessContext.Delete, 
					false, value);
				}
			}
			else if (value.IsDirty && !value.IsDeleted)
			{
				
				TitleTag returnValue = TitleTagUpdateAuto(sqlConnection, sqlTransaction, 
					value.TitleID,
						value.TagText,
						value.MarcDataFieldTag,
						value.MarcSubFieldCode);
					
				return new CustomDataAccessStatus<TitleTag>(
					CustomDataAccessContext.Update, 
					true, returnValue);
			}
			else
			{
				return new CustomDataAccessStatus<TitleTag>(
					CustomDataAccessContext.NA, 
					false, value);
			}
		}
		
		#endregion ===== MANAGE =====

	}	
}
// end of source generation
