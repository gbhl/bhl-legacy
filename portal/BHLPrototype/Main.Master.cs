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
using MOBOT.BHL.Server;
using MOBOT.BHL.Web.Utilities;

namespace MOBOT.BHL.Web
{
	public partial class Main : System.Web.UI.MasterPage
	{
		private PageType pageType = PageType.Content;
		private int titlesOnlineCount = 0;
		private bool debugMode = false;
		private string projectUpdateFeedLocation = "";

		protected void Page_Load( object sender, EventArgs e )
		{
			projectUpdateFeedLocation = ConfigurationManager.AppSettings[ "projectUpdatesFeedLocation" ];

			Page.Header.Controls.Add( ControlGenerator.GetRssFeedControl( projectUpdateFeedLocation,
				ConfigurationManager.AppSettings[ "projectUpdatesRssTitle" ] ) );

			debugMode = DebugUtility.IsDebugMode( Response, Request );
			debugModeDiv.Visible = debugMode;
			if ( debugMode )
				Page.Title = "***DEBUG MODE*** " + Page.Title;

            if (!this.IsPostBack)
            {
                PopulateContributorsList();
                PopulateLanguageList();
                DisplayAlertMessage();
            }

            if (pageType == PageType.Content)
			{
				nowOnlineDiv.Visible = true;
				Stats stats = this.GetStats();
				titlesOnlineCount = stats.TitleCount;
				titlesOnlineLiteral.Text = stats.TitleCount.ToString( "0,0" );
				volumesOnlineLiteral.Text = stats.VolumeCount.ToString( "0,0" );
				pagesOnlineLiteral.Text = stats.PageCount.ToString( "0,0" );
				//protologuesOnlineLiteral.Text = stats.ProtologueCount.ToString("0,0");
				//ControlGenerator.AddScriptControl(Master.Page.Header.Controls, "/Scripts/ResizeContentPanelUtils.js");
				ControlGenerator.AddAttributesAndPreserveExisting( Body, "onload", "ResizeContentPanelHeight('newsDiv', 262);" );
				ControlGenerator.AddAttributesAndPreserveExisting( Body, "onresize", "ResizeContentPanelHeight('newsDiv', 262);" );
				rssFeed.FeedLocation = projectUpdateFeedLocation;
			}
		}

		private Stats GetStats()
		{
			Stats stats = null;

			// Cache the results of the institutions query for 24 hours
			String cacheKey = "StatsSelect";
			if ( Cache[ cacheKey ] != null )
			{
				// Use cached version
				stats = (Stats)Cache[ cacheKey ];
			}
			else
			{
				// Refresh cache
				stats = new BHLProvider().StatsSelect();
				Cache.Add( cacheKey, stats, null, DateTime.Now.AddMinutes(
					Convert.ToDouble( ConfigurationManager.AppSettings[ "StatsSelectQueryCacheTime" ] ) ),
					System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Normal, null );
			}

			return stats;
		}

        /// <summary>
        /// Reads the alert message from a text file and caches it.  Using the cache
        /// and file system is done for performance reasons (testing showed that file 
        /// system access was 4 times faster than a database lookup).
        /// </summary>
        private void DisplayAlertMessage()
        {
            String alertMessage = String.Empty;

            String cacheKey = "AlertMessage";
            if (Cache[cacheKey] != null)
            {
                // Use cached version
                alertMessage = Cache[cacheKey].ToString();
            }
            else
            {
                // Refresh cache
                alertMessage = System.IO.File.ReadAllText(Request.PhysicalApplicationPath + "\\alertmsg.txt");
                Cache.Add( cacheKey, alertMessage, null, DateTime.Now.AddMinutes(
                    Convert.ToDouble (ConfigurationManager.AppSettings[ "AlertMessageCacheTime" ] ) ),
                    System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Normal, null);
            }

            // If we have a message, display it
            litAlertMessage.Text = alertMessage;
            divAlert.Visible = (alertMessage.Length > 0);
        }

		private void PopulateContributorsList()
		{
			BHLProvider provider = new BHLProvider();
			CustomDataAccess.CustomGenericList<Institution> institutions = null;

			// Cache the results of the institutions query for 24 hours
			String cacheKey = "InstitutionsWithPubItems";
			if ( Cache[ cacheKey ] != null )
			{
				// Use cached version
				institutions = (CustomDataAccess.CustomGenericList<Institution>)Cache[ cacheKey ];
			}
			else
			{
				// Refresh cache
				institutions = provider.InstitutionSelectWithPublishedItems(true);
				Cache.Add( cacheKey, institutions, null, DateTime.Now.AddMinutes(
					Convert.ToDouble( ConfigurationManager.AppSettings[ "InstitutionsListQueryCacheTime" ] ) ),
					System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Normal, null );
			}

			ddlContributors.DataSource = institutions;
			ddlContributors.DataBind();
			ddlContributors.Items.Insert( 0, new ListItem( "(All Contributors)", "" ) );

			// Select the appropriate item in the list
			if ( this.Request.Cookies[ "ddlContributors" ] != null )
				ddlContributors.SelectedValue = this.Request.Cookies[ "ddlContributors" ].Value;
		}

        private void PopulateLanguageList()
        {
            BHLProvider provider = new BHLProvider();
            CustomDataAccess.CustomGenericList<Language> languages = null;

            // Cache the results of the languages query for 24 hours
            String cacheKey = "LanguagesWithPubItems";
            if (Cache[cacheKey] != null)
            {
                // Use cached version
                languages = (CustomDataAccess.CustomGenericList<Language>)Cache[cacheKey];
            }
            else
            {
                // Refresh cache
                languages = provider.LanguageSelectWithPublishedItems();
                Cache.Add(cacheKey, languages, null, DateTime.Now.AddMinutes(
                    Convert.ToDouble(ConfigurationManager.AppSettings["LanguageListQueryCacheTime"])),
                    System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Normal, null);
            }

            ddlLanguage.DataSource = languages;
            ddlLanguage.DataBind();
            ddlLanguage.Items.Insert(0, new ListItem("(Any Language)", ""));

            // Select the appropriate item in the list
            if (this.Request.Cookies["ddlLanguage"] != null)
                ddlLanguage.SelectedValue = this.Request.Cookies["ddlLanguage"].Value;
        }

		internal HtmlGenericControl Body
		{
			get
			{
				return bod;
			}
		}

		internal int TitlesOnlineCount
		{
			get
			{
				return titlesOnlineCount;
			}
		}

		internal void HideOverflow()
		{
			hideOverflowStyle.Visible = true;
		}

		internal void SetPageType( PageType pageType )
		{
			this.pageType = pageType;
		}

		internal enum PageType
		{
			Content,
			Admin,
			Error,
			TitleViewer,
			NamesResult
		}
	}
}
