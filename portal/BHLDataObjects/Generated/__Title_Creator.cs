
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This abstract class __Title_Creator is based upon Title_Creator.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// It is recommended the code file you create be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DataObjects
// {
//		[Serializable]
// 		public class Title_Creator : __Title_Creator
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
	public abstract class __Title_Creator : CustomObjectBase, ICloneable, IComparable, IDisposable, ISetValues
	{
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public __Title_Creator()
		{
		}

		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="title_CreatorID"></param>
		/// <param name="titleID"></param>
		/// <param name="creatorID"></param>
		/// <param name="creatorRoleTypeID"></param>
		/// <param name="creationDate"></param>
		/// <param name="lastModifiedDate"></param>
		/// <param name="creationUserID"></param>
		/// <param name="lastModifiedUserID"></param>
		public __Title_Creator(int title_CreatorID, 
			int titleID, 
			int creatorID, 
			int creatorRoleTypeID, 
			DateTime? creationDate, 
			DateTime? lastModifiedDate, 
			int? creationUserID, 
			int? lastModifiedUserID) : this()
		{
			_Title_CreatorID = title_CreatorID;
			TitleID = titleID;
			CreatorID = creatorID;
			CreatorRoleTypeID = creatorRoleTypeID;
			CreationDate = creationDate;
			LastModifiedDate = lastModifiedDate;
			CreationUserID = creationUserID;
			LastModifiedUserID = lastModifiedUserID;
		}
		
		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
		~__Title_Creator()
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
					case "Title_CreatorID" :
					{
						_Title_CreatorID = (int)column.Value;
						break;
					}
					case "TitleID" :
					{
						_TitleID = (int)column.Value;
						break;
					}
					case "CreatorID" :
					{
						_CreatorID = (int)column.Value;
						break;
					}
					case "CreatorRoleTypeID" :
					{
						_CreatorRoleTypeID = (int)column.Value;
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
					case "CreationUserID" :
					{
						_CreationUserID = (int?)column.Value;
						break;
					}
					case "LastModifiedUserID" :
					{
						_LastModifiedUserID = (int?)column.Value;
						break;
					}
				}
			}
			
			IsNew = false;
		}
		
		#endregion Set Values
		
		#region Properties		
		
		#region Title_CreatorID
		
		private int _Title_CreatorID = default(int);
		
		/// <summary>
		/// Column: Title_CreatorID;
		/// DBMS data type: int; Auto key;
		/// </summary>
		[ColumnDefinition("Title_CreatorID", DbTargetType=SqlDbType.Int, Ordinal=1, NumericPrecision=10, IsAutoKey=true, IsInPrimaryKey=true)]
		public int Title_CreatorID
		{
			get
			{
				return _Title_CreatorID;
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
		
		#endregion Title_CreatorID
		
		#region TitleID
		
		private int _TitleID = default(int);
		
		/// <summary>
		/// Column: TitleID;
		/// DBMS data type: int;
		/// Description: Unique identifier for each Title record.
		/// </summary>
		[ColumnDefinition("TitleID", DbTargetType=SqlDbType.Int, Ordinal=2, Description="Unique identifier for each Title record.", NumericPrecision=10, IsInForeignKey=true)]
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
		
		#region CreatorID
		
		private int _CreatorID = default(int);
		
		/// <summary>
		/// Column: CreatorID;
		/// DBMS data type: int;
		/// Description: Unique identifier for each Creator record.
		/// </summary>
		[ColumnDefinition("CreatorID", DbTargetType=SqlDbType.Int, Ordinal=3, Description="Unique identifier for each Creator record.", NumericPrecision=10, IsInForeignKey=true)]
		public int CreatorID
		{
			get
			{
				return _CreatorID;
			}
			set
			{
				if (_CreatorID != value)
				{
					_CreatorID = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion CreatorID
		
		#region CreatorRoleTypeID
		
		private int _CreatorRoleTypeID = default(int);
		
		/// <summary>
		/// Column: CreatorRoleTypeID;
		/// DBMS data type: int;
		/// Description: Unique identifier for each Creator Role Type.
		/// </summary>
		[ColumnDefinition("CreatorRoleTypeID", DbTargetType=SqlDbType.Int, Ordinal=4, Description="Unique identifier for each Creator Role Type.", NumericPrecision=10, IsInForeignKey=true)]
		public int CreatorRoleTypeID
		{
			get
			{
				return _CreatorRoleTypeID;
			}
			set
			{
				if (_CreatorRoleTypeID != value)
				{
					_CreatorRoleTypeID = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion CreatorRoleTypeID
		
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
		
		#region CreationUserID
		
		private int? _CreationUserID = null;
		
		/// <summary>
		/// Column: CreationUserID;
		/// DBMS data type: int; Nullable;
		/// </summary>
		[ColumnDefinition("CreationUserID", DbTargetType=SqlDbType.Int, Ordinal=7, NumericPrecision=10, IsNullable=true)]
		public int? CreationUserID
		{
			get
			{
				return _CreationUserID;
			}
			set
			{
				if (_CreationUserID != value)
				{
					_CreationUserID = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion CreationUserID
		
		#region LastModifiedUserID
		
		private int? _LastModifiedUserID = null;
		
		/// <summary>
		/// Column: LastModifiedUserID;
		/// DBMS data type: int; Nullable;
		/// </summary>
		[ColumnDefinition("LastModifiedUserID", DbTargetType=SqlDbType.Int, Ordinal=8, NumericPrecision=10, IsNullable=true)]
		public int? LastModifiedUserID
		{
			get
			{
				return _LastModifiedUserID;
			}
			set
			{
				if (_LastModifiedUserID != value)
				{
					_LastModifiedUserID = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion LastModifiedUserID
			
		#endregion Properties
				
		#region From Array serialization
		
		/// <summary>
		/// Deserializes the byte array and returns an instance of <see cref="__Title_Creator"/>.
		/// </summary>
		/// <returns>If the byte array can be deserialized and cast to an instance of <see cref="__Title_Creator"/>, 
		/// returns an instance of <see cref="__Title_Creator"/>; otherwise returns null.</returns>
		public static new __Title_Creator FromArray(byte[] byteArray)
		{
			__Title_Creator o = null;
			
			try
			{
				o = (__Title_Creator) CustomObjectBase.FromArray(byteArray);
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
		/// Compares this instance with a specified object. Throws an ArgumentException if the specified object is not of type <see cref="__Title_Creator"/>.
		/// </summary>
		/// <param name="obj">An <see cref="__Title_Creator"/> object to compare with this instance.</param>
		/// <returns>0 if the specified object equals this instance; -1 if the specified object does not equal this instance.</returns>
		public virtual int CompareTo(Object obj)
		{
			if (obj is __Title_Creator)
			{
				__Title_Creator o = (__Title_Creator) obj;
				
				if (
					o.IsNew == IsNew &&
					o.IsDeleted == IsDeleted &&
					o.Title_CreatorID == Title_CreatorID &&
					o.TitleID == TitleID &&
					o.CreatorID == CreatorID &&
					o.CreatorRoleTypeID == CreatorRoleTypeID &&
					o.CreationDate == CreationDate &&
					o.LastModifiedDate == LastModifiedDate &&
					o.CreationUserID == CreationUserID &&
					o.LastModifiedUserID == LastModifiedUserID 
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
				throw new ArgumentException("Argument is not of type __Title_Creator");
			}
		}
 		
		#endregion CompareTo
		
		#region Operators
		
		/// <summary>
		/// Equality operator (==) returns true if the values of its operands are equal, false otherwise.
		/// </summary>
		/// <param name="a">The first <see cref="__Title_Creator"/> object to compare.</param>
		/// <param name="b">The second <see cref="__Title_Creator"/> object to compare.</param>
		/// <returns>true if values of operands are equal, false otherwise.</returns>
		public static bool operator == (__Title_Creator a, __Title_Creator b)
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
		/// <param name="a">The first <see cref="__Title_Creator"/> object to compare.</param>
		/// <param name="b">The second <see cref="__Title_Creator"/> object to compare.</param>
		/// <returns>false if values of operands are equal, false otherwise.</returns>
		public static bool operator !=(__Title_Creator a, __Title_Creator b)
		{
			return !(a == b);
		}
		
		/// <summary>
		/// Returns true the specified object is equal to this object instance, false otherwise.
		/// </summary>
		/// <param name="obj">The <see cref="__Title_Creator"/> object to compare with the current <see cref="__Title_Creator"/>.</param>
		/// <returns>true if specified object is equal to the instance of this object, false otherwise.</returns>
		public override bool Equals(Object obj)
		{
			if (!(obj is __Title_Creator))
			{
				return false;
			}
			
			return this == (__Title_Creator) obj;
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
		/// list.Sort(SortOrder.Ascending, __Title_Creator.SortColumn.Title_CreatorID);
		/// </summary>
		[Serializable]
		public sealed class SortColumn
		{	
			public const string Title_CreatorID = "Title_CreatorID";	
			public const string TitleID = "TitleID";	
			public const string CreatorID = "CreatorID";	
			public const string CreatorRoleTypeID = "CreatorRoleTypeID";	
			public const string CreationDate = "CreationDate";	
			public const string LastModifiedDate = "LastModifiedDate";	
			public const string CreationUserID = "CreationUserID";	
			public const string LastModifiedUserID = "LastModifiedUserID";
		}
				
		#endregion SortColumn
	}
}
// end of source generation
