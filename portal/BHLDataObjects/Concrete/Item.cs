using System;
using CustomDataAccess;

namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class Item : __Item
	{
		#region Properties

		private string _titleName;
        private string _shortTitle;
		private string _paginationStatusName;
		private string _paginationUserName;
		private string _downloadUrl;
        private short? _itemSequence = null;
        private string _institutionName;
        private string _institutionUrl;
		private CustomGenericList<Page> _pages = new CustomGenericList<Page>();
        private CustomGenericList<Title> _titles = new CustomGenericList<Title>();
        private CustomGenericList<TitleItem> _titleItems = new CustomGenericList<TitleItem>();
        private CustomGenericList<ItemLanguage> _itemLanguages = new CustomGenericList<ItemLanguage>();
        private string[] creatorStrings = null;
        private string[] tagStrings = null;
        private string[] associationStrings = null;
        private string _publicationDetails;

		public string DisplayedShortVolume
		{
			get
			{
				if ( Volume.Length > 32 )
					return Volume.Substring( 0, 32 ) + "...";
				else
					return Volume;
			}
		}

		public CustomGenericList<Page> Pages
		{
			get { return this._pages; }
			set { this._pages = value; }
		}

        public CustomGenericList<Title> Titles
        {
            get { return this._titles; }
            set { this._titles = value; }
        }

        public CustomGenericList<TitleItem> TitleItems
        {
            get { return this._titleItems; }
            set { this._titleItems = value; }
        }

        public CustomGenericList<ItemLanguage> ItemLanguages
        {
            get { return this._itemLanguages; }
            set { this._itemLanguages = value; }
        }

		public string TitleName
		{
			get { return this._titleName; }
			set { this._titleName = value; }
		}

        public string ShortTitle
        {
            get { return this._shortTitle; }
            set { this._shortTitle = value; }
        }

        public string PaginationStatusName
		{
			get { return this._paginationStatusName; }
			set { this._paginationStatusName = value; }
		}

		public string PaginationUserName
		{
			get { return this._paginationUserName; }
			set { this._paginationUserName = value; }
		}

		public string DownloadUrl
		{
			get { return this._downloadUrl; }
			set { this._downloadUrl = value; }
		}

        public short? ItemSequence
        {
            get { return this._itemSequence; }
            set { this._itemSequence = value; }
        }

        public string InstitutionName
        {
            get { return _institutionName; }
            set { _institutionName = value; }
        }

        public string InstitutionUrl
        {
            get { return _institutionUrl; }
            set { _institutionUrl = value; }
        }

        public string[] TagStrings
        {
            get { return tagStrings; }
        }

        public string[] CreatorStrings
        {
            get { return creatorStrings; }
        }

        public string[] AssociationStrings
        {
            get { return associationStrings; }
        }

        public string PublicationDetails
        {
            get { return _publicationDetails; }
            set { _publicationDetails = value; }
        }

        #endregion

        private void ProcessTagTextString(string value)
        {
            string tagTextString = "";
            //strip off the trailing separator if necessary
            if (value != null && value.EndsWith("|"))
                value = value.Substring(0, value.Length - 1);

            if (value != null)
                tagTextString = value;

            tagStrings = tagTextString.Split('|');
        }

        private void ProcessCreatorTextString(string value)
        {
            string creatorTextString = "";
            //strip off the trailing separator if necessary
            if (value != null && value.EndsWith("|"))
                value = value.Substring(0, value.Length - 1);

            if (value != null)
                creatorTextString = value;

            creatorStrings = creatorTextString.Split('|');
        }

        private void ProcessAssociationTextString(string value)
        {
            string associationTextString = "";
            //strip off the trailing separator if necessary
            if (value != null && value.EndsWith("|"))
                value = value.Substring(0, value.Length - 1);

            if (value != null)
                associationTextString = value;

            associationStrings = associationTextString.Split('|');
        }

		#region ISet override

		public override void SetValues( CustomDataRow row )
		{
			foreach ( CustomDataColumn column in row )
			{
				switch ( column.Name )
				{
                    case "TagTextString":
                        {
                            ProcessTagTextString(Utility.EmptyIfNull(column.Value));
                            break;
                        }
                    case "CreatorTextString":
                        {
                            ProcessCreatorTextString(Utility.EmptyIfNull(column.Value));
                            break;
                        }
                    case "AssociationTextString":
                        {
                            ProcessAssociationTextString(Utility.EmptyIfNull(column.Value));
                            break;
                        }
                    case "TitleName":
						{
							_titleName = Utility.EmptyIfNull( column.Value );
							break;
						}
                    case "ShortTitle":
                        {
                            _shortTitle = Utility.EmptyIfNull(column.Value);
                            break;
                        }
					case "PaginationStatusName":
						{
							_paginationStatusName = Utility.EmptyIfNull( column.Value );
							break;
						}
					case "PaginationUserName":
						{
							_paginationUserName = Utility.EmptyIfNull( column.Value );
							break;
						}
					case "DownloadUrl":
						{
							_downloadUrl = Utility.EmptyIfNull( column.Value );
							break;
						}
                    case "ItemSequence":
                        {
                            _itemSequence = (short?)column.Value;
                            break;
                        }
                    case "InstitutionName":
                        {
                            _institutionName = Utility.EmptyIfNull(column.Value);
                            break;
                        }
                    case "InstitutionUrl":
                        {
                            _institutionUrl = Utility.EmptyIfNull(column.Value);
                            break;
                        }
                    case "PublicationDetails":
                        {
                            _publicationDetails = Utility.EmptyIfNull(column.Value);
                            break;
                        }
				}
			}

			base.SetValues( row );
		}

		#endregion

	}
}
