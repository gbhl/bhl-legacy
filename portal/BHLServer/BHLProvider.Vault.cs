using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;
using CustomDataAccess;

namespace MOBOT.BHL.Server
{
	public partial class BHLProvider
	{
		public CustomGenericList<Vault> VaultSelectAll()
		{
			return VaultDAL.SelectAll( null, null );
		}

		public Vault VaultSelect( int vaultID )
		{
			return ( new VaultDAL().VaultSelectAuto( null, null, vaultID ) );
		}

		public void SaveVault( Vault vault )
		{
			VaultDAL.Save( null, null, vault );
		}

	}
}