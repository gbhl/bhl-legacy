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

namespace MOBOT.BHL.Web.Admin
{
	public partial class TitleEdit : System.Web.UI.Page
	{
		private TitleItemComparer.CompareEnum _sortColumn = TitleItemComparer.CompareEnum.ItemSequence;
		private SortOrder _sortOrder = SortOrder.Ascending;

		protected void Page_Load( object sender, EventArgs e )
		{
            ClientScript.RegisterClientScriptBlock(this.GetType(), "scptSelectItem", "<script language='javascript'>function selectItem(itemId) { document.getElementById('" + selectedItem.ClientID + "').value+=itemId+'|';}</script>");
            ClientScript.RegisterClientScriptBlock(this.GetType(), "scptClearItem", "<script language='javascript'>function clearItems() { document.getElementById('" + selectedItem.ClientID + "').value=''; overlay(); __doPostBack('', '');}</script>");
            ClientScript.RegisterClientScriptBlock(this.GetType(), "scptUpdateAssoc", "<script language='javascript'>function updateAssociations() { document.getElementById('" + associationsUpdated.ClientID + "').value='true'; __doPostBack('', '');}</script>");

            if (!IsPostBack)
			{
				string idString = Request.QueryString[ "id" ];
				int id = 0;
				if ( idString != null && int.TryParse( idString, out id ) )
				{
					fillCombos();
					fillUI( id );
				}
				else
				{
					// TODO: Inform user that title does not exist -- Perhaps redirect to unknown.aspx?type=title
				}
				showPubRadioButton.Checked = true;
			}
			else
			{
                String selectedItemIds = this.selectedItem.Value;
                if (selectedItemIds != "")
                {
                    Title title = (Title)Session["Title" + idLabel.Text];

                    if (selectedItemIds.EndsWith("|")) selectedItemIds = selectedItemIds.Substring(0, selectedItemIds.Length - 1);
                    String[] selectedItemIdList = selectedItemIds.Split('|');
                    foreach (String selectedItemId in selectedItemIdList)
                    {
                        TitleItem newTitleItem = new TitleItem();

                        // Get the current maximum itemsequence value
                        short? itemSequence = 0;
                        foreach (TitleItem titleItem in title.TitleItems)
                        {
                            if (titleItem.ItemSequence > itemSequence) itemSequence = titleItem.ItemSequence;
                        }

                        // Get details for "selectedItemId" from database
                        BHLProvider provider = new BHLProvider();
                        Item item = provider.ItemSelectAuto(Convert.ToInt32(selectedItemId));
                        newTitleItem.ItemID = Convert.ToInt32(selectedItemId);
                        newTitleItem.TitleID = title.TitleID;
                        newTitleItem.ItemSequence = ++itemSequence;
                        newTitleItem.ItemStatusID = item.ItemStatusID;
                        newTitleItem.BarCode = item.BarCode;
                        newTitleItem.Volume = item.Volume;
                        newTitleItem.PrimaryTitleID = (makePrimary.Checked) ? title.TitleID : item.PrimaryTitleID;
                        newTitleItem.IsNew = true;
                        title.TitleItems.Add(newTitleItem);
                    }

                    Session["Title" + title.TitleID.ToString()] = title;
                    this.selectedItem.Value = "";
                    this.bindItemData();
                }

                if (this.associationsUpdated.Value == "true")
                {
                    this.associationsUpdated.Value = String.Empty;
                    this.bindTitleAssociationData();
                }

                if (ViewState["SortColumn"] != null)
				{
					_sortColumn = (TitleItemComparer.CompareEnum)ViewState[ "SortColumn" ];
					_sortOrder = (SortOrder)ViewState[ "SortOrder" ];
				}
			}

            litMessage.Text = "";
			errorControl.Visible = false;
			Page.MaintainScrollPositionOnPostBack = true;
        }

        #region Fill methods

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
		}

		private void fillUI( int id )
		{
			BHLProvider bp = new BHLProvider();

			idLabel.Text = id.ToString();
            btnTitleAssociationAdd.Attributes["onclick"] = String.Format(btnTitleAssociationAdd.Attributes["onclick"], id.ToString());

			// Look up title
			Title title = bp.TitleSelectExtended( id );

			Session[ "Title" + title.TitleID.ToString()] = title;

            String displayTitle = ((title.ShortTitle.Length > 30) ? title.ShortTitle.Substring(0, 30) + "..." : title.ShortTitle);
            makePrimary.Text = "Make Title " + title.TitleID.ToString() + " (\"" + displayTitle + "\") the Primary title for the items.";
			publishReadyCheckBox.Checked = title.PublishReady;
			marcBibIdLabel.Text = title.MARCBibID;
			marcLeaderLabel.Text = title.MARCLeader;
			fullTitleTextBox.Text = title.FullTitle;
			shortTitleTextBox.Text = title.ShortTitle;
			sortTitleTextBox.Text = title.SortTitle;
			uniformTitleTextBox.Text = title.UniformTitle;
            partNumberTextBox.Text = title.PartNumber;
            partNameTextBox.Text = title.PartName;
			callNumberTextBox.Text = title.CallNumber;
            if (title.InstitutionCode != null && title.InstitutionCode.Length > 0)
            {
                ddlInst.SelectedValue = title.InstitutionCode;
            }
            else
            {
                ddlInst.SelectedIndex = 0;
            }

			if ( title.LanguageCode != null && title.LanguageCode.Length > 0 )
			{
				ddlLang.SelectedValue = title.LanguageCode;
			}
			else
			{
				ddlLang.SelectedIndex = 0;
			}

			descTextBox.Text = title.TitleDescription;
            publicationPlaceTextBox.Text = title.Datafield_260_a;
            publisherNameTextBox.Text = title.Datafield_260_b;
            publicationDateTextBox.Text = title.Datafield_260_c;
			startYearTextBox.Text = ( title.StartYear.HasValue ? title.StartYear.Value.ToString() : "" );
			endYearTextBox.Text = ( title.EndYear.HasValue ? title.EndYear.Value.ToString() : "" );
            OrigCatalogSourceTextBox.Text = title.OriginalCatalogingSource;
            EditionStatementTextBox.Text = title.EditionStatement;
            PubFrequencyTextBox.Text = title.CurrentPublicationFrequency;
			notesTextBox.Text = title.Note;

			creatorsList.DataSource = title.TitleCreators;
			creatorsList.DataBind();

            subjectsList.DataSource = title.TitleTags;
            subjectsList.DataBind();

            identifiersList.DataSource = title.TitleIdentifiers;
            identifiersList.DataBind();

            associationsList.DataSource = title.TitleAssociations;
            associationsList.DataBind();

			titleTypesList.DataSource = title.TitleTypes;
			titleTypesList.DataBind();

            languagesList.DataSource = title.TitleLanguages;
            languagesList.DataBind();

			bindItemData();
			//itemsList.DataSource = title.Items;
			//itemsList.DataBind();
        }

        #endregion Fill methods

        #region TitleCreator methods

        private void bindTitleCreatorData()
		{
			Title title = (Title)Session[ "Title" + idLabel.Text ];

			// filter out deleted items
			CustomGenericList<Title_Creator> titleCreators = new CustomGenericList<Title_Creator>();
			foreach ( Title_Creator tc in title.TitleCreators )
			{
				if ( tc.IsDeleted == false )
				{
					titleCreators.Add( tc );
				}
			}

			creatorsList.DataSource = titleCreators;
			creatorsList.DataBind();
		}

		CustomGenericList<Creator> _creators = null;
		protected CustomGenericList<Creator> GetCreators()
		{
			BHLProvider bp = new BHLProvider();
			_creators = bp.CreatorSelectAll();

			return _creators;
		}

		protected int GetCreatorIndex( object dataItem )
		{
			string creatorIdString = DataBinder.Eval( dataItem, "CreatorID" ).ToString();

			if ( !creatorIdString.Equals( "0" ) )
			{
				int creatorId = int.Parse( creatorIdString );
				int ix = 0;
				foreach ( Creator creator in _creators )
				{
					if ( creator.CreatorID == creatorId )
					{
						return ix;
					}
					ix++;
				}
			}

			return 0;
		}

		CustomGenericList<CreatorRoleType> _creatorRoleTypes = null;
		protected CustomGenericList<CreatorRoleType> GetCreatorRoles()
		{
			BHLProvider bp = new BHLProvider();
			_creatorRoleTypes = bp.CreatorRoleTypeSelectAll();

			return _creatorRoleTypes;
		}

		protected int GetCreatorRoleIndex( object dataItem )
		{
			string creatorRoleTypeIdString = DataBinder.Eval( dataItem, "CreatorRoleTypeID" ).ToString();

			if ( !creatorRoleTypeIdString.Equals( "0" ) )
			{
				int creatorRoleTypeId = int.Parse( creatorRoleTypeIdString );
				int ix = 0;
				foreach ( CreatorRoleType creatorRoleType in _creatorRoleTypes )
				{
					if ( creatorRoleType.CreatorRoleTypeID == creatorRoleTypeId )
					{
						return ix;
					}
					ix++;
				}
			}

			return 0;
		}

		private Title_Creator findTitleCreator( CustomGenericList<Title_Creator> titleCreators, int titleCreatorId,
			int creatorId, int creatorRoleTypeId )
		{
			foreach ( Title_Creator tc in titleCreators )
			{
				if ( tc.IsDeleted )
				{
					continue;
				}
				if ( titleCreatorId == 0 && tc.Title_CreatorID == 0 && creatorRoleTypeId == tc.CreatorRoleTypeID &&
					creatorId == tc.CreatorID )
				{
					return tc;
				}
				else if ( titleCreatorId > 0 && tc.Title_CreatorID == titleCreatorId )
				{
					return tc;
				}
			}

			return null;
		}

		#endregion

        #region TitleTag methods

        private void bindSubjectData()
        {
            Title title = (Title)Session["Title" + idLabel.Text];

            // filter out deleted items
            CustomGenericList<TitleTag> titleTags = new CustomGenericList<TitleTag>();
            foreach (TitleTag tt in title.TitleTags)
            {
                if (tt.IsDeleted == false)
                {
                    titleTags.Add(tt);
                }
            }

            subjectsList.DataSource = titleTags;
            subjectsList.DataBind();
        }

        private TitleTag findTitleTag(CustomGenericList<TitleTag> titleTags, int titleId, 
            string tagText)
        {
            foreach (TitleTag tt in titleTags)
            {
                if (tt.IsDeleted)
                {
                    continue;
                }
                if (titleId == tt.TitleID && tagText == tt.TagText)
                {
                    return tt;
                }
            }

            return null;
        }

        #endregion TitleTag methods

        #region TitleIdentifier methods

        private void bindTitleIdentifierData()
        {
            Title title = (Title)Session["Title" + idLabel.Text];

            // filter out deleted items
            CustomGenericList<Title_TitleIdentifier> titleTitleIdentifiers = new CustomGenericList<Title_TitleIdentifier>();
            foreach (Title_TitleIdentifier ti in title.TitleIdentifiers)
            {
                if (ti.IsDeleted == false)
                {
                    titleTitleIdentifiers.Add(ti);
                }
            }

            identifiersList.DataSource = titleTitleIdentifiers;
            identifiersList.DataBind();
        }

        CustomGenericList<TitleIdentifier> _titleIdentifiers = null;
        protected CustomGenericList<TitleIdentifier> GetTitleIdentifiers()
        {
            BHLProvider bp = new BHLProvider();
            _titleIdentifiers = bp.TitleIdentifierSelectAll();

            return _titleIdentifiers;
        }

        protected int GetTitleIdentifierIndex(object dataItem)
        {
            string titleIdentifierIdString = DataBinder.Eval(dataItem, "TitleIdentifierID").ToString();

            if (!titleIdentifierIdString.Equals("0"))
            {
                int titleIdentifierId = int.Parse(titleIdentifierIdString);
                int ix = 0;
                foreach (TitleIdentifier titleIdentifier in _titleIdentifiers)
                {
                    if (titleIdentifier.TitleIdentifierID == titleIdentifierId)
                    {
                        return ix;
                    }
                    ix++;
                }
            }

            return 0;
        }

        private Title_TitleIdentifier findTitle_TitleIdentifier(CustomGenericList<Title_TitleIdentifier> titleTitleIdentifiers, 
            int titleTitleIdentifierId, int titleIdentifierID, string identifierValue)
        {
            foreach (Title_TitleIdentifier tti in titleTitleIdentifiers)
            {
                if (tti.IsDeleted)
                {
                    continue;
                }
                if (titleTitleIdentifierId == 0 && tti.Title_TitleIdentifierID == 0 && 
                    titleIdentifierID == 0 && tti.TitleIdentifierID == 0 &&
                    identifierValue == "" && tti.IdentifierValue == "")
                {
                    return tti;
                }
                else if (titleTitleIdentifierId > 0 && tti.Title_TitleIdentifierID == titleTitleIdentifierId)
                {
                    return tti;
                }
            }

            return null;
        }

        #endregion

        #region TitleAssociation methods

        private void bindTitleAssociationData()
        {
            Title title = (Title)Session["Title" + idLabel.Text];

            // filter out deleted items
            CustomGenericList<TitleAssociation> titleAssociations = new CustomGenericList<TitleAssociation>();
            foreach (TitleAssociation ta in title.TitleAssociations)
            {
                if (ta.IsDeleted == false)
                {
                    titleAssociations.Add(ta);
                }
            }

            associationsList.DataSource = titleAssociations;
            associationsList.DataBind();
        }

        private TitleAssociation findTitleAssociation(CustomGenericList<TitleAssociation> titleAssociations,
            int titleAssociationId)
        {
            foreach (TitleAssociation ta in titleAssociations)
            {
                if (ta.IsDeleted)
                {
                    continue;
                }
                if (titleAssociationId == 0 && ta.TitleAssociationID == 0)
                {
                    return ta;
                }
                else if (titleAssociationId > 0 && ta.TitleAssociationID == titleAssociationId)
                {
                    return ta;
                }
            }

            return null;
        }

        #endregion TitleAssociation methods

        #region TitleLanguage methods

        private void bindLanguageData()
        {
            Title title = (Title)Session["Title" + idLabel.Text];

            // filter out deleted items
            CustomGenericList<TitleLanguage> titleLanguages = new CustomGenericList<TitleLanguage>();
            foreach (TitleLanguage tl in title.TitleLanguages)
            {
                if (tl.IsDeleted == false)
                {
                    titleLanguages.Add(tl);
                }
            }

            languagesList.DataSource = titleLanguages;
            languagesList.DataBind();
        }

        CustomGenericList<Language> _titleLanguages = null;
        protected CustomGenericList<Language> GetLanguages()
        {
            BHLProvider bp = new BHLProvider();
            _titleLanguages = bp.LanguageSelectAll();

            return _titleLanguages;
        }

        protected int GetLanguageIndex(object dataItem)
        {
            String languageCode = DataBinder.Eval(dataItem, "LanguageCode").ToString();

            int ix = 0;
            foreach (Language language in _titleLanguages)
            {
                if (language.LanguageCode == languageCode)
                {
                    return ix;
                }
                ix++;
            }

            return 0;
        }

        private TitleLanguage findTitleLanguage(CustomGenericList<TitleLanguage> titleLanguages, 
            int titleLanguageId, string languageCode)
        {
            foreach (TitleLanguage tl in titleLanguages)
            {
                if (tl.IsDeleted)
                {
                    continue;
                }
                if (titleLanguageId == 0 && tl.TitleLanguageID == 0 && languageCode == tl.LanguageCode)
                {
                    return tl;
                }
                else if (titleLanguageId > 0 && tl.TitleLanguageID == titleLanguageId)
                {
                    return tl;
                }
            }

            return null;
        }

        #endregion TitleLanguage methods

        #region TitleType methods

        private void bindTitleTypeData()
		{
            Title title = (Title)Session["Title" + idLabel.Text];

			// filter out deleted items
			CustomGenericList<Title_TitleType> titleTypes = new CustomGenericList<Title_TitleType>();
			foreach ( Title_TitleType tt in title.TitleTypes )
			{
				if ( tt.IsDeleted == false )
				{
					titleTypes.Add( tt );
				}
			}

			titleTypesList.DataSource = titleTypes;
			titleTypesList.DataBind();
		}

		CustomGenericList<TitleType> _titleTypes = null;
		protected CustomGenericList<TitleType> GetTitleTypes()
		{
			BHLProvider bp = new BHLProvider();
			_titleTypes = bp.TitleTypeSelectAll();

			return _titleTypes;
		}

		protected int GetTitleTypeIndex( object dataItem )
		{
			string titleTypeIdString = DataBinder.Eval( dataItem, "TitleTypeID" ).ToString();

			if ( !titleTypeIdString.Equals( "0" ) )
			{
				int titleTypeId = int.Parse( titleTypeIdString );
				int ix = 0;
				foreach ( TitleType titleType in _titleTypes )
				{
					if ( titleType.TitleTypeID == titleTypeId )
					{
						return ix;
					}
					ix++;
				}
			}

			return 0;
		}

		private Title_TitleType findTitleType( CustomGenericList<Title_TitleType> titleTypes, int title_TitleTypeId,
			int titleTypeId )
		{
			foreach ( Title_TitleType tt in titleTypes )
			{
				if ( tt.IsDeleted )
				{
					continue;
				}
				if ( title_TitleTypeId == 0 && tt.Title_TitleTypeID == 0 && titleTypeId == tt.TitleTypeID )
				{
					return tt;
				}
				else if ( title_TitleTypeId > 0 && tt.Title_TitleTypeID == title_TitleTypeId )
				{
					return tt;
				}
			}

			return null;
		}

		#endregion

        #region Item methods

        private void bindItemData()
		{
            Title title = (Title)Session["Title" + idLabel.Text];

			CustomGenericList<TitleItem> items = new CustomGenericList<TitleItem>();
			if ( showPubRadioButton.Checked || ( showAllRadioButton.Checked == false && showPubRadioButton.Checked == false ) )
			{
				foreach ( TitleItem item in title.TitleItems )
				{
					if (( item.ItemStatusID == 40 ) && (!item.IsDeleted))
					{
						items.Add( item );
					}
				}
			}
			else if ( showAllRadioButton.Checked )
			{
                foreach(TitleItem item in title.TitleItems)
                {
                    if (!item.IsDeleted) items.Add(item);
                }
			}

			TitleItemComparer comp = new TitleItemComparer( (TitleItemComparer.CompareEnum)_sortColumn, _sortOrder );
			items.Sort( comp );
			itemsList.DataSource = items;
			itemsList.DataBind();
        }

        #endregion Item methods

		#region Event handlers

        #region Creator event handlers

        protected void creatorsList_RowEditing( object sender, GridViewEditEventArgs e )
		{
			creatorsList.EditIndex = e.NewEditIndex;
			bindTitleCreatorData();
		}

		protected void creatorsList_RowUpdating( object sender, GridViewUpdateEventArgs e )
		{
			GridViewRow row = creatorsList.Rows[ e.RowIndex ];

			if ( row != null )
			{
				DropDownList ddlCreatorName = row.FindControl( "ddlCreatorName" ) as DropDownList;
				DropDownList ddlCreatorRole = row.FindControl( "ddlCreatorRole" ) as DropDownList;
				if ( ddlCreatorName != null && ddlCreatorRole != null )
				{
                    Title title = (Title)Session["Title" + idLabel.Text];
					int creatorId = int.Parse( ddlCreatorName.SelectedValue );
					int creatorRoleTypeId = int.Parse( ddlCreatorRole.SelectedValue );

					Title_Creator titleCreator = findTitleCreator( title.TitleCreators,
						(int)creatorsList.DataKeys[ e.RowIndex ].Values[ 0 ],
						(int)creatorsList.DataKeys[ e.RowIndex ].Values[ 1 ],
						(int)creatorsList.DataKeys[ e.RowIndex ].Values[ 2 ] );

					titleCreator.CreatorID = creatorId;
					titleCreator.CreatorRoleTypeID = creatorRoleTypeId;
					titleCreator.Creator.CreatorName = ddlCreatorName.SelectedItem.Text;
					titleCreator.CreatorRoleTypeDescription = ddlCreatorRole.SelectedItem.Text;
				}
			}

			creatorsList.EditIndex = -1;
			bindTitleCreatorData();
		}

		protected void creatorsList_RowCancelingEdit( object sender, GridViewCancelEditEventArgs e )
		{
			creatorsList.EditIndex = -1;
			bindTitleCreatorData();
		}

		protected void addCreatorButton_Click( object sender, EventArgs e )
		{
            Title title = (Title)Session["Title" + idLabel.Text];
			Title_Creator tc = new Title_Creator();
			tc.TitleID = title.TitleID;
			tc.Creator = new Creator();
			title.TitleCreators.Add( tc );
			creatorsList.EditIndex = creatorsList.Rows.Count;
			bindTitleCreatorData();
		}

		protected void creatorsList_RowCommand( object sender, GridViewCommandEventArgs e )
		{
			if ( e.CommandName.Equals( "RemoveButton" ) )
			{
				int rowNum = int.Parse( e.CommandArgument.ToString() );
                Title title = (Title)Session["Title" + idLabel.Text];

				Title_Creator titleCreator = findTitleCreator( title.TitleCreators,
					(int)creatorsList.DataKeys[ rowNum ].Values[ 0 ],
					(int)creatorsList.DataKeys[ rowNum ].Values[ 1 ],
					(int)creatorsList.DataKeys[ rowNum ].Values[ 2 ] );

				titleCreator.IsDeleted = true;
				bindTitleCreatorData();
			}
        }

        #endregion Creator event handlers

        #region TitleTag event handlers

        protected void subjectsList_RowEditing(object sender, GridViewEditEventArgs e)
        {
            subjectsList.EditIndex = e.NewEditIndex;
            bindSubjectData();
        }

        protected void subjectsList_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = subjectsList.Rows[e.RowIndex];

            if (row != null)
            {
                TextBox txtTagText = row.FindControl("txtTagText") as TextBox;
                TextBox txtMarcDataFieldTag = row.FindControl("txtMarcDataFieldTag") as TextBox;
                TextBox txtMarcSubFieldCode = row.FindControl("txtMarcSubFieldCode") as TextBox;
                if (txtTagText != null)
                {
                    Title title = (Title)Session["Title" + idLabel.Text];
                    String tagText = txtTagText.Text;
                    String marcDataFieldTag = txtMarcDataFieldTag.Text;
                    String marcSubFieldCode = txtMarcSubFieldCode.Text;

                    TitleTag titleTag = findTitleTag(title.TitleTags,
                        (int)subjectsList.DataKeys[e.RowIndex].Values[0],
                        subjectsList.DataKeys[e.RowIndex].Values[1].ToString());

                    titleTag.TitleID = title.TitleID;
                    titleTag.TagText = tagText;
                    titleTag.MarcDataFieldTag = marcDataFieldTag;
                    titleTag.MarcSubFieldCode = marcSubFieldCode;
                }
            }

            subjectsList.EditIndex = -1;
            bindSubjectData();
        }

        protected void subjectsList_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            subjectsList.EditIndex = -1;
            bindSubjectData();
        }

        protected void addSubjectButton_Click(object sender, EventArgs e)
        {
            Title title = (Title)Session["Title" + idLabel.Text];
            TitleTag titleTag = new TitleTag();
            titleTag.TitleID = title.TitleID;
            title.TitleTags.Add(titleTag);
            subjectsList.EditIndex = subjectsList.Rows.Count;
            bindSubjectData();
        }

        protected void subjectsList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("RemoveButton"))
            {
                int rowNum = int.Parse(e.CommandArgument.ToString());
                Title title = (Title)Session["Title" + idLabel.Text];

                TitleTag titleTag = findTitleTag(title.TitleTags,
                    (int)subjectsList.DataKeys[rowNum].Values[0],
                    subjectsList.DataKeys[rowNum].Values[1].ToString());

                titleTag.IsDeleted = true;
                bindSubjectData();
            }
        }

        #endregion TitleTag event handlers

        #region TitleIdentifier event handlers

        protected void identifiersList_RowEditing(object sender, GridViewEditEventArgs e)
        {
            identifiersList.EditIndex = e.NewEditIndex;
            bindTitleIdentifierData();
        }

        protected void identifiersList_RowUpdating(object sender, GridViewUpdateEventArgs e)
        {
            GridViewRow row = identifiersList.Rows[e.RowIndex];

            if (row != null)
            {
                DropDownList ddlIdentifierName = row.FindControl("ddlIdentifierName") as DropDownList;
                TextBox txtIdentifierValue = row.FindControl("txtIdentifierValue") as TextBox;
                if (ddlIdentifierName != null && txtIdentifierValue != null)
                {
                    Title title = (Title)Session["Title" + idLabel.Text];
                    int titleIdentifierId = int.Parse(ddlIdentifierName.SelectedValue);
                    String identifierValue = txtIdentifierValue.Text;

                    Title_TitleIdentifier titleTitleIdentifier = findTitle_TitleIdentifier(title.TitleIdentifiers,
                        (int)identifiersList.DataKeys[e.RowIndex].Values[0],
                        (int)identifiersList.DataKeys[e.RowIndex].Values[1],
                        identifiersList.DataKeys[e.RowIndex].Values[2].ToString());

                    titleTitleIdentifier.TitleID = title.TitleID;
                    titleTitleIdentifier.TitleIdentifierID = titleIdentifierId;
                    titleTitleIdentifier.IdentifierName = ddlIdentifierName.SelectedItem.Text;
                    titleTitleIdentifier.IdentifierValue = identifierValue;
                }
            }

            identifiersList.EditIndex = -1;
            bindTitleIdentifierData();
        }

        protected void identifiersList_RowCancelingEdit(object sender, GridViewCancelEditEventArgs e)
        {
            identifiersList.EditIndex = -1;
            bindTitleIdentifierData();
        }

        protected void addTitleIdentifierButton_Click(object sender, EventArgs e)
        {
            Title title = (Title)Session["Title" + idLabel.Text];
            Title_TitleIdentifier ti = new Title_TitleIdentifier();
            ti.TitleID = title.TitleID;
            title.TitleIdentifiers.Add(ti);
            identifiersList.EditIndex = identifiersList.Rows.Count;
            bindTitleIdentifierData();
        }

        protected void identifiersList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("RemoveButton"))
            {
                int rowNum = int.Parse(e.CommandArgument.ToString());
                Title title = (Title)Session["Title" + idLabel.Text];

                Title_TitleIdentifier titleTitleIdentifier = findTitle_TitleIdentifier(title.TitleIdentifiers,
                    (int)identifiersList.DataKeys[rowNum].Values[0],
                    (int)identifiersList.DataKeys[rowNum].Values[1],
                    identifiersList.DataKeys[rowNum].Values[2].ToString());

                titleTitleIdentifier.IsDeleted = true;
                bindTitleIdentifierData();
            }
        }

        #endregion TitleIdentifier event handlers

        #region Association event handlers

        protected void associationsList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("RemoveButton"))
            {
                int rowNum = int.Parse(e.CommandArgument.ToString());
                Title title = (Title)Session["Title" + idLabel.Text];

                TitleAssociation titleAssociation = findTitleAssociation(title.TitleAssociations,
                    (int)associationsList.DataKeys[rowNum].Values[0]);

                // Delete the association and any related title identifiers
                titleAssociation.IsDeleted = true;
                foreach(TitleAssociation_TitleIdentifier tati in titleAssociation.TitleAssociationIdentifiers)
                {
                    tati.IsDeleted = true;
                }
                bindTitleAssociationData();
            }
        }

        #endregion Association event handlers

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
                    Title title = (Title)Session["Title" + idLabel.Text];
                    String languageCode = ddlLanguageName.SelectedValue;

                    TitleLanguage titleLanguage = findTitleLanguage(title.TitleLanguages,
                    (int)languagesList.DataKeys[e.RowIndex].Values[0],
                    languagesList.DataKeys[e.RowIndex].Values[1].ToString());

                    titleLanguage.LanguageCode = languageCode;
                    titleLanguage.LanguageName = ddlLanguageName.SelectedItem.Text;
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
            Title title = (Title)Session["Title" + idLabel.Text];
            TitleLanguage tl = new TitleLanguage(0, title.TitleID, "", DateTime.Now);
            title.TitleLanguages.Add(tl);
            languagesList.EditIndex = languagesList.Rows.Count;
            bindLanguageData();
        }

        protected void languagesList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("RemoveButton"))
            {
                int rowNum = int.Parse(e.CommandArgument.ToString());
                Title title = (Title)Session["Title" + idLabel.Text];

                TitleLanguage titleLanguage = findTitleLanguage(title.TitleLanguages,
                    (int)languagesList.DataKeys[rowNum].Values[0],
                    languagesList.DataKeys[rowNum].Values[1].ToString());

                titleLanguage.IsDeleted = true;
                bindLanguageData();
            }
        }

        #endregion TitleLanguage event handlers

        #region TitleType event handlers

        protected void titleTypesList_RowEditing(object sender, GridViewEditEventArgs e)
		{
			titleTypesList.EditIndex = e.NewEditIndex;
			bindTitleTypeData();
		}

		protected void titleTypesList_RowUpdating( object sender, GridViewUpdateEventArgs e )
		{
			GridViewRow row = titleTypesList.Rows[ e.RowIndex ];

			if ( row != null )
			{
				DropDownList ddlTitleType = row.FindControl( "ddlTitleType" ) as DropDownList;
				if ( ddlTitleType != null )
				{
                    Title title = (Title)Session["Title" + idLabel.Text];
					int titleTypeId = int.Parse( ddlTitleType.SelectedValue );

					Title_TitleType titleType = findTitleType( title.TitleTypes,
					(int)titleTypesList.DataKeys[ e.RowIndex ].Values[ 0 ],
					(int)titleTypesList.DataKeys[ e.RowIndex ].Values[ 1 ] );

					titleType.TitleTypeID = titleTypeId;
					titleType.TitleType = ddlTitleType.SelectedItem.Text;
				}
			}

			titleTypesList.EditIndex = -1;
			bindTitleTypeData();
		}

		protected void titleTypesList_RowCancelingEdit( object sender, GridViewCancelEditEventArgs e )
		{
			titleTypesList.EditIndex = -1;
			bindTitleTypeData();
		}

		protected void addTitleTypeButton_Click( object sender, EventArgs e )
		{
            Title title = (Title)Session["Title" + idLabel.Text];
			Title_TitleType tt = new Title_TitleType( 0, title.TitleID, 0 );
			title.TitleTypes.Add( tt );
			titleTypesList.EditIndex = titleTypesList.Rows.Count;
			bindTitleTypeData();
		}

		protected void titleTypesList_RowCommand( object sender, GridViewCommandEventArgs e )
		{
			if ( e.CommandName.Equals( "RemoveButton" ) )
			{
				int rowNum = int.Parse( e.CommandArgument.ToString() );
                Title title = (Title)Session["Title" + idLabel.Text];

				Title_TitleType titleType = findTitleType( title.TitleTypes,
					(int)titleTypesList.DataKeys[ rowNum ].Values[ 0 ],
					(int)titleTypesList.DataKeys[ rowNum ].Values[ 1 ] );

				titleType.IsDeleted = true;
				bindTitleTypeData();
			}
		}

        #endregion TitleType event handlers

        #region Item event handlers

        protected void itemsList_RowEditing(object sender, GridViewEditEventArgs e
            )
		{
			itemsList.EditIndex = e.NewEditIndex;
			bindItemData();
		}

        protected void itemsList_RowCommand(object sender, GridViewCommandEventArgs e)
        {
            if (e.CommandName.Equals("RemoveButton"))
            {
                int rowNum = int.Parse(e.CommandArgument.ToString());
                int selectedItem = (int)itemsList.DataKeys[rowNum].Values[0];
                Title title = (Title)Session["Title" + idLabel.Text];
                foreach (TitleItem titleItem in title.TitleItems)
                {
                    if (selectedItem == titleItem.ItemID)
                    {
                        if ((title.TitleID == titleItem.PrimaryTitleID) && (!titleItem.IsNew))
                        {
                            errorControl.AddErrorText("Cannot delete previously saved items for which this is the primary title.");
                            errorControl.Visible = true;
                            Page.MaintainScrollPositionOnPostBack = false;
                        }
                        else
                        {
                            titleItem.IsDeleted = true;
                        }
                        break;
                    }
                }
                bindItemData();
            }
        }

        protected void itemsList_RowUpdating(object sender, GridViewUpdateEventArgs e)
		{
			GridViewRow row = itemsList.Rows[ e.RowIndex ];

			if ( row != null )
			{
				TextBox textBox = row.FindControl( "itemSequenceTextBox" ) as TextBox;
				if ( textBox != null )
				{
                    Title title = (Title)Session["Title" + idLabel.Text];

                    string newItemSeqString = textBox.Text.Trim();
                    short newItemSeq = 0;
					short.TryParse( newItemSeqString, out newItemSeq );

					string itemIdString = row.Cells[ 1 ].Text;
					int itemId = 0;
					int.TryParse( itemIdString, out itemId );

					if ( newItemSeq > 0 && itemId > 0 )
					{
						// Find item being changed
						short? oldItemSeq = 0;
                        TitleItem changedItem = null;

						foreach ( TitleItem item in title.TitleItems )
						{
							if ( item.ItemID == itemId && item.ItemSequence.HasValue )
							{
                                changedItem = item;
								oldItemSeq = changedItem.ItemSequence.Value;
								break;
							}
						}

                        if (changedItem != null)
                        {
                            // If sequence has been decreased
                            if (newItemSeq < oldItemSeq)
                            {
                                // Increment all item sequences between the old and new sequence values
                                foreach (TitleItem item in title.TitleItems)
                                {
                                    if (item.ItemSequence >= newItemSeq && item.ItemSequence < oldItemSeq)
                                    {
                                        item.ItemSequence++;
                                    }
                                }
                            }

                            // If sequence has been increased
                            if (newItemSeq > oldItemSeq)
                            {
                                // Decrement all item sequences between the old and new sequence values
                                foreach (TitleItem item in title.TitleItems)
                                {
                                    if (item.ItemSequence <= newItemSeq && item.ItemSequence > oldItemSeq)
                                    {
                                        item.ItemSequence--;
                                    }
                                }
                            }

                            // Change the old sequence value to the new sequence value
                            changedItem.ItemSequence = newItemSeq;
                            /*
                            foreach ( TitleItem item in title.TitleItems )
                            {
                                if ( item.ItemID == itemId )
                                {
                                    item.ItemSequence = newItemSeq;
                                    break;
                                }
                            }
                            */
                        }
					}
				}
			}

			itemsList.EditIndex = -1;
			bindItemData();
		}

		protected void itemsList_RowCancelingEdit( object sender, GridViewCancelEditEventArgs e )
		{
			itemsList.EditIndex = -1;
			bindItemData();
		}

		protected void itemsList_Sorting( object sender, GridViewSortEventArgs e )
		{
			TitleItemComparer.CompareEnum sortColumn = _sortColumn;

			if ( e.SortExpression.Equals( "ItemID" ) )
			{
				_sortColumn = TitleItemComparer.CompareEnum.ItemID;
			}
			else if ( e.SortExpression.Equals( "BarCode" ) )
			{
				_sortColumn = TitleItemComparer.CompareEnum.BarCode;
			}
			else if ( e.SortExpression.Equals( "ItemSequence" ) )
			{
				_sortColumn = TitleItemComparer.CompareEnum.ItemSequence;
			}
			else if ( e.SortExpression.Equals( "Volume" ) )
			{
				_sortColumn = TitleItemComparer.CompareEnum.Volume;
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

			bindItemData();
		}

		protected void itemsList_RowDataBound( object sender, GridViewRowEventArgs e )
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
					case TitleItemComparer.CompareEnum.BarCode:
						{
							sortColumnIndex = 1;
							break;
						}
					case TitleItemComparer.CompareEnum.ItemSequence:
						{
							sortColumnIndex = 2;
							break;
						}
					case TitleItemComparer.CompareEnum.Volume:
						{
							sortColumnIndex = 3;
							break;
						}
				}

				e.Row.Cells[ sortColumnIndex ].Controls.Add( new LiteralControl( " " ) );
				e.Row.Cells[ sortColumnIndex ].Controls.Add( img );
				e.Row.Cells[ sortColumnIndex ].Wrap = false;
			}
        }

        protected void itemFilter_CheckedChanged(object sender, EventArgs e)
        {
            bindItemData();
        }

        #endregion Item event handlers

        protected void saveButton_Click( object sender, EventArgs e )
		{
            Title title = (Title)Session["Title" + idLabel.Text];

			if ( validate( title ) )
			{
				// Gather up data on form
				short? s = null;
                title.PublishReady = publishReadyCheckBox.Checked;
				title.FullTitle = fullTitleTextBox.Text.Trim();
				title.ShortTitle = shortTitleTextBox.Text.Trim();
				title.SortTitle = sortTitleTextBox.Text.Trim();
				title.UniformTitle = uniformTitleTextBox.Text.Trim();
                title.PartNumber = partNumberTextBox.Text.Trim();
                title.PartName = partNameTextBox.Text.Trim();
				title.CallNumber = callNumberTextBox.Text.Trim();
                title.InstitutionCode = (ddlInst.SelectedValue.Length == 0 ? null : ddlInst.SelectedValue);
				title.LanguageCode = ( ddlLang.SelectedValue.Length == 0 ? null : ddlLang.SelectedValue );
				title.TitleDescription = descTextBox.Text.Trim();
				title.PublicationDetails = publicationPlaceTextBox.Text.Trim() + publisherNameTextBox.Text.Trim() + publicationDateTextBox.Text.Trim();
                title.Datafield_260_a = publicationPlaceTextBox.Text.Trim();
                title.Datafield_260_b = publisherNameTextBox.Text.Trim();
                title.Datafield_260_c = publicationDateTextBox.Text.Trim();
				title.StartYear = ( startYearTextBox.Text.Trim().Length == 0 ? s : short.Parse( startYearTextBox.Text.Trim() ) );
				title.EndYear = ( endYearTextBox.Text.Trim().Length == 0 ? s : short.Parse( endYearTextBox.Text.Trim() ) );
                title.OriginalCatalogingSource = OrigCatalogSourceTextBox.Text.Trim();
                title.EditionStatement = EditionStatementTextBox.Text.Trim();
                title.CurrentPublicationFrequency = PubFrequencyTextBox.Text.Trim();
				title.Note = notesTextBox.Text.Trim();

				title.IsNew = false;

				// Forces deletes to happen first
				title.TitleTypes.Sort( SortOrder.Descending, "IsDeleted" );
                title.TitleIdentifiers.Sort(SortOrder.Descending, "IsDeleted");
				title.TitleCreators.Sort( SortOrder.Descending, "IsDeleted" );
                title.TitleItems.Sort(SortOrder.Descending, "IsDeleted");
                title.TitleTags.Sort(SortOrder.Descending, "IsDeleted");
                title.TitleAssociations.Sort(SortOrder.Descending, "IsDeleted");

				BHLProvider bp = new BHLProvider();
				try
				{
					bp.TitleSave( title, 1 );
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

            litMessage.Text = "<span class='liveData'>Title Saved.</span>";
            Page.MaintainScrollPositionOnPostBack = false;
            //Response.Redirect( "/Admin/Dashboard.aspx" );
		}

		#endregion

        private bool validate(Title title)
        {
            bool flag = false;

            // Check that all edits were completed
            if (creatorsList.EditIndex != -1)
            {
                flag = true;
                errorControl.AddErrorText("Creators has an edit pending");
            }

            if (identifiersList.EditIndex != -1)
            {
                flag = true;
                errorControl.AddErrorText("Identifiers has an edit pending");
            }

            if (titleTypesList.EditIndex != -1)
            {
                flag = true;
                errorControl.AddErrorText("Title types has an edit pending");
            }

            if (itemsList.EditIndex != -1)
            {
                flag = true;
                errorControl.AddErrorText("Items has an edit pending");
            }

            if (fullTitleTextBox.Text.Trim().Length == 0)
            {
                flag = true;
                errorControl.AddErrorText("Full title is missing");
            }

            short x = 0;
            if (startYearTextBox.Text.Trim().Length > 0)
            {
                if (short.TryParse(startYearTextBox.Text.Trim(), out x) == false)
                {
                    flag = true;
                    errorControl.AddErrorText("Start Year must be a numeric value between 0 and 32767");
                }
            }

            if (endYearTextBox.Text.Trim().Length > 0)
            {
                if (short.TryParse(endYearTextBox.Text.Trim(), out x) == false)
                {
                    flag = true;
                    errorControl.AddErrorText("End Year must be a numeric value between 0 and 32767");
                }
            }

            bool br = false;
            int ix = 0;
            foreach (Title_TitleType tt in title.TitleTypes)
            {
                if (tt.IsDeleted == false)
                {
                    int iy = 0;
                    foreach (Title_TitleType tt2 in title.TitleTypes)
                    {
                        if (tt2.IsDeleted == false)
                        {
                            if ((tt.Title_TitleTypeID != tt2.Title_TitleTypeID && tt.TitleTypeID == tt2.TitleTypeID) ||
                                (tt.Title_TitleTypeID == 0 && tt2.Title_TitleTypeID == 0 && tt.TitleTypeID == tt2.TitleTypeID &&
                                ix != iy))
                            {
                                br = true;
                                flag = true;
                                errorControl.AddErrorText("Cannot duplicate title types");
                                break;
                            }
                        }
                        iy++;
                    }
                    if (br)
                    {
                        break;
                    }
                }
                ix++;
            }

            br = false;
            ix = 0;
            foreach (Title_Creator tc in title.TitleCreators)
            {
                if (tc.IsDeleted == false)
                {
                    int iy = 0;
                    foreach (Title_Creator tc2 in title.TitleCreators)
                    {
                        if (tc2.IsDeleted == false)
                        {
                            if ((tc.Title_CreatorID != tc2.Title_CreatorID && tc.CreatorID == tc2.CreatorID &&
                                tc.CreatorRoleTypeID == tc2.CreatorRoleTypeID) ||
                                (tc.Title_CreatorID == 0 && tc.Title_CreatorID == 0 && tc.CreatorID == tc2.CreatorID &&
                                tc.CreatorRoleTypeID == tc2.CreatorRoleTypeID && ix != iy))
                            {
                                br = true;
                                flag = true;
                                errorControl.AddErrorText("Cannot duplicate title creators");
                            }
                        }
                        iy++;
                    }
                    if (br)
                    {
                        break;
                    }
                }
                ix++;
            }

            errorControl.Visible = flag;
            Page.MaintainScrollPositionOnPostBack = !flag;

            return !flag;
        }
	}
}
