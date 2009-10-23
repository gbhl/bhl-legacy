
// Generated 7/30/2008 3:15:22 PM
// Do not modify the contents of this code file.
// This abstract class __Title_TitleIdentifier is based upon Title_TitleIdentifier.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// It is recommended the code file you create be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DataObjects
// {
//		[Serializable]
// 		public class Title_TitleIdentifier : __Title_TitleIdentifier
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
	public abstract class __Title_TitleIdentifier : CustomObjectBase, ICloneable, IComparable, IDisposable, ISetValues
	{
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public __Title_TitleIdentifier()
		{
		}

		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="title_TitleIdentifierID"></param>
		/// <param name="titleID"></param>
		/// <param name="titleIdentifierID"></param>
		/// <param name="identifierValue"></param>
		/// <param name="creationDate"></param>
		/// <param name="lastModifiedDate"></param>
		public __Title_TitleIdentifier(int title_TitleIdentifierID, 
			int titleID, 
			int titleIdentifierID, 
			string identifierValue, 
			DateTime? creationDate, 
			DateTime? lastModifiedDate) : this()
		{
			_Title_TitleIdentifierID = title_TitleIdentifierID;
			TitleID = titleID;
			TitleIdentifierID = titleIdentifierID;
			IdentifierValue = identifierValue;
			CreationDate = creationDate;
			LastModifiedDate = lastModifiedDate;
		}
		
		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
		~__Title_TitleIdentifier()
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
					case "Title_TitleIdentifierID" :
					{
						_Title_TitleIdentifierID = (int)column.Value;
						break;
					}
					case "TitleID" :
					{
						_TitleID = (int)column.Value;
						break;
					}
					case "TitleIdentifierID" :
					{
						_TitleIdentifierID = (int)column.Value;
						break;
					}
					case "IdentifierValue" :
					{
						_IdentifierValue = (string)column.Value;
						break;
					}
					case "CreationDate" :
					{
						_CreationDate = (DateTime?)column.Value;
						break;
					}
					case "LastModifiedDate" :
					{
						_LastModifiedDate = (DateTime?)column.Value;
						break;
					}
				}
			}
			
			IsNew = false;
		}
		
		#endregion Set Values
		
		#region Properties		
		
		#region Title_TitleIdentifierID
		
		private int _Title_TitleIdentifierID = default(int);
		
		/// <summary>
		/// Column: Title_TitleIdentifierID;
		/// DBMS data type: int; Auto key;
		/// </summary>
		[ColumnDefinition("Title_TitleIdentifierID", DbTargetType=SqlDbType.Int, Ordinal=1, NumericPrecision=10, IsAutoKey=true, IsInPrimaryKey=true)]
		public int Title_TitleIdentifierID
		{
			get
			{
				return _Title_TitleIdentifierID;
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
		
		#endregion Title_TitleIdentifierID
		
		#region TitleID
		
		private int _TitleID = default(int);
		
		/// <summary>
		/// Column: TitleID;
		/// DBMS data type: int;
		/// </summary>
		[ColumnDefinition("TitleID", DbTargetType=SqlDbType.Int, Ordinal=2, NumericPrecision=10, IsInForeignKey=true)]
		public int TitleID
		{
			get
			{
				return _TitleID;
			}
			set
			{
				if (_TitleID != value)
				{
					_TitleID = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion TitleID
		
		#region TitleIdentifierID
		
		private int _TitleIdentifierID = default(int);
		
		/// <summary>
		/// Column: TitleIdentifierID;
		/// DBMS data type: int;
		/// </summary>
		[ColumnDefinition("TitleIdentifierID", DbTargetType=SqlDbType.Int, Ordinal=3, NumericPrecision=10, IsInForeignKey=true)]
		public int TitleIdentifierID
		{
			get
			{
				return _TitleIdentifierID;
			}
			set
			{
				if (_TitleIdentifierID != value)
				{
					_TitleIdentifierID = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion TitleIdentifierID
		
		#region IdentifierValue
		
		private string _IdentifierValue = string.Empty;
		
		/// <summary>
		/// Column: IdentifierValue;
		/// DBMS data type: nvarchar(125);
		/// </summary>
		[ColumnDefinition("IdentifierValue", DbTargetType=SqlDbType.NVarChar, Ordinal=4, CharacterMaxLength=125)]
		public string IdentifierValue
		{
			get
			{
				return _IdentifierValue;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 125);
				if (_IdentifierValue != value)
				{
					_IdentifierValue = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion IdentifierValue
		
		#region CreationDate
		
		private DateTime? _CreationDate = null;
		
		/// <summary>
		/// Column: CreationDate;
		/// DBMS data type: datetime; Nullable;
		/// </summary>
		[ColumnDefinition("CreationDate", DbTargetType=SqlDbType.DateTime, Ordinal=5, IsNullable=true)]
		public DateTime? CreationDate
		{
			get
			{
				return _CreationDate;
			}
			set
			{
				if (_CreationDate != value)
				{
					_CreationDate = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion CreationDate
		
		#region LastModifiedDate
		
		private DateTime? _LastModifiedDate = null;
		
		/// <summary>
		/// Column: LastModifiedDate;
		/// DBMS data type: datetime; Nullable;
		/// </summary>
		[ColumnDefinition("LastModifiedDate", DbTargetType=SqlDbType.DateTime, Ordinal=6, IsNullable=true)]
		public DateTime? LastModifiedDate
		{
			get
			{
				return _LastModifiedDate;
			}
			set
			{
				if (_LastModifiedDate != value)
				{
					_LastModifiedDate = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion LastModifiedDate
			
		#endregion Properties
				
		#region From Array serialization
		
		/// <summary>
		/// Deserializes the byte array and returns an instance of <see cref="__Title_TitleIdentifier"/>.
		/// </summary>
		/// <returns>If the byte array can be deserialized and cast to an instance of <see cref="__Title_TitleIdentifier"/>, 
		/// returns an instance of <see cref="__Title_TitleIdentifier"/>; otherwise returns null.</returns>
		public static new __Title_TitleIdentifier FromArray(byte[] byteArray)
		{
			__Title_TitleIdentifier o = null;
			
			try
			{
				o = (__Title_TitleIdentifier) CustomObjectBase.FromArray(byteArray);
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
		/// Compares this instance with a specified object. Throws an ArgumentException if the specified object is not of type <see cref="__Title_TitleIdentifier"/>.
		/// </summary>
		/// <param name="obj">An <see cref="__Title_TitleIdentifier"/> object to compare with this instance.</param>
		/// <returns>0 if the specified object equals this instance; -1 if the specified object does not equal this instance.</returns>
		public virtual int CompareTo(Object obj)
		{
			if (obj is __Title_TitleIdentifier)
			{
				__Title_TitleIdentifier o = (__Title_TitleIdentifier) obj;
				
				if (
					o.IsNew == IsNew &&
					o.IsDeleted == IsDeleted &&
					o.Title_TitleIdentifierID == Title_TitleIdentifierID &&
					o.TitleID == TitleID &&
					o.TitleIdentifierID == TitleIdentifierID &&
					GetComparisonString(o.IdentifierValue) == GetComparisonString(IdentifierValue) &&
					o.CreationDate == CreationDate &&
					o.LastModifiedDate == LastModifiedDate 
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
				throw new ArgumentException("Argument is not of type __Title_TitleIdentifier");
			}
		}
 		
		#endregion CompareTo
		
		#region Operators
		
		/// <summary>
		/// Equality operator (==) returns true if the values of its operands are equal, false otherwise.
		/// </summary>
		/// <param name="a">The first <see cref="__Title_TitleIdentifier"/> object to compare.</param>
		/// <param name="b">The second <see cref="__Title_TitleIdentifier"/> object to compare.</param>
		/// <returns>true if values of operands are equal, false otherwise.</returns>
		public static bool operator == (__Title_TitleIdentifier a, __Title_TitleIdentifier b)
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
		/// <param name="a">The first <see cref="__Title_TitleIdentifier"/> object to compare.</param>
		/// <param name="b">The second <see cref="__Title_TitleIdentifier"/> object to compare.</param>
		/// <returns>false if values of operands are equal, false otherwise.</returns>
		public static bool operator !=(__Title_TitleIdentifier a, __Title_TitleIdentifier b)
		{
			return !(a == b);
		}
		
		/// <summary>
		/// Returns true the specified object is equal to this object instance, false otherwise.
		/// </summary>
		/// <param name="obj">The <see cref="__Title_TitleIdentifier"/> object to compare with the current <see cref="__Title_TitleIdentifier"/>.</param>
		/// <returns>true if specified object is equal to the instance of this object, false otherwise.</returns>
		public override bool Equals(Object obj)
		{
			if (!(obj is __Title_TitleIdentifier))
			{
				return false;
			}
			
			return this == (__Title_TitleIdentifier) obj;
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
		/// list.Sort(SortOrder.Ascending, __Title_TitleIdentifier.SortColumn.Title_TitleIdentifierID);
		/// </summary>
		[Serializable]
		public sealed class SortColumn
		{	
			public const string Title_TitleIdentifierID = "Title_TitleIdentifierID";	
			public const string TitleID = "TitleID";	
			public const string TitleIdentifierID = "TitleIdentifierID";	
			public const string IdentifierValue = "IdentifierValue";	
			public const string CreationDate = "CreationDate";	
			public const string LastModifiedDate = "LastModifiedDate";
		}
				
		#endregion SortColumn
	}
}
// end of source generation
