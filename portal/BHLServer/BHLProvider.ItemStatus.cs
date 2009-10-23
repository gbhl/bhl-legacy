using System;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;
using CustomDataAccess;

namespace MOBOT.BHL.Server
{
	public partial class BHLProvider
	{
		public CustomGenericList<ItemStatus> ItemStatusSelectAll()
		{
			return ItemStatusDAL.SelectAll(null, null );
		}

		public ItemStatus ItemStatusSelectAuto( int itemStatusID )
		{
			return ( new ItemStatusDAL().ItemStatusSelectAuto( null, null, itemStatusID ) );
		}

		public void SaveItemStatus( ItemStatus itemStatus )
		{
			ItemStatusDAL.Save( null, null, itemStatus );
		}
	}
}