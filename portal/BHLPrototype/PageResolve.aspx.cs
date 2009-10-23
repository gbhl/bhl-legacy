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
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using CustomDataAccess;

namespace MOBOT.BHL.Web
{
  public partial class PageResolve : BasePage
  {
    protected void Page_Load( object sender, EventArgs e )
    {
      if ( !IsPostBack )
      {
        browseContentPanel.SetTableID( "browseContentPanel" );
        Master.Page.Header.Controls.Add( ControlGenerator.GetScriptControl( "/Scripts/ResizeBrowseUtils.js" ) );
        ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onload",
          "ResizeBrowseDivs();ResizeContentPanel('browseContentPanel', 258);" );
        ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onresize",
          "ResizeBrowseDivs();ResizeContentPanel('browseContentPanel', 258);" );

        main.SetPageType( Main.PageType.Content );
      }

      if ( ( Request.QueryString[ "titleid" ] != null ||
        Request.QueryString[ "pid" ] != null || Request.QueryString[ "title" ] != null || 
        Request.QueryString[ "stitle" ] != null ) &&
        ( ( Request.QueryString[ "volume" ] != null ) || ( Request.QueryString[ "issue" ] != null ) || 
        ( Request.QueryString[ "year" ] != null ) || ( Request.QueryString[ "startpage" ] != null ) || 
        ( Request.QueryString[ "spage" ] != null ) || ( Request.QueryString[ "date" ] != null ) ) )
      {
        string volume = "";
        string issue = "";
        string year = "";
        string startpage = "";

        if ( Request.QueryString[ "volume" ] != null )
        {
          volume = Request.QueryString[ "volume" ].ToString();
        }
        if ( Request.QueryString[ "issue" ] != null )
        {
          issue = Request.QueryString[ "issue" ].ToString();
        }
        if ( Request.QueryString[ "year" ] != null )
        {
          year = Request.QueryString[ "year" ].ToString();
        }
        if ( Request.QueryString[ "startpage" ] != null )
        {
          startpage = Request.QueryString[ "startpage" ].ToString();
        }
        if ( Request.QueryString[ "spage" ] != null )
        {
          startpage = Request.QueryString[ "spage" ].ToString();
        }
        if ( Request.QueryString[ "date" ] != null )
        {
          year = Request.QueryString[ "date" ].ToString();
        }

        //see if this is a valid date value...if so, only use the year portion
        DateTime date;
        if ( DateTime.TryParse( year, out date ) )
        {
          year = date.Year.ToString();
        }

        if ( volume.Trim().Length == 0 )
        {
          volumeLiteral.Text = "not supplied";
        }
        else
        {
          volumeLiteral.Text = volume;
        }

        if ( issue.Trim().Length == 0 )
        {
          issueLiteral.Text = "not supplied";
        }
        else
        {
          issueLiteral.Text = issue;
        }

        if ( year.Trim().Length == 0 )
        {
          yearLiteral.Text = "not supplied";
        }
        else
        {
          yearLiteral.Text = year;
        }

        if ( startpage.Trim().Length == 0 )
        {
          startPageLiteral.Text = "not supplied";
        }
        else
        {
          startPageLiteral.Text = startpage;
        }

        int titleId = 0;
        string fullTitle = "";
        string abbreviation = "";

        if ( Request.QueryString[ "titleid" ] != null )
        {
          int.TryParse( Request.QueryString[ "titleid" ], out titleId );
        }

        if ( Request.QueryString[ "pid" ] != null )
        {
          int.TryParse( Request.QueryString[ "pid" ], out titleId );
        }

        if ( Request.QueryString[ "title" ] != null )
        {
          fullTitle = Request.QueryString[ "title" ];
        }
        if ( Request.QueryString[ "stitle" ] != null )
        {
          abbreviation = Request.QueryString[ "stitle" ];
        }

        MOBOT.BHL.DataObjects.Title title = null;
        if ( titleId > 0 )
        {
          title = bhlProvider.TitleSelectAuto( titleId );
        }
        else if ( fullTitle != null && fullTitle.Trim().Length > 0 )
        {
          CustomGenericList<MOBOT.BHL.DataObjects.Title> titleList = bhlProvider.TitleSelectByFullTitle( fullTitle );
          if ( titleList.Count == 1 )
          {
            titleId = titleList[ 0 ].TitleID;
          }
        }
        else if ( abbreviation != null && abbreviation.Trim().Length > 0 )
        {
          CustomGenericList<MOBOT.BHL.DataObjects.Title> titleList = bhlProvider.TitleSelectByAbbreviation( abbreviation );
          if ( titleList.Count == 1 )
          {
            titleId = titleList[ 0 ].TitleID;
          }
        }

        PageSummaryView ps = null;

        if ( titleId > 0 )
        {
          ps = bhlProvider.PageTitleSummarySelectByTitleId( titleId );
        }

        if ( ps == null )
        {
          resultMessageLiteral.Text = "We're sorry, but we were not able to map your request to a particular title.";
        }
        else
        {
          titleLiteral.Text = ps.FullTitle;
          resultMessageLiteral.Text = "Title found...move on to the next step...";
          CustomGenericList<CustomDataRow> list = bhlProvider.PageResolve( ps.TitleID, volume, issue, year, startpage );
          if ( !UniqueItemFound( list ) )
          {
            // Couldn't narrow down to a single item/volume, therefore, redirect to the bibliography page and let them choose 
            // from there
            resultMessageLiteral.Text = "We're sorry, but we were unable to resolve the page you requested to a unique " +
              "item. Please visit the <a href=\"/bibliography/" + ps.TitleID.ToString() + "\">bibliography</a> page for " +
              "this title to browse for the requested page.";
          }
          else if ( list.Count > 1 || !IsResultAnExactMatch( list[ 0 ] ) )
          {
            // Multiple results so show the results and let the user pick
            resultMessageLiteral.Text = "We're sorry, but we were not able to find an exact match based on the above " +
              "criteria. However, we did find options that are close. Please select one of the pages below or visit the " +
              "<a href=\"/bibliography/" + ps.TitleID.ToString() + "\">bibliography</a> page for this title to browse " +
              "for the requested page.<br />";

            // Kind of kludgy, but since we don't have a typed object to work with, we can't bind to a repeater.
            foreach ( CustomDataRow row in list )
            {
              string singleResut = "<br /><a href=\"page/" + row[ "PageID" ].Value.ToString() + "\">";
              if ( row[ "Year" ].Value != null )
              {
                singleResut += "Year: " + row[ "Year" ].Value.ToString() + "; ";
              }

              if ( row[ "Issue" ].Value != null )
              {
                singleResut += "Issue: " + row[ "Issue" ].Value.ToString() + "; ";
              }

              if ( row[ "Volume" ].Value != null )
              {
                singleResut += "Volume: " + row[ "Volume" ].Value.ToString() + "; ";
              }

              if ( row[ "PagePrefix" ].Value != null && row[ "PageNumber" ].Value != null )
              {
                singleResut += "Start Page: " + row[ "PagePrefix" ].Value.ToString() + " " +
                  row[ "PageNumber" ].Value.ToString() + "; ";
              }

              singleResut += "(ID: " + row[ "PageID" ].Value.ToString() + ")</a><br />";

              similarResultsLiteral.Text += singleResut;
            }
          }
          else
          {
            // Narrowed it down to one potential page. If all criteria matches exactly, redirect to title page.  
            // Otherwise display the single result and acknowledge that it is not an exact match
            Response.Redirect( "/page/" + list[ 0 ][ "PageID" ].Value.ToString() );
          }
        }
      }
      else
      {
        resultMessageLiteral.Text = "We're sorry, but we were not able to map your request to a particular title.";
      }
    }

    private bool UniqueItemFound( CustomGenericList<CustomDataRow> list )
    {
      ArrayList uniqueItemIDs = new ArrayList();
      foreach ( CustomDataRow row in list )
      {
        if ( !ValuePresentInArray( uniqueItemIDs, (int)row[ "ItemID" ].Value ) )
        {
          uniqueItemIDs.Add( (int)row[ "ItemID" ].Value );
        }
      }
      return uniqueItemIDs.Count == 1;
    }

    private bool ValuePresentInArray( ArrayList list, int intValue )
    {
      foreach ( int item in list )
      {
        if ( item == intValue )
        {
          return true;
        }
      }
      return false;
    }

    private bool IsResultAnExactMatch( CustomDataRow row )
    {
      bool volumeProvided = ( Request.QueryString[ "volume" ] != null && Request.QueryString[ "volume" ].Trim().Length > 0 );
      bool issueProvided = ( Request.QueryString[ "issue" ] != null && Request.QueryString[ "issue" ].Trim().Length > 0 );
      bool yearProvided = ( Request.QueryString[ "year" ] != null && Request.QueryString[ "year" ].Trim().Length > 0 );
      bool startPageProvided = ( Request.QueryString[ "startpage" ] != null && 
        Request.QueryString[ "startpage" ].Trim().Length > 0 );

      string volumeValue = "";
      string issueValue = "";
      string yearValue = "";
      string startPageValue = "";

      if ( row[ "Volume" ].Value != null )
      {
        volumeValue = row[ "Volume" ].Value.ToString();
      }

      if ( row[ "Issue" ].Value != null )
      {
        issueValue = row[ "Issue" ].Value.ToString();
      }

      if ( row[ "Year" ].Value != null )
      {
        yearValue = row[ "Year" ].Value.ToString();
      }

      if ( row[ "PageNumber" ].Value != null )
      {
        startPageValue = row[ "PageNumber" ].Value.ToString();
      }

      bool allCriteriaExceptYearMatched = ( ( !volumeProvided || Request.QueryString[ "volume" ].Equals( volumeValue ) &&
        ( !issueProvided || Request.QueryString[ "issue" ] == issueValue ) &&
        ( !startPageProvided || Request.QueryString[ "startpage" ] == startPageValue ) ) );

      if ( allCriteriaExceptYearMatched )
      {
        Year year = new Year( yearValue );
        return ( !yearProvided || year.IsProvidedYearValidForPage( Request.QueryString[ "year" ] ) );
      }
      else
      {
        return false;
      }
    }
  }
}
