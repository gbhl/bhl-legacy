using CustomDataAccess;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Server
{
    public partial class BHLProvider
    {
        public CustomGenericList<TitleIdentifier> TitleIdentifierSelectAll()
        {
            return (new TitleIdentifierDAL().TitleIdentifierSelectAll(null, null));
        }
    }
}
