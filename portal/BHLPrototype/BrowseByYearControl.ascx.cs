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
using MOBOT.BHL.Web.Utilities;
using MOBOT.BHL.Server;
using Data = MOBOT.BHL.DataObjects;
using CustomDataAccess;

namespace MOBOT.BHL.Web
{
	public partial class BrowseByYearControl : System.Web.UI.UserControl
	{
		protected void Page_Load( object sender, EventArgs e )
		{
			Main main = (Main)Page.Master;
			main.SetPageType( Main.PageType.Content );

			ControlGenerator.AddScriptControl( Page.Master.Page.Header.Controls, "/Scripts/ResizeBrowseUtils.js" );
			ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onload",
				"ResizeContentPanel('browseContentPanel', 258);ResizeBrowseDivs();" );
			ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onresize",
				"ResizeContentPanel('browseContentPanel', 258);ResizeBrowseDivs();" );

            String institutionCode = String.Empty;
            if (this.Request.Cookies["ddlContributors"] != null) institutionCode = this.Request.Cookies["ddlContributors"].Value;
            String languageCode = String.Empty;
            if (this.Request.Cookies["ddlLanguage"] != null) languageCode = this.Request.Cookies["ddlLanguage"].Value;
            
            int startDate;
			int endDate;
			bool startFlag = false;
			if ( int.TryParse( Request.QueryString[ "start" ], out startDate ) == false )
			{
				startDate = int.Parse( ConfigurationManager.AppSettings[ "browseByYearDefaultStart" ] );
				startFlag = true;
			}
			if ( int.TryParse( Request.QueryString[ "enddate" ], out endDate ) == false )
			{
				if ( startFlag )
				{
					endDate = int.Parse( ConfigurationManager.AppSettings[ "browseByYearDefaultEnd" ] );
				}
				else
				{
					endDate = DateTime.Now.Year;
				}
			}

			titleLiteral.Text = GenerateDateList(startDate, endDate, institutionCode, languageCode);
		}

		private string GenerateDateList(int startDate, int endDate, string institutionCode, string languageCode)
		{
            short? curYear = 0;
			StringBuilder html = new StringBuilder();

            String cacheKey = "YearBrowse" + startDate.ToString() + endDate.ToString() +  institutionCode + languageCode;
            if (Cache[cacheKey] != null)
            {
                // Use cached version
                html.Append(Cache[cacheKey].ToString());
            }
            else
            {
                BHLProvider provider = new BHLProvider();
                CustomGenericList<Data.Title> tl = provider.TitleSelectByDateRangeAndInstitution(startDate, endDate, institutionCode, languageCode);

                html.Append("<p class=\"pageheader\">");
                html.Append(tl.Count + " title");
                if (tl.Count != 1) html.Append("s");
                html.Append(" with a publication start date between " + startDate.ToString() + " and " + endDate.ToString());
                html.Append("</p>");

                html.Append("<ul>");
                foreach (Data.Title t in tl)
                {
                    if (t.StartYear != curYear)
                    {
                        curYear = t.StartYear;
                        html.Append("</ul><p class=\"pageheader\">" + curYear.Value.ToString() + "</p><ul>");
                    }
                    html.Append("<li><a href=\"/bibliography/" + t.TitleID.ToString() + "\">" + t.FullTitle + " " + (t.PartNumber ?? "") + " " + (t.PartName ?? "") + "</a><br />");
                    html.Append("Publication Info: " + t.PublicationDetails + "<br>");
                    html.Append("Contributed By: " + t.InstitutionName + "</li>");
                }
                html.Append("</ul>");

                // Cache the HTML fragment
                Cache.Add(cacheKey, html.ToString(), null, DateTime.Now.AddMinutes(
                    Convert.ToDouble(ConfigurationManager.AppSettings["BrowseQueryCacheTime"])),
                    System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Normal, null);
            }
			return ( html.ToString() );
		}
	}
}