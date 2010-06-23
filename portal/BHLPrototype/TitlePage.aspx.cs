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
using Data = MOBOT.BHL.DataObjects;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;

namespace MOBOT.BHL.Web
{
  public partial class TitlePage : BasePage
  {
    protected void Page_Load( object sender, EventArgs e )
    {
        //Master.Page.Header.Controls.Add( ControlGenerator.GetScriptControl( "/Scripts/Ubio.js" ) );
        Master.Page.Header.Controls.Add(ControlGenerator.GetScriptControl("/Scripts/BotanicusDropInViewerUtils.js"));
        //Master.Page.Header.Controls.Add( ControlGenerator.GetScriptControl( "/Scripts/Highlighter.js" ) );

        pageListContentPanel.SetTableID("pageListTable");
        namesListContentPanel.SetTableID("nameListTable");
        //ControlGenerator.AddScriptControl(Page.Master.Page.Header.Controls, "/Scripts/ResizeContentPanelUtils.js");
        ControlGenerator.AddAttributesAndPreserveExisting(main.Body, "onload",
          "SetContentPanelWidth('pageListTable', 250);SetContentPanelWidth('nameListTable', 250);");
        ControlGenerator.AddAttributesAndPreserveExisting(main.Body, "onresize", "resizeViewerHeight(157);");

        main.SetPageType(Main.PageType.TitleViewer);
        // main.HideOverflow();

        if (!Page.IsPostBack)
        {
            PageSummaryView ps = null;

            if ((Request["BibId"] != null) &&
                ((Request["volume"] != null) || (Request["issue"] != null) || (Request["year"] != null) ||
                (Request["startpage"] != null)) &&
                Request["resolved"] == null)
            {
                Response.Redirect("PageResolve.aspx?" + Request.ServerVariables["QUERY_STRING"]);
            }

            if (ps == null)
            {
                if (Request.QueryString["pageid"] != null)
                {
                    int pageid;
                    if (int.TryParse(Request.QueryString["pageid"], out pageid))
                    {
                        ps = bhlProvider.PageSummarySelectByPageId(pageid);
                    }
                }
                else if (Request.QueryString["titleid"] != null)
                {
                    int titleid;
                    if (int.TryParse(Request.QueryString["titleid"], out titleid))
                    {
                        // Check to make sure this title hasn't been replaced.  If it has, redirect
                        // to the appropriate titleid.
                        Title title = bhlProvider.TitleSelect(titleid);
                        if (title.RedirectTitleID != null)
                        {
                            Response.Redirect("/title/" + title.RedirectTitleID.ToString());
                            Response.End();
                        }

                        ps = bhlProvider.PageTitleSummarySelectByTitleId(titleid);
                    }
                }
                else if (Request.QueryString["itemid"] != null)
                {
                    int itemid;
                    if (int.TryParse(Request.QueryString["itemid"], out itemid))
                    {
                        ps = bhlProvider.PageSummarySelectByItemId(itemid);
                    }
                }
                else if (Request["BibId"] != null)
                {
                    ps = bhlProvider.PageTitleSummarySelectByBibID(Request["bibID"].ToString());
                }
                else if (Request["Barcode"] != null)
                {
                    ps = bhlProvider.PageSummarySelectByBarcode(Request["Barcode"].ToString());
                }
                else if (Request["Prefix"] != null)
                {
                    ps = bhlProvider.PageSummarySelectByPrefix(Request["Prefix"].ToString());
                }
            }

            if (ps != null)
            {
                hidItemID.Value = ps.ItemID.ToString();
                ControlGenerator.AddAttributesAndPreserveExisting(main.Body, "onload",
                  "changePage(" + ps.SequenceOrder + ");resizeViewerHeight(157);");
            }
            else
            {
                // if our PageSummaryView is still null, then redirect because we couldn't find the requested title.
                Response.Redirect("/TitleNotFound.aspx");
                Response.End();
            }

            if (ps != null)
            {
                Master.Page.Title = "Biodiversity Heritage Library: " + ps.ShortTitle;

                // Set the item for the COinS
                COinSControl1.ItemID = ps.ItemID;

                CustomGenericList<MOBOT.BHL.DataObjects.Page> pages = bhlProvider.PageMetadataSelectByItemID(ps.ItemID);

                pageListBox.DataTextField = "WebDisplay";
                pageListBox.DataValueField = "PageID";
                pageListBox.DataSource = pages;
                pageListBox.DataBind();

                int totalPageCount = bhlProvider.PageSelectCountByItemID(ps.ItemID);
                hidSequenceMax.Value = totalPageCount.ToString();

                hidPageID.Value = ps.PageID.ToString();
                pageLink.InnerText = "/page/" + ps.PageID.ToString();
                titleVolumeSelectionControl.PopulateControl(ps);

                Data.Institution institution = bhlProvider.InstitutionSelectByItemID(ps.ItemID);
                if (institution != null)
                {
                    if (institution.InstitutionUrl != null && institution.InstitutionUrl.Trim().Length > 0)
                    {
                        HyperLink link = new HyperLink();
                        link.Text = institution.InstitutionName;
                        link.NavigateUrl = institution.InstitutionUrl;
                        link.Target = "_blank";
                        attributionPlaceHolder.Controls.Add(link);
                    }
                    else
                    {
                        Literal literal = new Literal();
                        literal.Text = institution.InstitutionName;
                        attributionPlaceHolder.Controls.Add(literal);
                    }
                    string attributionDivAttributesString = "";
                    if (BrowserUtility.IsBrowserIE6OrBelow(Request))
                        attributionDivAttributesString = ConfigurationManager.AppSettings["attributionDivPropertiesIE6"];
                    else
                        attributionDivAttributesString = ConfigurationManager.AppSettings["attributionDivPropertiesDefault"];

                    string[] attributionDivAttributeParts = attributionDivAttributesString.Split('|');
                    attributionDiv.Style.Add("position", attributionDivAttributeParts[0]);
                    attributionDiv.Style.Add("bottom", attributionDivAttributeParts[1]);
                }
            }
        }
    }
  }
}
