
// Generated 4/4/2008 2:40:57 PM
// Do not modify the contents of this code file.
// This is part of a data access layer. 
// This partial class CreatorDAL is based upon Creator.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// The code file you create must be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DAL
// {
// 		public partial class CreatorDAL
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
	partial class CreatorDAL 
	{
 		#region ===== SELECT =====

		/// <summary>
		/// Select values from Creator by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="creatorID">Unique identifier for each Creator record.</param>
		/// <returns>Object of type Creator.</returns>
		public Creator CreatorSelectAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int creatorID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorSelectAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("CreatorID", SqlDbType.Int, null, false, creatorID)))
			{
				using (CustomSqlHelper<Creator> helper = new CustomSqlHelper<Creator>())
				{
					CustomGenericList<Creator> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Creator o = list[0];
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
		/// Select values from Creator by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="creatorID">Unique identifier for each Creator record.</param>
		/// <returns>CustomGenericList&lt;CustomDataRow&gt;</returns>
		public CustomGenericList<CustomDataRow> CreatorSelectAutoRaw(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int creatorID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorSelectAuto", connection, transaction,
				CustomSqlHelper.CreateInputParameter("CreatorID", SqlDbType.Int, null, false, creatorID)))
			{
				return CustomSqlHelper.ExecuteReaderAndReturnRows(command);
			}
		}
		
		#endregion ===== SELECT =====
	
 		#region ===== INSERT =====

		/// <summary>
		/// Insert values into Creator.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="creatorName">Creator name in last name first order.</param>
		/// <param name="firstNameFirst">Creator name in first name first order.</param>
		/// <param name="simpleName">Name using simple English alphabet (first name first).</param>
		/// <param name="dOB">Creator's date of birth.</param>
		/// <param name="dOD">Creator's date of death.</param>
		/// <param name="biography">Biography of the Creator.</param>
		/// <param name="creatorNote">Notes about this Creator.</param>
		/// <param name="mARCDataFieldTag">MARC XML DataFieldTag providing this record.</param>
		/// <param name="mARCCreator_a">"a" field from MARC XML</param>
		/// <param name="mARCCreator_b">"b" field from MARC XML</param>
		/// <param name="mARCCreator_c">"c" field from MARC XML</param>
		/// <param name="mARCCreator_d">"d" field from MARC XML</param>
		/// <param name="mARCCreator_Full">"Full" Creator information from MARC XML</param>
		/// <returns>Object of type Creator.</returns>
		public Creator CreatorInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			string creatorName,
			string firstNameFirst,
			string simpleName,
			string dOB,
			string dOD,
			string biography,
			string creatorNote,
			string mARCDataFieldTag,
			string mARCCreator_a,
			string mARCCreator_b,
			string mARCCreator_c,
			string mARCCreator_d,
			string mARCCreator_Full)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorInsertAuto", connection, transaction, 
				CustomSqlHelper.CreateOutputParameter("CreatorID", SqlDbType.Int, null, false),
					CustomSqlHelper.CreateInputParameter("CreatorName", SqlDbType.NVarChar, 255, false, creatorName),
					CustomSqlHelper.CreateInputParameter("FirstNameFirst", SqlDbType.NVarChar, 255, true, firstNameFirst),
					CustomSqlHelper.CreateInputParameter("SimpleName", SqlDbType.NVarChar, 255, true, simpleName),
					CustomSqlHelper.CreateInputParameter("DOB", SqlDbType.NVarChar, 50, true, dOB),
					CustomSqlHelper.CreateInputParameter("DOD", SqlDbType.NVarChar, 50, true, dOD),
					CustomSqlHelper.CreateInputParameter("Biography", SqlDbType.NText, 1073741823, true, biography),
					CustomSqlHelper.CreateInputParameter("CreatorNote", SqlDbType.NVarChar, 255, true, creatorNote),
					CustomSqlHelper.CreateInputParameter("MARCDataFieldTag", SqlDbType.NVarChar, 3, true, mARCDataFieldTag),
					CustomSqlHelper.CreateInputParameter("MARCCreator_a", SqlDbType.NVarChar, 450, true, mARCCreator_a),
					CustomSqlHelper.CreateInputParameter("MARCCreator_b", SqlDbType.NVarChar, 450, true, mARCCreator_b),
					CustomSqlHelper.CreateInputParameter("MARCCreator_c", SqlDbType.NVarChar, 450, true, mARCCreator_c),
					CustomSqlHelper.CreateInputParameter("MARCCreator_d", SqlDbType.NVarChar, 450, true, mARCCreator_d),
					CustomSqlHelper.CreateInputParameter("MARCCreator_Full", SqlDbType.NVarChar, 450, true, mARCCreator_Full), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<Creator> helper = new CustomSqlHelper<Creator>())
				{
					CustomGenericList<Creator> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Creator o = list[0];
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
		/// Insert values into Creator. Returns an object of type Creator.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Creator.</param>
		/// <returns>Object of type Creator.</returns>
		public Creator CreatorInsertAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Creator value)
		{
			return CreatorInsertAuto(sqlConnection, sqlTransaction, 
				value.CreatorName,
				value.FirstNameFirst,
				value.SimpleName,
				value.DOB,
				value.DOD,
				value.Biography,
				value.CreatorNote,
				value.MARCDataFieldTag,
				value.MARCCreator_a,
				value.MARCCreator_b,
				value.MARCCreator_c,
				value.MARCCreator_d,
				value.MARCCreator_Full);
		}
		
		#endregion ===== INSERT =====

		#region ===== DELETE =====

		/// <summary>
		/// Delete values from Creator by primary key(s).
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="creatorID">Unique identifier for each Creator record.</param>
		/// <returns>true if successful otherwise false.</returns>
		public bool CreatorDeleteAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int creatorID)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorDeleteAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("CreatorID", SqlDbType.Int, null, false, creatorID), 
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
		/// Update values in Creator. Returns an object of type Creator.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="creatorID">Unique identifier for each Creator record.</param>
		/// <param name="creatorName">Creator name in last name first order.</param>
		/// <param name="firstNameFirst">Creator name in first name first order.</param>
		/// <param name="simpleName">Name using simple English alphabet (first name first).</param>
		/// <param name="dOB">Creator's date of birth.</param>
		/// <param name="dOD">Creator's date of death.</param>
		/// <param name="biography">Biography of the Creator.</param>
		/// <param name="creatorNote">Notes about this Creator.</param>
		/// <param name="mARCDataFieldTag">MARC XML DataFieldTag providing this record.</param>
		/// <param name="mARCCreator_a">"a" field from MARC XML</param>
		/// <param name="mARCCreator_b">"b" field from MARC XML</param>
		/// <param name="mARCCreator_c">"c" field from MARC XML</param>
		/// <param name="mARCCreator_d">"d" field from MARC XML</param>
		/// <param name="mARCCreator_Full">"Full" Creator information from MARC XML</param>
		/// <returns>Object of type Creator.</returns>
		public Creator CreatorUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			int creatorID,
			string creatorName,
			string firstNameFirst,
			string simpleName,
			string dOB,
			string dOD,
			string biography,
			string creatorNote,
			string mARCDataFieldTag,
			string mARCCreator_a,
			string mARCCreator_b,
			string mARCCreator_c,
			string mARCCreator_d,
			string mARCCreator_Full)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
			SqlTransaction transaction = sqlTransaction;
			
			using (SqlCommand command = CustomSqlHelper.CreateCommand("CreatorUpdateAuto", connection, transaction, 
				CustomSqlHelper.CreateInputParameter("CreatorID", SqlDbType.Int, null, false, creatorID),
					CustomSqlHelper.CreateInputParameter("CreatorName", SqlDbType.NVarChar, 255, false, creatorName),
					CustomSqlHelper.CreateInputParameter("FirstNameFirst", SqlDbType.NVarChar, 255, true, firstNameFirst),
					CustomSqlHelper.CreateInputParameter("SimpleName", SqlDbType.NVarChar, 255, true, simpleName),
					CustomSqlHelper.CreateInputParameter("DOB", SqlDbType.NVarChar, 50, true, dOB),
					CustomSqlHelper.CreateInputParameter("DOD", SqlDbType.NVarChar, 50, true, dOD),
					CustomSqlHelper.CreateInputParameter("Biography", SqlDbType.NText, 1073741823, true, biography),
					CustomSqlHelper.CreateInputParameter("CreatorNote", SqlDbType.NVarChar, 255, true, creatorNote),
					CustomSqlHelper.CreateInputParameter("MARCDataFieldTag", SqlDbType.NVarChar, 3, true, mARCDataFieldTag),
					CustomSqlHelper.CreateInputParameter("MARCCreator_a", SqlDbType.NVarChar, 450, true, mARCCreator_a),
					CustomSqlHelper.CreateInputParameter("MARCCreator_b", SqlDbType.NVarChar, 450, true, mARCCreator_b),
					CustomSqlHelper.CreateInputParameter("MARCCreator_c", SqlDbType.NVarChar, 450, true, mARCCreator_c),
					CustomSqlHelper.CreateInputParameter("MARCCreator_d", SqlDbType.NVarChar, 450, true, mARCCreator_d),
					CustomSqlHelper.CreateInputParameter("MARCCreator_Full", SqlDbType.NVarChar, 450, true, mARCCreator_Full), 
					CustomSqlHelper.CreateReturnValueParameter("ReturnCode", SqlDbType.Int, null, false)))
			{
				using (CustomSqlHelper<Creator> helper = new CustomSqlHelper<Creator>())
				{
					CustomGenericList<Creator> list = helper.ExecuteReader(command);
					if (list.Count > 0)
					{
						Creator o = list[0];
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
		/// Update values in Creator. Returns an object of type Creator.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Creator.</param>
		/// <returns>Object of type Creator.</returns>
		public Creator CreatorUpdateAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Creator value)
		{
			return CreatorUpdateAuto(sqlConnection, sqlTransaction,
				value.CreatorID,
				value.CreatorName,
				value.FirstNameFirst,
				value.SimpleName,
				value.DOB,
				value.DOD,
				value.Biography,
				value.CreatorNote,
				value.MARCDataFieldTag,
				value.MARCCreator_a,
				value.MARCCreator_b,
				value.MARCCreator_c,
				value.MARCCreator_d,
				value.MARCCreator_Full);
		}
		
		#endregion ===== UPDATE =====

		#region ===== MANAGE =====
		
		/// <summary>
		/// Manage Creator object.
		/// If the object is of type CustomObjectBase, 
		/// then either insert values into, delete values from, or update values in Creator.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <param name="value">Object of type Creator.</param>
		/// <returns>Object of type CustomDataAccessStatus<Creator>.</returns>
		public CustomDataAccessStatus<Creator> CreatorManageAuto(
			SqlConnection sqlConnection, 
			SqlTransaction sqlTransaction, 
			Creator value  )
		{
			if (value.IsNew && !value.IsDeleted)
			{
				
				
				Creator returnValue = CreatorInsertAuto(sqlConnection, sqlTransaction, 
					value.CreatorName,
						value.FirstNameFirst,
						value.SimpleName,
						value.DOB,
						value.DOD,
						value.Biography,
						value.CreatorNote,
						value.MARCDataFieldTag,
						value.MARCCreator_a,
						value.MARCCreator_b,
						value.MARCCreator_c,
						value.MARCCreator_d,
						value.MARCCreator_Full);
				
				return new CustomDataAccessStatus<Creator>(
					CustomDataAccessContext.Insert, 
					true, returnValue);
			}
			else if (!value.IsNew && value.IsDeleted)
			{
				if (CreatorDeleteAuto(sqlConnection, sqlTransaction, 
					value.CreatorID))
				{
				return new CustomDataAccessStatus<Creator>(
					CustomDataAccessContext.Delete, 
					true, value);
				}
				else
				{
				return new CustomDataAccessStatus<Creator>(
					CustomDataAccessContext.Delete, 
					false, value);
				}
			}
			else if (value.IsDirty && !value.IsDeleted)
			{
				
				Creator returnValue = CreatorUpdateAuto(sqlConnection, sqlTransaction, 
					value.CreatorID,
						value.CreatorName,
						value.FirstNameFirst,
						value.SimpleName,
						value.DOB,
						value.DOD,
						value.Biography,
						value.CreatorNote,
						value.MARCDataFieldTag,
						value.MARCCreator_a,
						value.MARCCreator_b,
						value.MARCCreator_c,
						value.MARCCreator_d,
						value.MARCCreator_Full);
					
				return new CustomDataAccessStatus<Creator>(
					CustomDataAccessContext.Update, 
					true, returnValue);
			}
			else
			{
				return new CustomDataAccessStatus<Creator>(
					CustomDataAccessContext.NA, 
					false, value);
			}
		}
		
		#endregion ===== MANAGE =====

	}	
}
// end of source generation
