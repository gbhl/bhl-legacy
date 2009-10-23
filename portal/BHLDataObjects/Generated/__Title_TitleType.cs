
// Generated 1/18/2008 11:10:47 AM
// Do not modify the contents of this code file.
// This abstract class __Title_TitleType is based upon Title_TitleType.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// It is recommended the code file you create be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DataObjects
// {
//		[Serializable]
// 		public class Title_TitleType : __Title_TitleType
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
	public abstract class __Title_TitleType : CustomObjectBase, ICloneable, IComparable, IDisposable, ISetValues
	{
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public __Title_TitleType()
		{
		}

		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="title_TitleTypeID"></param>
		/// <param name="titleID"></param>
		/// <param name="titleTypeID"></param>
		public __Title_TitleType(int title_TitleTypeID, 
			int titleID, 
			int titleTypeID) : this()
		{
			_Title_TitleTypeID = title_TitleTypeID;
			TitleID = titleID;
			TitleTypeID = titleTypeID;
		}
		
		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
		~__Title_TitleType()
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
					case "Title_TitleTypeID" :
					{
						_Title_TitleTypeID = (int)column.Value;
						break;
					}
					case "TitleID" :
					{
						_TitleID = (int)column.Value;
						break;
					}
					case "TitleTypeID" :
					{
						_TitleTypeID = (int)column.Value;
						break;
					}
				}
			}
			
			IsNew = false;
		}
		
		#endregion Set Values
		
		#region Properties		
		
		#region Title_TitleTypeID
		
		private int _Title_TitleTypeID = default(int);
		
		/// <summary>
		/// Column: Title_TitleTypeID;
		/// DBMS data type: int; Auto key;
		/// </summary>
		[ColumnDefinition("Title_TitleTypeID", DbTargetType=SqlDbType.Int, Ordinal=1, NumericPrecision=10, IsAutoKey=true, IsInPrimaryKey=true)]
		public int Title_TitleTypeID
		{
			get
			{
				return _Title_TitleTypeID;
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
		
		#endregion Title_TitleTypeID
		
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
		
		#region TitleTypeID
		
		private int _TitleTypeID = default(int);
		
		/// <summary>
		/// Column: TitleTypeID;
		/// DBMS data type: int;
		/// Description: Unique identifier for each Title Type record.
		/// </summary>
		[ColumnDefinition("TitleTypeID", DbTargetType=SqlDbType.Int, Ordinal=3, Description="Unique identifier for each Title Type record.", NumericPrecision=10, IsInForeignKey=true)]
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
			
		#endregion Properties
				
		#region From Array serialization
		
		/// <summary>
		/// Deserializes the byte array and returns an instance of <see cref="__Title_TitleType"/>.
		/// </summary>
		/// <returns>If the byte array can be deserialized and cast to an instance of <see cref="__Title_TitleType"/>, 
		/// returns an instance of <see cref="__Title_TitleType"/>; otherwise returns null.</returns>
		public static new __Title_TitleType FromArray(byte[] byteArray)
		{
			__Title_TitleType o = null;
			
			try
			{
				o = (__Title_TitleType) CustomObjectBase.FromArray(byteArray);
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
		/// Compares this instance with a specified object. Throws an ArgumentException if the specified object is not of type <see cref="__Title_TitleType"/>.
		/// </summary>
		/// <param name="obj">An <see cref="__Title_TitleType"/> object to compare with this instance.</param>
		/// <returns>0 if the specified object equals this instance; -1 if the specified object does not equal this instance.</returns>
		public virtual int CompareTo(Object obj)
		{
			if (obj is __Title_TitleType)
			{
				__Title_TitleType o = (__Title_TitleType) obj;
				
				if (
					o.IsNew == IsNew &&
					o.IsDeleted == IsDeleted &&
					o.Title_TitleTypeID == Title_TitleTypeID &&
					o.TitleID == TitleID &&
					o.TitleTypeID == TitleTypeID 
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
				throw new ArgumentException("Argument is not of type __Title_TitleType");
			}
		}
 		
		#endregion CompareTo
		
		#region Operators
		
		/// <summary>
		/// Equality operator (==) returns true if the values of its operands are equal, false otherwise.
		/// </summary>
		/// <param name="a">The first <see cref="__Title_TitleType"/> object to compare.</param>
		/// <param name="b">The second <see cref="__Title_TitleType"/> object to compare.</param>
		/// <returns>true if values of operands are equal, false otherwise.</returns>
		public static bool operator == (__Title_TitleType a, __Title_TitleType b)
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
		/// <param name="a">The first <see cref="__Title_TitleType"/> object to compare.</param>
		/// <param name="b">The second <see cref="__Title_TitleType"/> object to compare.</param>
		/// <returns>false if values of operands are equal, false otherwise.</returns>
		public static bool operator !=(__Title_TitleType a, __Title_TitleType b)
		{
			return !(a == b);
		}
		
		/// <summary>
		/// Returns true the specified object is equal to this object instance, false otherwise.
		/// </summary>
		/// <param name="obj">The <see cref="__Title_TitleType"/> object to compare with the current <see cref="__Title_TitleType"/>.</param>
		/// <returns>true if specified object is equal to the instance of this object, false otherwise.</returns>
		public override bool Equals(Object obj)
		{
			if (!(obj is __Title_TitleType))
			{
				return false;
			}
			
			return this == (__Title_TitleType) obj;
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
		/// list.Sort(SortOrder.Ascending, __Title_TitleType.SortColumn.Title_TitleTypeID);
		/// </summary>
		[Serializable]
		public sealed class SortColumn
		{	
			public const string Title_TitleTypeID = "Title_TitleTypeID";	
			public const string TitleID = "TitleID";	
			public const string TitleTypeID = "TitleTypeID";
		}
				
		#endregion SortColumn
	}
}
// end of source generation
