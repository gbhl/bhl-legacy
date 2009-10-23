using System;
using System.Web.UI;
using System.Web.UI.WebControls;
using MOBOT.BHL.Server;

namespace MOBOT.BHL.Web
{
	public partial class Recent : BasePage
	{
		protected void Page_Load( object sender, EventArgs e )
		{
			int top = 25;
			String paramTop = Request.QueryString[ "top" ] as String;
			if ( paramTop != null )
				Int32.TryParse( paramTop, out top );
			top = ( top == 0 || top > 100 ) ? 25 : top;

            String institutionCode = String.Empty;
            if (this.Request.Cookies["ddlContributors"] != null)
            {
                institutionCode = this.Request.Cookies["ddlContributors"].Value;
            }

            String languageCode = String.Empty;
            if (this.Request.Cookies["ddlLanguage"] != null)
            {
                languageCode = this.Request.Cookies["ddlLanguage"].Value;
            }

            rptRecent.DataSource = bhlProvider.ItemSelectRecent(top, languageCode, institutionCode);
			rptRecent.DataBind();

            String recentLink = "http://" + Request.ServerVariables["HTTP_HOST"] + "/RecentRss/" + top.ToString();
            if ((languageCode + institutionCode) != String.Empty) 
            {
                if (languageCode == String.Empty) languageCode = "ALL";
                if (institutionCode == String.Empty) institutionCode = "ALL";
                recentLink += "/" + languageCode + "/" + institutionCode;
            }

            lblNumberDisplayed.Text = " (Last " + top.ToString() + ")";
            rssFeedLink.HRef = recentLink;
            rssFeedLink.InnerHtml = recentLink;
            rssFeedImageLink.HRef = recentLink;
		}

        protected void Page_LoadComplete(object sender, EventArgs e)
        {
            // Have to do this here instead of in the Load event, because the Master page 
            // Load event fires AFTER the content page Load event.
            DropDownList ddlLanguage = Master.FindControl("ddlLanguage") as DropDownList;
            DropDownList ddlContributors = this.Master.FindControl("ddlContributors") as DropDownList;
            if (ddlLanguage.SelectedIndex > 0) lblLanguage.Text = "<br>Published In: " + ddlLanguage.SelectedItem.Text;
            if (ddlContributors.SelectedIndex > 0) lblContributor.Text = "<br>For: " + ddlContributors.SelectedItem.Text;
        }

	}
}