using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;

namespace MOBOT.BHL.Web
{
    public partial class OpenUrlHelp : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            litMessage.Text = (Request.Cookies["OpenUrlMessage"] == null) ? "" : Request.Cookies["OpenUrlMessage"].Value;
        }
    }
}
