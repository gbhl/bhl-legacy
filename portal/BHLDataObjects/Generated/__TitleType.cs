
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This abstract class __TitleType is based upon TitleType.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// It is recommended the code file you create be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DataObjects
// {
//		[Serializable]
// 		public class TitleType : __TitleType
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
	public abstract class __TitleType : CustomObjectBase, ICloneable, IComparable, IDisposable, ISetValues
	{
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public __TitleType()
		{
		}

		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="titleTypeID"></param>
		/// <param name="titleType"></param>
		/// <param name="titleTypeDescription"></param>
		public __TitleType(int titleTypeID, 
			string titleType, 
			string titleTypeDescription) : this()
		{
			TitleTypeID = titleTypeID;
			TitleType = titleType;
			TitleTypeDescription = titleTypeDescription;
		}
		
		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
		~__TitleType()
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
					case "TitleTypeID" :
					{
						_TitleTypeID = (int)column.Value;
						break;
					}
					case "TitleType" :
					{
						_TitleType = (string)column.Value;
						break;
					}
					case "TitleTypeDescription" :
					{
						_TitleTypeDescription = (string)column.Value;
						break;
					}
				}
			}
			
			IsNew = false;
		}
		
		#endregion Set Values
		
		#region Properties		
		
		#region TitleTypeID
		
		private int _TitleTypeID = default(int);
		
		/// <summary>
		/// Column: TitleTypeID;
		/// DBMS data type: int;
		/// Description: Unique identifier for each Title Type record.
		/// </summary>
		[ColumnDefinition("TitleTypeID", DbTargetType=SqlDbType.Int, Ordinal=1, Description="Unique identifier for each Title Type record.", NumericPrecision=10, IsInForeignKey=true, IsInPrimaryKey=true)]
		public int TitleTypeID
		{
			get
			{
				return _TitleTypeID;
			}
			set
			{
				if (_TitleTypeID != value)
				{
					_TitleTypeID = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion TitleTypeID
		
		#region TitleType
		
		private string _TitleType = string.Empty;
		
		/// <summary>
		/// Column: TitleType;
		/// DBMS data type: nvarchar(25);
		/// Description: A Type to be associated with a Title.
		/// </summary>
		[ColumnDefinition("TitleType", DbTargetType=SqlDbType.NVarChar, Ordinal=2, Description="A Type to be associated with a Title.", CharacterMaxLength=25)]
		public string TitleType
		{
			get
			{
				return _TitleType;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 25);
				if (_TitleType != value)
				{
					_TitleType = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion TitleType
		
		#region TitleTypeDescription
		
		private string _TitleTypeDescription = null;
		
		/// <summary>
		/// Column: TitleTypeDescription;
		/// DBMS data type: nvarchar(80); Nullable;
		/// Description: Description of a Title Type.
		/// </summary>
		[ColumnDefinition("TitleTypeDescription", DbTargetType=SqlDbType.NVarChar, Ordinal=3, Description="Description of a Title Type.", CharacterMaxLength=80, IsNullable=true)]
		public string TitleTypeDescription
		{
			get
			{
				return _TitleTypeDescription;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 80);
				if (_TitleTypeDescription != value)
				{
					_TitleTypeDescription = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion TitleTypeDescription
			
		#endregion Properties
				
		#region From Array serialization
		
		/// <summary>
		/// Deserializes the byte array and returns an instance of <see cref="__TitleType"/>.
		/// </summary>
		/// <returns>If the byte array can be deserialized and cast to an instance of <see cref="__TitleType"/>, 
		/// returns an instance of <see cref="__TitleType"/>; otherwise returns null.</returns>
		public static new __TitleType FromArray(byte[] byteArray)
		{
			__TitleType o = null;
			
			try
			{
				o = (__TitleType) CustomObjectBase.FromArray(byteArray);
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
		/// Compares this instance with a specified object. Throws an ArgumentException if the specified object is not of type <see cref="__TitleType"/>.
		/// </summary>
		/// <param name="obj">An <see cref="__TitleType"/> object to compare with this instance.</param>
		/// <returns>0 if the specified object equals this instance; -1 if the specified object does not equal this instance.</returns>
		public virtual int CompareTo(Object obj)
		{
			if (obj is __TitleType)
			{
				__TitleType o = (__TitleType) obj;
				
				if (
					o.IsNew == IsNew &&
					o.IsDeleted == IsDeleted &&
					o.TitleTypeID == TitleTypeID &&
					GetComparisonString(o.TitleType) == GetComparisonString(TitleType) &&
					GetComparisonString(o.TitleTypeDescription) == GetComparisonString(TitleTypeDescription) 
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
				throw new ArgumentException("Argument is not of type __TitleType");
			}
		}
 		
		#endregion CompareTo
		
		#region Operators
		
		/// <summary>
		/// Equality operator (==) returns true if the values of its operands are equal, false otherwise.
		/// </summary>
		/// <param name="a">The first <see cref="__TitleType"/> object to compare.</param>
		/// <param name="b">The second <see cref="__TitleType"/> object to compare.</param>
		/// <returns>true if values of operands are equal, false otherwise.</returns>
		public static bool operator == (__TitleType a, __TitleType b)
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
		/// <param name="a">The first <see cref="__TitleType"/> object to compare.</param>
		/// <param name="b">The second <see cref="__TitleType"/> object to compare.</param>
		/// <returns>false if values of operands are equal, false otherwise.</returns>
		public static bool operator !=(__TitleType a, __TitleType b)
		{
			return !(a == b);
		}
		
		/// <summary>
		/// Returns true the specified object is equal to this object instance, false otherwise.
		/// </summary>
		/// <param name="obj">The <see cref="__TitleType"/> object to compare with the current <see cref="__TitleType"/>.</param>
		/// <returns>true if specified object is equal to the instance of this object, false otherwise.</returns>
		public override bool Equals(Object obj)
		{
			if (!(obj is __TitleType))
			{
				return false;
			}
			
			return this == (__TitleType) obj;
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
		/// list.Sort(SortOrder.Ascending, __TitleType.SortColumn.TitleTypeID);
		/// </summary>
		[Serializable]
		public sealed class SortColumn
		{	
			public const string TitleTypeID = "TitleTypeID";	
			public const string TitleType = "TitleType";	
			public const string TitleTypeDescription = "TitleTypeDescription";
		}
				
		#endregion SortColumn
	}
}
// end of source generation
