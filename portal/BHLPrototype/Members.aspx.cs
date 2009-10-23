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

namespace MOBOT.BHL.Web
{
    public partial class Members : BasePage
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            ControlGenerator.AddScriptControl(Page.Master.Page.Header.Controls, "/Scripts/ResizeBrowseUtils.js");
            ControlGenerator.AddAttributesAndPreserveExisting(main.Body, "onload", "ResizeBrowseDivs();ResizeContentPanel('browseContentPanel', 258);");
            ControlGenerator.AddAttributesAndPreserveExisting(main.Body, "onresize", "ResizeBrowseDivs();ResizeContentPanel('browseContentPanel', 258);");
        }
    }
}
