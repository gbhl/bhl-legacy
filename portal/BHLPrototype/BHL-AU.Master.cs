using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Linq;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;

namespace MOBOT.BHL.Web {

    public abstract class BHLMasterPage : System.Web.UI.MasterPage {

        internal PageType pageType = PageType.Content;
        internal int titlesOnlineCount = 0;
        internal bool debugMode = false;

        internal enum PageType {
            Content,
            Admin,
            Error,
            TitleViewer,
            NamesResult
        }

        internal abstract HtmlGenericControl Body { get; }


        internal void SetPageType(PageType pageType) {
            this.pageType = pageType;
        }

        internal int TitlesOnlineCount {
            get {
                return titlesOnlineCount;
            }
        }

        protected void Page_Load(object sender, EventArgs e) {
            if (pageType == PageType.Content) {                
                Stats stats = this.GetStats();
                titlesOnlineCount = stats.TitleCount;
            }

        }

        internal Stats GetStats() {
            Stats stats = null;

            // Cache the results of the institutions query for 24 hours
            String cacheKey = "StatsSelect";
            if (Cache[cacheKey] != null) {
                // Use cached version
                stats = (Stats)Cache[cacheKey];
            } else {
                // Refresh cache
                stats = new BHLProvider().StatsSelect();
                Cache.Add(cacheKey, stats, null, DateTime.Now.AddMinutes(
                    Convert.ToDouble(ConfigurationManager.AppSettings["StatsSelectQueryCacheTime"])),
                    System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Normal, null);
            }

            return stats;
        }


    }


    public partial class BHL_AU : BHLMasterPage {

        protected new void Page_Load(object sender, EventArgs e) {
            base.Page_Load(sender, e);
        }

        internal override HtmlGenericControl Body {
            get {
                return bod;
            }
        }


    }
}
