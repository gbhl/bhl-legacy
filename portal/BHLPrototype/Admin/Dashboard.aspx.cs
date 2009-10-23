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
using CustomDataAccess;

namespace MOBOT.BHL.Web.Admin
{
	public partial class Dashboard : System.Web.UI.Page
	{
		protected void Page_Load( object sender, EventArgs e )
		{
            int ageLimit = Convert.ToInt32(ConfigurationManager.AppSettings["StatsPendingApprovalDownloadLimit"]);
            
            BHLProvider bp = new BHLProvider();
            
            //BHLImportWebService.BHLImportWS ws = new BHLImportWebService.BHLImportWS();
            //gvItemStatus.DataSource = ws.StatsSelectIAItemGroupByStatus();
            //gvItemStatus.DataBind();

            // Get the PDF generation stats
            gvPDFGeneration.DataSource = bp.PDFStatsSelectOverview();
            gvPDFGeneration.DataBind();

            // Get the data harvest stats
            //BHLImportWebService.Stats importStats = ws.StatsCountIAItemPendingApproval(ageLimit);
            litNumDays.Text = ageLimit.ToString();
            //hypNumItems.NavigateUrl += ageLimit.ToString();
            //hypNumItems.Text = importStats.NumberOfItems.ToString();

            // Get the production stats
            String cacheKey = "DashboardStats";
            MOBOT.BHL.DataObjects.Stats stats = null;
            if (Cache[cacheKey] != null)
            {
                // Use cached version
                stats = (MOBOT.BHL.DataObjects.Stats)Cache[cacheKey];
            }
            else
            {
                // Refresh cache
                stats = bp.StatsSelectExpanded();
                Cache.Add(cacheKey, stats, null, DateTime.Now.AddMinutes(
                    Convert.ToDouble(ConfigurationManager.AppSettings["DashboardStatsCacheTime"])),
                    System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Normal, null);
            }

			titlesAllCell.InnerHtml = stats.TitleTotal.ToString();
			titlesActiveCell.InnerHtml = stats.TitleCount.ToString();
			itemsActiveCell.InnerHtml = stats.VolumeCount.ToString();
			itemsAllCell.InnerHtml = stats.VolumeTotal.ToString();
			pagesActiveCell.InnerHtml = stats.PageCount.ToString();
			pagesAllCell.InnerHtml = stats.PageTotal.ToString();

			string wid = ( ( (float)stats.TitleCount / (float)stats.TitleTotal ) * 100 ) + "%";
			titlesGreenBar.Style[ "width" ] = wid;
			wid = ( ( (float)stats.VolumeCount / (float)stats.VolumeTotal ) * 100 ) + "%";
			itemsGreenBar.Style[ "width" ] = wid;
			wid = ( ( (float)stats.PageCount / (float)stats.PageTotal ) * 100 ) + "%";
			pagesGreenBar.Style[ "width" ] = wid;
			if ( stats.UniqueTotal == stats.UniqueCount )
			{
				uniqueGreenBar.Style[ "width" ] = "100%";
				uniqueWhiteBar.Visible = false;
			}
			else
			{
				wid = ( ( (float)stats.UniqueCount / (float)stats.UniqueTotal ) * 100 ) + "%";
				uniqueGreenBar.Style[ "width" ] = wid;
			}

            // Get the growth stats
            CustomGenericList<MonthlyStats> growthYear = bp.MonthlyStatsSelectCurrentYearSummary();
            CustomGenericList<MonthlyStats> growthMonth = bp.MonthlyStatsSelectCurrentMonthSummary();
            foreach (MonthlyStats stat in growthYear)
            {
                switch (stat.StatType)
                {
                    case "Titles Created":
                        titlesThisYear.InnerHtml = stat.StatValue.ToString();
                        break;
                    case "Items Created":
                        itemsThisYear.InnerHtml = stat.StatValue.ToString();
                        break;
                    case "Pages Created":
                        pagesThisYear.InnerHtml = stat.StatValue.ToString();
                        break;
                    case "PageNames Created":
                        namesThisYear.InnerHtml = stat.StatValue.ToString();
                        break;
                }
            }
            foreach (MonthlyStats stat in growthMonth)
            {
                switch (stat.StatType)
                {
                    case "Titles Created":
                        titlesThisMonth.InnerHtml = stat.StatValue.ToString();
                        break;
                    case "Items Created":
                        itemsThisMonth.InnerHtml = stat.StatValue.ToString();
                        break;
                    case "Pages Created":
                        pagesThisMonth.InnerHtml = stat.StatValue.ToString();
                        break;
                    case "PageNames Created":
                        namesThisMonth.InnerHtml = stat.StatValue.ToString();
                        break;
                }
            }
        }
	}
}
