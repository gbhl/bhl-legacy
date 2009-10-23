using System;
using System.Collections.Generic;
using CustomDataAccess;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Server
{
	public partial class BHLProvider
	{
		private PageNameDAL pageNameDal = null;

		public PageName PageNameInsertAuto( PageName value )
		{
			return GetPageNameDalInstance().PageNameInsertAuto( null, null, value );
		}

		public PageName PageNameSelectByPageIDAndNameFound( int pageID, string nameFound )
		{
			return GetPageNameDalInstance().PageNameSelectByPageIDAndNameFound( null, null, pageID, nameFound );
		}

		public CustomGenericList<PageName> PageNameSelectByPageID( int pageID )
		{
			return GetPageNameDalInstance().PageNameSelectByPageID( null, null, pageID );
		}

		public PageName PageNameSelectByNameBankID( int nameBankID )
		{
			return GetPageNameDalInstance().PageNameSelectByNameBankID( null, null, nameBankID );
		}

		public PageName PageNameUpdateAuto( PageName value )
		{
			return GetPageNameDalInstance().PageNameUpdateAuto( null, null, value );
		}

		public void PageNameDeleteAuto( int pageNameID )
		{
			GetPageNameDalInstance().PageNameDeleteAuto( null, null, pageNameID );
		}

		/// <summary>
		/// For each page name in the list, it inserts a new row in the database or
		/// or updates an existing row.  Then, any previously-existing rows that
		/// were not updated are set to inactive.
		/// </summary>
		/// <param name="pageID">Identifier of the page whose page names are being updated</param>
		/// <param name="items">List of page names</param>
		public int[] PageNameUpdateList( int pageID, FindItItem[] items )
		{
			int[] updateStats = new int[ 4 ];

			foreach ( FindItItem item in items )
			{
				PageName pageName = this.PageNameSelectByPageIDAndNameFound( pageID, item.Name );
				if ( pageName == null )
				{
					// Insert new page name
					pageName = new PageName();
					pageName.NameFound = item.Name;
					pageName.NameConfirmed = item.Name;
					pageName.NameBankID = item.NamebankID;
					if ( pageName.NameBankID <= 0 )
						pageName.NameBankID = null;

					pageName.Active = !( pageName.NameBankID == null );
					pageName.PageID = pageID;
					pageName.Source = "uBio";
					pageName.IsCommonName = false;
					this.PageNameInsertAuto( pageName );
					updateStats[ 0 ]++;   // number inserted
				}
				else
				{
					// Update existing page name if the namebankid has changed
					if ( ( pageName.NameBankID ?? 0 ) != item.NamebankID )
					{
						pageName.NameBankID = item.NamebankID;
						if ( pageName.NameBankID <= 0 )
							pageName.NameBankID = null;
						pageName.Active = !( pageName.NameBankID == null );
						this.PageNameUpdateAuto( pageName );
						updateStats[ 1 ]++; // number updated
					}
					else
					{
						updateStats[ 3 ]++;  // number unchanged
					}
				}
			}

			// Deactivate any names that are in the database, but were not not returned
			// by the just-completed UBIO request (this means they've fallen out of the
			// list of page names for this page)
			CustomGenericList<PageName> pageNames = this.PageNameSelectByPageID( pageID );
			foreach ( PageName pageName in pageNames )
			{
				if ( !this.PageNameIsInList( pageName.NameFound, items ) )
				{
					if ( pageName.NameBankID != null )
					{
						pageName.Active = false;
						pageName.NameBankID = null;
						this.PageNameUpdateAuto( pageName );
						updateStats[ 2 ]++; // number deleted
					}
					else
					{
						updateStats[ 3 ]++; // number unchanged
					}
				}
			}

			return updateStats;
		}

		/// <summary>
		/// Determines if the specified page name is in the supplied list
		/// </summary>
		/// <param name="pageName">Page Name for which to search</param>
		/// <param name="items">List in which to search</param>
		/// <returns>True if found, False if not</returns>
		private bool PageNameIsInList( string pageName, FindItItem[] items )
		{
			bool searchResult = false;
			foreach ( FindItItem item in items )
			{
				if ( String.Compare(item.Name, pageName, true) == 0 )
					searchResult = true;
			}
			return searchResult;
		}

		public CustomGenericList<NameCloud> PageNameSelectTop( int top )
		{
			return PageNameDAL.PageNameSelectTop( null, null, top );
		}

		public NameSearchResult PageNameSearch( string name )
		{
			return PageNameSearch( name, 0, "" );
		}

		public NameSearchResult PageNameSearch( string name, int pageTypeId, string languageCode )
		{
			CustomGenericList<CustomDataRow> data = GetPageNameDalInstance().PageNameSearchByPageType( null, null, name,
				pageTypeId, languageCode );
            return this.GetPageNameSearchResult(data);
		}

        public NameSearchResult PageNameSearchByPageTypeAndTitle(string name, int pageTypeId, int titleID, string languageCode)
        {
            CustomGenericList<CustomDataRow> data = GetPageNameDalInstance().PageNameSearchByPageTypeAndTitle(null, null, name,
                pageTypeId, titleID, languageCode);
            return this.GetPageNameSearchResult(data);
        }

        private NameSearchResult GetPageNameSearchResult(CustomGenericList<CustomDataRow> data)
        {
            NameSearchResult result = new NameSearchResult();
            result.QueryDate = DateTime.Now.ToString("dd MMM yyyy h:mmtt");

            //loop through the results and create a list of NameSearchTitle objects
            int lastTitleID = -1;
            int lastItemID = -1;
            //List<NameSearchTitle> titleList = new List<NameSearchTitle>();
            foreach (CustomDataRow row in data)
            {
                int currentTitleID = (int)row["TitleID"].Value;
                if (currentTitleID != lastTitleID)
                {
                    NameSearchTitle title = new NameSearchTitle();
                    title.TitleID = (int)row["TitleID"].Value;
                    title.ShortTitle = (string)row["ShortTitle"].Value;
                    title.SortTitle = (string)row["SortTitle"].Value;
                    title.MarcBibID = (string)row["MarcBibID"].Value;

                    result.Titles.Add(title);
                }
                NameSearchTitle currentTitle = result.Titles[result.Titles.Count - 1];

                int currentItemID = (int)row["ItemID"].Value;
                if (currentItemID != lastItemID)
                {
                    NameSearchItem item = new NameSearchItem();
                    item.ItemID = (int)row["ItemID"].Value;
                    item.ItemSequence = (short)row["ItemSequence"].Value;
                    item.Volume = (string)row["ItemVolume"].Value;

                    currentTitle.Items.Add(item);
                }

                NameSearchItem currentItem = currentTitle.Items[currentTitle.Items.Count - 1];
                NameSearchPage page = new NameSearchPage();
                page.PageID = (int)row["PageID"].Value;
                page.SequenceOrder = (int)row["SequenceOrder"].Value;
                page.IndicatedPages = (string)row["IndicatedPages"].Value;
                currentTitle.TotalPageCount++;
                currentItem.Pages.Add(page);

                lastTitleID = currentTitleID;
                lastItemID = currentItemID;
            }
            return result;
        }

        public NameSearchResult PageNameSearchForTitles(string name, string languageCode)
        {
            CustomGenericList<CustomDataRow> data = GetPageNameDalInstance().PageNameSearchForTitles(null, null,
                name, languageCode);

            NameSearchResult result = new NameSearchResult();
            result.QueryDate = DateTime.Now.ToString("dd MMM yyyy h:mmtt");

            //loop through the results and create a list of NameSearchTitle objects
            foreach (CustomDataRow row in data)
            {
                NameSearchTitle title = new NameSearchTitle();
                title.TitleID = (int)row["TitleID"].Value;
                title.ShortTitle = (string)row["ShortTitle"].Value + " " + (string)row["PartNumber"].Value + " " + (string)row["PartName"].Value;
                title.SortTitle = (string)row["SortTitle"].Value;
                title.MarcBibID = (string)row["MarcBibID"].Value;
                title.TotalPageCount = (int)row["TotalPageCount"].Value;
                result.Titles.Add(title);
            }
            return result;
        }

        /// <summary>
		/// Update the Name Bank ID and Active flag for the specified Page Name.
		/// </summary>
		/// <param name="pageNameID">Identifier of the Page Name to update</param>
		/// <param name="nameBankID">Name Bank ID to assign to the Page Name</param>
		/// <param name="active">Active flag value to assign to the Page Name</param>
		/// <returns>The updated Page Name</returns>
		public PageName PageNameUpdateNameBankID( int pageNameID, int nameBankID, bool active )
		{
			PageNameDAL dal = new PageNameDAL();
			PageName storedPageName = dal.PageNameSelectAuto( null, null, pageNameID );
			if ( storedPageName != null )
			{
				storedPageName.NameBankID = nameBankID;
				storedPageName.Active = active;
				storedPageName.LastUpdateDate = System.DateTime.Now;
				storedPageName = dal.PageNameUpdateAuto( null, null, storedPageName );
			}
			else
			{
				throw new Exception( "Could not find existing page name record" );
			}
			return storedPageName;
		}

		public CustomGenericList<PageName> PageNameSelectByNameLike( string name )
		{
			return this.PageNameSelectByNameLike( name, "", 100 );
		}

        public CustomGenericList<PageName> PageNameSelectByNameLike(string name, string languageCode, int returnCount)
        {
            return GetPageNameDalInstance().PageNameSelectByNameLike(null, null, name, languageCode, returnCount);
        }

		public CustomGenericList<PageName> PageNameSelectByConfirmedName( string name, string languageCode )
		{
			return GetPageNameDalInstance().PageNameSelectByConfirmedName( null, null, name, languageCode );
		}

		private PageNameDAL GetPageNameDalInstance()
		{
			if ( pageNameDal == null )
				pageNameDal = new PageNameDAL();

			return pageNameDal;
		}

		public void PageNameSaveList( CustomGenericList<PageName> pageNames )
		{
			PageNameDAL.SaveList( null, null, pageNames );
		}

	}
}
