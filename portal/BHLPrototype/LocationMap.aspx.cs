using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;

namespace MOBOT.BHL.Web
{
    public partial class LocationMap : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                string key = ConfigurationManager.AppSettings["Google.Maps.Key." + Request.ServerVariables["HTTP_HOST"]];
                mapsScriptTag.Text = "<script src=\"" + ConfigurationManager.AppSettings["Google.Maps.ScriptUrlPrefix"] + key + "\" type=\"text/javascript\"></script>";
            }
        }
    }
}
