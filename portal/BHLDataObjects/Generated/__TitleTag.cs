
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This abstract class __TitleTag is based upon TitleTag.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// It is recommended the code file you create be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DataObjects
// {
//		[Serializable]
// 		public class TitleTag : __TitleTag
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
	public abstract class __TitleTag : CustomObjectBase, ICloneable, IComparable, IDisposable, ISetValues
	{
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public __TitleTag()
		{
		}

		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="titleID"></param>
		/// <param name="tagText"></param>
		/// <param name="marcDataFieldTag"></param>
		/// <param name="marcSubFieldCode"></param>
		/// <param name="creationDate"></param>
		/// <param name="lastModifiedDate"></param>
		public __TitleTag(int titleID, 
			string tagText, 
			string marcDataFieldTag, 
			string marcSubFieldCode, 
			DateTime? creationDate, 
			DateTime? lastModifiedDate) : this()
		{
			TitleID = titleID;
			TagText = tagText;
			MarcDataFieldTag = marcDataFieldTag;
			MarcSubFieldCode = marcSubFieldCode;
			CreationDate = creationDate;
			LastModifiedDate = lastModifiedDate;
		}
		
		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
		~__TitleTag()
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
					case "TitleID" :
					{
						_TitleID = (int)column.Value;
						break;
					}
					case "TagText" :
					{
						_TagText = (string)column.Value;
						break;
					}
					case "MarcDataFieldTag" :
					{
						_MarcDataFieldTag = (string)column.Value;
						break;
					}
					case "MarcSubFieldCode" :
					{
						_MarcSubFieldCode = (string)column.Value;
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
		
		#region TitleID
		
		private int _TitleID = default(int);
		
		/// <summary>
		/// Column: TitleID;
		/// DBMS data type: int;
		/// </summary>
		[ColumnDefinition("TitleID", DbTargetType=SqlDbType.Int, Ordinal=1, NumericPrecision=10, IsInForeignKey=true, IsInPrimaryKey=true)]
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
		
		#region TagText
		
		private string _TagText = string.Empty;
		
		/// <summary>
		/// Column: TagText;
		/// DBMS data type: nvarchar(50);
		/// </summary>
		[ColumnDefinition("TagText", DbTargetType=SqlDbType.NVarChar, Ordinal=2, CharacterMaxLength=50, IsInPrimaryKey=true)]
		public string TagText
		{
			get
			{
				return _TagText;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 50);
				if (_TagText != value)
				{
					_TagText = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion TagText
		
		#region MarcDataFieldTag
		
		private string _MarcDataFieldTag = null;
		
		/// <summary>
		/// Column: MarcDataFieldTag;
		/// DBMS data type: nvarchar(50); Nullable;
		/// </summary>
		[ColumnDefinition("MarcDataFieldTag", DbTargetType=SqlDbType.NVarChar, Ordinal=3, CharacterMaxLength=50, IsNullable=true)]
		public string MarcDataFieldTag
		{
			get
			{
				return _MarcDataFieldTag;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 50);
				if (_MarcDataFieldTag != value)
				{
					_MarcDataFieldTag = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion MarcDataFieldTag
		
		#region MarcSubFieldCode
		
		private string _MarcSubFieldCode = null;
		
		/// <summary>
		/// Column: MarcSubFieldCode;
		/// DBMS data type: nvarchar(50); Nullable;
		/// </summary>
		[ColumnDefinition("MarcSubFieldCode", DbTargetType=SqlDbType.NVarChar, Ordinal=4, CharacterMaxLength=50, IsNullable=true)]
		public string MarcSubFieldCode
		{
			get
			{
				return _MarcSubFieldCode;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 50);
				if (_MarcSubFieldCode != value)
				{
					_MarcSubFieldCode = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion MarcSubFieldCode
		
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
		/// Deserializes the byte array and returns an instance of <see cref="__TitleTag"/>.
		/// </summary>
		/// <returns>If the byte array can be deserialized and cast to an instance of <see cref="__TitleTag"/>, 
		/// returns an instance of <see cref="__TitleTag"/>; otherwise returns null.</returns>
		public static new __TitleTag FromArray(byte[] byteArray)
		{
			__TitleTag o = null;
			
			try
			{
				o = (__TitleTag) CustomObjectBase.FromArray(byteArray);
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
		/// Compares this instance with a specified object. Throws an ArgumentException if the specified object is not of type <see cref="__TitleTag"/>.
		/// </summary>
		/// <param name="obj">An <see cref="__TitleTag"/> object to compare with this instance.</param>
		/// <returns>0 if the specified object equals this instance; -1 if the specified object does not equal this instance.</returns>
		public virtual int CompareTo(Object obj)
		{
			if (obj is __TitleTag)
			{
				__TitleTag o = (__TitleTag) obj;
				
				if (
					o.IsNew == IsNew &&
					o.IsDeleted == IsDeleted &&
					o.TitleID == TitleID &&
					GetComparisonString(o.TagText) == GetComparisonString(TagText) &&
					GetComparisonString(o.MarcDataFieldTag) == GetComparisonString(MarcDataFieldTag) &&
					GetComparisonString(o.MarcSubFieldCode) == GetComparisonString(MarcSubFieldCode) &&
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
				throw new ArgumentException("Argument is not of type __TitleTag");
			}
		}
 		
		#endregion CompareTo
		
		#region Operators
		
		/// <summary>
		/// Equality operator (==) returns true if the values of its operands are equal, false otherwise.
		/// </summary>
		/// <param name="a">The first <see cref="__TitleTag"/> object to compare.</param>
		/// <param name="b">The second <see cref="__TitleTag"/> object to compare.</param>
		/// <returns>true if values of operands are equal, false otherwise.</returns>
		public static bool operator == (__TitleTag a, __TitleTag b)
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
		/// <param name="a">The first <see cref="__TitleTag"/> object to compare.</param>
		/// <param name="b">The second <see cref="__TitleTag"/> object to compare.</param>
		/// <returns>false if values of operands are equal, false otherwise.</returns>
		public static bool operator !=(__TitleTag a, __TitleTag b)
		{
			return !(a == b);
		}
		
		/// <summary>
		/// Returns true the specified object is equal to this object instance, false otherwise.
		/// </summary>
		/// <param name="obj">The <see cref="__TitleTag"/> object to compare with the current <see cref="__TitleTag"/>.</param>
		/// <returns>true if specified object is equal to the instance of this object, false otherwise.</returns>
		public override bool Equals(Object obj)
		{
			if (!(obj is __TitleTag))
			{
				return false;
			}
			
			return this == (__TitleTag) obj;
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
		/// list.Sort(SortOrder.Ascending, __TitleTag.SortColumn.TitleID);
		/// </summary>
		[Serializable]
		public sealed class SortColumn
		{	
			public const string TitleID = "TitleID";	
			public const string TagText = "TagText";	
			public const string MarcDataFieldTag = "MarcDataFieldTag";	
			public const string MarcSubFieldCode = "MarcSubFieldCode";	
			public const string CreationDate = "CreationDate";	
			public const string LastModifiedDate = "LastModifiedDate";
		}
				
		#endregion SortColumn
	}
}
// end of source generation
