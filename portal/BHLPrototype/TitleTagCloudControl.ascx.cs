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
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Web
{
  public partial class TitleTagCloudControl : System.Web.UI.UserControl
  {
    private int totalCount = 0;
    private double tagCloudThreshold1 = double.Parse( ConfigurationManager.AppSettings[ "tagCloudThreshold1" ] );
    private double tagCloudThreshold2 = double.Parse( ConfigurationManager.AppSettings[ "tagCloudThreshold2" ] );
    private double tagCloudThreshold3 = double.Parse( ConfigurationManager.AppSettings[ "tagCloudThreshold3" ] );
    private double tagCloudThreshold4 = double.Parse( ConfigurationManager.AppSettings[ "tagCloudThreshold4" ] );
    private double tagCloudThreshold5 = double.Parse( ConfigurationManager.AppSettings[ "tagCloudThreshold5" ] );

    protected void Page_Load( object sender, EventArgs e )
    {
      if ( !IsPostBack )
      {
        string headerText = String.Empty;
        int numOfSubjects = 100;  // show top 100 subjects by default

        if ( Request.QueryString[ "top" ] != null && Request.QueryString[ "top" ].Trim().Length > 0 )
        {
          Int32.TryParse( Request.QueryString[ "top" ].Trim(), out numOfSubjects );
        }

        this.PopulatePlaceHolder( numOfSubjects );
        if ( numOfSubjects == 10000000 )
          headerText = "ALL Subjects for " + totalCount.ToString() + " Titles";
        else
          headerText = "Top " + numOfSubjects.ToString() + " Subjects for " + totalCount.ToString() + " Titles";

        subjectCountLiteral.Text = "<p class=\"pageheader\">" + headerText + "</p>";
        subjectCountLiteral.Visible = true;
      }
    }

    private void PopulatePlaceHolder( int numberOfSubjects )
    {
      Main main = (Main)Page.Master;
      BHLProvider provider = new BHLProvider();
      CustomGenericList<CustomDataRow> list = null;

      String institutionCode = String.Empty;
      if (this.Request.Cookies["ddlContributors"] != null) institutionCode = this.Request.Cookies["ddlContributors"].Value;
      String languageCode = String.Empty;
      if (this.Request.Cookies["ddlLanguage"] != null) languageCode = this.Request.Cookies["ddlLanguage"].Value;

      // Cache the results of the Subject queries for 24 hours
      String cacheKey = "TitleTagSelectCount" + numberOfSubjects.ToString() + institutionCode + languageCode;
      if ( Cache[ cacheKey ] != null )
      {
        // Use cached version
        list = (CustomGenericList<CustomDataRow>)Cache[ cacheKey ];
      }
      else
      {
        // Refresh cache
        list = provider.TitleTagSelectCountByInstitution( numberOfSubjects, institutionCode, languageCode );
        Cache.Add( cacheKey, list, null, DateTime.Now.AddMinutes( 
          Convert.ToDouble( ConfigurationManager.AppSettings[ "SubjectQueryCacheTime" ] ) ), 
          System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Normal, null );
      }

      // Read the total number of titles from the first row in the result set
      if (list.Count > 0)
          totalCount = (int)list[0]["Count"].Value;
      else
          totalCount = main.TitlesOnlineCount;

      foreach ( CustomDataRow row in list )
      {
        if ( row[ "TagText" ].Value != null )
        {
          HyperLink link = new HyperLink();
          link.NavigateUrl = "/subject/" + Server.UrlEncode( row[ "TagText" ].Value.ToString() );
          link.Text = row[ "TagText" ].Value.ToString();
          link.CssClass = GetCssClassForCount( (int)row[ "Count" ].Value );
          titleTagCloudPlaceHolder.Controls.Add( link );
          Image spacer = new Image();
          spacer.ImageUrl = "/images/blank.gif";
          spacer.Height = 1;
          spacer.Width = 4;
          titleTagCloudPlaceHolder.Controls.Add( spacer );
        }
      }
    }

    private string GetCssClassForCount( int count )
    {
      double percentage = ( Convert.ToDouble( count ) / Convert.ToDouble( totalCount ) ) * 100;
      string classPrefix = "TitleTagCloud";

      if ( percentage < tagCloudThreshold1 )
        return classPrefix + "1";
      else if ( percentage < tagCloudThreshold2 )
        return classPrefix + "2";
      else if ( percentage < tagCloudThreshold3 )
        return classPrefix + "3";
      else if ( percentage < tagCloudThreshold4 )
        return classPrefix + "4";
      else if ( percentage < tagCloudThreshold5 )
        return classPrefix + "5";
      else
        return classPrefix + "6";
    }
  }
}