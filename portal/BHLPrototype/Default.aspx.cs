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
using MOBOT.BHL.Web.Utilities;

namespace MOBOT.BHL.Web {
    public partial class _Default : ALABasePage<BHL_AU> {

        protected void Page_Load(object sender, EventArgs e) {
            if (!Page.IsPostBack) {
                browseContentPanel.SetTableID("browseContentPanel");
                main.SetPageType(BHL_AU.PageType.Content);
                loadBrowseControl();
            }
        }

        private void loadBrowseControl() {
            //default to the cloud view for now            
            try {
                string browseTypeString = null; 

                if (Request.QueryString["browseType"] != null && Request.QueryString["browseType"] != "") {
                    browseTypeString = Request.QueryString["browseType"];
                }

                if (!String.IsNullOrEmpty(browseTypeString)) {
                    BrowseType browseType = (BrowseType)Enum.Parse(typeof(BrowseType), browseTypeString, true);
                    //load the appropriate control based on the browse type preference
                    switch (browseType) {
                        case BrowseType.Cloud:
                            browseControlPlaceHolder.Controls.Add( LoadControl( "/TitleTagCloudControl.ascx" ) );
                            break;
                        case BrowseType.Title:
                            browseControlPlaceHolder.Controls.Add(LoadControl("/TitleListControl.ascx"));
                            break;
                        case BrowseType.Author:
                            browseControlPlaceHolder.Controls.Add(LoadControl("/CreatorListControl.ascx"));
                            break;
                        case BrowseType.Map:
                            browseControlPlaceHolder.Controls.Add(LoadControl("/MapControl.ascx"));
                            break;
                        case BrowseType.Year:
                            browseControlPlaceHolder.Controls.Add(LoadControl("/BrowseByYearControl.ascx"));
                            break;
                        case BrowseType.Name:
                            browseControlPlaceHolder.Controls.Add(LoadControl("/NameCloudControl.ascx"));
                            break;
                        default:
                            browseControlPlaceHolder.Controls.Add(LoadControl("/TitleTagCloudControl.ascx"));
                            break;
                    }
                }
            } catch {
                //do nothing...just let the default remain
            }

        }

        private enum BrowseType {
            Cloud,
            Title,
            Author,
            Map,
            Year,
            Name
        }
    }
}
