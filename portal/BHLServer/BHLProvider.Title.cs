using System;
using CustomDataAccess;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Web.Utilities;

namespace MOBOT.BHL.Server
{
	public partial class BHLProvider
	{
		private TitleDAL titleDal = null;

		#region Select methods

		/// <summary>
		/// Select all values from Title.
		/// </summary>
		/// <returns>Objects of type Title.</returns>
		public CustomGenericList<Title> TitleSelectAll()
		{
			return ( new TitleDAL().TitleSelectAll( null, null ) );
		}

		public Title TitleSelectAuto( int titleID )
		{
			return GetTitleDalInstance().TitleSelectAuto( null, null, titleID );
		}

		/// <summary>
		/// Select all values from Title.
		/// </summary>
		/// <returns>Objects of type Title.</returns>
		public CustomGenericList<Title> TitleSelectAllNonPublished()
		{
			return ( new TitleDAL().TitleSelectAllNonPublished( null, null ) );
		}

		/// <summary>
		/// Select all values from Title.
		/// </summary>
		/// <returns>Objects of type Title.</returns>
		public CustomGenericList<Title> TitleSelectAllPublished()
		{
			return ( new TitleDAL().TitleSelectAllPublished( null, null ) );
		}

        /// <summary>
        /// Select all published titles for the specified institution.
        /// </summary>
        /// <param name="institutionCode">ID of the institution for which to retreive titles</param>
        /// <returns>List of objects of type Title</returns>
        public CustomGenericList<Title> TitleSelectPublishedByInstitution(String institutionCode)
        {
            return (new TitleDAL().TitleSelectPublishedByInstitution(null, null, institutionCode));
        }

		/// <summary>
		/// Select all values from Title like a particular string.
		/// </summary>
		/// <returns>Objects of type Title.</returns>
		public CustomGenericList<Title> TitleSelectByNameLike( string name, string institutionCode, string languageCode )
		{
			return ( new TitleDAL().TitleSelectByNameLike( null, null, name, institutionCode, languageCode ) );
		}

		/// <summary>
		/// Select all values from Title like a particular string.
		/// </summary>
		/// <returns>Objects of type Title.</returns>
		public CustomGenericList<Title> TitleSelectSearchName( string name, bool published, string languageCode, string includeSecondaryTitles, int returnCount )
		{
			return ( new TitleDAL().TitleSelectSearchName( null, null, name, published, languageCode, includeSecondaryTitles, returnCount ) );
		}

		/// <summary>
		/// Select all values from Title like a particular string.
		/// </summary>
		/// <returns>Objects of type Title.</returns>
        public CustomGenericList<Title> TitleSelectByDateRangeAndInstitution(int startDate, int endDate, String institutionCode, String languageCode)
		{
            return (new TitleDAL().TitleSelectByDateRangeAndInstitution(null, null, startDate, endDate, institutionCode, languageCode));
		}

		/// <summary>
		/// Select Title 
		/// </summary>
		/// <param name="titleID"></param>
		/// <returns>Object of type Title.</returns>
		public Title TitleSelect( int titleID )
		{
			return ( new TitleDAL().TitleSelectAuto( null, null, titleID ) );
		}

		public Title TitleSelectExtended( int titleId )
		{
			return TitleDAL.TitleSelectExtended( null, null, titleId );
		}

		public CustomGenericList<Title> TitleSelectByTagTextInstitutionAndLanguage( string tagText, string institutionCode, string languageCode )
		{
			return GetTitleDalInstance().TitleSelectByTagTextInstitutionAndLanguage( null, null, tagText, institutionCode, languageCode, "0" );
		}

        public CustomGenericList<Title> TitleSelectByTagTextInstitutionAndLanguage(string tagText, string institutionCode, string languageCode, string includeSecondaryTitles)
        {
            return GetTitleDalInstance().TitleSelectByTagTextInstitutionAndLanguage(null, null, tagText, institutionCode, languageCode, includeSecondaryTitles);
        }

        public CustomGenericList<Title> TitleSelectByFullTitle(string fullTitle)
		{
			return GetTitleDalInstance().TitleSelectByFullTitle( null, null, fullTitle );
		}

		public CustomGenericList<Title> TitleSelectByAbbreviation( string abbreviation )
		{
			return GetTitleDalInstance().TitleSelectByAbbreviation( null, null, abbreviation );
		}

		/// <summary>
		/// Select Title for a particular CreatorId.
		/// </summary>
		/// <param name="creatorId"></param>
		/// <returns>Object of type Title.</returns>
		public CustomGenericList<Title> TitleSelectByCreator( int creatorId, String includeSecondaryTitles )
		{
			return ( new TitleDAL().TitleSelectByCreator( null, null, creatorId, includeSecondaryTitles ) );
		}

		public CustomGenericList<CreatorTitle> TitleSimpleSelectByCreator( int creatorId )
		{
			return ( new TitleDAL().TitleSimpleSelectByCreator( null, null, creatorId ) );
		}

        /// <summary>
        /// Select all Titles for the specified Item.
        /// </summary>
        /// <returns>Objects of type Title.</returns>
        public CustomGenericList<Title> TitleSelectByItem(int itemID)
        {
            return (new TitleDAL().TitleSelectByItem(null, null, itemID));
        }

        public CustomGenericList<TitleBibTeX> TitleBibTeXSelectAllTitleCitations()
        {
            return (new TitleDAL().TitleBibTeXSelectAllTitleCitations(null, null));
        }

        public CustomGenericList<TitleBibTeX> TitleBibTeXSelectAllItemCitations()
        {
            return (new TitleDAL().TitleBibTeXSelectAllItemCitations(null, null));
        }

        public CustomGenericList<TitleBibTeX> TitleBibTeXSelectForTitleID(int titleID)
        {
            return (new TitleDAL().TitleBibTeXSelectForTitleID(null, null, titleID));
        }

        public CustomGenericList<TitleEndNote> TitleEndNoteSelectAllTitleCitations()
        {
            return (new TitleDAL().TitleEndNoteSelectAllTitleCitations(null, null));
        }

        public CustomGenericList<TitleEndNote> TitleEndNoteSelectAllItemCitations()
        {
            return (new TitleDAL().TitleEndNoteSelectAllItemCitations(null, null));
        }

        public CustomGenericList<TitleEndNote> TitleEndNoteSelectForTitleID(int titleID)
        {
            return (new TitleDAL().TitleEndNoteSelectForTitleID(null, null, titleID));
        }

        public String TitleBibTeXGetCitationStringForTitleID(int titleID)
        {
            System.Text.StringBuilder bibtexString = new System.Text.StringBuilder("");
            CustomGenericList<TitleBibTeX> citations = this.TitleBibTeXSelectForTitleID(titleID);
            foreach (TitleBibTeX citation in citations)
            {
                String volume = citation.Volume;
                String copyrightStatus = citation.CopyrightStatus;
                String url = citation.Url;
                String note = citation.Note;
                String pages = citation.Pages.ToString();
                String keywords = citation.Keywords;

                System.Collections.Generic.Dictionary<String, String> elements = new System.Collections.Generic.Dictionary<string, string>();
                elements.Add(BibTeXRefElementName.TITLE, citation.Title);
                if (volume != String.Empty) elements.Add(BibTeXRefElementName.VOLUME, volume);
                if (copyrightStatus != String.Empty) elements.Add(BibTeXRefElementName.COPYRIGHT, copyrightStatus);
                if (url != String.Empty) elements.Add(BibTeXRefElementName.URL, url);
                if (note != String.Empty) elements.Add(BibTeXRefElementName.NOTE, note);
                elements.Add(BibTeXRefElementName.PUBLISHER, citation.Publisher);
                elements.Add(BibTeXRefElementName.AUTHOR, citation.Authors.Replace("|", " and "));
                elements.Add(BibTeXRefElementName.YEAR, citation.Year);
                if (pages != String.Empty) elements.Add(BibTeXRefElementName.PAGES, pages);
                if (keywords != String.Empty) elements.Add(BibTeXRefElementName.KEYWORDS, keywords);

                BibTeX bibTex = new BibTeX(BibTeXRefType.BOOK, citation.CitationKey, elements);
                bibtexString.Append(bibTex.GenerateReference());
            }
            return bibtexString.ToString();
        }

        public String TitleEndNoteGetCitationStringForTitleID(int titleID, String titleUrl)
        {
            System.Text.StringBuilder endnoteString = new System.Text.StringBuilder("");
            CustomGenericList<TitleEndNote> citations = this.TitleEndNoteSelectForTitleID(titleID);
            foreach (TitleEndNote citation in citations)
            {
                String type = citation.PublicationType;
                String authors = citation.Authors;
                String year = citation.Year;
                String title = citation.FullTitle;
                String secondaryTitle = citation.SecondaryTitle;
                String publisherPlace = citation.PublisherPlace;
                String publisherName = citation.PublisherName;
                String volume = citation.Volume;
                String shortTitle = citation.ShortTitle;
                String abbreviation = citation.Abbreviation;
                String isbnissn = citation.Isbn;
                String callNumber = citation.CallNumber;
                String keywords = citation.Keywords;
                String language = citation.LanguageName;
                String note = citation.Note;
                String edition = citation.EditionStatement;
                String url = String.Format(titleUrl, citation.ItemID.ToString());

                System.Collections.Generic.Dictionary<String, String> elements = new System.Collections.Generic.Dictionary<string, string>();
                if (authors != String.Empty) elements.Add(EndNoteRefElementName.AUTHORS, authors);
                if (year != String.Empty) elements.Add(EndNoteRefElementName.YEAR, year);
                if (title != String.Empty) elements.Add(EndNoteRefElementName.TITLE, title);
                if (secondaryTitle != String.Empty) elements.Add(EndNoteRefElementName.SECONDARYTITLE, secondaryTitle);
                if (publisherPlace != String.Empty) elements.Add(EndNoteRefElementName.CITY, publisherPlace);
                if (publisherName != String.Empty) elements.Add(EndNoteRefElementName.PUBLISHER, publisherName);
                if (volume != String.Empty) elements.Add(EndNoteRefElementName.VOLUME, volume);
                if (shortTitle != String.Empty) elements.Add(EndNoteRefElementName.SHORTTITLE, shortTitle);
                if (abbreviation != String.Empty) elements.Add(EndNoteRefElementName.ABBREVIATION, abbreviation);
                if (isbnissn != String.Empty) elements.Add(EndNoteRefElementName.ISBNISSN, isbnissn);
                if (callNumber != String.Empty) elements.Add(EndNoteRefElementName.CALLNUMBER, callNumber);
                if (keywords != String.Empty) elements.Add(EndNoteRefElementName.KEYWORDS, keywords);
                if (language != String.Empty) elements.Add(EndNoteRefElementName.LANGUAGE, language);
                if (note != String.Empty) elements.Add(EndNoteRefElementName.NOTE, note);
                if (edition != String.Empty) elements.Add(EndNoteRefElementName.EDITION, edition);
                if (url != String.Empty) elements.Add(EndNoteRefElementName.URL, url);

                EndNote endnote = new EndNote(type, elements);
                endnoteString.Append(endnote.GenerateReference());
            }
            return endnoteString.ToString();
        }

        #endregion

		public CustomGenericList<Title> TitleSearchPaging( TitleSearchCriteria criteria )
		{
			return TitleDAL.TitleSearch( null, null, criteria );
		}

		public int TitleSearchCount( TitleSearchCriteria criteria )
		{
			return TitleDAL.TitleSearchCount( null, null, criteria );
		}

		public Title TitleUpdatePublishReady( int titleID, bool publishReady )
		{
			TitleDAL dal = new TitleDAL();
			Title title = dal.TitleSelectAuto( null, null, titleID );
			if ( title != null )
			{
				title.PublishReady = publishReady;
				title = dal.TitleUpdateAuto( null, null, title );
			}
			else
			{
				throw new Exception( "Could not find existing title record" );
			}
			return title;
		}

		public string NullIfEmpty( string value )
		{
			if ( value.Trim().Length == 0 )
			{
				return null;
			}
			else
			{
				return value;
			}
		}

		private TitleDAL GetTitleDalInstance()
		{
			if ( titleDal == null )
				titleDal = new TitleDAL();

			return titleDal;
		}

		public void TitleSave( Title title, int userId )
		{
			TitleDAL.Save( null, null, title, userId );
		}

        public CustomGenericList<TitleSuspectCharacter> TitleSelectWithSuspectCharacters(String institutionCode, int maxAge)
        {
            return new TitleDAL().TitleSelectWithSuspectCharacters(null, null, institutionCode, maxAge);
        }
	}
}
