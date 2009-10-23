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
using MOBOT.BHL.Web.Utilities;

namespace MOBOT.BHL.Web
{
  public partial class _Default : BasePage
  {
    protected void Page_Load( object sender, EventArgs e )
    {
      if ( !Page.IsPostBack )
      {
        browseContentPanel.SetTableID( "browseContentPanel" );
        Master.Page.Header.Controls.Add( ControlGenerator.GetScriptControl( "/Scripts/ResizeBrowseUtils.js" ) );
        //ControlGenerator.AddScriptControl(Master.Page.Header.Controls, "/Scripts/ResizeContentPanelUtils.js");
        ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onload", 
          "ResizeBrowseDivs();ResizeContentPanel('browseContentPanel', 258);" );
        ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onresize", 
          "ResizeBrowseDivs();ResizeContentPanel('browseContentPanel', 258);" );

        main.SetPageType( Main.PageType.Content );
        loadBrowseControl();
      }
    }

    private void loadBrowseControl()
    {
      //default to the cloud view for now
      BrowseType browseType = BrowseType.Cloud;
      try
      {
        string browseTypeString = ConfigurationManager.AppSettings[ "defaultBrowseType" ].Trim().ToLower();
        if ( browseTypeString == BrowseType.Author.ToString().ToLower() )
          browseType = BrowseType.Author;
        else if ( browseTypeString == BrowseType.Cloud.ToString().ToLower() )
          browseType = BrowseType.Cloud;
        else if ( browseTypeString == BrowseType.Map.ToString().ToLower() )
          browseType = BrowseType.Map;
        else if ( browseTypeString == BrowseType.Title.ToString().ToLower() )
          browseType = BrowseType.Title;
        else if ( browseTypeString == BrowseType.Year.ToString().ToLower() )
          browseType = BrowseType.Year;
				else if ( browseTypeString == BrowseType.Name.ToString().ToLower() )
					browseType = BrowseType.Name;
			}
      catch
      {
        //do nothing...just let the default remain
      }
      //check to see if a value was passed in the querystring
      if ( Request.QueryString[ "browseType" ] != null && Request.QueryString[ "browseType" ] != "" )
      {
        switch ( Request.QueryString[ "browseType" ].Trim().ToLower() )
        {
          case "cloud":
            browseType = BrowseType.Cloud;
            break;
          case "title":
            browseType = BrowseType.Title;
            break;
          case "author":
            browseType = BrowseType.Author;
            break;
          case "map":
            browseType = BrowseType.Map;
            break;
          case "year":
            browseType = BrowseType.Year;
            break;
					case "name":
						browseType = BrowseType.Name;
						break;
        }

        //add this preference to the cookie so we can display it when the user returns to this page
        Response.Cookies.Add( new HttpCookie( "BotanicusBrowseType", browseType.ToString() ) );
      }
      //otherwise, check to see if a value is in a cookie
      else if ( Request.Cookies[ "BotanicusBrowseType" ] != null && Request.Cookies[ "BotanicusBrowseType" ].Value != "" )
      {
        switch ( Request.Cookies[ "BotanicusBrowseType" ].Value.Trim().ToLower() )
        {
          case "cloud":
            browseType = BrowseType.Cloud;
            break;
          case "title":
            browseType = BrowseType.Title;
            break;
          case "author":
            browseType = BrowseType.Author;
            break;
          case "map":
            browseType = BrowseType.Map;
            break;
          case "year":
            browseType = BrowseType.Year;
            break;
					case "name":
						browseType = BrowseType.Name;
						break;
				}
      }
      //otherwise, we'll just stay with the default

      //load the appropriate control based on the browse type preference
      switch ( browseType )
      {
        case BrowseType.Cloud:
          browseControlPlaceHolder.Controls.Add( LoadControl( "/TitleTagCloudControl.ascx" ) );
          break;
        case BrowseType.Title:
          browseControlPlaceHolder.Controls.Add( LoadControl( "/TitleListControl.ascx" ) );
          break;
        case BrowseType.Author:
          browseControlPlaceHolder.Controls.Add( LoadControl( "/CreatorListControl.ascx" ) );
          break;
        case BrowseType.Map:
          browseControlPlaceHolder.Controls.Add( LoadControl( "/MapControl.ascx" ) );
          break;
        case BrowseType.Year:
          browseControlPlaceHolder.Controls.Add( LoadControl( "/BrowseByYearControl.ascx" ) );
          break;
		case BrowseType.Name:
			browseControlPlaceHolder.Controls.Add( LoadControl( "/NameCloudControl.ascx" ) );
			break;
		default:
          browseControlPlaceHolder.Controls.Add( LoadControl( "/TitleTagCloudControl.ascx" ) );
          break;
      }
    }

    private enum BrowseType
    {
      Cloud,
      Title,
      Author,
      Map,
      Year,
			Name
    }
  }
}
