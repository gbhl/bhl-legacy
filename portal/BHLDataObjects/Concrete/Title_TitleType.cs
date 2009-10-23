using System;
using CustomDataAccess;

namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class Title_TitleType : __Title_TitleType
	{
		private string _titleType;
		private string _titleTypeDescription;

		public string TitleType
		{
			get { return this._titleType; }
			set { this._titleType = value; }
		}

		public string TitleTypeDescription
		{
			get { return this._titleTypeDescription; }
			set { this._titleTypeDescription = value; }
		}


		#region Constructors

		public Title_TitleType()
		{
		}

		public Title_TitleType( int title_TitleTypeID, int titleID, int titleTypeID )
			:
		base( title_TitleTypeID, titleID, titleTypeID )
		{
		}

		#endregion Constructors

		public override void SetValues( CustomDataRow row )
		{
			foreach ( CustomDataColumn column in row )
			{
				switch ( column.Name )
				{
					case "TitleType":
						{
							_titleType = (string)column.Value;
							break;
						}
					case "TitleTypeDescription":
						{
							_titleTypeDescription = (string)column.Value;
							break;
						}
				}
			}

			base.SetValues( row );
		}
	}
}
