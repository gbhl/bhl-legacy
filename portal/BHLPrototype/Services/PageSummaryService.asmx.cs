using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Diagnostics;
using System.Net;
using System.Text;
using System.Web;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script.Services;
using System.Xml;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using MOBOT.FileAccess;
using MOBOT.FileAccess.RemotingUtilities;
using CustomDataAccess;
using MOBOT.BHL.Web.Utilities;

namespace MOBOT.BHL.Web.Services
{
	/// <summary>
	/// Summary description for PageSummaryService
	/// </summary>
	[WebService( Namespace = "http://tempuri.org/" )]
	[WebServiceBinding( ConformsTo = WsiProfiles.BasicProfile1_1 )]
	[ToolboxItem( false )]
	[ScriptService]
	public class PageSummaryService : WebService
	{
		[WebMethod]
		[ScriptMethod( UseHttpGet = true )]
		public string[] FetchPageUrl( int pageID )
		{
			string[] sa = new string[ 6 ];
			PageSummaryView psv = new BHLProvider().PageSummarySelectByPageId( pageID );
			sa[ 0 ] = new BHLProvider().GetPageUrl( psv );
			sa[ 1 ] = GetTextUrl( psv );
			sa[ 2 ] = psv.PageDescription;
			sa[ 3 ] = psv.PageID.ToString();
			sa[ 4 ] = ReplaceReturnsWithBreaks( GetOcrText( psv ) );
			sa[ 5 ] = String.Format( "http://names.ubio.org/webservices/service.php?function=findIT&url=http://www.botanicus.org/PrimeOcr/mbgserv14/{0}/{1}/{2}/{3}.txt&strict=1&keyCode=78bd024866f1df74125f194b764d80333e0d64aa", psv.WebVirtualDirectory, psv.MARCBibID, psv.BarCode, psv.FileNamePrefix );
			return ( sa );
		}

		private string GetTextUrl( PageSummaryView psv )
		{
			try
			{
                if (new BHLProvider().GetFileAccessProvider(ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true").FileExists(psv.OcrTextLocation))
				{
					return ( "/Text.aspx?PageId=" + psv.PageID );
				}
				else
					return ( "" );
			}
			catch
			{
				if ( DebugUtility.IsDebugMode( this.Context.Request ) )
					return ( "error" );
				else
					return "";
			}
		}

		private string GetOcrText( PageSummaryView ps )
		{
			try
			{
                return new BHLProvider().GetFileAccessProvider(ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true").GetFileText(ps.OcrTextLocation);
			}
			catch ( Exception ex )
			{
				return DebugUtility.GetErrorInfo( this.Context.Request, ex );
			}
			return "";
		}

		[WebMethod]
		public FindItItem[] GetUBioNames( int pageID )
		{
			bool tooLarge = false;
			string webServiceUrl = string.Empty;

			PageSummaryView ps = new BHLProvider().PageSummarySelectByPageId( pageID );
			string filepath = ps.OcrTextLocation;

            if (new BHLProvider().GetFileAccessProvider(ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true").GetFileSizeInKB(filepath) <= 5)
			{
				// OCR text not too large for URI, so send it in the UBIO request

				// Get the OCR text and start to build the UBIO url
				string ocrText = this.GetOcrText( ps );
				StringBuilder webServiceUrlSB = new StringBuilder();
				webServiceUrlSB.Append( "http://www.ubio.org/webservices/service.php?function=taxonFinder&includeLinks=0&freeText=" );
				webServiceUrlSB.Append( System.Web.HttpUtility.UrlEncode( ocrText ) );

				// Add the existing page names for this Page to the UBIO url
				CustomGenericList<PageName> pageNames = new BHLProvider().PageNameSelectByPageID( pageID );
				foreach ( PageName pageName in pageNames )
				{
					webServiceUrlSB.Append( System.Web.HttpUtility.UrlEncode( "  " + pageName.NameFound ) );
				}

				// Get the final UBIO url
				webServiceUrl = webServiceUrlSB.ToString();

				// If the url is too large after all UrlEncoding is complete, just send the file path
				if ( ( (long)webServiceUrl.Length / 1024 ) > 5 )
					tooLarge = true;
			}
			else
			{
				tooLarge = true;
			}

			// OCR text is too large, so just send the file path
			//string webServiceUrl = String.Format("http://names.ubio.org/webservices/service.php?function=findIT&url=http://www.botanicus.org/PrimeOcr/{0}/{1}/{2}/{3}.txt&strict=1&keyCode=78bd024866f1df74125f194b764d80333e0d64aa", ps.WebVirtualDirectory, ps.MARCBibID, ps.BarCode, ps.FileNamePrefix);
			if ( tooLarge )
				webServiceUrl = String.Format( "http://www.ubio.org/webservices/service.php?function=taxonFinder&includeLinks=0&url=http://www.botanicus.org/PrimeOcr/mbgserv14/{0}/{1}/{2}/{3}.txt", ps.WebVirtualDirectory, ps.FileRootFolder, ps.BarCode, 
					ps.FileNamePrefix );


			List<FindItItem> fiil = new List<FindItItem>();
			XmlTextReader reader = null;
			try
			{
				HttpWebRequest req = (HttpWebRequest)WebRequest.Create( webServiceUrl );
				req.Method = "POST";
				req.Timeout = 15000;
				HttpWebResponse resp = (HttpWebResponse)req.GetResponse();
				reader = new XmlTextReader( (System.IO.Stream)resp.GetResponseStream() );
				StringBuilder sb = new StringBuilder();

				FindItItem fii = null;
				string currentStage = "";
				while ( reader.Read() )
				{
					if ( reader.NodeType == XmlNodeType.Whitespace )
						continue;

					if ( reader.HasValue )
						sb.Append( reader.Value );
					if ( currentStage == "nameString" && reader.Value != "" )
					{
						fii.Name = reader.Value;
					}
					if ( currentStage == "namebankID" && reader.Value != "" )
					{
						fii.NamebankID = Int32.Parse( reader.Value );
					}
					else if ( reader.NodeType != XmlNodeType.EndElement )
					{
						sb.Append( "\n" + reader.Name + ": " );
						currentStage = reader.Name;
						if ( reader.Name == "entity" )
						{
							fii = new FindItItem();
						}
					}
					else
					{
						if ( reader.Name == "entity" )
						{
							fiil.Add( fii );
						}
					}
				}
			}
			finally
			{
				if ( reader != null )
					reader.Close();
			}
			return ( fiil.ToArray() );
		}

		private string ReplaceReturnsWithBreaks( string input )
		{
			return input.Replace( "\n", "<br />" );
		}
	}
}
