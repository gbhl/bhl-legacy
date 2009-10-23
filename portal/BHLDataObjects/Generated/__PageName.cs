
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This abstract class __PageName is based upon PageName.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// It is recommended the code file you create be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DataObjects
// {
//		[Serializable]
// 		public class PageName : __PageName
//		{
//		}
// }

#endregion How To Implement

#region Using 

using System;
using System.Data;
using CustomDataAccess;

#endregion Using

namespace MOBOT.BHL.DataObjects
{	
	[Serializable]
	public abstract class __PageName : CustomObjectBase, ICloneable, IComparable, IDisposable, ISetValues
	{
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public __PageName()
		{
		}

		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="pageNameID"></param>
		/// <param name="pageID"></param>
		/// <param name="source"></param>
		/// <param name="nameFound"></param>
		/// <param name="nameConfirmed"></param>
		/// <param name="nameBankID"></param>
		/// <param name="active"></param>
		/// <param name="createDate"></param>
		/// <param name="lastUpdateDate"></param>
		/// <param name="isCommonName"></param>
		public __PageName(int pageNameID, 
			int pageID, 
			string source, 
			string nameFound, 
			string nameConfirmed, 
			int? nameBankID, 
			bool active, 
			DateTime createDate, 
			DateTime lastUpdateDate, 
			bool? isCommonName) : this()
		{
			_PageNameID = pageNameID;
			PageID = pageID;
			Source = source;
			NameFound = nameFound;
			NameConfirmed = nameConfirmed;
			NameBankID = nameBankID;
			Active = active;
			CreateDate = createDate;
			LastUpdateDate = lastUpdateDate;
			IsCommonName = isCommonName;
		}
		
		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
		~__PageName()
		{
		}
		
		#endregion Destructor
		
		#region Set Values
		
		/// <summary>
		/// Set the property values of this instance from the specified <see cref="CustomDataRow"/>.
		/// </summary>
		public virtual void SetValues(CustomDataRow row)
		{
			foreach (CustomDataColumn column in row)
			{
				switch (column.Name)
				{
					case "PageNameID" :
					{
						_PageNameID = (int)column.Value;
						break;
					}
					case "PageID" :
					{
						_PageID = (int)column.Value;
						break;
					}
					case "Source" :
					{
						_Source = (string)column.Value;
						break;
					}
					case "NameFound" :
					{
						_NameFound = (string)column.Value;
						break;
					}
					case "NameConfirmed" :
					{
						_NameConfirmed = (string)column.Value;
						break;
					}
					case "NameBankID" :
					{
						_NameBankID = (int?)column.Value;
						break;
					}
					case "Active" :
					{
						_Active = (bool)column.Value;
						break;
					}
					case "CreateDate" :
					{
						_CreateDate = (DateTime)column.Value;
						break;
					}
					case "LastUpdateDate" :
					{
						_LastUpdateDate = (DateTime)column.Value;
						break;
					}
					case "IsCommonName" :
					{
						_IsCommonName = (bool?)column.Value;
						break;
					}
				}
			}
			
			IsNew = false;
		}
		
		#endregion Set Values
		
		#region Properties		
		
		#region PageNameID
		
		private int _PageNameID = default(int);
		
		/// <summary>
		/// Column: PageNameID;
		/// DBMS data type: int; Auto key;
		/// </summary>
		[ColumnDefinition("PageNameID", DbTargetType=SqlDbType.Int, Ordinal=1, NumericPrecision=10, IsAutoKey=true, IsInPrimaryKey=true)]
		public int PageNameID
		{
			get
			{
				return _PageNameID;
			}
			set
			{
				// NOTE: This dummy setter provides a work-around for the following: Read-only properties cannot be exposed by XML Web Services
				// see http://support.microsoft.com/kb/313584
				// Cause: When an object is passed i.e. marshalled to or from a Web service, it must be serialized into an XML stream and then deserialized back into an object.
				// The XML Serializer cannot deserialize the XML back into an object because it cannot load the read-only properties. 
				// Thus the read-only properties are not exposed through the Web Services Description Language (WSDL). 
				// Because the Web service proxy is generated from the WSDL, the proxy also excludes any read-only properties.
			}
		}
		
		#endregion PageNameID
		
		#region PageID
		
		private int _PageID = default(int);
		
		/// <summary>
		/// Column: PageID;
		/// DBMS data type: int;
		/// </summary>
		[ColumnDefinition("PageID", DbTargetType=SqlDbType.Int, Ordinal=2, NumericPrecision=10, IsInForeignKey=true)]
		public int PageID
		{
			get
			{
				return _PageID;
			}
			set
			{
				if (_PageID != value)
				{
					_PageID = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion PageID
		
		#region Source
		
		private string _Source = null;
		
		/// <summary>
		/// Column: Source;
		/// DBMS data type: nvarchar(50); Nullable;
		/// </summary>
		[ColumnDefinition("Source", DbTargetType=SqlDbType.NVarChar, Ordinal=3, CharacterMaxLength=50, IsNullable=true)]
		public string Source
		{
			get
			{
				return _Source;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 50);
				if (_Source != value)
				{
					_Source = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion Source
		
		#region NameFound
		
		private string _NameFound = string.Empty;
		
		/// <summary>
		/// Column: NameFound;
		/// DBMS data type: nvarchar(100);
		/// </summary>
		[ColumnDefinition("NameFound", DbTargetType=SqlDbType.NVarChar, Ordinal=4, CharacterMaxLength=100)]
		public string NameFound
		{
			get
			{
				return _NameFound;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 100);
				if (_NameFound != value)
				{
					_NameFound = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion NameFound
		
		#region NameConfirmed
		
		private string _NameConfirmed = null;
		
		/// <summary>
		/// Column: NameConfirmed;
		/// DBMS data type: nvarchar(100); Nullable;
		/// </summary>
		[ColumnDefinition("NameConfirmed", DbTargetType=SqlDbType.NVarChar, Ordinal=5, CharacterMaxLength=100, IsNullable=true)]
		public string NameConfirmed
		{
			get
			{
				return _NameConfirmed;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 100);
				if (_NameConfirmed != value)
				{
					_NameConfirmed = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion NameConfirmed
		
		#region NameBankID
		
		private int? _NameBankID = null;
		
		/// <summary>
		/// Column: NameBankID;
		/// DBMS data type: int; Nullable;
		/// </summary>
		[ColumnDefinition("NameBankID", DbTargetType=SqlDbType.Int, Ordinal=6, NumericPrecision=10, IsNullable=true)]
		public int? NameBankID
		{
			get
			{
				return _NameBankID;
			}
			set
			{
				if (_NameBankID != value)
				{
					_NameBankID = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion NameBankID
		
		#region Active
		
		private bool _Active = false;
		
		/// <summary>
		/// Column: Active;
		/// DBMS data type: bit;
		/// </summary>
		[ColumnDefinition("Active", DbTargetType=SqlDbType.Bit, Ordinal=7)]
		public bool Active
		{
			get
			{
				return _Active;
			}
			set
			{
				if (_Active != value)
				{
					_Active = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion Active
		
		#region CreateDate
		
		private DateTime _CreateDate;
		
		/// <summary>
		/// Column: CreateDate;
		/// DBMS data type: datetime;
		/// Description: CreationDate
		/// </summary>
		[ColumnDefinition("CreateDate", DbTargetType=SqlDbType.DateTime, Ordinal=8, Description="CreationDate")]
		public DateTime CreateDate
		{
			get
			{
				return _CreateDate;
			}
			set
			{
				if (_CreateDate != value)
				{
					_CreateDate = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion CreateDate
		
		#region LastUpdateDate
		
		private DateTime _LastUpdateDate;
		
		/// <summary>
		/// Column: LastUpdateDate;
		/// DBMS data type: datetime;
		/// Description: LastModifiedDate
		/// </summary>
		[ColumnDefinition("LastUpdateDate", DbTargetType=SqlDbType.DateTime, Ordinal=9, Description="LastModifiedDate")]
		public DateTime LastUpdateDate
		{
			get
			{
				return _LastUpdateDate;
			}
			set
			{
				if (_LastUpdateDate != value)
				{
					_LastUpdateDate = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion LastUpdateDate
		
		#region IsCommonName
		
		private bool? _IsCommonName = null;
		
		/// <summary>
		/// Column: IsCommonName;
		/// DBMS data type: bit; Nullable;
		/// </summary>
		[ColumnDefinition("IsCommonName", DbTargetType=SqlDbType.Bit, Ordinal=10, IsNullable=true)]
		public bool? IsCommonName
		{
			get
			{
				return _IsCommonName;
			}
			set
			{
				if (_IsCommonName != value)
				{
					_IsCommonName = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion IsCommonName
			
		#endregion Properties
				
		#region From Array serialization
		
		/// <summary>
		/// Deserializes the byte array and returns an instance of <see cref="__PageName"/>.
		/// </summary>
		/// <returns>If the byte array can be deserialized and cast to an instance of <see cref="__PageName"/>, 
		/// returns an instance of <see cref="__PageName"/>; otherwise returns null.</returns>
		public static new __PageName FromArray(byte[] byteArray)
		{
			__PageName o = null;
			
			try
			{
				o = (__PageName) CustomObjectBase.FromArray(byteArray);
			}
			catch (Exception e)
			{
				throw e;
			}

			return o;
		}
		
		#endregion From Array serialization

		#region CompareTo
		
		/// <summary>
		/// Compares this instance with a specified object. Throws an ArgumentException if the specified object is not of type <see cref="__PageName"/>.
		/// </summary>
		/// <param name="obj">An <see cref="__PageName"/> object to compare with this instance.</param>
		/// <returns>0 if the specified object equals this instance; -1 if the specified object does not equal this instance.</returns>
		public virtual int CompareTo(Object obj)
		{
			if (obj is __PageName)
			{
				__PageName o = (__PageName) obj;
				
				if (
					o.IsNew == IsNew &&
					o.IsDeleted == IsDeleted &&
					o.PageNameID == PageNameID &&
					o.PageID == PageID &&
					GetComparisonString(o.Source) == GetComparisonString(Source) &&
					GetComparisonString(o.NameFound) == GetComparisonString(NameFound) &&
					GetComparisonString(o.NameConfirmed) == GetComparisonString(NameConfirmed) &&
					o.NameBankID == NameBankID &&
					o.Active == Active &&
					o.CreateDate == CreateDate &&
					o.LastUpdateDate == LastUpdateDate &&
					o.IsCommonName == IsCommonName 
				)
				{
					o = null;
					return 0; // true
				}
				else
				{
					o = null;
					return -1; // false
				}
			}
			else
			{
				throw new ArgumentException("Argument is not of type __PageName");
			}
		}
 		
		#endregion CompareTo
		
		#region Operators
		
		/// <summary>
		/// Equality operator (==) returns true if the values of its operands are equal, false otherwise.
		/// </summary>
		/// <param name="a">The first <see cref="__PageName"/> object to compare.</param>
		/// <param name="b">The second <see cref="__PageName"/> object to compare.</param>
		/// <returns>true if values of operands are equal, false otherwise.</returns>
		public static bool operator == (__PageName a, __PageName b)
		{
			if (((Object) a) == null || ((Object) b) == null)
			{
				if (((Object) a) == null && ((Object) b) == null)
				{
					return true;
				}
			}
			else
			{
				int r = a.CompareTo(b);
				
				if (r == 0)
				{
					return true;
				}
				else
				{
					return false;
				}
			}
			
			return false;
		}
		
		/// <summary>
		/// Inequality operator (!=) returns false if its operands are equal, true otherwise.
		/// </summary>
		/// <param name="a">The first <see cref="__PageName"/> object to compare.</param>
		/// <param name="b">The second <see cref="__PageName"/> object to compare.</param>
		/// <returns>false if values of operands are equal, false otherwise.</returns>
		public static bool operator !=(__PageName a, __PageName b)
		{
			return !(a == b);
		}
		
		/// <summary>
		/// Returns true the specified object is equal to this object instance, false otherwise.
		/// </summary>
		/// <param name="obj">The <see cref="__PageName"/> object to compare with the current <see cref="__PageName"/>.</param>
		/// <returns>true if specified object is equal to the instance of this object, false otherwise.</returns>
		public override bool Equals(Object obj)
		{
			if (!(obj is __PageName))
			{
				return false;
			}
			
			return this == (__PageName) obj;
		}
	
        /// <summary>
        /// Returns the hash code for this instance.
        /// </summary>
        /// <returns>Hash code for this instance as an integer.</returns>
		public override int GetHashCode()
		{
			return base.GetHashCode();
		}
		
		#endregion Operators
		
		#region SortColumn
		
		/// <summary>
		/// Use when defining sort columns for a collection sort request.
		/// For example where list is a instance of <see cref="CustomGenericList">, 
		/// list.Sort(SortOrder.Ascending, __PageName.SortColumn.PageNameID);
		/// </summary>
		[Serializable]
		public sealed class SortColumn
		{	
			public const string PageNameID = "PageNameID";	
			public const string PageID = "PageID";	
			public const string Source = "Source";	
			public const string NameFound = "NameFound";	
			public const string NameConfirmed = "NameConfirmed";	
			public const string NameBankID = "NameBankID";	
			public const string Active = "Active";	
			public const string CreateDate = "CreateDate";	
			public const string LastUpdateDate = "LastUpdateDate";	
			public const string IsCommonName = "IsCommonName";
		}
				
		#endregion SortColumn
	}
}
// end of source generation
