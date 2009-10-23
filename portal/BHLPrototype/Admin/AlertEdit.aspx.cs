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
using FredCK.FCKeditorV2;

namespace MOBOT.BHL.Web.Admin
{
    public partial class AlertEdit : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                txtAlertMessage.ToolbarSet = "BHL";

                String alertMessage = System.IO.File.ReadAllText(Request.PhysicalApplicationPath + "\\alertmsg.txt");
                txtAlertMessage.Value = alertMessage;
            }

        }

        protected void saveButton_Click(object sender, EventArgs e)
        {
            if (validate())
            {
                String alertMessage = txtAlertMessage.Value;
                System.IO.File.WriteAllText(Request.PhysicalApplicationPath + "\\alertmsg.txt", alertMessage);
            }
            else
            {
                return;
            }

            Response.Redirect("/Admin/Dashboard.aspx");
        }

        protected void clearButton_Click(object sender, EventArgs e)
        {
            clearForm(this.Controls);
        }

        private void clearForm(ControlCollection controls)
        {
            foreach (Control c in controls)
            {
                if (c is TextBox)
                {
                    TextBox textBox = (TextBox)c;
                    textBox.Text = "";
                }
                else if (c.HasControls())
                {
                    clearForm(c.Controls);
                }
                else if (c is FCKeditor)
                {
                    FCKeditor fck = (FCKeditor)c;
                    fck.Value = "";
                }
            }
        }

        private bool validate()
        {
            bool flag = false;
            return !flag;
        }

        protected void lnkButton_Click(object sender, EventArgs e)
        {
            LinkButton linkButton = (LinkButton)sender;
            txtAlertMessage.Value = linkButton.Text;
        }
    }
}
