using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using CustomDataAccess;
using MOBOT.Utility;
using SortOrder = CustomDataAccess.SortOrder;
using Paige = MOBOT.BHL.DataObjects.Page;

namespace MOBOT.BHL.Web.Admin
{
	public partial class ItemEdit : System.Web.UI.Page
	{
		private PageComparer.CompareEnum _sortColumn = PageComparer.CompareEnum.SequenceOrder;
		private SortOrder _sortOrder = SortOrder.Ascending;

		protected void Page_Load( object sender, EventArgs e )
		{
            ClientScript.RegisterClientScriptBlock(this.GetType(), "scptSelectTitle", "<script language='javascript'>function selectTitle(titleId) { document.getElementById('" + selectedTitle.ClientID + "').value=titleId; overlay(); __doPostBack('',''); }</script>");

			if ( !IsPostBack )
			{
				fillCombos();

				string idString = Request.QueryString[ "id" ];
				int id = 0;
				if ( idString != null && int.TryParse( idString, out id ) )
				{
					itemIdTextBox.Text = id.ToString();
					search( id, null );
				}
				else
				{
					// TODO: Inform user that title does not exist -- Perhaps redirect to unknown.aspx?type=title
				}
			}
			else
			{
                String selectedTitleId = this.selectedTitle.Value;
                if (selectedTitleId != "")
                {
                    CustomGenericList<ItemTitle> itemTitles = (CustomGenericList<ItemTitle>)Session["ItemTitleList" + itemIdTextBox.Text];
                    ItemTitle itemTitle = new ItemTitle();

                    // Get details for "selectedTitleId" from database
                    BHLProvider provider = new BHLProvider();
                    Title title = provider.TitleSelect(Convert.ToInt32(selectedTitleId));
                    itemTitle.TitleID = title.TitleID;
                    itemTitle.ShortTitle = title.ShortTitle;
                    itemTitle.IsPrimary = false;
                    itemTitles.Add(itemTitle);
                    Session["ItemTitleList" + itemIdTextBox.Text] = itemTitles;
                    this.selectedTitle.Value = "";
                    this.bindTitleData();
                }

				if ( ViewState[ "SortColumn" ] != null )
				{
					_sortColumn = (PageComparer.CompareEnum)ViewState[ "SortColumn" ];
					_sortOrder = (SortOrder)ViewState[ "SortOrder" ];
				}
			}

            litMessage.Text = "";
            errorControl.Visible = false;
			Page.MaintainScrollPositionOnPostBack = true;

			Page.SetFocus( itemIdTextBox );
		}

		private void fillCombos()
		{
			BHLProvider bp = new BHLProvider();
            CustomGenericList<Institution> institutions = bp.InstituationSelectAll();

            Institution emptyInstitution = new Institution();
            emptyInstitution.InstitutionCode = "";
            emptyInstitution.InstitutionName = "";
            institutions.Insert(0, emptyInstitution);

            ddlInst.DataSource = institutions;
            ddlInst.DataTextField = "InstitutionName";
            ddlInst.DataValueField = "InstitutionCode";
            ddlInst.DataBind();

            CustomGenericList<Language> languages = bp.LanguageSelectAll();

			Language emptyLanguage = new Language();
			emptyLanguage.LanguageCode = "";
			emptyLanguage.LanguageName = "";
			languages.Insert( 0, emptyLanguage );

			ddlLang.DataSource = languages;
			ddlLang.DataTextField = "LanguageName";
			ddlLang.DataValueField = "LanguageCode";
			ddlLang.DataBind();

			CustomGenericList<Vault> vaults = bp.VaultSelectAll();

			Vault emptyVault = new Vault();
			emptyVault.VaultID = 0;
			emptyVault.Description = "";
			vaults.Insert( 0, emptyVault );

			ddlVault.DataSource = vaults;
			ddlVault.DataTextField = "Description";
			ddlVault.DataValueField = "VaultID";
			ddlVault.DataBind();

			CustomGenericList<ItemStatus> itemStatuses = bp.ItemStatusSelectAll();

			ddlItemStatus.DataSource = itemStatuses;
			ddlItemStatus.DataTextField = "ItemStatusName";
			ddlItemStatus.DataValueField = "ItemStatusID";
			ddlItemStatus.DataBind();
		}

		private void fillUI()
		{
            Item item = (Item)Session["Item" + itemIdTextBox.Text];

            if (item != null)
            {

                itemIdLabel.Text = item.ItemID.ToString();
                barcodeLabel.Text = item.BarCode;
                marcItemIDTextBox.Text = item.MARCItemID;
                callNumberTextBox.Text = item.CallNumber;
                volumeTextBox.Text = item.Volume;
                notesTextBox.Text = item.Note;
                yearTextBox.Text = item.Year;
                identifierBibTextBox.Text = item.IdentifierBib;
                zQueryTextBox.Text = item.ZQuery;
                sponsorTextBox.Text = item.Sponsor;
                licenseUrlTextBox.Text = item.LicenseUrl;
                rightsTextBox.Text = item.Rights;
                dueDiligenceTextBox.Text = item.DueDiligence;
                copyrightStatusTextBox.Text = item.CopyrightStatus;
                copyrightRegionTextBox.Text = item.CopyrightRegion;
                copyrightCommentTextBox.Text = item.CopyrightComment;
                copyrightEvidenceTextBox.Text = item.CopyrightEvidence;

                CustomGenericList<ItemTitle> itemTitles = new CustomGenericList<ItemTitle>();
                foreach (TitleItem titleItem in item.TitleItems)
                {
                    ItemTitle itemTitle = new ItemTitle();
                    itemTitle.TitleID = titleItem.TitleID;
                    itemTitle.ShortTitle = titleItem.ShortTitle;
                    itemTitle.IsPrimary = (item.PrimaryTitleID == titleItem.TitleID);
                    itemTitles.Add(itemTitle);
                }
                Session["ItemTitleList" + itemIdTextBox.Text] = itemTitles;

                titleList.DataSource = itemTitles;// item.Titles;
                titleList.DataBind();

                languagesList.DataSource = item.ItemLanguages;
                languagesList.DataBind();

                scannedByLabel.Text = item.ScanningUser;
                scannedDateLabel.Text = (item.ScanningDate.HasValue ? item.ScanningDate.Value.ToShortDateString() : "");
                creationDateLabel.Text = (item.CreationDate.HasValue ? item.CreationDate.Value.ToShortDateString() : "");
                lastModifiedDateLabel.Text =
                    (item.LastModifiedDate.HasValue ? item.LastModifiedDate.Value.ToShortDateString() : "");

                if (item.InstitutionCode != null && item.InstitutionCode.Length > 0)
                {
                    ddlInst.SelectedValue = item.InstitutionCode;
                }
                else
                {
                    ddlInst.SelectedIndex = 0;
                }

                if (item.LanguageCode != null && item.LanguageCode.Length > 0)
                {
                    ddlLang.SelectedValue = item.LanguageCode.ToUpper();
                }
                else
                {
                    ddlLang.SelectedIndex = 0;
                }

                if (item.VaultID.HasValue)
                {
                    ddlVault.SelectedValue = item.VaultID.Value.ToString();
                }
                else
                {
                    ddlVault.SelectedIndex = 0;
                }

                if (item.ItemStatusID > 0)
                {
                    ddlItemStatus.SelectedValue = item.ItemStatusID.ToString();
                }
                else
                {
                    ddlItemStatus.SelectedIndex = 0;
                }

                pageList.DataSource = item.Pages;
                pageList.DataBind();
            }
		}

		private void search( int? id, string barcode )
		{
			BHLProvider bp = new BHLProvider();
			Item item = bp.ItemSelectByBarcodeOrItemID( id, barcode );
            Session["Item" + itemIdTextBox.Text] = item;
			fillUI();
		}

		private void bindPageData()
		{
            Item item = (Item)Session["Item" + itemIdTextBox.Text];
			PageComparer comp = new PageComparer( (PageComparer.CompareEnum)_sortColumn, _sortOrder );
			item.Pages.Sort( comp );
			pageList.DataSource = item.Pages;
			pageList.DataBind();
		}

        private void bindTitleData()
        {
            CustomGenericList<ItemTitle> itemTitles = (CustomGenericList<ItemTitle>)Session["ItemTitleList" + itemIdTextBox.Text];
            titleList.DataSource = itemTitles;
            titleList.DataBind();
        }

		private bool validate( Item item )
		{
			bool flag = false;

            // Make sure that one and only one title is designated as the primary title.
            int primaryTitleId = 0;
            int numPrimary = 0;
            CustomGenericList<ItemTitle> itemTitles = (CustomGenericList<ItemTitle>)Session["ItemTitleList" + itemIdTextBox.Text];
            foreach (ItemTitle itemTitle in itemTitles)
            {
                if (itemTitle.IsPrimary)
                {
                    numPrimary++;
                    primaryTitleId = itemTitle.TitleID;
                }
            }
            if (numPrimary == 1)
            {
                item.PrimaryTitleID = primaryTitleId;
            }
            else
            {
                flag = true;
                errorControl.AddErrorText("One and only one title must be designated the Primary title for this item.");
            }

			// Check that all edits were completed
			if ( pageList.EditIndex != -1 )
			{
			  flag = true;
			  errorControl.AddErrorText( "Items has an edit pending" );
			}

			errorControl.Visible = flag;
			Page.MaintainScrollPositionOnPostBack = !flag;

			return !flag;
		}

        #region ItemLanguage methods

        private void bindLanguageData()
        {
            Item item = (Item)Session["Item" + itemIdTextBox.Text];

            // filter out deleted items
            CustomGenericList<ItemLanguage> itemLanguages = new CustomGenericList<ItemLanguage>();
            foreach (ItemLanguage il in item.ItemLanguages)
            {
                if (il.IsDeleted == false)
                {
                    itemLanguages.Add(il);
                }
            }

            languagesList.DataSource = itemLanguages;
            languagesList.DataBind();
        }

        CustomGenericList<Language> _itemLanguages = null;
        protected CustomGenericList<Language> GetLanguages()
        {
            BHLProvider bp = new BHLProvider();
            _itemLanguages = bp.LanguageSelectAll();

            return _itemLanguages;
        }

        protected int GetLanguageIndex(object dataItem)
        {
            String languageCode = DataBinder.Eval(dataItem, "LanguageCode").ToString();

            int ix = 0;
            foreach (Language language in _itemLanguages)
            {
                if (language.LanguageCode == languageCode)
                {
                    return ix;
                }
                ix++;
            }

            return 0;
        }

        private ItemLanguage findItemLanguage(CustomGenericList<ItemLanguage> itemLanguages,
            int itemLanguageId, string languageCode)
        {
            foreach (ItemLanguage il in itemLanguages)
            {
                if (il.IsDeleted)
                {
                    continue;
                }
                if (itemLanguageId == 0 && il.ItemLanguageID == 0 && languageCode == il.LanguageCode)
                {
                    return il;
                }
                else if (itemLanguageId > 0 && il.ItemLanguageID == itemLanguageId)
                {
                    return il;
                }
            }

            return null;
        }

        #endregion ItemLanguage methods

		#region Event handlers

        #region Title event handlers

        protected void titleList_RowEditing(object sender, GridViewEditEventArgs e)
        {
            titleList.EditIndex = e.NewEditIndex;
            bindTitleData();
        }

        protected void titleList_RowUpdating(object sender, GridViewUpdateEventArgs e)
        { 
            GridViewRow row = titleList.Rows[e.RowIndex];

            if (row != null)
            {
                CheckBox checkBox = row.FindControl("isPrimaryCheckBoxEdit") as CheckBox;
                if (checkBox != null)
                {
                    CustomGenericList<ItemTitle> itemTitles = (CustomGenericList<ItemTitle>)Session["ItemTitleList" + itemIdTextBox.Text];
                    bool isPrimary = checkBox.Checked;

                    String titleIdString = row.Cells[1].Text;
                    int titleId = 0;
                    int.TryParse(titleIdString, out titleId);

                    if (titleId > 0)
                    {
                        // Update primary title
                        foreach (ItemTitle itemTitle in itemTitles)
                        {
                            if (titleId == itemTitle.TitleID)
                            {
                                itemTitle.IsPrimary = isPrimary;
                                break;
                            }
                        }
                    }
                }
            }

            titleList.EditIndex = -1;
            bindTitleData();
        }

        protected void titleList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("RemoveButton"))
            {
                int rowNum = int.Parse(e.CommandArgument.ToString());
                int selectedTitle = (int)titleList.DataKeys[rowNum].Values[0];
                CustomGenericList<ItemTitle> itemTitles = (CustomGenericList<ItemTitle>)Session["ItemTitleList" + itemIdTextBox.Text];

                for (int i = 0; i < itemTitles.Count; i++)
                {
                    if (itemTitles[i].TitleID == selectedTitle)
                    {
                        itemTitles.RemoveAt(i);
                        break;
                    }
                }

                bindTitleData();
            }
        }

        protected void titleList_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            titleList.EditIndex = -1;
            bindTitleData();
        }

        #endregion Title event handlers

        #region TitleLanguage event handlers

        protected void languagesList_RowEditing(object sender, GridViewEditEventArgs e)
        {
            languagesList.EditIndex = e.NewEditIndex;
            bindLanguageData();
        }

        protected void languagesList_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = languagesList.Rows[e.RowIndex];

            if (row != null)
            {
                DropDownList ddlLanguageName = row.FindControl("ddlLanguageName") as DropDownList;
                if (ddlLanguageName != null)
                {
                    Item item = (Item)Session["Item" + itemIdTextBox.Text];
                    String languageCode = ddlLanguageName.SelectedValue;

                    ItemLanguage itemLanguage = findItemLanguage(item.ItemLanguages,
                    (int)languagesList.DataKeys[e.RowIndex].Values[0],
                    languagesList.DataKeys[e.RowIndex].Values[1].ToString());

                    itemLanguage.LanguageCode = languageCode;
                    itemLanguage.LanguageName = ddlLanguageName.SelectedItem.Text;
                }
            }

            languagesList.EditIndex = -1;
            bindLanguageData();
        }

        protected void languagesList_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            languagesList.EditIndex = -1;
            bindLanguageData();
        }

        protected void addLanguageButton_Click(object sender, EventArgs e)
        {
            Item item = (Item)Session["Item" + itemIdTextBox.Text];
            ItemLanguage il = new ItemLanguage(0, item.ItemID, "", DateTime.Now);
            item.ItemLanguages.Add(il);
            languagesList.EditIndex = languagesList.Rows.Count;
            bindLanguageData();
        }

        protected void languagesList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("RemoveButton"))
            {
                int rowNum = int.Parse(e.CommandArgument.ToString());
                Item item = (Item)Session["Item" + itemIdTextBox.Text];

                ItemLanguage itemLanguage = findItemLanguage(item.ItemLanguages,
                    (int)languagesList.DataKeys[rowNum].Values[0],
                    languagesList.DataKeys[rowNum].Values[1].ToString());

                itemLanguage.IsDeleted = true;
                bindLanguageData();
            }
        }

        #endregion TitleLanguage event handlers

        #region Page event handlers

        protected void pageList_RowEditing( object sender, GridViewEditEventArgs e )
		{
			pageList.EditIndex = e.NewEditIndex;
			bindPageData();
		}

		protected void pageList_RowUpdating( object sender, GridViewUpdateEventArgs e )
		{
			GridViewRow row = pageList.Rows[ e.RowIndex ];

			if ( row != null )
			{
				TextBox textBox = row.FindControl( "sequenceOrderTextBox" ) as TextBox;
				if ( textBox != null )
				{
                    Item item = (Item)Session["Item" + itemIdTextBox.Text];
					string seqOrderString = textBox.Text.Trim();

					int seqOrder = 0;
					int.TryParse( seqOrderString, out seqOrder );
					string pageIdString = row.Cells[ 0 ].Text;
					int pageId = 0;
					int.TryParse( pageIdString, out pageId );

					if ( seqOrder > 0 && pageId > 0 )
					{
						// Find current item sequence
						int? curSeqOrder = 0;
						foreach ( Paige page in item.Pages )
						{
							if ( page.PageID == pageId && page.SequenceOrder.HasValue )
							{
								curSeqOrder = page.SequenceOrder.Value;
								break;
							}
						}

						// Find item whose item sequence will be overwritten
						if ( curSeqOrder > 0 )
						{
							foreach ( Paige page in item.Pages )
							{
								if ( page.SequenceOrder == seqOrder )
								{
									// Change it to the changing item's item sequence
									page.SequenceOrder = curSeqOrder;
									break;
								}
							}
						}
						else // move all item sequences down by one
						{
							int id = pageId;
							int seqOrdert = seqOrder;
							foreach ( Paige page in item.Pages )
							{
								if ( page.SequenceOrder == seqOrdert && page.PageID != id )
								{
									if ( page.SequenceOrder.HasValue )
									{
										page.SequenceOrder = (int?)( page.SequenceOrder.Value + 1 );
										seqOrdert++;
									}
								}
								id = page.PageID;
							}
						}

						foreach ( Paige page in item.Pages )
						{
							if ( page.PageID == pageId )
							{
								page.SequenceOrder = seqOrder;
								break;
							}
						}
					}
				}
			}

			pageList.EditIndex = -1;
			bindPageData();
		}

		protected void pageList_RowCancelingEdit( object sender, GridViewCancelEditEventArgs e )
		{
			pageList.EditIndex = -1;
			bindPageData();
		}

		protected void pageList_Sorting( object sender, GridViewSortEventArgs e )
		{
			PageComparer.CompareEnum sortColumn = _sortColumn;

			if ( e.SortExpression.Equals( "PageID" ) )
			{
				_sortColumn = PageComparer.CompareEnum.PageID;
			}
			else if ( e.SortExpression.Equals( "FileNamePrefix" ) )
			{
				_sortColumn = PageComparer.CompareEnum.FileNamePrefix;
			}
			else if ( e.SortExpression.Equals( "SequenceOrder" ) )
			{
				_sortColumn = PageComparer.CompareEnum.SequenceOrder;
			}

			if ( sortColumn == _sortColumn )
			{
				if ( _sortOrder == SortOrder.Descending )
				{
					_sortOrder = SortOrder.Ascending;
				}
				else
				{
					_sortOrder = SortOrder.Descending;
				}
			}
			else
			{
				_sortOrder = SortOrder.Ascending;
			}

			ViewState[ "SortColumn" ] = _sortColumn;
			ViewState[ "SortOrder" ] = _sortOrder;

			bindPageData();
		}

		protected void pageList_RowDataBound( object sender, GridViewRowEventArgs e )
		{
			if ( e.Row.RowType == DataControlRowType.Header )
			{
				Image img = new Image();
				img.Attributes[ "style" ] = "padding-bottom:2px";
				if ( _sortOrder == SortOrder.Ascending )
				{
					img.ImageUrl = "/images/up.gif";
				}
				else
				{
					img.ImageUrl = "/Admin/images/down.gif";
				}

				int sortColumnIndex = 0;
				switch ( _sortColumn )
				{
					case PageComparer.CompareEnum.PageID:
						{
							sortColumnIndex = 0;
							break;
						}
					case PageComparer.CompareEnum.FileNamePrefix:
						{
							sortColumnIndex = 1;
							break;
						}
					case PageComparer.CompareEnum.SequenceOrder:
						{
							sortColumnIndex = 2;
							break;
						}
				}

				e.Row.Cells[ sortColumnIndex ].Controls.Add( new LiteralControl( " " ) );
				e.Row.Cells[ sortColumnIndex ].Controls.Add( img );
				e.Row.Cells[ sortColumnIndex ].Wrap = false;
			}
        }

        #endregion Page event handlers

        protected void searchButton_Click(object sender, EventArgs e)
        {
            int itemId = 0;
            if (int.TryParse(itemIdTextBox.Text.Trim(), out itemId))
            {
                search(itemId, null);
            }
            else if (barCodeTextBox.Text.Trim().Length > 0)
            {
                search(null, barCodeTextBox.Text.Trim());
            }
        }

        protected void saveButton_Click(object sender, EventArgs e)
		{
            Item item = (Item)Session["Item" + itemIdTextBox.Text];

			if ( validate( item ) )
			{
				// Gather up data on form
				short? s = null;
				int? i = null;
				item.MARCItemID = marcItemIDTextBox.Text.Trim();
				item.CallNumber = callNumberTextBox.Text.Trim();
				item.Volume = volumeTextBox.Text.Trim();
                item.InstitutionCode = (ddlInst.SelectedValue.Length == 0 ? null : ddlInst.SelectedValue);
				item.LanguageCode = ( ddlLang.SelectedValue.Length == 0 ? null : ddlLang.SelectedValue );
				item.Note = notesTextBox.Text.Trim();
                item.Year = yearTextBox.Text.Trim();
                item.IdentifierBib = identifierBibTextBox.Text.Trim();
                item.ZQuery = zQueryTextBox.Text.Trim();
                item.Sponsor = sponsorTextBox.Text.Trim();
                item.LicenseUrl = licenseUrlTextBox.Text.Trim();
                item.Rights = rightsTextBox.Text.Trim();
                item.DueDiligence = dueDiligenceTextBox.Text.Trim();
                item.CopyrightStatus = copyrightStatusTextBox.Text.Trim();
                item.CopyrightRegion = copyrightRegionTextBox.Text.Trim();
                item.CopyrightComment = copyrightCommentTextBox.Text.Trim();
                item.CopyrightEvidence = copyrightEvidenceTextBox.Text.Trim();
				item.VaultID = ( ddlVault.SelectedIndex == 0 ? i : int.Parse(ddlVault.SelectedValue) );
				item.ItemStatusID = int.Parse( ddlItemStatus.SelectedValue );

				item.IsNew = false;

                //----------------------------------------
                // Update the title information
                CustomGenericList<ItemTitle> itemTitles = (CustomGenericList<ItemTitle>)Session["ItemTitleList" + itemIdTextBox.Text];

                // Add new titles
                foreach (ItemTitle itemTitle in itemTitles)
                {
                    bool found = false;
                    foreach (TitleItem titleItem in item.TitleItems)
                    {
                        if (itemTitle.TitleID == titleItem.TitleID)
                        {
                            found = true;
                            break;
                        }
                    }
                    if (!found)
                    {
                        TitleItem newTitleItem = new TitleItem();
                        newTitleItem.TitleID = itemTitle.TitleID;
                        newTitleItem.ItemID = item.ItemID;
                        newTitleItem.ItemSequence = 1;
                        newTitleItem.IsNew = true;
                        item.TitleItems.Add(newTitleItem);
                    }
                }

                // Flag deleted titles
                foreach (TitleItem titleItem in item.TitleItems)
                {
                    bool found = false;
                    foreach (ItemTitle itemTitle in itemTitles)
                    {
                        if (titleItem.TitleID == itemTitle.TitleID)
                        {
                            found = true;
                            break;
                        }
                    }
                    if (!found) titleItem.IsDeleted = true;
                }
                //----------------------------------------

				BHLProvider bp = new BHLProvider();
				try
				{
					bp.ItemSave( item, 1 );
				}
				catch ( Exception ex )
				{
					Session[ "Exception" ] = ex;
					Response.Redirect( "/Error.aspx" );
				}
			}
			else
			{
				return;
			}

            litMessage.Text = "<span class='liveData'>Item Saved.</span>";
            Page.MaintainScrollPositionOnPostBack = false;
            //Response.Redirect("/Admin/Dashboard.aspx");
		}

        protected void PaginatorButton_Click(object sender, EventArgs e)
        {
            int titleId = 0;

            CustomGenericList<ItemTitle> itemTitles = (CustomGenericList<ItemTitle>)Session["ItemTitleList" + itemIdTextBox.Text];
            foreach (ItemTitle itemTitle in itemTitles)
            {
                if (itemTitle.IsPrimary) { titleId = itemTitle.TitleID; break; }
            }

            Response.Redirect("/Admin/Paginator.aspx?TitleID=" + titleId.ToString() + 
                "&ItemID=" + this.itemIdLabel.Text);
        }

		#endregion

        #region TitleItem

        private class ItemTitle : Title
        {
            private int _titleID;

            public int TitleID
            {
                get { return _titleID; }
                set { _titleID = value; }
            }

            private String _shortTitle;

            public String ShortTitle
            {
                get { return _shortTitle; }
                set { _shortTitle = value; }
            }

            private bool _isPrimary;

            public bool IsPrimary
            {
                get { return _isPrimary; }
                set { _isPrimary = value; }
            }
        }

        #endregion
    }
}
