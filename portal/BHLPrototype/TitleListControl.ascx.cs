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
using MOBOT.BHL.Server;
using CustomDataAccess;
using Data = MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Web
{
	public partial class TitleListControl : System.Web.UI.UserControl
	{
		BHLProvider provider = new BHLProvider();
		protected void Page_Load( object sender, EventArgs e )
		{
			String institutionCode = String.Empty;
			if ( this.Request.Cookies[ "ddlContributors" ] != null )
			{
				institutionCode = this.Request.Cookies[ "ddlContributors" ].Value;
			}

            String languageCode = String.Empty;
            if (this.Request.Cookies["ddlLanguage"] != null)
            {
                languageCode = this.Request.Cookies["ddlLanguage"].Value;
            }

            CustomGenericList<Data.Title> titleList = null;

			string startString = Request.QueryString[ "start" ];
			if ( startString == null || startString.Trim().Length == 0 )
			{
				startString = "A";
			}
            if (startString.ToUpper() == "ALL") startString = String.Empty;

            string titleListHtml = this.GetTitleListHtml(startString, institutionCode, languageCode);
            this.titleList.Text = titleListHtml;
		}

        private string GetTitleListHtml(string startString, string institutionCode, string languageCode)
        {
            System.Text.StringBuilder html = new System.Text.StringBuilder(); ;

            String cacheKey = "TitleBrowse" + startString + institutionCode + languageCode;
            if (Cache[cacheKey] != null)
            {
                // Use cached version
                html.Append(Cache[cacheKey].ToString());
            }
            else
            {
                // Refresh cache

                // Get the list of titles
                CustomGenericList<Data.Title> titleList = null;
                titleList = provider.TitleSelectByNameLike(startString, institutionCode, languageCode);

                // Format the titles into an HTML fragment
                html.Append("<p class=\"pageheader\">");
                if (startString == String.Empty) html.Append("All ");
                html.Append(titleList.Count.ToString() + " Title");
                if (titleList.Count != 1) html.Append("s");
                if (startString != String.Empty) html.Append(" beginning with \"" + startString.ToUpper() + "\"");
                html.Append("</p>");

                // Add HTML for each title in the list
                html.Append("<ol>");
                foreach (Data.Title title in titleList)
                {
                    html.Append("<li>");
                    html.Append("<a href=\"/bibliography/" + title.TitleID.ToString() + "\" class=\"booktitle\">");
                    html.Append(title.FullTitle + " " + title.PartNumber + " " + title.PartName);
                    html.Append("</a><br />Publication Info:&nbsp;");
                    html.Append(title.PublicationDetails);
                    html.Append("<br />Contributed By:&nbsp;");
                    html.Append(title.InstitutionName);
                    html.Append("</li>");
                }
                html.Append("</ol>");

                // Cache the HTML fragment
                Cache.Add(cacheKey, html.ToString(), null, DateTime.Now.AddMinutes(
                    Convert.ToDouble(ConfigurationManager.AppSettings["BrowseQueryCacheTime"])),
                    System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Normal, null);
            }

            return html.ToString();
        }
	}
}