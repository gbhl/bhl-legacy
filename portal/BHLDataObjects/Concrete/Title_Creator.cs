using System;
using CustomDataAccess;

namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class Title_Creator : __Title_Creator
	{
		private Creator _creator = null;
		private string _creatorRoleTypeDescription = null;

		public Creator Creator
		{
			get { return this._creator; }
			set { this._creator = value; }
		}

		public string CreatorName
		{
			get
			{
				if ( _creator != null )
				{
					return _creator.CreatorName;
				}
				return "";
			}
			set { }
		}

		public string CreatorRoleTypeDescription
		{
			get { return this._creatorRoleTypeDescription; }
			set { this._creatorRoleTypeDescription = value; }
		}

		public override void SetValues( CustomDataRow row )
		{
			foreach ( CustomDataColumn column in row )
			{
				switch ( column.Name )
				{
					case "CreatorRoleTypeDescription":
						{
							_creatorRoleTypeDescription = (string)column.Value;
							break;
						}
				}
			}

			base.SetValues( row );
		}
	}
}
