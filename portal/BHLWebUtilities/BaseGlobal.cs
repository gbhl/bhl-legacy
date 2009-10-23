using System;
using System.Web;

namespace MOBOT.BHL.Web.Utilities
{
	public class BaseGlobal : HttpApplication
	{
		protected void Application_BeginRequest( object sender, EventArgs e )
		{
			// The requested URL
			string rawUrl = Request.RawUrl;
			// Scan the path for the keywords and rewrite the path to the preferred content
			if ( rawUrl.IndexOf( "." ) < 0 || rawUrl.IndexOf( "404.aspx" ) >= 0 )
			{
				/*
				 * If a specific file was not requested, check for the following patterns
				 * 
				 * /bibliogrpahy/titleid will be rewritten as bibliography.aspx?titleid=<titleid>
				 * /creator/creatorid will be re-written as creator.aspx?creatorid=<creatorid>
				 * /item/itemid will be rewritten as title.aspx?itemid=<itemid>
				 * /page/pageid will be re-written as title.aspx?pageid=<pageid>
				 * /title/titleid will be rewritten as title.aspx?titleid=<titleid>
         * /ia/barcode will be rewritten as title.aspx?barcode=<barcode>
				 * /subject/tag will be rewritten as browsebytitle.aspx?tagtext=<tag>
				 * /browse will be re-written as default.aspx
				 * /browse/titles will be re-written as default.aspx?browseType=title
				 * /browse/authors will be re-written as default.aspx?browseType=author
				 * /browse/subject will be re-written as default.aspx?browseType=cloud
				 * /browse/map will be re-written as default.aspx?browseType=map
				 * /browse/year will be re-written as default.aspx?browseType=year
				 * /browse/titles/startLetter will be re-written as default.aspx?browseType=title&start=<startLetter>
				 * /browse/authors/startLetter will be re-written as default.aspx?browseType=author&start=<startLetter>
				 * /browse/year/startYear-endYear will be re-written as default.aspx?browseType=year&start=<startYear>&enddate=<endYear>
				 * /name/poa_annua will be re-written as NameSearchResults.aspx?name=poa annua (underscores replaced with spaces)
				 * 
				 * Deprecated patterns
				 * /item/barcode will be re-written as title.aspx?barcode=<barcode>
				 * /title/bibid will be re-written as title.aspx?bibid=<bibid>
				 * 
				 */

				//remove trailing "/" if present
				if ( rawUrl.EndsWith( "/" ) )
				{
					rawUrl = rawUrl.Remove( rawUrl.Length - 1 );
				}

				string urlPrefix = "";
				string urlSuffix = rawUrl.Substring( rawUrl.LastIndexOf( "/" ) + 1 );

				rawUrl = rawUrl.ToLower();
				if ( rawUrl.EndsWith( "/browse" ) || rawUrl.EndsWith( "/browse/" ) )
				{
					urlPrefix = "/default.aspx";
					urlSuffix = "";
				}
				else if ( rawUrl.EndsWith( "/permissions" ) || rawUrl.EndsWith( "/permissions/" ) )
				{
					urlPrefix = "/permissions.aspx";
					urlSuffix = "";
				}
				else if ( rawUrl.IndexOf( "browse/" ) >= 0 )
				{
					urlPrefix = "/default.aspx?browseType=";
					urlSuffix = "";
					if ( rawUrl.IndexOf( "/titles" ) >= 0 )
					{
						urlSuffix = "title";
						if ( !rawUrl.EndsWith( "/titles" ) && !rawUrl.EndsWith( "/titles/" ) )
						{
							urlSuffix += "&start=" + rawUrl.Substring( rawUrl.LastIndexOf( "/" ) + 1 ).ToUpper();
						}
					}
					else if ( rawUrl.IndexOf( "/authors" ) >= 0 )
					{
						urlSuffix = "author";
						if ( !rawUrl.EndsWith( "/authors" ) && !rawUrl.EndsWith( "/authors/" ) )
						{
							urlSuffix += "&start=" + rawUrl.Substring( rawUrl.LastIndexOf( "/" ) + 1 ).ToUpper();
						}
					}
					else if ( rawUrl.IndexOf( "/subject" ) >= 0 )
					{
						urlSuffix = "cloud";
						if ( !rawUrl.EndsWith( "/subject" ) && !rawUrl.EndsWith( "/subject/" ) )
						{
							urlSuffix += "&top=" + rawUrl.Substring( rawUrl.LastIndexOf( "/" ) + 1 ).ToUpper();
						}
					}
					else if ( rawUrl.IndexOf( "/map" ) >= 0 )
					{
						urlSuffix = "map";
					}
					else if ( rawUrl.IndexOf( "/year" ) >= 0 )
					{
						urlSuffix = "year";
						if ( !rawUrl.EndsWith( "/year" ) && !rawUrl.EndsWith( "/year/" ) )
						{
							string[] years = rawUrl.Substring( rawUrl.LastIndexOf( "/" ) + 1 ).Split( '-' );
							urlSuffix += "&start=" + years[ 0 ] + "&enddate=" + years[ 1 ];
						}
					}
				}
				else if ( rawUrl.IndexOf( "name/" ) >= 0 )
				{
					urlPrefix = "/NameSearchResults.aspx?name=";
					urlSuffix = urlSuffix.Replace( "_", " " );
				}
				else if ( rawUrl.IndexOf( "title/" ) >= 0 )
				{
					if ( rawUrl.Substring( rawUrl.IndexOf( "title/" ) + 6 ).Length > 5 )
					{
						urlPrefix = "/title.aspx?bibid=";
					}
					else
					{
						urlPrefix = "/title.aspx?titleid=";
					}
				}
				else if ( rawUrl.IndexOf( "item/" ) >= 0 )
				{
          if ( rawUrl.Substring( rawUrl.IndexOf( "item/" ) + 5 ).Length > 5 )
          {
            urlPrefix = "/title.aspx?barcode=";
          }
          else
          {
            urlPrefix = "/title.aspx?itemid=";
          }
        }
        else if ( rawUrl.IndexOf( "ia/" ) >= 0 )
        {
          urlPrefix = "/title.aspx?barcode=";
        }
				else if ( rawUrl.IndexOf( "page/" ) >= 0 )
				{
					urlPrefix = "/title.aspx?pageid=";
				}
				else if ( rawUrl.IndexOf( "bibliography/" ) >= 0 )
				{
					urlPrefix = "/bibliography.aspx?titleid=";
				}
				else if ( rawUrl.IndexOf( "creator/" ) >= 0 )
				{
					urlPrefix = "/creator.aspx?creatorid=";
				}
				else if ( rawUrl.IndexOf( "subject/" ) >= 0 )
				{
					urlPrefix = "/browsebytitletag.aspx?tagtext=";
				}
				else if ( rawUrl.IndexOf( "recent/" ) > 0 )
				{
					urlPrefix = "/recent.aspx?sel=";

					switch ( rawUrl.Substring( rawUrl.LastIndexOf( "/" ) + 1 ).ToUpper() )
					{
						case "1": { urlSuffix += "&top=25"; break; }
						case "2": { urlSuffix += "&top=50"; break; }
						case "3": { urlSuffix += "&top=100"; break; }
					}
				}
				else if ( rawUrl.IndexOf( "recentrss/" ) > 0 )
				{
					urlPrefix = "/recentrss.aspx?sel=";

					switch ( rawUrl.Substring( rawUrl.LastIndexOf( "/" ) + 1 ).ToUpper() )
					{
						case "1": { urlSuffix += "&top=25"; break; }
						case "2": { urlSuffix += "&top=50"; break; }
						case "3": { urlSuffix += "&top=100"; break; }
					}
				}
				else if ( rawUrl.ToLower().IndexOf( "openurl?" ) >= 0 )
				{
					urlPrefix = "/pageresolve.aspx";
					urlSuffix = rawUrl.Substring( rawUrl.LastIndexOf( "?" ) );
				}

				if ( urlPrefix.Length > 0 || urlSuffix.Length > 0 )
				{
					Context.RewritePath( urlPrefix + urlSuffix );
					//RedirectAndEnd(urlPrefix + urlSuffix);
				}
			}
		}

		protected void Application_Error( object sender, EventArgs e )
		{
			Exception ex = Server.GetLastError();
			if ( !DebugUtility.IsDebugMode( Response, Request ) )
			{
				try
				{
					if ( ex is HttpException )
					{
						HttpException http = (HttpException)ex;
						if ( http.GetHttpCode() == 404 )
						{
							RedirectAndEnd( "/PageNotFound.aspx" );
						}
					}
					RedirectAndEnd( "/Error.aspx" );
				}
				catch
				{
					RedirectAndEnd( "/Error.aspx" );
				}
			}
			else
			{
				try
				{
					Exception ex2 = null;
					if ( ex.InnerException != null )
						ex2 = ex.InnerException;
					else
						ex2 = ex;

					Response.Write( "<b>Message:</b> " + ex2.Message + "<br /><br />" );
					Response.Write( "<b>Stack Trace:</b> " + ex2.StackTrace.Replace( "\n", "<br />" ) );
					Response.End();
				}
				catch
				{
					RedirectAndEnd( "/Error.aspx" );
				}
			}
		}

		private void RedirectAndEnd( string url )
		{
			Response.Redirect( url );
			Response.End();
		}
	}
}
