using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using CustomDataAccess;
using MOBOT.Utility;
using SortOrder = CustomDataAccess.SortOrder;

namespace MOBOT.BHL.Web.Admin
{
	public partial class PageNameEdit : System.Web.UI.Page
	{
		private PageNameComparer.CompareEnum _sortColumn = PageNameComparer.CompareEnum.NameFound;
		private SortOrder _sortOrder = SortOrder.Ascending;

		protected void Page_Load( object sender, EventArgs e )
		{
			if ( !IsPostBack )
			{
				string idString = Request.QueryString[ "id" ];
				int id = 0;
				if ( idString != null && int.TryParse( idString, out id ) )
				{
					pageIdTextBox.Text = id.ToString();
					search( id );
					fillUI();
				}
			}
			else
			{
				if ( ViewState[ "SortColumn" ] != null )
				{
					_sortColumn = (PageNameComparer.CompareEnum)ViewState[ "SortColumn" ];
					_sortOrder = (SortOrder)ViewState[ "SortOrder" ];
				}
			}

			errorControl.Visible = false;
			Page.MaintainScrollPositionOnPostBack = true;
		}

		private void fillUI()
		{
            PageSummaryView ps = (PageSummaryView)Session["Page" + pageIdTextBox.Text];

			pageIdLabel.Text = ps.PageID.ToString();
			titleLink.NavigateUrl = "/Admin/TitleEdit.aspx?id=" + ps.TitleID.ToString();
			titleLink.Text = ps.ShortTitle + " (" + ps.TitleID.ToString() + ")";
            itemLink.NavigateUrl = "/Admin/ItemEdit.aspx?id=" + ps.ItemID.ToString();
            itemLink.Text = (ps.Volume == "") ? "(click to edit volume)" : ps.Volume;
			descriptionLabel.Text = ps.PageDescription;
			addPageNameButton.Enabled = true;
			saveButton.Enabled = true;

            pageNameList.DataSource = (CustomGenericList<PageName>)Session["PageNames" + pageIdTextBox.Text];
			pageNameList.DataBind();

            string viewerUrl = new BHLProvider().GetPageUrl(ps);
			pageFrame.Attributes.Add( "src", viewerUrl );
		}

		private void search( int id )
		{
			BHLProvider bp = new BHLProvider();

			PageSummaryView ps = bp.PageSummarySelectByPageId( id );
            Session["Page" + pageIdTextBox.Text] = ps;

			CustomGenericList<PageName> pageNameList = bp.PageNameSelectByPageID( ps.PageID );
            Session["PageNames" + pageIdTextBox.Text] = pageNameList;

			fillUI();
		}

		#region PageNameList methods

		private void bindPageNameData( bool sort )
		{
            CustomGenericList<PageName> pageNames = (CustomGenericList<PageName>)Session["PageNames" + pageIdTextBox.Text];

			// filter out deleted items
			CustomGenericList<PageName> pns = new CustomGenericList<PageName>();
			foreach ( PageName pn in pageNames )
			{
				if ( pn.IsDeleted == false )
				{
					pns.Add( pn );
				}
			}
			if ( sort )
			{
				PageNameComparer comp = new PageNameComparer( (PageNameComparer.CompareEnum)_sortColumn, _sortOrder );
				pns.Sort( comp );
			}
			pageNameList.DataSource = pns;
			pageNameList.DataBind();
		}

		private PageName findPageName( CustomGenericList<PageName> pageNames, int pageNameId, string nameFound,
			string nameConfirmed, int? nameBankId, bool active )
		{
			foreach ( PageName pn in pageNames )
			{
				if ( pageNameId == 0 && nameBankId == pn.NameBankID && nameFound.ToLower().Equals( pn.NameFound.ToLower() ) &&
					TypeHelper.EmptyIfNull( nameConfirmed ).ToLower().Equals( TypeHelper.EmptyIfNull( pn.NameConfirmed ).ToLower() )
					&& active == pn.Active )
				{
					return pn;
				}
				else if ( pageNameId > 0 && pageNameId == pn.PageNameID )
				{
					return pn;
				}
			}

			return null;
		}

		protected bool SetNameFoundRO( object dataItem )
		{
			int pageNameId = (int)DataBinder.Eval( dataItem, "PageNameID" );

			return ( pageNameId > 0 );
		}

		#endregion

		private FindItItem ubioLookup( string name )
		{
			XmlTextReader reader = null;
			try
			{
				HttpWebRequest request = (HttpWebRequest)WebRequest.Create(
					"http://www.ubio.org/webservices/service.php?function=taxonFinder&includeLinks=0&freeText=" +
					Server.UrlEncode( name ) );
				request.Timeout = 15000;
				HttpWebResponse response = (HttpWebResponse)request.GetResponse();
				reader = new XmlTextReader( (Stream)response.GetResponseStream() );
				XmlDocument doc = new XmlDocument();
				doc.Load( reader );
				FindItItem result = null;
				// Taking this simple, straight forward approach because we're only expecting one result per check. Will
				// make parsing algorithm more robust later if needed.
				XmlNodeList nameList = doc.GetElementsByTagName( "nameString" );
				XmlNodeList idList = doc.GetElementsByTagName( "namebankID" );
				if ( nameList.Count == 1 )
				{
					result = new FindItItem();
					result.Name = nameList[ 0 ].InnerText;
					if ( idList.Count == 1 )
					{
						result.NamebankID = int.Parse( idList[ 0 ].InnerText );
					}
				}
				return result;
			}
			catch
			{
				return null;
			}
			finally
			{
				if ( reader != null )
				{
					reader.Close();
				}
			}
		}

		private bool validate( CustomGenericList<PageName> pageNames )
		{
			bool flag = false;

			// Check that all edits were completed
			if ( pageNameList.EditIndex != -1 )
			{
				flag = true;
				errorControl.AddErrorText( "Page names list has an edit pending" );
			}

			foreach ( PageName pageName in pageNames )
			{
				if ( pageName.NameFound.Trim().Length == 0 && pageName.IsDeleted == false )
				{
					flag = true;
					errorControl.AddErrorText( 
						"One or more of the page names have an empty Name Found. Please fill in missing data" );
					break;
				}
			}

			errorControl.Visible = flag;
			Page.MaintainScrollPositionOnPostBack = !flag;

			return !flag;
		}

		#region Event handlers

		protected void pageNameList_RowEditing( object sender, GridViewEditEventArgs e )
		{
			pageNameList.EditIndex = e.NewEditIndex;
			bindPageNameData( true );
		}

		protected void pageNameList_RowUpdating( object sender, GridViewUpdateEventArgs e )
		{
			GridViewRow row = pageNameList.Rows[ e.RowIndex ];

			if ( row != null )
			{
				CheckBox activeCheckBox = row.FindControl( "activeCheckBox" ) as CheckBox;
				TextBox nameFoundTextBox = row.FindControl( "nameFoundTextBox" ) as TextBox;
				if ( activeCheckBox != null && nameFoundTextBox != null )
				{
                    CustomGenericList<PageName> pageNames = (CustomGenericList<PageName>)Session["PageNames" + pageIdTextBox.Text];
					bool active = activeCheckBox.Checked;
					string nameFound = nameFoundTextBox.Text.Trim();

					int? i = null;
					PageName pageName = findPageName( pageNames,
						(int)pageNameList.DataKeys[ e.RowIndex ].Values[ 0 ],
						(string)pageNameList.DataKeys[ e.RowIndex ].Values[ 1 ],
						( pageNameList.DataKeys[ e.RowIndex ].Values[ 2 ] == null ?
							null : (string)pageNameList.DataKeys[ e.RowIndex ].Values[ 2 ] ),
						( pageNameList.DataKeys[ e.RowIndex ].Values[ 3 ] == null ?
							i : (int)pageNameList.DataKeys[ e.RowIndex ].Values[ 3 ] ),
						(bool)pageNameList.DataKeys[ e.RowIndex ].Values[ 4 ] );

					pageName.Active = active;
					pageName.NameFound = nameFound;
				}
			}

			pageNameList.EditIndex = -1;
			bindPageNameData( true );
		}

		protected void pageNameList_RowCancelingEdit( object sender, GridViewCancelEditEventArgs e )
		{
			pageNameList.EditIndex = -1;
			bindPageNameData( true );
		}

		protected void addPageNameButton_Click( object sender, EventArgs e )
		{
            PageSummaryView ps = (PageSummaryView)Session["Page" + pageIdTextBox.Text];
			PageName pn = new PageName();
			pn.PageID = ps.PageID;
            CustomGenericList<PageName> pageNames = (CustomGenericList<PageName>)Session["PageNames" + pageIdTextBox.Text];
			pageNames.Add( pn );
			pageNameList.EditIndex = pageNames.Count - 1;
			bindPageNameData( false );
		}

		protected void pageNameList_RowCommand( object sender, GridViewCommandEventArgs e )
		{
			if ( e.CommandName.Equals( "RemoveButton" ) )
			{
				int rowNum = int.Parse( e.CommandArgument.ToString() );
                CustomGenericList<PageName> pageNames = (CustomGenericList<PageName>)Session["PageNames" + pageIdTextBox.Text];

				int? i = null;
				PageName pageName = findPageName( pageNames,
					(int)pageNameList.DataKeys[ rowNum ].Values[ 0 ],
					(string)pageNameList.DataKeys[ rowNum ].Values[ 1 ],
					( pageNameList.DataKeys[ rowNum ].Values[ 2 ] == null ?
						null : (string)pageNameList.DataKeys[ rowNum ].Values[ 2 ] ),
					( pageNameList.DataKeys[ rowNum ].Values[ 3 ] == null ?
						i : (int)pageNameList.DataKeys[ rowNum ].Values[ 3 ] ),
					(bool)pageNameList.DataKeys[ rowNum ].Values[ 4 ] );

				pageName.IsDeleted = true;
				bindPageNameData( true );
			}
		}

		protected void pageNameList_Sorting( object sender, GridViewSortEventArgs e )
		{
			PageNameComparer.CompareEnum sortColumn = _sortColumn;

			if ( e.SortExpression.Equals( "NameFound" ) )
			{
				_sortColumn = PageNameComparer.CompareEnum.NameFound;
			}
			else if ( e.SortExpression.Equals( "NameConfirmed" ) )
			{
				_sortColumn = PageNameComparer.CompareEnum.NameConfirmed;
			}
			else if ( e.SortExpression.Equals( "NameBankID" ) )
			{
				_sortColumn = PageNameComparer.CompareEnum.NameBankID;
			}
			else if ( e.SortExpression.Equals( "Active" ) )
			{
				_sortColumn = PageNameComparer.CompareEnum.Active;
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

			bindPageNameData( true );
		}

		protected void pageNameList_RowDataBound( object sender, GridViewRowEventArgs e )
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

				int sortColumnIndex = 1;
				switch ( _sortColumn )
				{
					case PageNameComparer.CompareEnum.NameFound:
						{
							sortColumnIndex = 1;
							break;
						}
					case PageNameComparer.CompareEnum.NameConfirmed:
						{
							sortColumnIndex = 2;
							break;
						}
					case PageNameComparer.CompareEnum.NameBankID:
						{
							sortColumnIndex = 3;
							break;
						}
					case PageNameComparer.CompareEnum.Active:
						{
							sortColumnIndex = 4;
							break;
						}
				}

				e.Row.Cells[ sortColumnIndex ].Controls.Add( new LiteralControl( " " ) );
				e.Row.Cells[ sortColumnIndex ].Controls.Add( img );
				e.Row.Cells[ sortColumnIndex ].Wrap = false;
			}
		}

		protected void searchButton_Click( object sender, EventArgs e )
		{
			int pageId = 0;
			if ( int.TryParse( pageIdTextBox.Text.Trim(), out pageId ) )
			{
				search( pageId );
			}
		}

		protected void saveButton_Click( object sender, EventArgs e )
		{
            PageSummaryView ps = (PageSummaryView)Session["Page" + pageIdTextBox.Text];
            CustomGenericList<PageName> pageNames = (CustomGenericList<PageName>)Session["PageNames" + pageIdTextBox.Text];

			if ( validate( pageNames ) )
			{
				BHLProvider bp = new BHLProvider();
				try
				{
					foreach ( PageName pageName in pageNames )
					{
						if ( pageName.IsNew && pageName.Active )
						{
							PageName existingPageName =
								bp.PageNameSelectByPageIDAndNameFound( ps.PageID, pageName.NameFound );

							if ( existingPageName == null )
							{
								pageName.PageID = ps.PageID;
								pageName.Source = "User Reported";
								pageName.Active = true;
								// Get confirmed value and namebankid from uBio
								FindItItem uBioResult = ubioLookup( pageName.NameFound );
								if ( uBioResult != null )
								{
									pageName.NameConfirmed = TypeHelper.NullIfEmpty( uBioResult.Name );
									pageName.NameBankID = TypeHelper.NullIfZero( uBioResult.NamebankID );
								}
							}
						}
						else
						{
							if ( pageName.Active )
							{
								FindItItem uBioResult = ubioLookup( pageName.NameFound );
								if ( uBioResult != null && uBioResult.NamebankID >= 0 )
								{
									pageName.NameConfirmed = TypeHelper.NullIfEmpty( uBioResult.Name );
									pageName.NameBankID = TypeHelper.NullIfZero( uBioResult.NamebankID );
								}
							}
						}
					}

					bp.PageNameSaveList( pageNames );
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

			Response.Redirect( "/Admin/Dashboard.aspx" );
		}

		#endregion

	}
}
