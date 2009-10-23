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

namespace MOBOT.BHL.Web
{
    public partial class AdvancedSearch : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!this.IsPostBack)
            {
                this.PopulateLanguageList();
            }
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
        }

        protected void btnSearch_Click(object sender, EventArgs e)
        {
            // Get the specified search criteria
            String searchTerm = this.txtFind.Text;
            String searchCat = String.Empty;
            String searchLang = this.ddlLanguage.SelectedValue;
            String searchSecondary = String.Empty;

            if (this.chkAuthor.Checked) searchCat += "A";
            if (this.chkName.Checked) searchCat += "N";
            if (this.chkSubject.Checked) searchCat += "S";
            if (this.chkTitle.Checked) searchCat += "T";
            if (this.chkSecondary.Checked) searchSecondary = "1";

            // Redirect to the search page
            Response.Redirect("/Search.aspx?searchTerm=" + Server.UrlEncode(searchTerm) + "&searchCat=" + Server.UrlEncode(searchCat) + "&lang=" + Server.UrlEncode(searchLang) + "&sec=" + Server.UrlEncode(searchSecondary), false);
        }
    }
}
