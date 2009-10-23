
#region Using

using System;
using CustomDataAccess;

#endregion Using

namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class Title : __Title
	{
		#region Properties

		private string[] tags = null;
		private CustomGenericList<Title_Creator> _titleCreators = new CustomGenericList<Title_Creator>();
        private CustomGenericList<Title_TitleIdentifier> _titleIdentifiers = new CustomGenericList<Title_TitleIdentifier>();
		private CustomGenericList<Title_TitleType> _titleTypes = new CustomGenericList<Title_TitleType>();
		private CustomGenericList<Item> _items = new CustomGenericList<Item>();
        private CustomGenericList<TitleItem> _titleItems = new CustomGenericList<TitleItem>();
        private CustomGenericList<TitleTag> _titleTags = new CustomGenericList<TitleTag>();
        private CustomGenericList<TitleAssociation> _titleAssociations = new CustomGenericList<TitleAssociation>();
        private CustomGenericList<TitleLanguage> _titleLanguages = new CustomGenericList<TitleLanguage>();
		private long _rowNum;
		private string _institutionName;

		public string[] Tags
		{
			get
			{
				return tags;
			}
		}

		public CustomGenericList<Title_Creator> TitleCreators
		{
			get { return _titleCreators; }
			set { _titleCreators = value; }
		}

        public CustomGenericList<Title_TitleIdentifier> TitleIdentifiers
        {
            get { return _titleIdentifiers; }
            set { _titleIdentifiers = value; }
        }

		public CustomGenericList<Title_TitleType> TitleTypes
		{
			get { return this._titleTypes; }
			set { this._titleTypes = value; }
		}

		public CustomGenericList<Item> Items
		{
			get { return this._items; }
			set { this._items = value; }
		}

        public CustomGenericList<TitleItem> TitleItems
        {
            get { return this._titleItems; }
            set { this._titleItems = value; }
        }
        
        public CustomGenericList<TitleTag> TitleTags
        {
            get { return _titleTags; }
            set { _titleTags = value; }
        }

        public CustomGenericList<TitleAssociation> TitleAssociations
        {
            get { return _titleAssociations; }
            set { _titleAssociations = value; }
        }

        public CustomGenericList<TitleLanguage> TitleLanguages
        {
            get { return _titleLanguages; }
            set { _titleLanguages = value; }
        }

        public string InstitutionName
		{
			get { return this._institutionName; }
			set { this._institutionName = value; }
		}

		public long RowNum
		{
			get { return this._rowNum; }
		}

		#endregion

		#region Helper methods

		public string DisplayedShortTitle
		{
			get
			{
				if ( FullTitle.Length > 60 )
				{
					return ( FullTitle.Substring( 0, 60 ) + "..." );
				}
				else
				{
					return ( FullTitle );
				}
			}
		}

		private void ProcessTagTextString( string value )
		{
			string tagTextString = "";
			//strip off the trailing separator if necessary
			if ( value != null && value.EndsWith( "|" ) )
				value = value.Substring( 0, value.Length - 1 );

			if ( value != null )
				tagTextString = value;

			tags = tagTextString.Split( '|' );
		}

		#endregion

		#region ISet override

		public override void SetValues( CustomDataRow row )
		{
			foreach ( CustomDataColumn column in row )
			{
				switch ( column.Name )
				{
					case "TagTextString":
						{
							ProcessTagTextString( Utility.EmptyIfNull( column.Value ) );
							break;
						}
					case "InstitutionName":
						{
							_institutionName = Utility.EmptyIfNull( column.Value );
							break;
						}
					case "RowNum":
						{
							_rowNum = (long)column.Value;
							break;
						}
				}
			}

			base.SetValues( row );

		}

		#endregion

	}
}
