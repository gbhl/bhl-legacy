using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using CustomDataAccess;

namespace MOBOT.BHL.Web.Services
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class ItemService : IHttpHandler
    {
        public void ProcessRequest(HttpContext context)
        {
            String response;

            // Clean up inputs
            String qsItemID = context.Request.QueryString["itemID"] as String;
            String barCode = context.Request.QueryString["barcode"] as String;
            String qsTitleID = context.Request.QueryString["titleID"] as String;
            String marcBibId = context.Request.QueryString["marcBibId"] as String;
            int itemID;
            Int32.TryParse(qsItemID, out itemID);
            barCode = (barCode ?? "");
            int titleID;
            Int32.TryParse(qsTitleID, out titleID);
            marcBibId = (marcBibId ?? "");

            switch (context.Request.QueryString["op"])
            {
                case "ItemSearch":
                    {
                        response = this.ItemSearch(itemID, barCode);
                        break;
                    }
                case "ItemSearchByTitle":
                    {
                        response = this.ItemSearchByTitle(titleID, marcBibId);
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

        private string ItemSearch(int itemId, String barCode)
        {
            try
            {
                Item item = null;
                if (itemId != 0)
                {
                    item = new BHLProvider().ItemSelectAuto(itemId);
                }
                else
                {
                    item = new BHLProvider().ItemSelectByBarCode(barCode);
                }

                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(item);
            }
            catch
            {
                return null;
            }
        }

        private string ItemSearchByTitle(int titleId, String marcBibId)
        {
            try
            {
                CustomGenericList<Item> items = null;
                if (titleId != 0)
                {
                    items = new BHLProvider().ItemSelectByTitleId(titleId);
                }
                else
                {
                    items = new BHLProvider().ItemSelectByMarcBibId(marcBibId);
                }

                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(items);
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
