using System;
using System.Collections;
using System.Data;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using MOBOT.BHL.Web.Utilities;

namespace MOBOT.BHL.Web
{
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class GetPageThumb : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            String pageIDString = context.Request.QueryString["PageID"] as String;
            if (pageIDString == null) return;

            String heightString = context.Request.QueryString["h"] as String;
            String widthString = context.Request.QueryString["w"] as String;
            int height;
            int width;
            if (!Int32.TryParse(heightString, out height)) height = 300;
            if (!Int32.TryParse(widthString, out width)) width = 200;

            int pageID;
            if (Int32.TryParse(pageIDString, out pageID))
            {
                BHLProvider provider = new BHLProvider();
                PageSummaryView ps = provider.PageSummarySelectByPageId(pageID);


                String imageUrl = String.Empty;
                if (ps != null) {
                    if (ps.ExternalURL == null) {
                        String cat = (ps.WebVirtualDirectory == String.Empty) ? "Researchimages" : ps.WebVirtualDirectory;
                        String item = ps.MARCBibID + "/" + ps.BarCode + "/jp2/" + ps.FileNamePrefix + ".jp2";
                        imageUrl = String.Format("http://images.mobot.org/ImageWeb/GetImage.aspx?cat={0}&item={1}&wid=" + width.ToString() + "&hei= " + height.ToString() + "&rgn=0,0,1,1&method=scale", cat, item);
                    } else {
                        imageUrl = ps.ExternalURL;
                    }

                    System.Net.WebClient client = new System.Net.WebClient();
                    context.Response.ContentType = "image/jpeg";
                    context.Response.BinaryWrite(client.DownloadData(imageUrl));
                } else {
                    // Page not found!
                }
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
