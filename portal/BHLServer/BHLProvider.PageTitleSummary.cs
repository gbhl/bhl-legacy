using CustomDataAccess;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Server
{
  public partial class BHLProvider
  {
    public PageSummaryView PageTitleSummarySelectByTitleId( int titleId )
    {
      return ( new PageTitleSummaryDAL().PageTitleSummarySelectByTitleId( null, null, titleId ) );
    }

    /// <summary>
    /// Select values from PageSummaryView by MARC Bib Id.
    /// </summary>
    /// <param name="bibID"></param>
    /// <returns>Object of type PageTitleSummaryView.</returns>
    public PageSummaryView PageTitleSummarySelectByBibID( string bibID )
    {
      return ( new PageTitleSummaryDAL().PageTitleSummarySelectByBibId( null, null, bibID ) );
    }
  }
}
