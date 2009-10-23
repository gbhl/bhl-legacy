using System;
using CustomDataAccess;

namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class Title_TitleIdentifier : __Title_TitleIdentifier
	{
		private string _IdentifierName;

		public string IdentifierName
		{
			get { return this._IdentifierName; }
			set { this._IdentifierName = value; }
		}

        public string IdentifierNameFull
        {
            get
            {
                if (this.MarcDataFieldTag != String.Empty)
                    return this.IdentifierName + " (MARC " + this.MarcDataFieldTag + this.MarcSubFieldCode + ")";
                else
                    return this.IdentifierName;
            }
        }

        private string _marcDataFieldTag;

        public string MarcDataFieldTag
        {
            get { return _marcDataFieldTag; }
            set { _marcDataFieldTag = value; }
        }

        private string _marcSubFieldCode;

        public string MarcSubFieldCode
        {
            get { return _marcSubFieldCode; }
            set { _marcSubFieldCode = value; }
        }
        
		#region Constructors

		public Title_TitleIdentifier()
		{
		}

		public Title_TitleIdentifier( int title_TitleIdentifierID, int titleID, int titleIdentifierID, 
            string identifierValue, DateTime? creationDate, DateTime? lastModifiedDate )
			:
		base( title_TitleIdentifierID, titleID, titleIdentifierID, identifierValue, creationDate, lastModifiedDate )
		{
		}

		#endregion Constructors

		public override void SetValues( CustomDataRow row )
		{
			foreach ( CustomDataColumn column in row )
			{
				switch ( column.Name )
				{
					case "IdentifierName":
						{
							_IdentifierName = (string)column.Value;
							break;
						}
                    case "MarcDataFieldTag":
                        {
                            _marcDataFieldTag = Utility.EmptyIfNull(column.Value);
                            break;
                        }
                    case "MarcSubFieldCode":
                        {
                            _marcSubFieldCode = Utility.EmptyIfNull(column.Value);
                            break;
                        }
                }
			}

			base.SetValues( row );
		}
	}
}
