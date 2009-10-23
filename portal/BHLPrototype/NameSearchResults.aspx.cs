using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Web.Utilities;
using CustomDataAccess;

namespace MOBOT.BHL.Web
{
	public partial class NameSearchResults : BasePage
	{
		protected string name = "";
        protected string lang = "";
		protected string PageNameMarkupText = "";
		protected string PageTypeComboClientId;

		private void fillPageTypeCombo()
		{
			CustomGenericList<PageType> pageTypes = bhlProvider.PageTypeSelectAll();

			PageType emptyPageType = new PageType();
			emptyPageType.PageTypeName = "";

			pageTypes.Insert( 0, emptyPageType );

			pageTypeCombo.DataTextField = "PageTypeName";
			pageTypeCombo.DataValueField = "PageTypeID";
			pageTypeCombo.DataSource = pageTypes;
			pageTypeCombo.DataBind();

			PageTypeComboClientId = pageTypeCombo.ClientID;
		}

		private void fillResultTree()
		{
			if ( Request.QueryString[ "name" ] != null )
			{
				name = Request.QueryString[ "name" ];
			}

            if (Request.Cookies["nameSearchLang"] != null)
            {
                lang = Request.Cookies["nameSearchLang"].Value;
                Request.Cookies.Remove("nameSearchLang");
            }

			// If we received a namebankid instead of a name, go get the name
			int nameBankID;
			if ( int.TryParse( name, out nameBankID ) )
			{
				PageName pageName = bhlProvider.PageNameSelectByNameBankID( nameBankID );
				name = pageName.NameConfirmed;
			}

			CustomGenericList<PageName> pageNames = bhlProvider.PageNameSelectByConfirmedName( name, lang );
			if ( pageNames.Count > 0 )
			{
				PageName pageName = pageNames[ 0 ];
				if ( pageName.NameBankID.HasValue )
				{
					if ( pageName.NameBankID != null && pageName.Active )
					{
						PageNameMarkup pageNameMarkup = new PageNameMarkup( pageName.NameFound, pageName.NameConfirmed,
							pageName.NameBankID );
						PageNameMarkupText = pageNameMarkup.UBioText;
					}
				}
			}
		}

		protected void Page_Load( object sender, EventArgs e )
		{
			main.SetPageType( Main.PageType.NamesResult );
			Master.Page.Header.Controls.Add( ControlGenerator.GetScriptControl( "/Scripts/BotanicusDropInViewerUtils.js" ) );

			if ( !IsPostBack )
			{
				//fillPageTypeCombo();
			}
			fillResultTree();

			main.Body.Attributes.Add( "onload", "ResizeNameBibliography();resizeViewerHeight(97);PerformSearch();" );
			main.Body.Attributes.Add( "onresize", "ResizeNameBibliography();resizeViewerHeight(97);" );
			main.Page.Title = "Biodiversity Heritage Library: Name Search - \"" + name + "\"";
		}

		//protected void pageTypeCombo_SelectedIndexChanged( object sender, EventArgs e )
		//{
		//  PageTypeId = int.Parse( pageTypeCombo.SelectedValue );
		//}
	}
}
