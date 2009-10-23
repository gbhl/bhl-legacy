using System;
using System.Configuration;
using System.Web;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;
using CustomDataAccess;

namespace MOBOT.BHL.Server
{
    public partial class BHLProvider
    {
        /// <summary>
        /// Build the image viewer path to a specific page image.  Depending on 
        /// various attributes of the page, different parameters will be passed 
        /// to the image viewer.
        /// </summary>
        /// <param name="psv">Object containing the page attributes</param>
        /// <returns>The completed image viewer path</returns>
        public String GetPageUrl(PageSummaryView psv)
        {
            String cat = String.Empty;
            String client = String.Empty;
            String image = String.Empty;
            String imageUrl = String.Empty;
            String imageDetailUrl = String.Empty;

            if (psv.ExternalURL != null && psv.ExternalURL.Length > 0)
            {
                imageUrl = psv.ExternalURL;
                imageDetailUrl = psv.AltExternalURL;
            }
            else if (psv.RareBooks)
            {
                if (psv.Illustration)
                {
                    cat = psv.WebVirtualDirectory;
                    client = psv.MARCBibID + "/" + psv.BarCode;
                    image = psv.FileNamePrefix + ".jp2";
                }
                else
                {
                    imageUrl = String.Format("http://www.botanicus.org/{0}/{1}/{2}/fullsize/{3}.jpg", psv.WebVirtualDirectory, psv.MARCBibID, psv.BarCode, psv.FileNamePrefix);
                }
            }
            else
            {
                cat = psv.WebVirtualDirectory;
                client = psv.MARCBibID + "/" + psv.BarCode + "/jp2";
                image = psv.FileNamePrefix + ".jp2";
            }

            if (ConfigurationManager.AppSettings["UseIAViewer"] == "true")
            {
                // TODO: This branch only for testing OpenLibrary GnuBook viewer!
                int numPages = 0;
                int pageIndex = 0;
                Item item = this.ItemSelectByBarCode(psv.BarCode);
                if (item != null) numPages = this.PageSelectCountByItemID(item.ItemID);

                if (psv.ExternalURL != null)
                {
                    // IA items
                    pageIndex = Convert.ToInt32(imageUrl.Substring(imageUrl.Length - 8).Substring(0, 4));
                }
                else
                {
                    // Botanicus items
                    if (psv.FileNamePrefix != String.Empty) pageIndex = (int)psv.SequenceOrder;  // Convert.ToInt32(psv.FileNamePrefix.Substring(psv.FileNamePrefix.Length - 4));
                }
                return String.Format("/OLBookReader/Viewer/index.html?pgs={0}&item={1}&alt={2}#page/{3}", 
                    numPages.ToString(), 
                    item.ItemID.ToString(), 
                    HttpUtility.UrlEncode(String.Format(psv.ImageServerUrlFormat,
                        HttpUtility.UrlEncode(cat),
                        HttpUtility.UrlEncode(client),
                        HttpUtility.UrlEncode(image),
                        HttpUtility.UrlEncode(imageUrl),
                        HttpUtility.UrlEncode(imageDetailUrl))),
                    pageIndex);
            }
            else
            {
                return (String.Format(psv.ImageServerUrlFormat,
                    HttpUtility.UrlEncode(cat),
                    HttpUtility.UrlEncode(client),
                    HttpUtility.UrlEncode(image),
                    HttpUtility.UrlEncode(imageUrl),
                    HttpUtility.UrlEncode(imageDetailUrl)));
            }
        }

        public MOBOT.FileAccess.IFileAccessProvider GetFileAccessProvider(bool useRemoteProvider)
        {
            if (useRemoteProvider)
            {
                return MOBOT.FileAccess.RemotingUtilities.RemotingHelper.GetRemotedFileAccessProvider();
            }
            else
            {
                return new MOBOT.FileAccess.FileAccessProvider();
            }
        }
    }
}
