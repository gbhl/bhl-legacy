using System;
using System.Collections.Generic;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using CustomDataAccess;

namespace MOBOT.BHL.Web.Admin.Services
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class StatsService : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            String response;

            switch (context.Request.QueryString["op"])
            {
                case "SelectExpandedNames":
                    {
                        response = this.SelectExpandedNames();
                        break;
                    }
                default:
                    {
                        response = null;
                        break;
                    }

            }

            context.Response.ContentType = "application/json";
            context.Response.Write(response);
        }

        private string SelectExpandedNames()
        {
            try
            {
                MOBOT.BHL.DataObjects.Stats stats = null;
                stats = new BHLProvider().StatsSelectExpandedNames();

                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(stats);
            }
            catch
            {
                return null;
            }
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
