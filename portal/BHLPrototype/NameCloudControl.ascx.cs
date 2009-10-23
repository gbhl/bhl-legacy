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
  public partial class NameCloudControl : System.Web.UI.UserControl
  {
    private int _totalCount = 0;
		private int _maxCount = 0;
		private int _minCount = 0;

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
        int numOfNames = 100;  // show top 100 names by default

        if ( Request.QueryString[ "top" ] != null && Request.QueryString[ "top" ].Trim().Length > 0 )
        {
          Int32.TryParse( Request.QueryString[ "top" ].Trim(), out numOfNames );
        }

				if ( numOfNames > 500 )
				{
					numOfNames = 500;
				}

        populatePlaceHolder( numOfNames );

				headerText = "Top " + numOfNames.ToString() + " Scientific Names found in " + _totalCount.ToString() + " Titles";

        nameCountLiteral.Text = "<p class=\"pageheader\">" + headerText + "</p>";
        nameCountLiteral.Visible = true;
      }
    }

    private void populatePlaceHolder( int numberOfNames )
    {
      Main main = (Main)Page.Master;
      BHLProvider provider = new BHLProvider();
      CustomGenericList<NameCloud> list = null;

      // Cache the results of the Subject queries for 24 hours
			String cacheKey = "NameSelectTop" + numberOfNames.ToString();
      if ( Cache[ cacheKey ] != null )
      {
        // Use cached version
				list = (CustomGenericList<NameCloud>)Cache[ cacheKey ];
      }
      else
      {
        // Refresh cache
        list = provider.PageNameSelectTop( numberOfNames );
        Cache.Add( cacheKey, list, null, DateTime.Now.AddMinutes( 
          Convert.ToDouble( ConfigurationManager.AppSettings[ "SubjectQueryCacheTime" ] ) ), 
          System.Web.Caching.Cache.NoSlidingExpiration, System.Web.Caching.CacheItemPriority.Normal, null );
      }

			_totalCount = main.TitlesOnlineCount;

			list.Sort( SortOrder.Descending, "Qty" );
			_maxCount = list[ 0 ].Qty;
			_minCount = list[ list.Count - 1 ].Qty;
			list.Sort( "NameConfirmed" );

			foreach ( NameCloud nameCloud in list )
      {
        if ( nameCloud.NameConfirmed != null )
        {
          HyperLink link = new HyperLink();
					link.NavigateUrl = "/name/" + Server.UrlEncode( nameCloud.NameConfirmed );
					link.Text = nameCloud.NameConfirmed;
					link.CssClass = GetCssClassForCount( nameCloud.Qty );
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
      double percentage = ( Convert.ToDouble( count - _minCount ) / Convert.ToDouble( _maxCount - _minCount ) ) * 20;
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