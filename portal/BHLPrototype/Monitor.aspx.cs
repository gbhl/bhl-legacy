using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Net;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Data = MOBOT.BHL.DataObjects;
using CustomDataAccess;
using MOBOT.BHL.Server;
using MOBOT.FileAccess.RemotingUtilities;
using MOBOT.FileAccess;

namespace MOBOT.BHL.Web
{
    public partial class Monitor : System.Web.UI.Page
    {
        private bool exceptionsOccurred = false;

        protected void Page_Load(object sender, EventArgs e)
        {
            Response.Expires = -1;
            Response.Write("Starting tests on " + DateTime.Now.ToString("MM/dd/yyyy") + " at " + DateTime.Now.ToString("HH:mm:ss.fffffff"));
            Response.Flush();
            Response.Write("<ul>");
            //query the database
            Response.Write("<li>Querying database:  ");
            Response.Flush();
            CustomGenericList<Data.ItemSource> list = null;
            try
            {
                BHLProvider provider = new BHLProvider();
                list = provider.ItemSourceSelectAll();
                Response.Write("completed successfully at " + DateTime.Now.ToString("HH:mm:ss:fffffff") + "</li>");
                Response.Flush();
            }
            catch (Exception ex)
            {
                WriteExceptionInfo(ex);
                exceptionsOccurred = true;
                Response.Flush();
            }
            //call the FileAccess service
            Response.Write("<li>Calling the FileAccess service:  ");
            Response.Flush();
            try
            {
                //throw new Exception("Test");
                string[] subDirectories = new BHLProvider().GetFileAccessProvider(ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true").GetSubDirectories(@"\\server\imagecache");
                Response.Write("completed successfully at " + DateTime.Now.ToString("HH:mm:ss:fffffff") + "</li>");
                Response.Flush();
            }
            catch (Exception ex)
            {
                WriteExceptionInfo(ex);
                exceptionsOccurred = true;
                Response.Flush();
            }
            //call the image viewer
            if (list != null)
            {
                foreach (Data.ItemSource itemSource in list)
                {
                    //string requestUrl = String.Format(itemSource.ImageServerUrlFormat, "botanicus3", "b12069590/31753000802824/jp2", "31753000802824_0000.jp2", "", "");
                    String requestUrl = String.Format(itemSource.ImageServerUrlFormat, "", "", "", "", "");
                    Response.Write("<li>Calling the viewer for " + itemSource.SourceName + " using " + Server.HtmlEncode(requestUrl) + ":  ");
                    Response.Flush();
                    try
                    {
                        HttpWebRequest wr = (HttpWebRequest)WebRequest.Create(requestUrl);
                        HttpWebResponse response = (HttpWebResponse)wr.GetResponse();
                        if (response.StatusCode != HttpStatusCode.OK)
                        {
                            throw new Exception("StatusCode from WebRequest = " + response.StatusCode.ToString());
                        }
                        if (response.ResponseUri.ToString() != requestUrl)
                        {
                            throw new Exception("Unexpected ResponseUri:  " + response.ResponseUri.ToString());
                        }
                        Response.Write("completed successfully at " + DateTime.Now.ToString("HH:mm:ss:fffffff") + "</li>");
                        Response.Flush();
                    }
                    catch (Exception ex)
                    {
                        WriteExceptionInfo(ex);
                        exceptionsOccurred = true;
                        Response.Flush();
                    }
                }
            }
            else
            {
                WriteExceptionInfo("Invalid list of image servers retrieved from database.");
                exceptionsOccurred = true;
                Response.Flush();
            }
            Response.Write("</ul>");
            if (!exceptionsOccurred)
            {
                Response.Write("All tests completed successfully at " + DateTime.Now.ToString("HH:mm:ss:fffffff"));
            }
            else
            {
                Response.Write("<font color=\"red\"><b>Exceptions occurred!</b></font>");
            }
            Response.Flush();
        }

        private void WriteExceptionInfo(Exception ex)
        {
            this.WriteError(ex.Message, ex.StackTrace);
        }

        private void WriteExceptionInfo(String message)
        {
            this.WriteError(message, "");
        }

        private void WriteError(String message, String stackTrace)
        {
            Response.Write("<font color=\"red\">The following exception occurred:<br>");
            Response.Write("<b>Message:</b> " + message + "<br>");
            Response.Write("<b>Stack Trace:</b>" + stackTrace.Replace("\n", "<br>") + "</font></li>");
        }
    }
}
