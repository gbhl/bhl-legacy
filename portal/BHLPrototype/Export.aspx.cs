using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using Page = MOBOT.BHL.DataObjects.Page;

namespace MOBOT.BHL.Web
{
	public partial class Export : System.Web.UI.Page
	{
		protected void Page_Load( object sender, EventArgs e )
		{
			string type = Request.QueryString[ "type" ];
			string name = Request.QueryString[ "name" ];
			string pagetype = Request.QueryString[ "pagetype" ];

			if ( type != null && name != null && pagetype != null &&
				type.Length >0 && name.Length > 0 && pagetype.Length > 0 )
			{
				StringBuilder sb = new StringBuilder();
				BHLProvider bp = new BHLProvider();

				NameSearchResult result = bp.PageNameSearch( name, int.Parse( pagetype ), "" );
				string sGenName = name;
				if ( type.ToLower().Equals( "bibtex" ) )
				{
					sGenName += ".bibtex";
				}
				else if ( type.ToLower().Equals( "endnote" ) )
				{
					sGenName += ".endnote";
				}

				foreach ( NameSearchTitle title in result.Titles )
				{
					foreach ( NameSearchItem item in title.Items )
					{
						foreach ( NameSearchPage page in item.Pages )
						{
							if ( type.ToLower().Equals( "bibtex" ) )
							{
								sb.Append( "@Page{pageid:" );
								sb.Append( page.PageID.ToString() );
								sb.Append( "\r\n" );
								sb.Append( "\ttitle = \"" );
								sb.Append( title.ShortTitle );
								sb.Append( "\",\r\n" );
								sb.Append( "\titem = \"" );
								sb.Append( item.Volume );
								sb.Append( "\",\r\n" );
								sb.Append( "\tpage = \"" );
								if ( page.IndicatedPages != null && page.IndicatedPages.Length > 0 )
								{
									sb.Append( page.IndicatedPages );
								}
								else
								{
									sb.Append( page.SequenceOrder.ToString() );
								}
								sb.Append( "\",\r\n" );
								sb.Append( "\turl = \"http://" );
								sb.Append( Request.ServerVariables[ "HTTP_HOST" ] );
								sb.Append( "/page/" );
								sb.Append( page.PageID.ToString() );
								sb.Append( "\",\r\n" );
								sb.Append( "}" );
								sb.Append( "\r\n" );
								sb.Append( "\r\n" );
							}
							else if ( type.ToLower().Equals( "endnote" ) )
							{

							}
						}
					}
				}

				
				Response.AddHeader( "Content-disposition", "attachment; filename=" + sGenName );
				Response.ContentType = "application/octet-stream";
				Response.Write( sb.ToString() );
				Response.End();
			}
		}
	}
}
