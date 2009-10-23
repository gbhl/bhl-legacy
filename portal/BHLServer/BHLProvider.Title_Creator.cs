using System;
using CustomDataAccess;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Server
{
	public partial class BHLProvider
	{

		private bool titleCreatorExists( CustomGenericList<Title_Creator> titleCreators,
				Title_Creator titleCreatorToCheckFor )
		{
			foreach ( Title_Creator tc in titleCreators )
			{
				if ( ( tc.TitleID == titleCreatorToCheckFor.TitleID ) &&
						( tc.CreatorID == titleCreatorToCheckFor.CreatorID ) &&
						( tc.CreatorRoleTypeID == titleCreatorToCheckFor.CreatorRoleTypeID ) )
				{
					return true;
				}
			}
			return false;
		}
	}
}
