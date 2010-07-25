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
using Data = MOBOT.BHL.DataObjects;
using CustomDataAccess;
using MOBOT.BHL.Web.Utilities;

namespace MOBOT.BHL.Web
{
  public partial class CreatorPage : BasePage
  {
    protected void Page_Load( object sender, EventArgs e )
    {

      ControlGenerator.AddAttributesAndPreserveExisting(main.Body, "onload", "resizeContentDiv()");
      ControlGenerator.AddAttributesAndPreserveExisting(main.Body, "onresize", "resizeContentDiv()");

      //authorListContentPanel.SetTableID("authorListContentPanel");
      authorContentPanel.SetTableID( "authorDetailContentPanel" );
      //Page.Master.Page.Header.Controls.Add(ControlGenerator.GetScriptControl("/Scripts/ResizeContentPanelUtils.js"));
      //ControlGenerator.AddScriptControl(Page.Master.Page.Header.Controls, "/Scripts/ResizeContentPanelUtils.js");
      //ControlGenerator.AddScriptControl( Page.Master.Page.Header.Controls, "/Scripts/ResizeBrowseUtils.js" );
      //ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onload", "ResizeContentPanel('authorDetailContentPanel', 258);ResizeBrowseDivs();" );
      //ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onresize", "ResizeContentPanel('authorDetailContentPanel', 258);ResizeBrowseDivs();" );
      
      //CustomGenericList<Data.Creator> creators = bhlProvider.CreatorSelectAll();
      //authorsDropDownList.DataSource = creators;
      //authorsDropDownList.DataTextField = "CreatorName";
      //authorsDropDownList.DataValueField = "CreatorId";
      //authorsDropDownList.DataBind();
      //authorsDropDownList.Attributes.Add("onchange",
      //                          "location.href='/creator/' + this.options[selectedIndex].value");


      if ( Request[ "CreatorId" ] != null )
      {
        int creatorId = 0;
        try
        {
          creatorId = int.Parse( Request[ "CreatorId" ] );
        }
        catch
        {
          CreatorNotFound();
        }
        Data.Creator c = bhlProvider.CreatorSelectAuto( creatorId );
        if ( c == null )
          CreatorNotFound();

        //authorsDropDownList.SelectedValue = c.CreatorID.ToString();
        creatorNameLiteral.Text = c.MARCCreator_a;
        if (c.MARCCreator_b != null) creatorNameLiteral.Text += " " + c.MARCCreator_b;
        if ( c.DOB != null && c.DOB != "" )
        {
          lifespanLiteral.Text = c.DOB;
        }
        if ( c.DOD != null && c.DOD != "" )
        {
          if ( lifespanLiteral.Text != "" )
          {
            lifespanLiteral.Text += " - " + c.DOD;
          }
          else
          {
            lifespanLiteral.Text += "Died " + c.DOD;
          }
        }
        else if ( lifespanLiteral.Text != "" )
        {
          lifespanLiteral.Text = "Born " + lifespanLiteral.Text;
        }
        if ( lifespanLiteral.Text != "" )
        {
          lifespanLiteral.Text = "(" + lifespanLiteral.Text + ")";
        }

        // If we're referred here by the search page and the "secondary titles" flag was set,
        // then include secondary titles in the search.
        String includeSecondaryTitles = String.Empty;
        if (Request.UrlReferrer != null)
        {
            if (Request.UrlReferrer.LocalPath.ToLower().Contains("search.aspx") &&
                Request.UrlReferrer.Query.ToLower().Contains("sec=1")) includeSecondaryTitles = "1";
        }
        titlesRepeater.DataSource = bhlProvider.TitleSelectByCreator( c.CreatorID, includeSecondaryTitles );
        titlesRepeater.DataBind();

        biographyLiteral.Text = c.Biography;
      }
    }

    private void CreatorNotFound()
    {
      Response.Redirect( "/CreatorNotFound.aspx" );
      Response.End();
    }
  }
}
