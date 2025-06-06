using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.Services;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;

namespace MOBOT.BHL.WebService
{
    public partial class BHLWS
    {
        [WebMethod]
        public int[] PageNameUpdateList(int pageID, FindItItem[] items)
        {
            BHLProvider provider = new BHLProvider();
            return provider.PageNameUpdateList(pageID, items);
        }

    }
}
