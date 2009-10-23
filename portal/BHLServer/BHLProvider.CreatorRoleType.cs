using CustomDataAccess;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Server
{
	public partial class BHLProvider
	{
		public CustomGenericList<CreatorRoleType> CreatorRoleTypeSelectAll()
		{
			return CreatorRoleTypeDAL.CreatorRoleTypeSelectAll( null, null );
		}
	}
}
