using System;
using System.Data;
using System.Web;
using System.Collections;
using System.Web.Services;
using System.Web.Services.Protocols;

namespace MOBOT.BHL.Web
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class ContributorRedirect : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            // Kluge to set cookie with the selected contributor value.
            
            // If the cookie is set in javascript, it sometimes is not preserved 
            // properly.  (Not clear if this is a browser issue or an ASP.NET 
            // issue.)  Attempting to set the cookie in the codebehind of the page 
            // on which the contributor was selected also causes problems.  Postbacks 
            // do not work properly on pages that have had their URL rewritten.
            // (This is a known issue with our method of URL rewriting.) 
            // 2/12/2008

            String queryString = context.Request.QueryString.ToString();

            // Write cookie
            if (context.Request.QueryString["contrib"] != null)
            {
                // Get the selected contributor and write it to the cookie
                String institutionCode = context.Request.QueryString["contrib"];

                if (context.Response.Cookies["ddlContributors"] == null)
                {
                    context.Response.Cookies.Add(new HttpCookie("ddlContributors", institutionCode));
                }
                else
                {
                    context.Response.Cookies["ddlContributors"].Value = institutionCode;
                }
            }

            // Get the address to which we should redirect
            String path = "/";
            if (context.Request.QueryString["path"] != null)
            {
                path = System.Web.HttpUtility.UrlDecode(context.Request.QueryString["path"]);
            }

            context.Response.Redirect(path);
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
