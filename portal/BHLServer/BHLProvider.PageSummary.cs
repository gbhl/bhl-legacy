using CustomDataAccess;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Server
{
  public partial class BHLProvider
  {
    public PageSummaryView PageSummarySelectByItemId( int itemId )
    {
      return ( new PageSummaryDAL().PageSummarySelectByItemId( null, null, itemId ) );
    }

    public CustomGenericList<PageSummaryView> PageSummarySelectForViewerByItemID(int itemId)
    {
        return (new PageSummaryDAL().PageSummarySelectForViewerByItemID(null, null, itemId));
    }

    /// <summary>
    /// Select values from PageSummaryView by Barcode.
    /// </summary>
    /// <param name="barcode"></param>
    /// <returns>Object of type Title.</returns>
    public PageSummaryView PageSummarySelectByBarcode( string barcode )
    {
      return ( new PageSummaryDAL().PageSummarySelectByBarcode( null, null, barcode ) );
    }

    /// <summary>
    /// Select values from PageSummaryView by Page Id.
    /// </summary>
    /// <param name="pageId"></param>
    /// <returns>Object of type Title.</returns>
    public PageSummaryView PageSummarySelectByPageId( int pageId )
    {
      return ( new PageSummaryDAL().PageSummarySelectByPageId( null, null, pageId ) );
    }

    /// <summary>
    /// Select values from PageSummaryView by File Name Prefix.
    /// </summary>
    /// <param name="prefix"></param>
    /// <returns>Object of type Title.</returns>
    public PageSummaryView PageSummarySelectByPrefix( string prefix )
    {
      return ( new PageSummaryDAL().PageSummarySelectByPrefix( null, null, prefix ) );
    }

    /// <summary>
    /// Select values from PageSummaryView by File Name Prefixes.
    /// </summary>
    /// <param name="prefixList"></param>
    /// <returns>Object of type Title.</returns>
    public CustomGenericList<PageSummaryView> PageSummarySelectByPrefixList( string prefixList )
    {
      return ( new PageSummaryDAL().PageSummarySelectByPrefixList( null, null, prefixList ) );
    }

    /// <summary>
    /// Select values from PageSummaryView by Item and Sequence.
    /// </summary>
    /// <param name="itemID"></param>
    /// <param name="sequence"></param>
    /// <returns>Object of type Title.</returns>
    public PageSummaryView PageSummarySelectByItemAndSequence( int itemID, int sequence )
    {
      return ( new PageSummaryDAL().PageSummarySelectByItemAndSequence( null, null, itemID, sequence ) );
    }

    public CustomGenericList<PageSummaryView> PageSummarySelectFoldersForTitleID(int titleID)
    {
        return (new PageSummaryDAL().PageSummarySelectFoldersForTitleID(null, null, titleID));
    }

    public CustomGenericList<PageSummaryView> PageSummarySelectBarcodeForTitleID(int titleID)
    {
        return (new PageSummaryDAL().PageSummarySelectBarcodeForTitleID(null, null, titleID));
    }
  }
}
