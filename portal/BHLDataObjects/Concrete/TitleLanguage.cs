using System;
using CustomDataAccess;

namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class TitleLanguage : __TitleLanguage
	{
        private String _languageName;

        public String LanguageName
        {
            get { return _languageName; }
            set { _languageName = value; }
        }

		#region Constructors

		public TitleLanguage()
		{
		}

		public TitleLanguage( int titleLanguageID, int titleID, String languageCode, DateTime creationDate )
			:
		base(titleLanguageID, titleID, languageCode, creationDate)
		{
		}

		#endregion Constructors

        public override void SetValues(CustomDataRow row)
        {
            foreach (CustomDataColumn column in row)
            {
                switch (column.Name)
                {
                    case "LanguageName":
                        {
                            _languageName = (String)column.Value;
                            break;
                        }
                }
            }

            base.SetValues(row);
        }
	}
}
