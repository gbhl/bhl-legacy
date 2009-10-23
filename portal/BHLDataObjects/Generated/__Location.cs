
// Generated 4/30/2008 10:05:00 AM
// Do not modify the contents of this code file.
// This abstract class __Location is based upon Location.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// It is recommended the code file you create be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DataObjects
// {
//		[Serializable]
// 		public class Location : __Location
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
	public abstract class __Location : CustomObjectBase, ICloneable, IComparable, IDisposable, ISetValues
	{
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public __Location()
		{
		}

		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="locationName"></param>
		/// <param name="latitude"></param>
		/// <param name="longitude"></param>
		/// <param name="nextAttemptDate"></param>
		/// <param name="includeInUI"></param>
		/// <param name="creationDate"></param>
		/// <param name="lastModifiedDate"></param>
		public __Location(string locationName, 
			string latitude, 
			string longitude, 
			DateTime? nextAttemptDate, 
			bool includeInUI, 
			DateTime? creationDate, 
			DateTime? lastModifiedDate) : this()
		{
			LocationName = locationName;
			Latitude = latitude;
			Longitude = longitude;
			NextAttemptDate = nextAttemptDate;
			IncludeInUI = includeInUI;
			CreationDate = creationDate;
			LastModifiedDate = lastModifiedDate;
		}
		
		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
		~__Location()
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
					case "LocationName" :
					{
						_LocationName = (string)column.Value;
						break;
					}
					case "Latitude" :
					{
						_Latitude = (string)column.Value;
						break;
					}
					case "Longitude" :
					{
						_Longitude = (string)column.Value;
						break;
					}
					case "NextAttemptDate" :
					{
						_NextAttemptDate = (DateTime?)column.Value;
						break;
					}
					case "IncludeInUI" :
					{
						_IncludeInUI = (bool)column.Value;
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
		
		#region LocationName
		
		private string _LocationName = string.Empty;
		
		/// <summary>
		/// Column: LocationName;
		/// DBMS data type: nvarchar(50);
		/// </summary>
		[ColumnDefinition("LocationName", DbTargetType=SqlDbType.NVarChar, Ordinal=1, CharacterMaxLength=50, IsInPrimaryKey=true)]
		public string LocationName
		{
			get
			{
				return _LocationName;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 50);
				if (_LocationName != value)
				{
					_LocationName = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion LocationName
		
		#region Latitude
		
		private string _Latitude = null;
		
		/// <summary>
		/// Column: Latitude;
		/// DBMS data type: varchar(20); Nullable;
		/// </summary>
		[ColumnDefinition("Latitude", DbTargetType=SqlDbType.VarChar, Ordinal=2, CharacterMaxLength=20, IsNullable=true)]
		public string Latitude
		{
			get
			{
				return _Latitude;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 20);
				if (_Latitude != value)
				{
					_Latitude = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion Latitude
		
		#region Longitude
		
		private string _Longitude = null;
		
		/// <summary>
		/// Column: Longitude;
		/// DBMS data type: varchar(20); Nullable;
		/// </summary>
		[ColumnDefinition("Longitude", DbTargetType=SqlDbType.VarChar, Ordinal=3, CharacterMaxLength=20, IsNullable=true)]
		public string Longitude
		{
			get
			{
				return _Longitude;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 20);
				if (_Longitude != value)
				{
					_Longitude = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion Longitude
		
		#region NextAttemptDate
		
		private DateTime? _NextAttemptDate = null;
		
		/// <summary>
		/// Column: NextAttemptDate;
		/// DBMS data type: datetime; Nullable;
		/// </summary>
		[ColumnDefinition("NextAttemptDate", DbTargetType=SqlDbType.DateTime, Ordinal=4, IsNullable=true)]
		public DateTime? NextAttemptDate
		{
			get
			{
				return _NextAttemptDate;
			}
			set
			{
				if (_NextAttemptDate != value)
				{
					_NextAttemptDate = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion NextAttemptDate
		
		#region IncludeInUI
		
		private bool _IncludeInUI = false;
		
		/// <summary>
		/// Column: IncludeInUI;
		/// DBMS data type: bit;
		/// </summary>
		[ColumnDefinition("IncludeInUI", DbTargetType=SqlDbType.Bit, Ordinal=5)]
		public bool IncludeInUI
		{
			get
			{
				return _IncludeInUI;
			}
			set
			{
				if (_IncludeInUI != value)
				{
					_IncludeInUI = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion IncludeInUI
		
		#region CreationDate
		
		private DateTime? _CreationDate = null;
		
		/// <summary>
		/// Column: CreationDate;
		/// DBMS data type: datetime; Nullable;
		/// </summary>
		[ColumnDefinition("CreationDate", DbTargetType=SqlDbType.DateTime, Ordinal=6, IsNullable=true)]
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
		[ColumnDefinition("LastModifiedDate", DbTargetType=SqlDbType.DateTime, Ordinal=7, IsNullable=true)]
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
		/// Deserializes the byte array and returns an instance of <see cref="__Location"/>.
		/// </summary>
		/// <returns>If the byte array can be deserialized and cast to an instance of <see cref="__Location"/>, 
		/// returns an instance of <see cref="__Location"/>; otherwise returns null.</returns>
		public static new __Location FromArray(byte[] byteArray)
		{
			__Location o = null;
			
			try
			{
				o = (__Location) CustomObjectBase.FromArray(byteArray);
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
		/// Compares this instance with a specified object. Throws an ArgumentException if the specified object is not of type <see cref="__Location"/>.
		/// </summary>
		/// <param name="obj">An <see cref="__Location"/> object to compare with this instance.</param>
		/// <returns>0 if the specified object equals this instance; -1 if the specified object does not equal this instance.</returns>
		public virtual int CompareTo(Object obj)
		{
			if (obj is __Location)
			{
				__Location o = (__Location) obj;
				
				if (
					o.IsNew == IsNew &&
					o.IsDeleted == IsDeleted &&
					GetComparisonString(o.LocationName) == GetComparisonString(LocationName) &&
					GetComparisonString(o.Latitude) == GetComparisonString(Latitude) &&
					GetComparisonString(o.Longitude) == GetComparisonString(Longitude) &&
					o.NextAttemptDate == NextAttemptDate &&
					o.IncludeInUI == IncludeInUI &&
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
				throw new ArgumentException("Argument is not of type __Location");
			}
		}
 		
		#endregion CompareTo
		
		#region Operators
		
		/// <summary>
		/// Equality operator (==) returns true if the values of its operands are equal, false otherwise.
		/// </summary>
		/// <param name="a">The first <see cref="__Location"/> object to compare.</param>
		/// <param name="b">The second <see cref="__Location"/> object to compare.</param>
		/// <returns>true if values of operands are equal, false otherwise.</returns>
		public static bool operator == (__Location a, __Location b)
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
		/// <param name="a">The first <see cref="__Location"/> object to compare.</param>
		/// <param name="b">The second <see cref="__Location"/> object to compare.</param>
		/// <returns>false if values of operands are equal, false otherwise.</returns>
		public static bool operator !=(__Location a, __Location b)
		{
			return !(a == b);
		}
		
		/// <summary>
		/// Returns true the specified object is equal to this object instance, false otherwise.
		/// </summary>
		/// <param name="obj">The <see cref="__Location"/> object to compare with the current <see cref="__Location"/>.</param>
		/// <returns>true if specified object is equal to the instance of this object, false otherwise.</returns>
		public override bool Equals(Object obj)
		{
			if (!(obj is __Location))
			{
				return false;
			}
			
			return this == (__Location) obj;
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
		/// list.Sort(SortOrder.Ascending, __Location.SortColumn.LocationName);
		/// </summary>
		[Serializable]
		public sealed class SortColumn
		{	
			public const string LocationName = "LocationName";	
			public const string Latitude = "Latitude";	
			public const string Longitude = "Longitude";	
			public const string NextAttemptDate = "NextAttemptDate";	
			public const string IncludeInUI = "IncludeInUI";	
			public const string CreationDate = "CreationDate";	
			public const string LastModifiedDate = "LastModifiedDate";
		}
				
		#endregion SortColumn
	}
}
// end of source generation
