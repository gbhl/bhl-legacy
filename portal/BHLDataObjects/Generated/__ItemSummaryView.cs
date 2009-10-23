
// Generated 1/29/2008 2:13:01 PM
// Do not modify the contents of this code file.
// This abstract class __ItemSummaryView is based upon ItemSummaryView.

#region How To Implement

// To implement, create another code file as outlined in the following example.
// It is recommended the code file you create be in the same project as this code file.
// Example:
// using System;
//
// namespace MOBOT.BHL.DataObjects
// {
//		[Serializable]
// 		public class ItemSummaryView : __ItemSummaryView
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
	public abstract class __ItemSummaryView : CustomObjectBase, ICloneable, IComparable, IDisposable, ISetValues
	{
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public __ItemSummaryView()
		{
		}

		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="mARCBibID"></param>
		/// <param name="titleID"></param>
		/// <param name="fullTitle"></param>
		/// <param name="rareBooks"></param>
		/// <param name="itemStatusID"></param>
		/// <param name="itemID"></param>
		/// <param name="barCode"></param>
		/// <param name="pDFSize"></param>
		/// <param name="shortTitle"></param>
		/// <param name="volume"></param>
		/// <param name="itemSequence"></param>
		/// <param name="webVirtualDirectory"></param>
		/// <param name="oCRFolderShare"></param>
		/// <param name="sortTitle"></param>
		/// <param name="scanningDate"></param>
		/// <param name="publishReady"></param>
		/// <param name="creationDate"></param>
		public __ItemSummaryView(string mARCBibID, 
			int titleID, 
			string fullTitle, 
			bool rareBooks, 
			int itemStatusID, 
			int itemID, 
			string barCode, 
			int? pDFSize, 
			string shortTitle, 
			string volume, 
			short? itemSequence, 
			string webVirtualDirectory, 
			string oCRFolderShare, 
			string sortTitle, 
			DateTime? scanningDate, 
			bool publishReady, 
			DateTime? creationDate) : this()
		{
			MARCBibID = mARCBibID;
			TitleID = titleID;
			FullTitle = fullTitle;
			RareBooks = rareBooks;
			ItemStatusID = itemStatusID;
			ItemID = itemID;
			BarCode = barCode;
			PDFSize = pDFSize;
			ShortTitle = shortTitle;
			Volume = volume;
			ItemSequence = itemSequence;
			WebVirtualDirectory = webVirtualDirectory;
			OCRFolderShare = oCRFolderShare;
			SortTitle = sortTitle;
			ScanningDate = scanningDate;
			PublishReady = publishReady;
			CreationDate = creationDate;
		}
		
		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
		~__ItemSummaryView()
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
					case "MARCBibID" :
					{
						_MARCBibID = (string)column.Value;
						break;
					}
					case "TitleID" :
					{
						_TitleID = (int)column.Value;
						break;
					}
					case "FullTitle" :
					{
						_FullTitle = (string)column.Value;
						break;
					}
					case "RareBooks" :
					{
						_RareBooks = (bool)column.Value;
						break;
					}
					case "ItemStatusID" :
					{
						_ItemStatusID = (int)column.Value;
						break;
					}
					case "ItemID" :
					{
						_ItemID = (int)column.Value;
						break;
					}
					case "BarCode" :
					{
						_BarCode = (string)column.Value;
						break;
					}
					case "PDFSize" :
					{
						_PDFSize = (int?)column.Value;
						break;
					}
					case "ShortTitle" :
					{
						_ShortTitle = (string)column.Value;
						break;
					}
					case "Volume" :
					{
						_Volume = (string)column.Value;
						break;
					}
					case "ItemSequence" :
					{
						_ItemSequence = (short?)column.Value;
						break;
					}
					case "WebVirtualDirectory" :
					{
						_WebVirtualDirectory = (string)column.Value;
						break;
					}
					case "OCRFolderShare" :
					{
						_OCRFolderShare = (string)column.Value;
						break;
					}
					case "SortTitle" :
					{
						_SortTitle = (string)column.Value;
						break;
					}
					case "ScanningDate" :
					{
						_ScanningDate = (DateTime?)column.Value;
						break;
					}
					case "PublishReady" :
					{
						_PublishReady = (bool)column.Value;
						break;
					}
					case "CreationDate" :
					{
						_CreationDate = (DateTime?)column.Value;
						break;
					}
				}
			}
			
			IsNew = false;
		}
		
		#endregion Set Values
		
		#region Properties		
		
		#region MARCBibID
		
		private string _MARCBibID = string.Empty;
		
		/// <summary>
		/// Column: MARCBibID;
		/// DBMS data type: nvarchar(50);
		/// </summary>
		[ColumnDefinition("MARCBibID", DbTargetType=SqlDbType.NVarChar, Ordinal=1, CharacterMaxLength=50)]
		public string MARCBibID
		{
			get
			{
				return _MARCBibID;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 50);
				if (_MARCBibID != value)
				{
					_MARCBibID = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion MARCBibID
		
		#region TitleID
		
		private int _TitleID = default(int);
		
		/// <summary>
		/// Column: TitleID;
		/// DBMS data type: int;
		/// </summary>
		[ColumnDefinition("TitleID", DbTargetType=SqlDbType.Int, Ordinal=2, NumericPrecision=10)]
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
		
		#region FullTitle
		
		private string _FullTitle = string.Empty;
		
		/// <summary>
		/// Column: FullTitle;
		/// DBMS data type: ntext;
		/// </summary>
		[ColumnDefinition("FullTitle", DbTargetType=SqlDbType.NText, Ordinal=3, CharacterMaxLength=1073741823)]
		public string FullTitle
		{
			get
			{
				return _FullTitle;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 1073741823);
				if (_FullTitle != value)
				{
					_FullTitle = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion FullTitle
		
		#region RareBooks
		
		private bool _RareBooks = false;
		
		/// <summary>
		/// Column: RareBooks;
		/// DBMS data type: bit;
		/// </summary>
		[ColumnDefinition("RareBooks", DbTargetType=SqlDbType.Bit, Ordinal=4)]
		public bool RareBooks
		{
			get
			{
				return _RareBooks;
			}
			set
			{
				if (_RareBooks != value)
				{
					_RareBooks = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion RareBooks
		
		#region ItemStatusID
		
		private int _ItemStatusID = default(int);
		
		/// <summary>
		/// Column: ItemStatusID;
		/// DBMS data type: int;
		/// </summary>
		[ColumnDefinition("ItemStatusID", DbTargetType=SqlDbType.Int, Ordinal=5, NumericPrecision=10)]
		public int ItemStatusID
		{
			get
			{
				return _ItemStatusID;
			}
			set
			{
				if (_ItemStatusID != value)
				{
					_ItemStatusID = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion ItemStatusID
		
		#region ItemID
		
		private int _ItemID = default(int);
		
		/// <summary>
		/// Column: ItemID;
		/// DBMS data type: int;
		/// </summary>
		[ColumnDefinition("ItemID", DbTargetType=SqlDbType.Int, Ordinal=6, NumericPrecision=10)]
		public int ItemID
		{
			get
			{
				return _ItemID;
			}
			set
			{
				if (_ItemID != value)
				{
					_ItemID = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion ItemID
		
		#region BarCode
		
		private string _BarCode = string.Empty;
		
		/// <summary>
		/// Column: BarCode;
		/// DBMS data type: nvarchar(40);
		/// </summary>
		[ColumnDefinition("BarCode", DbTargetType=SqlDbType.NVarChar, Ordinal=7, CharacterMaxLength=40)]
		public string BarCode
		{
			get
			{
				return _BarCode;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 40);
				if (_BarCode != value)
				{
					_BarCode = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion BarCode
		
		#region PDFSize
		
		private int? _PDFSize = null;
		
		/// <summary>
		/// Column: PDFSize;
		/// DBMS data type: int; Nullable;
		/// </summary>
		[ColumnDefinition("PDFSize", DbTargetType=SqlDbType.Int, Ordinal=8, NumericPrecision=10, IsNullable=true)]
		public int? PDFSize
		{
			get
			{
				return _PDFSize;
			}
			set
			{
				if (_PDFSize != value)
				{
					_PDFSize = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion PDFSize
		
		#region ShortTitle
		
		private string _ShortTitle = null;
		
		/// <summary>
		/// Column: ShortTitle;
		/// DBMS data type: nvarchar(255); Nullable;
		/// </summary>
		[ColumnDefinition("ShortTitle", DbTargetType=SqlDbType.NVarChar, Ordinal=9, CharacterMaxLength=255, IsNullable=true)]
		public string ShortTitle
		{
			get
			{
				return _ShortTitle;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 255);
				if (_ShortTitle != value)
				{
					_ShortTitle = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion ShortTitle
		
		#region Volume
		
		private string _Volume = null;
		
		/// <summary>
		/// Column: Volume;
		/// DBMS data type: nvarchar(100); Nullable;
		/// </summary>
		[ColumnDefinition("Volume", DbTargetType=SqlDbType.NVarChar, Ordinal=10, CharacterMaxLength=100, IsNullable=true)]
		public string Volume
		{
			get
			{
				return _Volume;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 100);
				if (_Volume != value)
				{
					_Volume = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion Volume
		
		#region ItemSequence
		
		private short? _ItemSequence = null;
		
		/// <summary>
		/// Column: ItemSequence;
		/// DBMS data type: smallint; Nullable;
		/// </summary>
		[ColumnDefinition("ItemSequence", DbTargetType=SqlDbType.SmallInt, Ordinal=11, NumericPrecision=5, IsNullable=true)]
		public short? ItemSequence
		{
			get
			{
				return _ItemSequence;
			}
			set
			{
				if (_ItemSequence != value)
				{
					_ItemSequence = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion ItemSequence
		
		#region WebVirtualDirectory
		
		private string _WebVirtualDirectory = null;
		
		/// <summary>
		/// Column: WebVirtualDirectory;
		/// DBMS data type: nvarchar(30); Nullable;
		/// </summary>
		[ColumnDefinition("WebVirtualDirectory", DbTargetType=SqlDbType.NVarChar, Ordinal=12, CharacterMaxLength=30, IsNullable=true)]
		public string WebVirtualDirectory
		{
			get
			{
				return _WebVirtualDirectory;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 30);
				if (_WebVirtualDirectory != value)
				{
					_WebVirtualDirectory = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion WebVirtualDirectory
		
		#region OCRFolderShare
		
		private string _OCRFolderShare = null;
		
		/// <summary>
		/// Column: OCRFolderShare;
		/// DBMS data type: nvarchar(100); Nullable;
		/// </summary>
		[ColumnDefinition("OCRFolderShare", DbTargetType=SqlDbType.NVarChar, Ordinal=13, CharacterMaxLength=100, IsNullable=true)]
		public string OCRFolderShare
		{
			get
			{
				return _OCRFolderShare;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 100);
				if (_OCRFolderShare != value)
				{
					_OCRFolderShare = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion OCRFolderShare
		
		#region SortTitle
		
		private string _SortTitle = null;
		
		/// <summary>
		/// Column: SortTitle;
		/// DBMS data type: nvarchar(60); Nullable;
		/// </summary>
		[ColumnDefinition("SortTitle", DbTargetType=SqlDbType.NVarChar, Ordinal=14, CharacterMaxLength=60, IsNullable=true)]
		public string SortTitle
		{
			get
			{
				return _SortTitle;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 60);
				if (_SortTitle != value)
				{
					_SortTitle = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion SortTitle
		
		#region ScanningDate
		
		private DateTime? _ScanningDate = null;
		
		/// <summary>
		/// Column: ScanningDate;
		/// DBMS data type: datetime; Nullable;
		/// </summary>
		[ColumnDefinition("ScanningDate", DbTargetType=SqlDbType.DateTime, Ordinal=15, IsNullable=true)]
		public DateTime? ScanningDate
		{
			get
			{
				return _ScanningDate;
			}
			set
			{
				if (_ScanningDate != value)
				{
					_ScanningDate = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion ScanningDate
		
		#region PublishReady
		
		private bool _PublishReady = false;
		
		/// <summary>
		/// Column: PublishReady;
		/// DBMS data type: bit;
		/// </summary>
		[ColumnDefinition("PublishReady", DbTargetType=SqlDbType.Bit, Ordinal=16)]
		public bool PublishReady
		{
			get
			{
				return _PublishReady;
			}
			set
			{
				if (_PublishReady != value)
				{
					_PublishReady = value;
					_IsDirty = true;
				}
			}
		}
		
		#endregion PublishReady
		
		#region CreationDate
		
		private DateTime? _CreationDate = null;
		
		/// <summary>
		/// Column: CreationDate;
		/// DBMS data type: datetime; Nullable;
		/// </summary>
		[ColumnDefinition("CreationDate", DbTargetType=SqlDbType.DateTime, Ordinal=17, IsNullable=true)]
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
			
		#endregion Properties
				
		#region From Array serialization
		
		/// <summary>
		/// Deserializes the byte array and returns an instance of <see cref="__ItemSummaryView"/>.
		/// </summary>
		/// <returns>If the byte array can be deserialized and cast to an instance of <see cref="__ItemSummaryView"/>, 
		/// returns an instance of <see cref="__ItemSummaryView"/>; otherwise returns null.</returns>
		public static new __ItemSummaryView FromArray(byte[] byteArray)
		{
			__ItemSummaryView o = null;
			
			try
			{
				o = (__ItemSummaryView) CustomObjectBase.FromArray(byteArray);
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
		/// Compares this instance with a specified object. Throws an ArgumentException if the specified object is not of type <see cref="__ItemSummaryView"/>.
		/// </summary>
		/// <param name="obj">An <see cref="__ItemSummaryView"/> object to compare with this instance.</param>
		/// <returns>0 if the specified object equals this instance; -1 if the specified object does not equal this instance.</returns>
		public virtual int CompareTo(Object obj)
		{
			if (obj is __ItemSummaryView)
			{
				__ItemSummaryView o = (__ItemSummaryView) obj;
				
				if (
					o.IsNew == IsNew &&
					o.IsDeleted == IsDeleted &&
					GetComparisonString(o.MARCBibID) == GetComparisonString(MARCBibID) &&
					o.TitleID == TitleID &&
					GetComparisonString(o.FullTitle) == GetComparisonString(FullTitle) &&
					o.RareBooks == RareBooks &&
					o.ItemStatusID == ItemStatusID &&
					o.ItemID == ItemID &&
					GetComparisonString(o.BarCode) == GetComparisonString(BarCode) &&
					o.PDFSize == PDFSize &&
					GetComparisonString(o.ShortTitle) == GetComparisonString(ShortTitle) &&
					GetComparisonString(o.Volume) == GetComparisonString(Volume) &&
					o.ItemSequence == ItemSequence &&
					GetComparisonString(o.WebVirtualDirectory) == GetComparisonString(WebVirtualDirectory) &&
					GetComparisonString(o.OCRFolderShare) == GetComparisonString(OCRFolderShare) &&
					GetComparisonString(o.SortTitle) == GetComparisonString(SortTitle) &&
					o.ScanningDate == ScanningDate &&
					o.PublishReady == PublishReady &&
					o.CreationDate == CreationDate 
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
				throw new ArgumentException("Argument is not of type __ItemSummaryView");
			}
		}
 		
		#endregion CompareTo
		
		#region Operators
		
		/// <summary>
		/// Equality operator (==) returns true if the values of its operands are equal, false otherwise.
		/// </summary>
		/// <param name="a">The first <see cref="__ItemSummaryView"/> object to compare.</param>
		/// <param name="b">The second <see cref="__ItemSummaryView"/> object to compare.</param>
		/// <returns>true if values of operands are equal, false otherwise.</returns>
		public static bool operator == (__ItemSummaryView a, __ItemSummaryView b)
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
		/// <param name="a">The first <see cref="__ItemSummaryView"/> object to compare.</param>
		/// <param name="b">The second <see cref="__ItemSummaryView"/> object to compare.</param>
		/// <returns>false if values of operands are equal, false otherwise.</returns>
		public static bool operator !=(__ItemSummaryView a, __ItemSummaryView b)
		{
			return !(a == b);
		}
		
		/// <summary>
		/// Returns true the specified object is equal to this object instance, false otherwise.
		/// </summary>
		/// <param name="obj">The <see cref="__ItemSummaryView"/> object to compare with the current <see cref="__ItemSummaryView"/>.</param>
		/// <returns>true if specified object is equal to the instance of this object, false otherwise.</returns>
		public override bool Equals(Object obj)
		{
			if (!(obj is __ItemSummaryView))
			{
				return false;
			}
			
			return this == (__ItemSummaryView) obj;
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
		/// list.Sort(SortOrder.Ascending, __ItemSummaryView.SortColumn.MARCBibID);
		/// </summary>
		[Serializable]
		public sealed class SortColumn
		{	
			public const string MARCBibID = "MARCBibID";	
			public const string TitleID = "TitleID";	
			public const string FullTitle = "FullTitle";	
			public const string RareBooks = "RareBooks";	
			public const string ItemStatusID = "ItemStatusID";	
			public const string ItemID = "ItemID";	
			public const string BarCode = "BarCode";	
			public const string PDFSize = "PDFSize";	
			public const string ShortTitle = "ShortTitle";	
			public const string Volume = "Volume";	
			public const string ItemSequence = "ItemSequence";	
			public const string WebVirtualDirectory = "WebVirtualDirectory";	
			public const string OCRFolderShare = "OCRFolderShare";	
			public const string SortTitle = "SortTitle";	
			public const string ScanningDate = "ScanningDate";	
			public const string PublishReady = "PublishReady";	
			public const string CreationDate = "CreationDate";
		}
				
		#endregion SortColumn
	}
}
// end of source generation
