using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.IO;
using System.Net;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MOBOT.BHL.Web.Utilities;
using MOBOT.BHL.Server;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Web
{
    public partial class MapControl : System.Web.UI.UserControl
    {
        protected string locations = String.Empty;
        protected string institutionCode = String.Empty;
        protected string languageCode = String.Empty;
        protected void Page_Load(object sender, EventArgs e)
        {
            BHLMasterPage main = (BHLMasterPage) Page.Master;
            ControlGenerator.AddAttributesAndPreserveExisting(main.Body, "onload", "initMap();");

            if (this.Request.Cookies["ddlContributors"] != null) institutionCode = this.Request.Cookies["ddlContributors"].Value;
            if (this.Request.Cookies["ddlLanguage"] != null) languageCode = this.Request.Cookies["ddlLanguage"].Value;

            string key = ConfigurationManager.AppSettings["Google.Maps.Key." + Request.ServerVariables["HTTP_HOST"]];
            //mapsScriptTag.Text = "<script src=\"http://maps.google.com/maps?file=api&amp;v=2&amp;key=" + key + "\" type=\"text/javascript\"></script>";
            mapsScriptTag.Text = "<script src=\"" + ConfigurationManager.AppSettings["Google.Maps.ScriptUrlPrefix"] + key + "\" type=\"text/javascript\"></script>";
            string geocodeUrlPrefix = "http://maps.google.com/maps/geo?output=csv&key=" + key + "&q=";
            BHLProvider provider = new BHLProvider();
            //first get the list of TitleTags that do not yet exist in the location table
            CustomGenericList<CustomDataRow> newLocationList = provider.TitleTagSelectNewLocations();

            foreach (CustomDataRow row in newLocationList)
            {
                //do the geocode lookups for our new locations
                HttpWebRequest req = (HttpWebRequest)WebRequest.Create(geocodeUrlPrefix + row["TagText"].Value.ToString());
                req.Timeout = 15000;
                HttpWebResponse resp = (HttpWebResponse)req.GetResponse();
                StreamReader reader = new StreamReader((System.IO.Stream)resp.GetResponseStream());
                string results = reader.ReadLine();
                string[] resultsArray = results.Split(',');
                //save the results to the Location table
                if (resultsArray[0] == "200")
                {
                    //if we got a valid response, save the coordinates
                    provider.LocationInsertAuto(row["TagText"].Value.ToString(), resultsArray[2], resultsArray[3], null, true);
                }
                else
                {
                    //if we did not get a valid response, save a location record with null coordinates and set the NextAttemptDate to 30 days out
                    provider.LocationInsertAuto(row["TagText"].Value.ToString(), null, null, DateTime.Now.AddDays(30), true);
                }
            }

            //next, get the list of Locations that were not successful in the past that are due for another attempt
            CustomGenericList<Location> invalidLocationList = provider.LocationSelectAllInvalid();
            foreach (Location location in invalidLocationList)
            {
                //if the NextAttemptDate indicates that we're due to try again, do a new geocode lookup for this location
                if (location.NextAttemptDate != null && location.NextAttemptDate < DateTime.Now)
                {
                    HttpWebRequest req = (HttpWebRequest)WebRequest.Create(geocodeUrlPrefix + location.LocationName);
                    req.Timeout = 15000;
                    HttpWebResponse resp = (HttpWebResponse)req.GetResponse();
                    StreamReader reader = new StreamReader((System.IO.Stream)resp.GetResponseStream());
                    string results = reader.ReadLine();
                    string[] resultsArray = results.Split(',');
                    //save the results to the Location table
                    if (resultsArray[0] == "200")
                    {
                        //if we got a valid response, save the coordinates and wipe out the NextAttemptDate
                        provider.LocationUpdateAuto(location.LocationName, resultsArray[2], resultsArray[3], null, location.IncludeInUI);
                    }
                    else
                    {
                        //if we still did not get a valid response, increment the NextAttemptDate by another 30 days
                        provider.LocationUpdateAuto(location.LocationName, null, null, DateTime.Now.AddDays(30), location.IncludeInUI);
                    }
                }
            }

            //now get the updated list of coordinates to set the markers on the map
            CustomGenericList<Location> validLocationList = provider.LocationSelectValidByInstitution(institutionCode, languageCode);
            foreach (Location location in validLocationList)
                locations += location.Latitude + "," + location.Longitude + "," + location.LocationName + "," + location.NumberOfTitles.ToString() + ";";

            //strip the trailing ";"
            if (locations.EndsWith(";"))
                locations = locations.Substring(0, locations.Length - 1);
        }
    }
}