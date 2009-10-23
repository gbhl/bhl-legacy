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
    public partial class BrowseByTitleTag : BasePage
    {
        string tagText = "";
        protected void Page_Load( object sender, EventArgs e )
        {
            main.SetPageType( Main.PageType.Content );
            ControlGenerator.AddScriptControl( Page.Master.Page.Header.Controls, "/Scripts/ResizeBrowseUtils.js" );
            ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onload", 
                "ResizeBrowseDivs();ResizeContentPanel('browseContentPanel', 258);" );
            ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onresize", 
                "ResizeBrowseDivs();ResizeContentPanel('browseContentPanel', 258);" );

            String institutionCode = String.Empty;
            if (this.Request.Cookies["ddlContributors"] != null) institutionCode = this.Request.Cookies["ddlContributors"].Value;

            String languageCode = String.Empty;
            if (this.Request.Cookies["ddlLanguage"] != null) languageCode = this.Request.Cookies["ddlLanguage"].Value;

            if (Request.QueryString["tagText"] != null)
            tagText = Request.QueryString[ "tagText" ];

            // If we're referred here by the search page and the "secondary titles" flag was set,
            // then include secondary titles in the search.
            String includeSecondaryTitles = String.Empty;
            if (Request.UrlReferrer != null)
            {
                if (Request.UrlReferrer.LocalPath.ToLower().Contains("search.aspx") &&
                    Request.UrlReferrer.Query.ToLower().Contains("sec=1")) includeSecondaryTitles = "1";
            }
            CustomGenericList<Data.Title> list = bhlProvider.TitleSelectByTagTextInstitutionAndLanguage( tagText, institutionCode, languageCode, includeSecondaryTitles );
            //titleRepeater.DataSource = list;
            //titleRepeater.DataBind();

            string headerText = list.Count + " Title";
            if ( list.Count != 1 ) headerText += "s";
            headerText += " tagged with \"" + tagText + "\"";
            pageHeaderLabel.Text = headerText;

            foreach ( Data.Title title in list )
            {
                HtmlGenericControl li = new HtmlGenericControl( "li" );
                li.InnerHtml = "<a href=\"/bibliography/" + title.TitleID.ToString() + "\" class=\"booktitle\">" + title.FullTitle + 
                    " " + (title.PartNumber ?? "") + " " + (title.PartName ?? "") + 
                    "</a><br />" +
                    "Publication Info: " + title.PublicationDetails + "<br />" +
                            "Contributed By: " + title.InstitutionName + "<br/>" +
                    "Tags: ";
                foreach ( string tag in title.Tags )
                {
                    li.InnerHtml += "<a href=\"/subject/" + tag + "\" class=\"TitleTag\">" + tag + 
                        "</a>&nbsp;&nbsp;";
                }
                titleList.Controls.Add( li );
            }
        }
    }
}
