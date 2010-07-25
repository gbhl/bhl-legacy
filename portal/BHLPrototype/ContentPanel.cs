using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;

namespace MOBOT.BHL.Web
{
    public class ContentPanel : Control
    {
        private string tableID = "";
        private string width = null;
        private String @class = "ContentPanel";

        public string Class {
            get { return @class; }
            set { @class = value; }
        }

        public string TableID {
            get { return tableID; }
            set { tableID = value; }
        }

        public string Width {
            get { return width; }
            set { width = value; }
        }

        protected override void Render(HtmlTextWriter writer) {
            string openingTag = "<table class=\"" + @class + "\" style=\"height:99%;\" border=\"0\" ";
            if (tableID != null && tableID.Trim().Length > 0)
                openingTag += "id=\"" + tableID.Trim() + "\" ";

            if (!String.IsNullOrEmpty(width)) {
                openingTag += "width=\"" + width.ToString() + "\" ";
            }

            openingTag += "cellpadding=\"0\" cellspacing=\"0\">";

            writer.WriteLine(openingTag);
            writer.WriteLine("<tr>");
            writer.WriteLine("<td width=\"12\"><img src=\"/images/panel/top_left.gif\" width=\"12\" height=\"12\" /></td>");
            writer.WriteLine("<td background=\"/images/panel/top.gif\"><img src=\"/images/blank.gif\" width=\"1\" height=\"1\" /></td>");
            writer.WriteLine("<td width=\"12\"><img src=\"/images/panel/top_right.gif\" width=\"12\" height=\"12\" /></td>");
            writer.WriteLine("</tr>");
            writer.WriteLine("<tr>");
            writer.WriteLine("<td background=\"/images/panel/left.gif\"><img src=\"/images/blank.gif\" width=\"12\" height=\"12\" /></td>");
            writer.WriteLine("<td background=\"/images/panel/bg.gif\" valign=\"top\" height=\"99%\">");

            //add inner controls here
            foreach (Control control in base.Controls)
            {
                control.RenderControl(writer);
            }

            writer.WriteLine("</td>");
            writer.WriteLine("<td background=\"/images/panel/right.gif\"><img src=\"/images/blank.gif\" width=\"12\" height=\"12\" /></td>");
            writer.WriteLine("</tr>");
            writer.WriteLine("<tr>");
            writer.WriteLine("<td><img src=\"/images/panel/bottom_left.gif\" width=\"12\" height=\"12\" /></td>");
            writer.WriteLine("<td background=\"/images/panel/bottom.gif\"><img src=\"/images/blank.gif\" width=\"196\" height=\"12\" /></td>");
            writer.WriteLine("<td><img src=\"/images/panel/bottom_right.gif\" width=\"12\" height=\"12\" /></td>");
            writer.WriteLine("</tr>");
            writer.WriteLine("</table>");
        }

        internal void SetTableID(string tableID)
        {
            this.tableID = tableID;
        }
    }
}
