using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using System.Xml;
using CustomDataAccess;
using Data = MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using MOBOT.BHL.Web.Utilities;

namespace MOBOT.BHL.Web
{
	public partial class Bibliography : BasePage
	{
		public string Barcode = "";

		protected void Page_Load( object sender, EventArgs e )
		{
			main.SetPageType( Main.PageType.Content );
			ControlGenerator.AddScriptControl( Page.Master.Page.Header.Controls, "/Scripts/ResizeBrowseUtils.js" );
            ControlGenerator.AddScriptControl( Page.Master.Page.Header.Controls, "/Scripts/jquery-1.4.2.min.js" );
			ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onload",
				"ResizeContentPanel('browseContentPanel', 258);ResizeBrowseDivs();" );
			ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onresize",
				"ResizeContentPanel('browseContentPanel', 258);ResizeBrowseDivs();" );

			Data.PageSummaryView ps = null;
			CustomGenericList<Data.Item> items = null;
			CustomGenericList<Data.Creator> creators = null;
			CustomGenericList<Data.TitleTag> titleTags = null;
            CustomGenericList<Data.Title_TitleIdentifier> titleIdentifiers = null;
            CustomGenericList<Data.TitleAssociation> titleAssociations = null;
			Data.Title title = null;
            bool showData = false;
            int titleId = 0;

			if ( Request[ "titleid" ] != null )
			{
                if (!int.TryParse(Request.QueryString["titleid"], out titleId))
                {
                    // Request seems to have included a MARCBibID instead of a TitleId
                    Data.PageSummaryView psBib = bhlProvider.PageTitleSummarySelectByBibID(Request.QueryString["titleid"].ToString());
                    if (psBib != null) titleId = psBib.TitleID;
                }
                showData = true;
            }

            if (!showData && Request.QueryString["oclc"] != null)
            {
                // Get the title id associated with the OCLC identifier
                Data.Title_TitleIdentifier titleTitleId = bhlProvider.Title_TitleIdentifierSelectByIdentifierValue(Request.QueryString["oclc"].ToString());
                if (titleTitleId != null) titleId = titleTitleId.TitleID;
                showData = true;
            }
             
            if (showData)
            {
                hidTitleID.Value = titleId.ToString();

                // Check to make sure this title hasn't been replaced.  If it has, redirect
                // to the appropriate titleid.
                title = bhlProvider.TitleSelect(titleId);
                if (title.RedirectTitleID != null)
                {
                    Response.Redirect("/bibliography/" + title.RedirectTitleID.ToString());
                    Response.End();
                }

                // Set the title for the COinS
                COinSControl1.TitleID = titleId;

                ps = bhlProvider.PageTitleSummarySelectByTitleId( titleId );
				if ( ps == null )
				{
					Response.Redirect( "/TitleNotFound.aspx" );
					Response.End();
				}
				Barcode = ps.BarCode;
				creators = bhlProvider.CreatorSelectByTitleId( titleId );
				items = bhlProvider.ItemSelectByTitleId( titleId );
				titleTags = bhlProvider.TitleTagSelectTagTextByTitleId( titleId );
                titleIdentifiers = bhlProvider.Title_TitleIdentifierSelectByTitleID(titleId);
                titleAssociations = bhlProvider.TitleAssociationSelectByTitleId(titleId, true);

                if (titleAssociations.Count == 0)
                {
                    associationsDiv.Visible = false;
                }
                else
                {
                    associationsDiv.Visible = true;
                    associationsRepeater.DataSource = titleAssociations;
                    associationsRepeater.DataBind();
                }

                foreach(Data.Item item in items)
                {
                    // Populate empty volume descriptions with default text
                    if (item.Volume == String.Empty || item.Volume == null)
                    {
                        if (items.Count == 1) item.Volume = "View Book";
                        if (items.Count > 1) item.Volume = "(no volume description)";
                    }

                    // Make sure all Botanicus PDFs actually exist.  Remove the DownloadUrl for any that do not.
                    if (item.DownloadUrl != String.Empty && item.ItemSourceID == 2)
                    {
                        // This is kludgy... should find a better way to do this
                        String pdfLocation = item.DownloadUrl.Replace("http://www.botanicus.org/", "\\\\server\\").Replace('/', '\\');
                        if (new BHLProvider().GetFileAccessProvider(ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true").FileExists(pdfLocation))
                            item.DownloadUrl = ConfigurationManager.AppSettings["PdfAuthUrl"] != null ? String.Format(ConfigurationManager.AppSettings["PdfAuthUrl"], item.BarCode) : String.Empty;
                        else
                            item.DownloadUrl = String.Empty;
                    }
                }

                // Look for an OCLC identifier (use the first one... might need to account for multiple at some point)
                bool oclcFound = false;
                foreach (Data.Title_TitleIdentifier titleIdentifier in titleIdentifiers)
                {
                    if (String.Compare(titleIdentifier.IdentifierName, "OCLC", StringComparison.CurrentCultureIgnoreCase) == 0)
                    {
                        localLibraryLink.NavigateUrl += "wcpa/oclc/";
                        if (titleIdentifier.IdentifierValue.ToLower().StartsWith("ocm"))
                        {
                            //strip the "ocm" from the beginning of the value.
                            localLibraryLink.NavigateUrl += titleIdentifier.IdentifierValue.Substring(3);
                        }
                        else
                        {
                            localLibraryLink.NavigateUrl += titleIdentifier.IdentifierValue;
                        }
                        oclcFound = true;
                        break;
                    }
                }

				if (!oclcFound)
				{
					string truncatedTitle = "";
					if ( title.FullTitle.Length > 220 )
					{
						truncatedTitle = title.FullTitle.Substring( 0, 220 );
						truncatedTitle = truncatedTitle.Substring( 0, truncatedTitle.LastIndexOf( " " ) );
					}
					else
					{
						truncatedTitle = title.FullTitle;
					}
					localLibraryLink.NavigateUrl += "search?q=" + truncatedTitle.Replace( " ", "+" ) + "&qt=owc_search";
				}

				Master.Page.Title = "Biodiversity Heritage Library: Information about '" + ps.FullTitle + "'";
				//descriptionLiteral.Text = title.TitleDescription;
				publicationInfoLiteral.Text = title.PublicationDetails;
				fullTitleLiteral.Text = title.FullTitle + " " + (title.PartNumber ?? "" ) + " " + (title.PartName ?? "");
				if ( title.CallNumber == null || title.CallNumber.Length == 0 )
				{
					callNumberPanel.Visible = false;
				}
				else
				{
					callNumberLiteral.Text = title.CallNumber;
				}

				if ( titleTags == null || titleTags.Count == 0 )
				{
					subjectPanel.Visible = false;
				}
				else
				{
					int k = titleTags.Count - 1;
					int i = 0;
					StringBuilder sb = new StringBuilder();
					foreach ( Data.TitleTag titleTag in titleTags )
					{
						sb.Append( "<a href='/subject/" );
						sb.Append( Server.UrlEncode( titleTag.TagText ) );
						sb.Append( "'>" );
						sb.Append( titleTag.TagText );
						sb.Append( "</a>" );

						if ( i + 1 <= k )
						{
							sb.Append( ", " );
						}
						i++;
					}
					subjectLiteral.Text = sb.ToString();
				}

				itemRepeater.DataSource = items;
				itemRepeater.DataBind();

				CustomGenericList<Data.Creator> authors = new CustomGenericList<Data.Creator>();
				CustomGenericList<Data.Creator> additionalAuthors = new CustomGenericList<Data.Creator>();
				foreach ( Data.Creator creator in creators )
				{
					if ( creator.CreatorRoleTypeForTitle >= 1 && creator.CreatorRoleTypeForTitle <= 3 )
					{
						authors.Add( creator );
					}
					else
					{
						additionalAuthors.Add( creator );
					}
				}
				authorsRepeater.DataSource = authors;
				authorsRepeater.DataBind();
				additionalAuthorsRepeater.DataSource = additionalAuthors;
				additionalAuthorsRepeater.DataBind();

                //Data.Institution institution = bhlProvider.InstitutionSelectByItemID( ps.ItemID );
                //if ( institution != null )
                //{
                //    if ( institution.InstitutionUrl != null && institution.InstitutionUrl.Trim().Length > 0 )
                //    {
                //        HyperLink link = new HyperLink();
                //        link.Text = institution.InstitutionName;
                //        link.NavigateUrl = institution.InstitutionUrl;
                //        link.Target = "_blank";
                //        attributionPlaceHolder.Controls.Add( link );
                //    }
                //    else
                //    {
                //        Literal literal = new Literal();
                //        literal.Text = institution.InstitutionName;
                //        attributionPlaceHolder.Controls.Add( literal );
                //    }
                //}

				if ( Helper.IsAdmin( Request ) )
				{
					editTitleLink.NavigateUrl = "/Admin/TitleEdit.aspx?id=" + titleId.ToString();
				}
				else
				{
					editTitleLink.Visible = false;
				}

                // Get the full MARC details
                bool marcFound = false;
                String filepath = ps.MarcXmlLocation;
                bool test = (ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true");
                if (new BHLProvider().GetFileAccessProvider(ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true").FileExists(filepath))
                {
                    marcFound = true;
                }
                else 
                {
                    // File not found in primary location, so look in alternate location (Botanicus files in alt location)
                    filepath = ps.MarcXmlAltLocation;
                    if (new BHLProvider().GetFileAccessProvider(ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true").FileExists(filepath)) marcFound = true;
                }

                if (marcFound)
                {
                    string marcXML = new BHLProvider().GetFileAccessProvider(ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true").GetFileText(filepath);

                    XmlDocument xml = new XmlDocument();
                    StringReader reader = new StringReader(marcXML);
                    xml.Load(reader);

                    // Set up the XSL resolver that we'll use to extract the text from the xml
                    XmlUrlResolver resolver = new XmlUrlResolver();
                    resolver.Credentials = System.Net.CredentialCache.DefaultCredentials;
                    System.Xml.Xsl.XslTransform xslTransform = new System.Xml.Xsl.XslTransform();

                    // Format the MARC XML into a "readable" format
                    xslTransform.Load(Request.PhysicalApplicationPath + "xsl\\MARC21transformEnglish.xsl", resolver);
                    StringWriter output = new StringWriter();
                    xslTransform.Transform(xml, null, output, resolver);
                    litExpanded.Text = output.ToString();

                    // Format the MARC XML into a "flat" MARC format
                    xslTransform.Load(Request.PhysicalApplicationPath + "xsl\\MARC21transformMARC.xsl", resolver);
                    output = new StringWriter();
                    xslTransform.Transform(xml, null, output, resolver);
                    litMarc.Text = output.ToString();

                    viewcontrol.Visible = true;
                }
                else
                {
                    viewcontrolnomarc.Visible = true;
                }

                // Get the BibTex citations for this title
                try
                {
                    hypBibTex.NavigateUrl += title.TitleID.ToString();
                    litBibTeX.Text = bhlProvider.TitleBibTeXGetCitationStringForTitleID(title.TitleID).Replace("\n", "<br>").Replace("\r", "<br>");
                }
                catch
                {
                    hypBibTex.Visible = false;
                    litBibTeX.Text = "Error retrieving BibTex citations for this title.";
                }

                // Get the EndNote citation for this title
                try
                {
                    hypEndNote.NavigateUrl += title.TitleID.ToString();
                    litEndNote.Text = bhlProvider.TitleEndNoteGetCitationStringForTitleID(title.TitleID,
                        ConfigurationManager.AppSettings["ItemPageUrl"].ToString()).Replace("\n", "<br>").Replace("\r", "<br>");
                }
                catch
                {
                    hypEndNote.Visible = false;
                    litEndNote.Text = "Error retrieving EndNote citations for this title.";
                }
			}
		}
	}
}
