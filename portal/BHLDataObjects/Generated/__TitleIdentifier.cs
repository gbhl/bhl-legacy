
// Generated 5/6/2009 3:30:24 PM
// Do not modify the contents of this code file.
// This abstract class __TitleIdentifier is based upon TitleIdentifier.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// It is recommended the code file you create be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DataObjects
// {
//		[Serializable]
// 		public class TitleIdentifier : __TitleIdentifier
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
	public abstract class __TitleIdentifier : CustomObjectBase, ICloneable, IComparable, IDisposable, ISetValues
	{
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public __TitleIdentifier()
		{
		}

		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="titleIdentifierID"></param>
		/// <param name="identifierName"></param>
		/// <param name="marcDataFieldTag"></param>
		/// <param name="marcSubFieldCode"></param>
		public __TitleIdentifier(int titleIdentifierID, 
			string identifierName, 
			string marcDataFieldTag, 
			string marcSubFieldCode) : this()
		{
			_TitleIdentifierID = titleIdentifierID;
			IdentifierName = identifierName;
			MarcDataFieldTag = marcDataFieldTag;
			MarcSubFieldCode = marcSubFieldCode;
		}
		
		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
		~__TitleIdentifier()
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
					case "TitleIdentifierID" :
					{
						_TitleIdentifierID = (int)column.Value;
						break;
					}
					case "IdentifierName" :
					{
						_IdentifierName = (string)column.Value;
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
				}
			}
			
			IsNew = false;
		}
		
		#endregion Set Values
		
		#region Properties		
		
		#region TitleIdentifierID
		
		private int _TitleIdentifierID = default(int);
		
		/// <summary>
		/// Column: TitleIdentifierID;
		/// DBMS data type: int; Auto key;
		/// </summary>
		[ColumnDefinition("TitleIdentifierID", DbTargetType=SqlDbType.Int, Ordinal=1, NumericPrecision=10, IsAutoKey=true, IsInForeignKey=true, IsInPrimaryKey=true)]
		public int TitleIdentifierID
		{
			get
			{
				return _TitleIdentifierID;
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
		
		#endregion TitleIdentifierID
		
		#region IdentifierName
		
		private string _IdentifierName = string.Empty;
		
		/// <summary>
		/// Column: IdentifierName;
		/// DBMS data type: nvarchar(40);
		/// </summary>
		[ColumnDefinition("IdentifierName", DbTargetType=SqlDbType.NVarChar, Ordinal=2, CharacterMaxLength=40)]
		public string IdentifierName
		{
			get
			{
				return _IdentifierName;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 40);
				if (_IdentifierName != value)
				{
					_IdentifierName = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion IdentifierName
		
		#region MarcDataFieldTag
		
		private string _MarcDataFieldTag = string.Empty;
		
		/// <summary>
		/// Column: MarcDataFieldTag;
		/// DBMS data type: nvarchar(50);
		/// </summary>
		[ColumnDefinition("MarcDataFieldTag", DbTargetType=SqlDbType.NVarChar, Ordinal=3, CharacterMaxLength=50)]
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
		
		private string _MarcSubFieldCode = string.Empty;
		
		/// <summary>
		/// Column: MarcSubFieldCode;
		/// DBMS data type: nvarchar(50);
		/// </summary>
		[ColumnDefinition("MarcSubFieldCode", DbTargetType=SqlDbType.NVarChar, Ordinal=4, CharacterMaxLength=50)]
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
			
		#endregion Properties
				
		#region From Array serialization
		
		/// <summary>
		/// Deserializes the byte array and returns an instance of <see cref="__TitleIdentifier"/>.
		/// </summary>
		/// <returns>If the byte array can be deserialized and cast to an instance of <see cref="__TitleIdentifier"/>, 
		/// returns an instance of <see cref="__TitleIdentifier"/>; otherwise returns null.</returns>
		public static new __TitleIdentifier FromArray(byte[] byteArray)
		{
			__TitleIdentifier o = null;
			
			try
			{
				o = (__TitleIdentifier) CustomObjectBase.FromArray(byteArray);
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
		/// Compares this instance with a specified object. Throws an ArgumentException if the specified object is not of type <see cref="__TitleIdentifier"/>.
		/// </summary>
		/// <param name="obj">An <see cref="__TitleIdentifier"/> object to compare with this instance.</param>
		/// <returns>0 if the specified object equals this instance; -1 if the specified object does not equal this instance.</returns>
		public virtual int CompareTo(Object obj)
		{
			if (obj is __TitleIdentifier)
			{
				__TitleIdentifier o = (__TitleIdentifier) obj;
				
				if (
					o.IsNew == IsNew &&
					o.IsDeleted == IsDeleted &&
					o.TitleIdentifierID == TitleIdentifierID &&
					GetComparisonString(o.IdentifierName) == GetComparisonString(IdentifierName) &&
					GetComparisonString(o.MarcDataFieldTag) == GetComparisonString(MarcDataFieldTag) &&
					GetComparisonString(o.MarcSubFieldCode) == GetComparisonString(MarcSubFieldCode) 
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
				throw new ArgumentException("Argument is not of type __TitleIdentifier");
			}
		}
 		
		#endregion CompareTo
		
		#region Operators
		
		/// <summary>
		/// Equality operator (==) returns true if the values of its operands are equal, false otherwise.
		/// </summary>
		/// <param name="a">The first <see cref="__TitleIdentifier"/> object to compare.</param>
		/// <param name="b">The second <see cref="__TitleIdentifier"/> object to compare.</param>
		/// <returns>true if values of operands are equal, false otherwise.</returns>
		public static bool operator == (__TitleIdentifier a, __TitleIdentifier b)
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
		/// <param name="a">The first <see cref="__TitleIdentifier"/> object to compare.</param>
		/// <param name="b">The second <see cref="__TitleIdentifier"/> object to compare.</param>
		/// <returns>false if values of operands are equal, false otherwise.</returns>
		public static bool operator !=(__TitleIdentifier a, __TitleIdentifier b)
		{
			return !(a == b);
		}
		
		/// <summary>
		/// Returns true the specified object is equal to this object instance, false otherwise.
		/// </summary>
		/// <param name="obj">The <see cref="__TitleIdentifier"/> object to compare with the current <see cref="__TitleIdentifier"/>.</param>
		/// <returns>true if specified object is equal to the instance of this object, false otherwise.</returns>
		public override bool Equals(Object obj)
		{
			if (!(obj is __TitleIdentifier))
			{
				return false;
			}
			
			return this == (__TitleIdentifier) obj;
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
		/// list.Sort(SortOrder.Ascending, __TitleIdentifier.SortColumn.TitleIdentifierID);
		/// </summary>
		[Serializable]
		public sealed class SortColumn
		{	
			public const string TitleIdentifierID = "TitleIdentifierID";	
			public const string IdentifierName = "IdentifierName";	
			public const string MarcDataFieldTag = "MarcDataFieldTag";	
			public const string MarcSubFieldCode = "MarcSubFieldCode";
		}
				
		#endregion SortColumn
	}
}
// end of source generation
