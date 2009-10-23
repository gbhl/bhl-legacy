
#region Using

using System;
using CustomDataAccess;

#endregion Using

namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class PageName : __PageName
	{
		private int pageCount = 0;
		private string _urlName;

		public int PageCount
		{
			get
			{
				return pageCount;
			}
			set
			{
				pageCount = value;
			}
		}

		public string UrlName
		{
			get { return this._urlName; }
			set { this._urlName = value; }
		}		

		public override void SetValues( CustomDataRow row )
		{
			foreach ( CustomDataColumn column in row )
			{
				if ( column.Name == "PageCount" )
				{
					pageCount = Utility.ZeroIfNull( row[ "PageCount" ].Value );
				}
			}
			base.SetValues( row );
		}

		
	}
}
