using System;
using System.Collections.Generic;
using System.Text;
using CustomDataAccess;

namespace MOBOT.BHL.DataObjects
{
	public class CreatorTitle : ISetValues
	{
		int _titleID;
		string _fullTitle;
		string _creatorRoleType;

		public int TitleID
		{
			get { return this._titleID; }
			set { this._titleID = value; }
		}

		public string FullTitle
		{
			get { return this._fullTitle; }
			set { this._fullTitle = value; }
		}

		public string CreatorRoleType
		{
			get { return this._creatorRoleType; }
			set { this._creatorRoleType = value; }
		}

		
		#region ISetValues Members

		void ISetValues.SetValues( CustomDataRow row )
		{
			foreach ( CustomDataColumn column in row )
			{
				switch ( column.Name )
				{
					case "TitleID":
						{
							TitleID = (int)column.Value;
							break;
						}
					case "FullTitle":
						{
							FullTitle = (string)column.Value;
							break;
						}
					case "CreatorRoleTypeDescription":
						{
							CreatorRoleType = (string)column.Value;
							break;
						}
				}
			}
		}

		#endregion
	}
}
