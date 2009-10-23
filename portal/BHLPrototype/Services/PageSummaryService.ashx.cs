using System;
using System.Data;
using System.Web;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Serialization;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using MOBOT.FileAccess;
using MOBOT.FileAccess.RemotingUtilities;
using CustomDataAccess;
using MOBOT.BHL.Web.Utilities;

namespace MOBOT.BHL.Web.Services
{
    /// <summary>
    /// Summary description for $codebehindclassname$
    /// </summary>
    [WebService(Namespace = "http://tempuri.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class PageSummaryService1 : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            String response;

            // Clean up inputs
            String pageTypeID = context.Request.QueryString["pageTypeID"] as String;
            String titleID = context.Request.QueryString["titleID"] as String;
            String pageID = context.Request.QueryString["pageID"] as String;
            String itemID = context.Request.QueryString["itemID"] as String;
            pageTypeID = String.IsNullOrEmpty(pageTypeID) ? "0" : pageTypeID;
            titleID = String.IsNullOrEmpty(titleID) ? "0" : titleID;
            pageID = String.IsNullOrEmpty(pageID) ? "0" : pageID;
            itemID = String.IsNullOrEmpty(itemID) ? "0" : itemID;

            switch (context.Request.QueryString["op"])
            {
                case "PageNameSearchForTitles":
                    {
                        response = this.PageNameSearchForTitles(context.Request.QueryString["name"], 
                                            context.Request.QueryString["languageCode"]);
                        break;
                    }
                case "PageNameSearchByPageTypeAndTitle":
                    {
                        response = this.PageNameSearchByPageTypeAndTitle(
                                            context.Request.QueryString["name"], 
                                            Convert.ToInt32(pageTypeID),
                                            Convert.ToInt32(titleID), 
                                            context.Request.QueryString["languageCode"]);
                        break;
                    }
                case "FetchPageUrl":
                    {
                        response = this.FetchPageUrl(context,
                                            Convert.ToInt32(pageID));
                        break;
                    }
                case "GetPageNameList":
                    {
                        response = this.GetPageNameList(
                                            Convert.ToInt32(pageID));
                        break;
                    }
                case "GetAlternateLocations":
                    {
                        response = this.GetAlternateLocations(
                                            context.Request.QueryString["locationName"]);
                        break;
                    }
                case "TitleSelectByTagTextInstitutionAndLanguage":
                    {
                        response = this.TitleSelectByTagTextInstitutionAndLanguage(
                                            context.Request.QueryString["tagText"],
                                            context.Request.QueryString["instCode"],
                                            context.Request.QueryString["langCode"]);
                        break;
                    }
                case "PageSummarySelectForViewerByItemID":
                    {
                        response = this.PageSummarySelectForViewerByItemID(itemID);
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

        private string PageNameSearchForTitles(string name, string languageCode)
        {
            try
            {

                NameSearchResult nsr = new BHLProvider().PageNameSearchForTitles(name, languageCode);
                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(nsr);
            }
            catch
            {
                return null;
            }
        }

        private string PageNameSearchByPageTypeAndTitle(string name, int pageTypeID, int titleID, string languageCode)
        {
            try
            {
                NameSearchResult nsr = new BHLProvider().PageNameSearchByPageTypeAndTitle(name, pageTypeID, titleID, languageCode);
                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(nsr);
            }
            catch
            {
                return null;
            }
        }

        private string FetchPageUrl(HttpContext context, int pageID)
        {
            PageSummaryService pss = new PageSummaryService();
            string[] sa = pss.FetchPageUrl(pageID);

            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(sa);
        }

        private string GetPageNameList(int pageID)
        {
            this.PopulatePageNames(pageID);
            CustomGenericList<PageName> pageNameList = new BHLProvider().PageNameSelectByPageID(pageID);
            List<PageName> returnList = new List<PageName>();
            foreach (PageName pageName in pageNameList)
            {
                if (pageName.NameBankID != null && pageName.Active)
                {
                    pageName.UrlName = pageName.NameConfirmed.Replace(' ', '_');
                    returnList.Add(pageName);
                }
            }

            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(returnList);
        }

        private string GetAlternateLocations(string locationName)
        {
            try
            {
                System.Net.HttpWebRequest req = (System.Net.HttpWebRequest)System.Net.WebRequest.Create(String.Format(ConfigurationManager.AppSettings["GeocodeUrl"], locationName));
                req.Method = "GET";
                req.Timeout = 15000;
                System.Net.HttpWebResponse resp = (System.Net.HttpWebResponse)req.GetResponse();
                System.IO.StreamReader reader = new System.IO.StreamReader((System.IO.Stream)resp.GetResponseStream());
                return reader.ReadToEnd();
            }
            catch
            {
                return null;
            }
        }
    
        /// <summary>
        /// Uses the OCR for the page to look up any names that weren't previously identified by SciLINC
        /// </summary>
        /// <param name="itemID"></param>
        /// <param name="sequenceOrder"></param>
        private void PopulatePageNames(int pageID)
        {
            BHLProvider provider = new BHLProvider();
            Page page = provider.PageSelectAuto(pageID);
            bool doLookup = false;

            // Look up the page names if we never have for this page, or if it's been longer
            // than the maximum page name age since we've looked them up
            if (page.LastPageNameLookupDate == null)
            {
                doLookup = true;
            }
            else
            {
                TimeSpan ts = DateTime.Now.Subtract((DateTime)page.LastPageNameLookupDate);
                if (ts.Days > Convert.ToInt32(ConfigurationManager.AppSettings["MaximumPageNameAge"]))
                    doLookup = true;
            }

            if (doLookup)
            {
                FindItItem[] items = new PageSummaryService().GetUBioNames(pageID);
                provider.PageNameUpdateList(pageID, items);
                provider.PageUpdateLastPageNameLookupDate(page.PageID);
            }
        }

        private string TitleSelectByTagTextInstitutionAndLanguage(string tagText, string institutionCode, string languageCode)
        {
            try
            {
                CustomGenericList<Title> titles = new BHLProvider().TitleSelectByTagTextInstitutionAndLanguage(tagText, institutionCode, languageCode);
                JavaScriptSerializer js = new JavaScriptSerializer();
                return js.Serialize(titles);
            }
            catch
            {
                return null;
            }
        }

        private string PageSummarySelectForViewerByItemID(string itemIDString)
        {
            try
            {
                int itemID;
                if (Int32.TryParse(itemIDString, out itemID))
                {
                    CustomGenericList<PageSummaryView> pages = new BHLProvider().PageSummarySelectForViewerByItemID(itemID);

                    // Serialize only the information we need
                    List<ViewerPage> viewerPages = new List<ViewerPage>();
                    foreach (PageSummaryView page in pages)
                    {
                        ViewerPage viewerPage = new ViewerPage();
                        viewerPage.AltExternalUrl = page.AltExternalURL;
                        viewerPage.WebVirtualDirectory = page.WebVirtualDirectory;
                        viewerPage.FileRootFolder = page.FileRootFolder;
                        viewerPage.BarCode = page.BarCode;
                        viewerPage.FileNamePrefix = page.FileNamePrefix;
                        viewerPage.RareBooks = page.RareBooks;
                        viewerPage.Illustration = page.Illustration;
                        viewerPages.Add(viewerPage);
                    }

                    JavaScriptSerializer js = new JavaScriptSerializer();
                    return js.Serialize(viewerPages);
                }
                else
                {
                    return null;
                }
            }
            catch
            {
                return null;
            }
        }

        [Serializable]
        private class ViewerPage
        {
            public string AltExternalUrl = string.Empty;
            public string WebVirtualDirectory = string.Empty;
            public string FileRootFolder = string.Empty;
            public string BarCode = string.Empty;
            public string FileNamePrefix = string.Empty;
            public bool RareBooks = false;
            public bool Illustration = false;
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
