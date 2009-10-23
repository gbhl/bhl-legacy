using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MOBOT.BHL.Server;
using MOBOT.BHL.DataObjects;
using CustomDataAccess;

namespace MOBOT.BHL.Web
{
	public partial class RecentRss : System.Web.UI.Page
	{
		protected void Page_Load( object sender, EventArgs e )
		{
			int top = 25;
			String paramTop = Request.QueryString[ "top" ] as String;
			if ( paramTop != null )
				Int32.TryParse( paramTop, out top );
			top = ( top == 0 || top > 100 ) ? 25 : top;

            String institutionCode = (Request.QueryString["inst"] as String) ?? String.Empty;
            String languageCode = (Request.QueryString["lang"] as String) ?? String.Empty;

            Response.ContentType = "text/xml";
            WriteLine("<?xml version='1.0' encoding='UTF-8'?>");
			WriteLine( "<rss version=\"2.0\">" );
			WriteLine( "<channel>" );
			WriteLine( "<title>BHL Recent Updates</title>" );
			WriteLine( "<link>http://www.biodiversitylibrary.org/</link>" );
			WriteLine( "<description>Recently published digital volumes from the Biodiversity Heritage Library.</description>" );
			WriteLine( "<pubDate>" + DateTime.Now.ToUniversalTime().ToString() + "</pubDate>" );
			WriteLine( "<lastBuildDate>" + DateTime.Now.ToUniversalTime().ToString() + "</lastBuildDate>" );
			WriteLine( "<generator>http://www.biodiversitylibrary.org/</generator>" );

			CustomGenericList<Item> list = new BHLProvider().ItemSelectRecent( top, languageCode, institutionCode );
			foreach ( Item item in list )
			{
                String description = String.Empty;
                if ((item.CreatorStrings.Length > 1) || (item.CreatorStrings.Length == 1 && !String.IsNullOrEmpty(item.CreatorStrings[0]))) description += "<b>By:</b><br/>";
                foreach (String creator in item.CreatorStrings)
                {
                    if (!String.IsNullOrEmpty(creator)) description += creator + "<br/>";
                }
                if (!String.IsNullOrEmpty(item.PublicationDetails)) description += "<b>Publication Info:</b><br/>" + item.PublicationDetails + "<br/>";
                if ((item.TagStrings.Length > 1) || (item.TagStrings.Length == 1 && !String.IsNullOrEmpty(item.TagStrings[0]))) description += "<b>Subjects:</b><br/>" + String.Join(", ", item.TagStrings) + "<br/>";
                if ((item.AssociationStrings.Length > 1) || (item.AssociationStrings.Length == 1 && !String.IsNullOrEmpty(item.AssociationStrings[0]))) description += "<b>Related Titles:</b><br/>";
                foreach (String association in item.AssociationStrings)
                {
                    if (!String.IsNullOrEmpty(association)) description += association + "<br/>";
                }
                if (!String.IsNullOrEmpty(item.InstitutionName)) description += "<b>Contributing Library:</b><br/>" + item.InstitutionName + "<br/>";
                if (!String.IsNullOrEmpty(item.Sponsor)) description += "<b>Sponsor:</b><br/>" + item.Sponsor + "<br/>";
                if (!String.IsNullOrEmpty(item.LicenseUrl)) description += "<b>License Type:</b><br/>" + item.LicenseUrl + "<br/>";
                if (!String.IsNullOrEmpty(item.Rights)) description += "<b>Rights:</b><br/>" + item.Rights + "<br/>";
                if (!String.IsNullOrEmpty(item.DueDiligence)) description += "<b>Due Diligence:</b><br/>" + item.DueDiligence + "<br/>";
                if (!String.IsNullOrEmpty(item.CopyrightStatus)) description += "<b>Copyright Status:</b><br/>" + item.CopyrightStatus + "<br/>";
                if (!String.IsNullOrEmpty(item.CopyrightRegion)) description += "<b>Copyright Region:</b><br/>" + item.CopyrightRegion + "<br/>";
                if (!String.IsNullOrEmpty(item.CopyrightComment)) description += "<b>Copyright Comments:</b><br/>" + item.CopyrightComment + "<br/>";
                if (!String.IsNullOrEmpty(item.CopyrightEvidence)) description += "<b>Copyright Evidence:</b><br/>" + item.CopyrightEvidence + "<br/>";

				WriteLine( "<item>" );
				WriteLine( "<title>" + Server.HtmlEncode( item.ShortTitle + " " + item.Volume ) + 
" (added: " + DateTime.Parse( item.ScanningDate.ToString() ).ToString( "MM/dd/yyyy" ) + ")</title>" );
				WriteLine( "<link>http://www.biodiversitylibrary.org/item/" + item.ItemID.ToString() + "</link>" );
                WriteLine( "<description>" + Server.HtmlEncode(description) + "</description>");
				WriteLine( "<pubDate>" + item.ScanningDate.ToString() + "</pubDate>" );
				WriteLine( "<author>webhelp@mobot.org (Biodiversity Heritage Library)</author>" );
				WriteLine( "<guid>http://www.biodiversitylibrary.org/item/" + item.ItemID.ToString() + "</guid>" );
				WriteLine( "</item>" );
			}

			WriteLine( "</channel>" );
			WriteLine( "</rss>" );
			Response.End();
		}

		private void WriteLine( string text )
		{
			Response.Write( text + "\n" );
		}
	}
}
