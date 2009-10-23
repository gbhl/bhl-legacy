
// Generated 4/4/2008 2:40:57 PM
// Do not modify the contents of this code file.
// This abstract class __Creator is based upon Creator.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// It is recommended the code file you create be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DataObjects
// {
//		[Serializable]
// 		public class Creator : __Creator
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
	public abstract class __Creator : CustomObjectBase, ICloneable, IComparable, IDisposable, ISetValues
	{
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public __Creator()
		{
		}

		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="creatorID"></param>
		/// <param name="creatorName"></param>
		/// <param name="firstNameFirst"></param>
		/// <param name="simpleName"></param>
		/// <param name="dOB"></param>
		/// <param name="dOD"></param>
		/// <param name="biography"></param>
		/// <param name="creatorNote"></param>
		/// <param name="mARCDataFieldTag"></param>
		/// <param name="mARCCreator_a"></param>
		/// <param name="mARCCreator_b"></param>
		/// <param name="mARCCreator_c"></param>
		/// <param name="mARCCreator_d"></param>
		/// <param name="mARCCreator_Full"></param>
		/// <param name="creationDate"></param>
		/// <param name="lastModifiedDate"></param>
		public __Creator(int creatorID, 
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
			string mARCCreator_Full, 
			DateTime? creationDate, 
			DateTime? lastModifiedDate) : this()
		{
			_CreatorID = creatorID;
			CreatorName = creatorName;
			FirstNameFirst = firstNameFirst;
			SimpleName = simpleName;
			DOB = dOB;
			DOD = dOD;
			Biography = biography;
			CreatorNote = creatorNote;
			MARCDataFieldTag = mARCDataFieldTag;
			MARCCreator_a = mARCCreator_a;
			MARCCreator_b = mARCCreator_b;
			MARCCreator_c = mARCCreator_c;
			MARCCreator_d = mARCCreator_d;
			MARCCreator_Full = mARCCreator_Full;
			CreationDate = creationDate;
			LastModifiedDate = lastModifiedDate;
		}
		
		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
		~__Creator()
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
					case "CreatorID" :
					{
						_CreatorID = (int)column.Value;
						break;
					}
					case "CreatorName" :
					{
						_CreatorName = (string)column.Value;
						break;
					}
					case "FirstNameFirst" :
					{
						_FirstNameFirst = (string)column.Value;
						break;
					}
					case "SimpleName" :
					{
						_SimpleName = (string)column.Value;
						break;
					}
					case "DOB" :
					{
						_DOB = (string)column.Value;
						break;
					}
					case "DOD" :
					{
						_DOD = (string)column.Value;
						break;
					}
					case "Biography" :
					{
						_Biography = (string)column.Value;
						break;
					}
					case "CreatorNote" :
					{
						_CreatorNote = (string)column.Value;
						break;
					}
					case "MARCDataFieldTag" :
					{
						_MARCDataFieldTag = (string)column.Value;
						break;
					}
					case "MARCCreator_a" :
					{
						_MARCCreator_a = (string)column.Value;
						break;
					}
					case "MARCCreator_b" :
					{
						_MARCCreator_b = (string)column.Value;
						break;
					}
					case "MARCCreator_c" :
					{
						_MARCCreator_c = (string)column.Value;
						break;
					}
					case "MARCCreator_d" :
					{
						_MARCCreator_d = (string)column.Value;
						break;
					}
					case "MARCCreator_Full" :
					{
						_MARCCreator_Full = (string)column.Value;
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
		
		#region CreatorID
		
		private int _CreatorID = default(int);
		
		/// <summary>
		/// Column: CreatorID;
		/// DBMS data type: int; Auto key;
		/// Description: Unique identifier for each Creator record.
		/// </summary>
		[ColumnDefinition("CreatorID", DbTargetType=SqlDbType.Int, Ordinal=1, Description="Unique identifier for each Creator record.", NumericPrecision=10, IsAutoKey=true, IsInForeignKey=true, IsInPrimaryKey=true)]
		public int CreatorID
		{
			get
			{
				return _CreatorID;
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
		
		#endregion CreatorID
		
		#region CreatorName
		
		private string _CreatorName = string.Empty;
		
		/// <summary>
		/// Column: CreatorName;
		/// DBMS data type: nvarchar(255);
		/// Description: Creator name in last name first order.
		/// </summary>
		[ColumnDefinition("CreatorName", DbTargetType=SqlDbType.NVarChar, Ordinal=2, Description="Creator name in last name first order.", CharacterMaxLength=255)]
		public string CreatorName
		{
			get
			{
				return _CreatorName;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 255);
				if (_CreatorName != value)
				{
					_CreatorName = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion CreatorName
		
		#region FirstNameFirst
		
		private string _FirstNameFirst = null;
		
		/// <summary>
		/// Column: FirstNameFirst;
		/// DBMS data type: nvarchar(255); Nullable;
		/// Description: Creator name in first name first order.
		/// </summary>
		[ColumnDefinition("FirstNameFirst", DbTargetType=SqlDbType.NVarChar, Ordinal=3, Description="Creator name in first name first order.", CharacterMaxLength=255, IsNullable=true)]
		public string FirstNameFirst
		{
			get
			{
				return _FirstNameFirst;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 255);
				if (_FirstNameFirst != value)
				{
					_FirstNameFirst = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion FirstNameFirst
		
		#region SimpleName
		
		private string _SimpleName = null;
		
		/// <summary>
		/// Column: SimpleName;
		/// DBMS data type: nvarchar(255); Nullable;
		/// Description: Name using simple English alphabet (first name first).
		/// </summary>
		[ColumnDefinition("SimpleName", DbTargetType=SqlDbType.NVarChar, Ordinal=4, Description="Name using simple English alphabet (first name first).", CharacterMaxLength=255, IsNullable=true)]
		public string SimpleName
		{
			get
			{
				return _SimpleName;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 255);
				if (_SimpleName != value)
				{
					_SimpleName = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion SimpleName
		
		#region DOB
		
		private string _DOB = null;
		
		/// <summary>
		/// Column: DOB;
		/// DBMS data type: nvarchar(50); Nullable;
		/// Description: Creator's date of birth.
		/// </summary>
		[ColumnDefinition("DOB", DbTargetType=SqlDbType.NVarChar, Ordinal=5, Description="Creator's date of birth.", CharacterMaxLength=50, IsNullable=true)]
		public string DOB
		{
			get
			{
				return _DOB;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 50);
				if (_DOB != value)
				{
					_DOB = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion DOB
		
		#region DOD
		
		private string _DOD = null;
		
		/// <summary>
		/// Column: DOD;
		/// DBMS data type: nvarchar(50); Nullable;
		/// Description: Creator's date of death.
		/// </summary>
		[ColumnDefinition("DOD", DbTargetType=SqlDbType.NVarChar, Ordinal=6, Description="Creator's date of death.", CharacterMaxLength=50, IsNullable=true)]
		public string DOD
		{
			get
			{
				return _DOD;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 50);
				if (_DOD != value)
				{
					_DOD = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion DOD
		
		#region Biography
		
		private string _Biography = null;
		
		/// <summary>
		/// Column: Biography;
		/// DBMS data type: ntext; Nullable;
		/// Description: Biography of the Creator.
		/// </summary>
		[ColumnDefinition("Biography", DbTargetType=SqlDbType.NText, Ordinal=7, Description="Biography of the Creator.", CharacterMaxLength=1073741823, IsNullable=true)]
		public string Biography
		{
			get
			{
				return _Biography;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 1073741823);
				if (_Biography != value)
				{
					_Biography = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion Biography
		
		#region CreatorNote
		
		private string _CreatorNote = null;
		
		/// <summary>
		/// Column: CreatorNote;
		/// DBMS data type: nvarchar(255); Nullable;
		/// Description: Notes about this Creator.
		/// </summary>
		[ColumnDefinition("CreatorNote", DbTargetType=SqlDbType.NVarChar, Ordinal=8, Description="Notes about this Creator.", CharacterMaxLength=255, IsNullable=true)]
		public string CreatorNote
		{
			get
			{
				return _CreatorNote;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 255);
				if (_CreatorNote != value)
				{
					_CreatorNote = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion CreatorNote
		
		#region MARCDataFieldTag
		
		private string _MARCDataFieldTag = null;
		
		/// <summary>
		/// Column: MARCDataFieldTag;
		/// DBMS data type: nvarchar(3); Nullable;
		/// Description: MARC XML DataFieldTag providing this record.
		/// </summary>
		[ColumnDefinition("MARCDataFieldTag", DbTargetType=SqlDbType.NVarChar, Ordinal=9, Description="MARC XML DataFieldTag providing this record.", CharacterMaxLength=3, IsNullable=true)]
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
		
		#region MARCCreator_a
		
		private string _MARCCreator_a = null;
		
		/// <summary>
		/// Column: MARCCreator_a;
		/// DBMS data type: nvarchar(450); Nullable;
		/// Description: 'a' field from MARC XML
		/// </summary>
		[ColumnDefinition("MARCCreator_a", DbTargetType=SqlDbType.NVarChar, Ordinal=10, Description="'a' field from MARC XML", CharacterMaxLength=450, IsNullable=true)]
		public string MARCCreator_a
		{
			get
			{
				return _MARCCreator_a;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 450);
				if (_MARCCreator_a != value)
				{
					_MARCCreator_a = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion MARCCreator_a
		
		#region MARCCreator_b
		
		private string _MARCCreator_b = null;
		
		/// <summary>
		/// Column: MARCCreator_b;
		/// DBMS data type: nvarchar(450); Nullable;
		/// Description: 'b' field from MARC XML
		/// </summary>
		[ColumnDefinition("MARCCreator_b", DbTargetType=SqlDbType.NVarChar, Ordinal=11, Description="'b' field from MARC XML", CharacterMaxLength=450, IsNullable=true)]
		public string MARCCreator_b
		{
			get
			{
				return _MARCCreator_b;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 450);
				if (_MARCCreator_b != value)
				{
					_MARCCreator_b = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion MARCCreator_b
		
		#region MARCCreator_c
		
		private string _MARCCreator_c = null;
		
		/// <summary>
		/// Column: MARCCreator_c;
		/// DBMS data type: nvarchar(450); Nullable;
		/// Description: 'c' field from MARC XML
		/// </summary>
		[ColumnDefinition("MARCCreator_c", DbTargetType=SqlDbType.NVarChar, Ordinal=12, Description="'c' field from MARC XML", CharacterMaxLength=450, IsNullable=true)]
		public string MARCCreator_c
		{
			get
			{
				return _MARCCreator_c;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 450);
				if (_MARCCreator_c != value)
				{
					_MARCCreator_c = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion MARCCreator_c
		
		#region MARCCreator_d
		
		private string _MARCCreator_d = null;
		
		/// <summary>
		/// Column: MARCCreator_d;
		/// DBMS data type: nvarchar(450); Nullable;
		/// Description: 'd' field from MARC XML
		/// </summary>
		[ColumnDefinition("MARCCreator_d", DbTargetType=SqlDbType.NVarChar, Ordinal=13, Description="'d' field from MARC XML", CharacterMaxLength=450, IsNullable=true)]
		public string MARCCreator_d
		{
			get
			{
				return _MARCCreator_d;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 450);
				if (_MARCCreator_d != value)
				{
					_MARCCreator_d = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion MARCCreator_d
		
		#region MARCCreator_Full
		
		private string _MARCCreator_Full = null;
		
		/// <summary>
		/// Column: MARCCreator_Full;
		/// DBMS data type: nvarchar(450); Nullable;
		/// Description: 'Full' Creator information from MARC XML
		/// </summary>
		[ColumnDefinition("MARCCreator_Full", DbTargetType=SqlDbType.NVarChar, Ordinal=14, Description="'Full' Creator information from MARC XML", CharacterMaxLength=450, IsNullable=true)]
		public string MARCCreator_Full
		{
			get
			{
				return _MARCCreator_Full;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 450);
				if (_MARCCreator_Full != value)
				{
					_MARCCreator_Full = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion MARCCreator_Full
		
		#region CreationDate
		
		private DateTime? _CreationDate = null;
		
		/// <summary>
		/// Column: CreationDate;
		/// DBMS data type: datetime; Nullable;
		/// </summary>
		[ColumnDefinition("CreationDate", DbTargetType=SqlDbType.DateTime, Ordinal=15, IsNullable=true)]
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
		[ColumnDefinition("LastModifiedDate", DbTargetType=SqlDbType.DateTime, Ordinal=16, IsNullable=true)]
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
		/// Deserializes the byte array and returns an instance of <see cref="__Creator"/>.
		/// </summary>
		/// <returns>If the byte array can be deserialized and cast to an instance of <see cref="__Creator"/>, 
		/// returns an instance of <see cref="__Creator"/>; otherwise returns null.</returns>
		public static new __Creator FromArray(byte[] byteArray)
		{
			__Creator o = null;
			
			try
			{
				o = (__Creator) CustomObjectBase.FromArray(byteArray);
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
		/// Compares this instance with a specified object. Throws an ArgumentException if the specified object is not of type <see cref="__Creator"/>.
		/// </summary>
		/// <param name="obj">An <see cref="__Creator"/> object to compare with this instance.</param>
		/// <returns>0 if the specified object equals this instance; -1 if the specified object does not equal this instance.</returns>
		public virtual int CompareTo(Object obj)
		{
			if (obj is __Creator)
			{
				__Creator o = (__Creator) obj;
				
				if (
					o.IsNew == IsNew &&
					o.IsDeleted == IsDeleted &&
					o.CreatorID == CreatorID &&
					GetComparisonString(o.CreatorName) == GetComparisonString(CreatorName) &&
					GetComparisonString(o.FirstNameFirst) == GetComparisonString(FirstNameFirst) &&
					GetComparisonString(o.SimpleName) == GetComparisonString(SimpleName) &&
					GetComparisonString(o.DOB) == GetComparisonString(DOB) &&
					GetComparisonString(o.DOD) == GetComparisonString(DOD) &&
					GetComparisonString(o.Biography) == GetComparisonString(Biography) &&
					GetComparisonString(o.CreatorNote) == GetComparisonString(CreatorNote) &&
					GetComparisonString(o.MARCDataFieldTag) == GetComparisonString(MARCDataFieldTag) &&
					GetComparisonString(o.MARCCreator_a) == GetComparisonString(MARCCreator_a) &&
					GetComparisonString(o.MARCCreator_b) == GetComparisonString(MARCCreator_b) &&
					GetComparisonString(o.MARCCreator_c) == GetComparisonString(MARCCreator_c) &&
					GetComparisonString(o.MARCCreator_d) == GetComparisonString(MARCCreator_d) &&
					GetComparisonString(o.MARCCreator_Full) == GetComparisonString(MARCCreator_Full) &&
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
				throw new ArgumentException("Argument is not of type __Creator");
			}
		}
 		
		#endregion CompareTo
		
		#region Operators
		
		/// <summary>
		/// Equality operator (==) returns true if the values of its operands are equal, false otherwise.
		/// </summary>
		/// <param name="a">The first <see cref="__Creator"/> object to compare.</param>
		/// <param name="b">The second <see cref="__Creator"/> object to compare.</param>
		/// <returns>true if values of operands are equal, false otherwise.</returns>
		public static bool operator == (__Creator a, __Creator b)
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
		/// <param name="a">The first <see cref="__Creator"/> object to compare.</param>
		/// <param name="b">The second <see cref="__Creator"/> object to compare.</param>
		/// <returns>false if values of operands are equal, false otherwise.</returns>
		public static bool operator !=(__Creator a, __Creator b)
		{
			return !(a == b);
		}
		
		/// <summary>
		/// Returns true the specified object is equal to this object instance, false otherwise.
		/// </summary>
		/// <param name="obj">The <see cref="__Creator"/> object to compare with the current <see cref="__Creator"/>.</param>
		/// <returns>true if specified object is equal to the instance of this object, false otherwise.</returns>
		public override bool Equals(Object obj)
		{
			if (!(obj is __Creator))
			{
				return false;
			}
			
			return this == (__Creator) obj;
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
		/// list.Sort(SortOrder.Ascending, __Creator.SortColumn.CreatorID);
		/// </summary>
		[Serializable]
		public sealed class SortColumn
		{	
			public const string CreatorID = "CreatorID";	
			public const string CreatorName = "CreatorName";	
			public const string FirstNameFirst = "FirstNameFirst";	
			public const string SimpleName = "SimpleName";	
			public const string DOB = "DOB";	
			public const string DOD = "DOD";	
			public const string Biography = "Biography";	
			public const string CreatorNote = "CreatorNote";	
			public const string MARCDataFieldTag = "MARCDataFieldTag";	
			public const string MARCCreator_a = "MARCCreator_a";	
			public const string MARCCreator_b = "MARCCreator_b";	
			public const string MARCCreator_c = "MARCCreator_c";	
			public const string MARCCreator_d = "MARCCreator_d";	
			public const string MARCCreator_Full = "MARCCreator_Full";	
			public const string CreationDate = "CreationDate";	
			public const string LastModifiedDate = "LastModifiedDate";
		}
				
		#endregion SortColumn
	}
}
// end of source generation
