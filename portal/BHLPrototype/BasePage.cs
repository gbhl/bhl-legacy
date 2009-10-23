using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MOBOT.BHL.Server;

namespace MOBOT.BHL.Web
{
    public class BasePage : Page
    {
        protected BHLProvider bhlProvider = null;
        protected Main main = null;

        protected override void OnInit(EventArgs e)
        {
            base.OnInit(e);
            bhlProvider = new BHLProvider();
            main = (Main)Page.Master;
        }
    }
}
