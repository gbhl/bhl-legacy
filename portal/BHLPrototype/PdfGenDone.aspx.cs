﻿using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace MOBOT.BHL.Web
{
    public partial class PdfGenDone : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (Request != null)
            {
                String pdfID = Request.Cookies["pdf"]["id"] as String;
                litPDFID.Text = pdfID ?? "0";
            }
        }
    }
}
