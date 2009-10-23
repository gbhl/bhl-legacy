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

namespace MOBOT.BHL.Web.Admin
{
    public partial class DataHarvestStats : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            int numLogsToDisplay = Convert.ToInt32(ConfigurationManager.AppSettings["StatsNumberOfLogItemsToDisplay"]);
            int ageLimit = Convert.ToInt32(ConfigurationManager.AppSettings["StatsPendingApprovalDownloadLimit"]);
            int ageDisplay = Convert.ToInt32(ConfigurationManager.AppSettings["StatsPendingApprovalMinimimDisplayAge"]);

            BHLImportWebService.BHLImportWS ws = new BHLImportWebService.BHLImportWS();
            gvItemCountByStatus.DataSource = ws.StatsSelectIAItemGroupByStatus();
            gvItemCountByStatus.DataBind();

            gvPendApprovalByAge.DataSource = ws.StatsSelectIAItemPendingApprovalGroupByAge(ageDisplay);
            gvPendApprovalByAge.DataBind();

            BHLImportWebService.Stats importStats = ws.StatsCountIAItemPendingApproval(ageLimit);
            litNumDays.Text = ageLimit.ToString();
            litNumItems.Text = importStats.NumberOfItems.ToString();
            hypNumItems.NavigateUrl += ageLimit.ToString();

            gvIAReadyToPublish.DataSource = ws.StatsSelectReadyForProductionBySource(1);
            gvIAReadyToPublish.DataBind();

            gvBotReadyToPublish.DataSource = ws.StatsSelectReadyForProductionBySource(2);
            gvBotReadyToPublish.DataBind();

            gvLatestPubToProdLogs.DataSource = ws.ImportLogSelectRecent(numLogsToDisplay);
            gvLatestPubToProdLogs.DataBind();

            gvLatestPubToProdErrors.DataSource = ws.ImportErrorSelectRecent(numLogsToDisplay);
            gvLatestPubToProdErrors.DataBind();

            gvBotHarvestLog.DataSource = ws.BotanicusHarvestLogSelectRecent(numLogsToDisplay);
            gvBotHarvestLog.DataBind();

            gvIAItemErrors.DataSource = ws.IAItemErrorSelectRecent(numLogsToDisplay);
            gvIAItemErrors.DataBind();
        }

    }
}
