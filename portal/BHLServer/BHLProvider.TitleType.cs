using CustomDataAccess;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Server
{
	public partial class BHLProvider
	{
		public CustomGenericList<TitleType> TitleTypeSelectAll()
		{
			return TitleTypeDAL.SelectAll( null, null );
		}
	}
}
