
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This abstract class __CreatorRoleType is based upon CreatorRoleType.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// It is recommended the code file you create be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DataObjects
// {
//		[Serializable]
// 		public class CreatorRoleType : __CreatorRoleType
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
	public abstract class __CreatorRoleType : CustomObjectBase, ICloneable, IComparable, IDisposable, ISetValues
	{
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public __CreatorRoleType()
		{
		}

		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="creatorRoleTypeID"></param>
		/// <param name="creatorRoleType"></param>
		/// <param name="creatorRoleTypeDescription"></param>
		/// <param name="mARCDataFieldTag"></param>
		public __CreatorRoleType(int creatorRoleTypeID, 
			string creatorRoleType, 
			string creatorRoleTypeDescription, 
			string mARCDataFieldTag) : this()
		{
			CreatorRoleTypeID = creatorRoleTypeID;
			CreatorRoleType = creatorRoleType;
			CreatorRoleTypeDescription = creatorRoleTypeDescription;
			MARCDataFieldTag = mARCDataFieldTag;
		}
		
		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
		~__CreatorRoleType()
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
					case "CreatorRoleTypeID" :
					{
						_CreatorRoleTypeID = (int)column.Value;
						break;
					}
					case "CreatorRoleType" :
					{
						_CreatorRoleType = (string)column.Value;
						break;
					}
					case "CreatorRoleTypeDescription" :
					{
						_CreatorRoleTypeDescription = (string)column.Value;
						break;
					}
					case "MARCDataFieldTag" :
					{
						_MARCDataFieldTag = (string)column.Value;
						break;
					}
				}
			}
			
			IsNew = false;
		}
		
		#endregion Set Values
		
		#region Properties		
		
		#region CreatorRoleTypeID
		
		private int _CreatorRoleTypeID = default(int);
		
		/// <summary>
		/// Column: CreatorRoleTypeID;
		/// DBMS data type: int;
		/// Description: Unique identifier for each Creator Role Type.
		/// </summary>
		[ColumnDefinition("CreatorRoleTypeID", DbTargetType=SqlDbType.Int, Ordinal=1, Description="Unique identifier for each Creator Role Type.", NumericPrecision=10, IsInForeignKey=true, IsInPrimaryKey=true)]
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
		
		#region CreatorRoleType
		
		private string _CreatorRoleType = string.Empty;
		
		/// <summary>
		/// Column: CreatorRoleType;
		/// DBMS data type: nvarchar(25);
		/// Description: A type of Role performed by a Creator.
		/// </summary>
		[ColumnDefinition("CreatorRoleType", DbTargetType=SqlDbType.NVarChar, Ordinal=2, Description="A type of Role performed by a Creator.", CharacterMaxLength=25)]
		public string CreatorRoleType
		{
			get
			{
				return _CreatorRoleType;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 25);
				if (_CreatorRoleType != value)
				{
					_CreatorRoleType = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion CreatorRoleType
		
		#region CreatorRoleTypeDescription
		
		private string _CreatorRoleTypeDescription = null;
		
		/// <summary>
		/// Column: CreatorRoleTypeDescription;
		/// DBMS data type: nvarchar(255); Nullable;
		/// Description: Description of a Creator Role Type.
		/// </summary>
		[ColumnDefinition("CreatorRoleTypeDescription", DbTargetType=SqlDbType.NVarChar, Ordinal=3, Description="Description of a Creator Role Type.", CharacterMaxLength=255, IsNullable=true)]
		public string CreatorRoleTypeDescription
		{
			get
			{
				return _CreatorRoleTypeDescription;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 255);
				if (_CreatorRoleTypeDescription != value)
				{
					_CreatorRoleTypeDescription = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion CreatorRoleTypeDescription
		
		#region MARCDataFieldTag
		
		private string _MARCDataFieldTag = null;
		
		/// <summary>
		/// Column: MARCDataFieldTag;
		/// DBMS data type: nvarchar(3); Nullable;
		/// Description: Data Field Tag from MARC XML.
		/// </summary>
		[ColumnDefinition("MARCDataFieldTag", DbTargetType=SqlDbType.NVarChar, Ordinal=4, Description="Data Field Tag from MARC XML.", CharacterMaxLength=3, IsNullable=true)]
		public string MARCDataFieldTag
		{
			get
			{
				return _MARCDataFieldTag;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 3);
				if (_MARCDataFieldTag != value)
				{
					_MARCDataFieldTag = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion MARCDataFieldTag
			
		#endregion Properties
				
		#region From Array serialization
		
		/// <summary>
		/// Deserializes the byte array and returns an instance of <see cref="__CreatorRoleType"/>.
		/// </summary>
		/// <returns>If the byte array can be deserialized and cast to an instance of <see cref="__CreatorRoleType"/>, 
		/// returns an instance of <see cref="__CreatorRoleType"/>; otherwise returns null.</returns>
		public static new __CreatorRoleType FromArray(byte[] byteArray)
		{
			__CreatorRoleType o = null;
			
			try
			{
				o = (__CreatorRoleType) CustomObjectBase.FromArray(byteArray);
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
		/// Compares this instance with a specified object. Throws an ArgumentException if the specified object is not of type <see cref="__CreatorRoleType"/>.
		/// </summary>
		/// <param name="obj">An <see cref="__CreatorRoleType"/> object to compare with this instance.</param>
		/// <returns>0 if the specified object equals this instance; -1 if the specified object does not equal this instance.</returns>
		public virtual int CompareTo(Object obj)
		{
			if (obj is __CreatorRoleType)
			{
				__CreatorRoleType o = (__CreatorRoleType) obj;
				
				if (
					o.IsNew == IsNew &&
					o.IsDeleted == IsDeleted &&
					o.CreatorRoleTypeID == CreatorRoleTypeID &&
					GetComparisonString(o.CreatorRoleType) == GetComparisonString(CreatorRoleType) &&
					GetComparisonString(o.CreatorRoleTypeDescription) == GetComparisonString(CreatorRoleTypeDescription) &&
					GetComparisonString(o.MARCDataFieldTag) == GetComparisonString(MARCDataFieldTag) 
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
				throw new ArgumentException("Argument is not of type __CreatorRoleType");
			}
		}
 		
		#endregion CompareTo
		
		#region Operators
		
		/// <summary>
		/// Equality operator (==) returns true if the values of its operands are equal, false otherwise.
		/// </summary>
		/// <param name="a">The first <see cref="__CreatorRoleType"/> object to compare.</param>
		/// <param name="b">The second <see cref="__CreatorRoleType"/> object to compare.</param>
		/// <returns>true if values of operands are equal, false otherwise.</returns>
		public static bool operator == (__CreatorRoleType a, __CreatorRoleType b)
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
		/// <param name="a">The first <see cref="__CreatorRoleType"/> object to compare.</param>
		/// <param name="b">The second <see cref="__CreatorRoleType"/> object to compare.</param>
		/// <returns>false if values of operands are equal, false otherwise.</returns>
		public static bool operator !=(__CreatorRoleType a, __CreatorRoleType b)
		{
			return !(a == b);
		}
		
		/// <summary>
		/// Returns true the specified object is equal to this object instance, false otherwise.
		/// </summary>
		/// <param name="obj">The <see cref="__CreatorRoleType"/> object to compare with the current <see cref="__CreatorRoleType"/>.</param>
		/// <returns>true if specified object is equal to the instance of this object, false otherwise.</returns>
		public override bool Equals(Object obj)
		{
			if (!(obj is __CreatorRoleType))
			{
				return false;
			}
			
			return this == (__CreatorRoleType) obj;
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
		/// list.Sort(SortOrder.Ascending, __CreatorRoleType.SortColumn.CreatorRoleTypeID);
		/// </summary>
		[Serializable]
		public sealed class SortColumn
		{	
			public const string CreatorRoleTypeID = "CreatorRoleTypeID";	
			public const string CreatorRoleType = "CreatorRoleType";	
			public const string CreatorRoleTypeDescription = "CreatorRoleTypeDescription";	
			public const string MARCDataFieldTag = "MARCDataFieldTag";
		}
				
		#endregion SortColumn
	}
}
// end of source generation
