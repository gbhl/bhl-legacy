using System;
using System.Configuration;
using System.Collections.Generic;
using System.Web;

namespace MOBOT.BHL.Web
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    //[WebService(Namespace = "http://tempuri.org/")]
    //[WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class EndNoteDownload : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            int titleId;
            String titleIdString = context.Request.QueryString["id"] as String;
            String response = String.Empty;
            String filename = "BHL";

            if (Int32.TryParse(titleIdString, out titleId))
            {
                try
                {
                    response = new MOBOT.BHL.Server.BHLProvider().TitleEndNoteGetCitationStringForTitleID(titleId,
                        ConfigurationManager.AppSettings["ItemPageUrl"].ToString());
                    filename += titleId.ToString();
                }
                catch
                {
                    response = "Error retrieving EndNote citations for this title.";
                }
            }

            context.Response.ContentType = "application/x-endnote-refer";
            context.Response.AddHeader("Content-Disposition", "attachment; filename=" + filename + ".enw");
            context.Response.Write(response);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }
    }
}
