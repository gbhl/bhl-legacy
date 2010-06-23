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
using Data = MOBOT.BHL.DataObjects;
using MOBOT.FileAccess;
using MOBOT.FileAccess.RemotingUtilities;
using MOBOT.BHL.Server;
using CustomDataAccess;
using MOBOT.BHL.Web.Utilities;

namespace MOBOT.BHL.Web
{
  public partial class TitleVolumeSelectionControl : System.Web.UI.UserControl
  {
    protected string pageName = "";

    protected void Page_Load( object sender, EventArgs e )
    {
      Main main = (Main)Page.Master;
      titleSelectionContentPanel.SetTableID( "titleSelectionContentPanel" );
      ControlGenerator.AddScriptControl(Page.Master.Page.Header.Controls, "/Scripts/jquery-1.4.2.min.js");
      ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onload", 
        "ResizeContentPanel('titleSelectionContentPanel', 258);" );
      ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onresize", 
        "ResizeContentPanel('titleSelectionContentPanel', 258);" );
    }

    private string[] GetPdfUrl( Data.PageSummaryView psv )
    {
      string[] returnStrings = new string[ 2 ];
      string pdfLocation = psv.PdfLocation;

      IFileAccessProvider fileAccess = new BHLProvider().GetFileAccessProvider(ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true");
      try
      {
          bool fileExists = fileAccess.FileExists(pdfLocation);
        if ( fileExists )
        {
          returnStrings[ 0 ] = 
            fileAccess.GetFileSizeInMB( pdfLocation ).ToString( "0." ) + " MB";
          returnStrings[1] = psv.PdfAuthUrl;
          return ( returnStrings );
        }
      }
      catch ( Exception ex )
      {
        DebugUtility.WriteErrorInfo( Response, Request, ex );
      }
      return ( null );
    }

    public void PopulateControl( Data.PageSummaryView ps)
    {
      pageName = Request.ServerVariables[ "SCRIPT_NAME" ];
      pageName = pageName.Substring( pageName.LastIndexOf( "/" ) + 1, pageName.Length - pageName.LastIndexOf( "/" ) - 1 );

      if ( pageName.ToLower() == "titlepage.aspx" )
      {
        ddlItem.Attributes.Add( "onchange", "location.href='/item/' + this.options[selectedIndex].value" );
      }

      if ( ps != null )
      {
        CustomGenericList<Data.Item> item = new BHLProvider().ItemSelectByTitleId( ps.TitleID );
        for ( int i = 0; i < item.Count; i++ )
        {
          if ( item[ i ].Volume == null || item[ i ].Volume == "" )
          {
            item.RemoveAt( i );
            i--;
          }
        }

        ddlItem.DataSource = item;
        ddlItem.DataTextField = "DisplayedShortVolume";
        ddlItem.DataValueField = "ItemID";
        ddlItem.DataBind();
        if ( ddlItem.Items.Count <= 1 )
        {
          ddlItem.Visible = false;
        }
        else
        {
          ddlItem.Visible = true;
        }
      }

      if (ps != null)
      {
          ddlItem.SelectedValue = ps.ItemID.ToString();
          String displayTitle = ps.ShortTitle + " " + (ps.PartNumber ?? "") + " " + (ps.PartName ?? "");
          titleLiteral.Text = (displayTitle.Length <= 64) ? displayTitle : displayTitle.Substring(0, 64) + "...";

          linkBib.HRef = "/bibliography/" + ps.TitleID.ToString();
          linkPDFGen.HRef = "/pdfgen/" + ps.ItemID.ToString();

          if (ps.DownloadUrl != String.Empty)
          {
              linkPDF.HRef = "http://www.archive.org/download/" + ps.BarCode + "/" + ps.BarCode + ".pdf";
              linkPDF.Target = "_blank";

              linkOCR.HRef = "http://www.archive.org/download/" + ps.BarCode + "/" + ps.BarCode + "_djvu.txt";
              linkImages.HRef = "http://www.archive.org/download/" + ps.BarCode + "/" + ps.BarCode + "_jp2.zip";
              linkAll.HRef = ps.DownloadUrl + ps.BarCode;
          }
          else
          {
              string[] pdfUrl = GetPdfUrl(ps);
              if (pdfUrl != null)
              {
                  linkPDF.Attributes["onclick"] = "javascript:window.open('" + pdfUrl[1] + "','pdf', 'width=400,height=200,status=no,toolbar=no,menubar=no,resizeable=no');";
                  linkPDF.InnerText += " (" + pdfUrl[0] + " PDF) ";
              }
              else
              {
                  linkPDF.Visible = false;
              }
              
              linkOCR.Visible = false;
              linkImages.Visible = false;
              linkAll.Visible = false;
          }
      }
      else
      {
          linkAbout.Visible = false;
      }
    }
  }
}