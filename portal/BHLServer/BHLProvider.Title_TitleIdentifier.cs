using CustomDataAccess;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Server
{
    public partial class BHLProvider
    {
        public CustomGenericList<Title_TitleIdentifier> Title_TitleIdentifierSelectByTitleID(int titleID)
        {
            return (new Title_TitleIdentifierDAL().Title_TitleIdentifierSelectByTitleID(null, null, titleID));
        }

        public Title_TitleIdentifier Title_TitleIdentifierSelectByIdentifierValue(string identifierValue)
        {
            return (new Title_TitleIdentifierDAL().Title_TitleIdentifierSelectByIdentifierValue(null, null, identifierValue));
        }
    }
}
