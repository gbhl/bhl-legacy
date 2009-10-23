using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Data = MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using CustomDataAccess;

namespace MOBOT.BHL.Web
{
    public partial class CreatorListControl : System.Web.UI.UserControl
    {
        BHLProvider provider = new BHLProvider();

        protected void Page_Load(object sender, EventArgs e)
        {
            String institutionCode = String.Empty;
            if (this.Request.Cookies["ddlContributors"] != null) institutionCode = this.Request.Cookies["ddlContributors"].Value;
            String languageCode = String.Empty;
            if (this.Request.Cookies["ddlLanguage"] != null) languageCode = this.Request.Cookies["ddlLanguage"].Value;

            if (Request.QueryString["start"] != null && Request.QueryString["start"].Trim().Length > 0)
            {
                creatorList.Text = this.GetAuthorListHtml(Request.QueryString["start"].Trim(), 
                    institutionCode, languageCode);
            }
            else
            {
                creatorListAllLiteral.Text = GetCompleteAuthorList(institutionCode, languageCode);
            }
        }

        private string GetAuthorListHtml(string startString, string institutionCode, string languageCode)
        {
            System.Text.StringBuilder html = new System.Text.StringBuilder(); ;

            String cacheKey = "CreatorBrowse" + startString + institutionCode + languageCode;
            if (Cache[cacheKey] != null)
            {
                // Use cached version
                html.Append(Cache[cacheKey].ToString());
            }
            else
            {
                // Refresh cache

                // Get the list of authors
                CustomGenericList<Data.Creator> creatorList = null;
                creatorList = provider.CreatorSelectByCreatorNameLikeAndInstitution(startString, institutionCode, languageCode);

                // Format the titles into an HTML fragment
                html.Append("<p class=\"pageheader\">");
                html.Append(creatorList.Count.ToString() + " author");
                if (creatorList.Count != 1) html.Append("s");
                if (startString != String.Empty) html.Append(" beginning with \"" + startString.ToUpper() + "\"");
                html.Append("</p>");

                // Add HTML for each title in the list
                html.Append("<ul>");
                foreach (Data.Creator creator in creatorList)
                {
                    html.Append("<li>");
                    html.Append("<a href=\"/creator/" + creator.CreatorID.ToString() + "\">");
                    html.Append(creator.CreatorName);
                    if (creator.MARCCreator_b != null) html.Append(creator.MARCCreator_b);
                    if (!String.IsNullOrEmpty(creator.DOB)) html.Append(creator.DOB + "-");
                    html.Append(creator.DOD);
                    html.Append("</a>");
                    html.Append("</li>");
                }
                html.Append("</ul>");

                // Cache the HTML fragment
                Cache.Add(cacheKey, html.ToString(), null, DateTime.Now.AddMinutes(
                    Convert.ToDouble(ConfigurationManager.AppSettings["BrowseQueryCacheTime"])),
                    System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Normal, null);
            }

            return html.ToString();
        }

        private string GetCompleteAuthorList(String institutionCode, String languageCode)
        {
            StringBuilder html = new StringBuilder();

            String cacheKey = "CreatorBrowseAll" + institutionCode + languageCode;
            if (Cache[cacheKey] != null)
            {
                // Use cached version
                html.Append(Cache[cacheKey].ToString());
            }
            else
            {
                CustomGenericList<Data.Creator> cl = provider.CreatorSelectByInstitution(institutionCode, languageCode);
                html.Append("<p class=\"pageheader\">");
                html.Append("Author List - " + cl.Count.ToString() + " represented");
                html.Append("</p>");
                html.Append("<table><tr><td valign=\"top\">");
                char currentChar = '~';
                bool columnOne = true;
                for (int i = 0; i < cl.Count; i++)
                {
                    if (cl[i].CreatorName[0] != currentChar)
                    {
                        currentChar = cl[i].CreatorName[0];
                        if (currentChar >= 'L' && currentChar < 'Z' && columnOne)
                        {
                            html.Append("</td><td valign=\"top\">");
                            columnOne = false;
                        }
                        html.Append("<p class=\"pageheader\">" + currentChar + "</p>");
                    }
                    string lifeSpan = "";
                    if (cl[i].DOB != null && cl[i].DOB != "")
                    {
                        lifeSpan = cl[i].DOB;
                    }
                    if (cl[i].DOD != null && cl[i].DOD != "")
                    {
                        if (lifeSpan != "")
                        {
                            lifeSpan += " - " + cl[i].DOD;
                        }
                        else
                        {
                            lifeSpan += "Died " + cl[i].DOD;
                        }
                    }
                    else if (lifeSpan != "")
                    {
                        lifeSpan = "Born " + lifeSpan;
                    }
                    if (lifeSpan != "")
                    {
                        lifeSpan = "(" + lifeSpan + ")";
                    }
                    html.Append("<a href=\"/creator/" + cl[i].CreatorID + "\">" + cl[i].MARCCreator_a + " " + cl[i].MARCCreator_b + "</a> " + lifeSpan + "<br />");
                }
                html.Append("</td></tr></table>");

                // Cache the HTML fragment
                Cache.Add(cacheKey, html.ToString(), null, DateTime.Now.AddMinutes(
                    Convert.ToDouble(ConfigurationManager.AppSettings["BrowseQueryCacheTime"])),
                    System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Normal, null);
            }

            return html.ToString();
        }
    }
}