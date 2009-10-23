using System;
using System.Web.Services;
using System.ComponentModel;
using Config = System.Configuration;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using MOBOT.Utility;

namespace MOBOT.BHL.WebService
{
    /// <summary>
    /// Summary description for BHLWS
    /// </summary>
    [WebService(Namespace = "http://www.mobot.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    [ToolboxItem(false)]
    public partial class BHLWS : System.Web.Services.WebService
    {

        #region Title Methods
        
        [WebMethod]
        public CustomGenericList<Title> TitleSelectAllPublished()
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.TitleSelectAllPublished();
        }

        [WebMethod]
        public Title TitleSelectByTitleID(int titleID)
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.TitleSelectAuto(titleID);
        }

        [WebMethod]
        public CustomGenericList<TitleBibTeX> TitleBibTeXSelectAllTitleCitations()
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.TitleBibTeXSelectAllTitleCitations();
        }

        [WebMethod]
        public CustomGenericList<TitleBibTeX> TitleBibTeXSelectAllItemCitations()
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.TitleBibTeXSelectAllItemCitations();
        }

        [WebMethod]
        public CustomGenericList<TitleEndNote> TitleEndNoteSelectAllTitleCitations()
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.TitleEndNoteSelectAllTitleCitations();
        }

        [WebMethod]
        public CustomGenericList<TitleEndNote> TitleEndNoteSelectAllItemCitations()
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.TitleEndNoteSelectAllItemCitations();
        }

        #endregion Title Methods

        #region Item Methods

        [WebMethod]
        public Item ItemSelectByBarCode(string barCode)
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.ItemSelectByBarCode(barCode);
        }

        [WebMethod]
        public CustomGenericList<Item> ItemSelectByTitleID(int titleID)
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.ItemSelectByTitleId(titleID);
        }

        [WebMethod]
        public Item ItemUpdateStatus(int itemID, int itemStatusID)
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.ItemUpdateStatus(itemID, itemStatusID);
        }

        [WebMethod]
        public Item ItemUpdatePaginationStatus(int itemID, int paginationStatusID, int userID)
        {
            BHLProvider provider = new BHLProvider();
            return provider.ItemUpdatePaginationStatus(itemID, paginationStatusID, userID);
        }

        [WebMethod]
        public Item ItemSelectAuto(int itemID)
        {
            BHLProvider provider = new BHLProvider();
            return provider.ItemSelectAuto(itemID);
        }

        [WebMethod]
        public CustomGenericList<Item> ItemSelectWithExpiredPageNames(int maxAge)
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.ItemSelectWithExpiredPageNames(maxAge);
        }

        [WebMethod]
        public CustomGenericList<Item> ItemSelectWithoutPageNames()
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.ItemSelectWithoutPageNames();
        }

        [WebMethod]
        public Item ItemUpdateLastPageNameLookupDate(int itemID)
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.ItemUpdateLastPageNameLookupDate(itemID);
        }

        [WebMethod]
        public bool ItemCheckForOcrText(int itemID, string ocrTextPath)
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.ItemCheckForOcrText(itemID, ocrTextPath);
        }

        #endregion Item Methods
        
        #region Vault Methods

        [WebMethod]
        public Vault VaultSelect(int vaultID)
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.VaultSelect(vaultID);
        }

        #endregion Vault Methods

        #region Institution Methods

        [WebMethod]
        public Institution InstitutionSelectAuto(String institutionCode)
        {
            BHLProvider bhlServer = new BHLProvider();
            return bhlServer.InstitutionSelectAuto(institutionCode);
        }

        #endregion

        #region Email Methods

        [WebMethod]
        public bool SendEmail(String from, String[] to, String[] cc, String[] bcc, String subject,
            String body)
        {
            System.Net.Mail.MailAddress fromAddress = new System.Net.Mail.MailAddress(from);
            System.Net.Mail.MailAddress[] toAddresses = new System.Net.Mail.MailAddress[to.Length];
            int x = 0;
            foreach (String toAddress in to)
            {
                toAddresses[x] = new System.Net.Mail.MailAddress(toAddress);
                x++;
            }
            System.Net.Mail.MailAddress[] ccAddresses = null;
            if (cc != null)
            {
                ccAddresses = new System.Net.Mail.MailAddress[cc.Length];
                x = 0;
                foreach (string ccAddress in cc)
                {
                    ccAddresses[x] = new System.Net.Mail.MailAddress(ccAddress);
                    x++;
                }
            }
            System.Net.Mail.MailAddress[] bccAddresses = null;
            if (bcc != null)
            {
                bccAddresses = new System.Net.Mail.MailAddress[bcc.Length];
                x = 0;
                foreach (string bccAddress in bcc)
                {
                    bccAddresses[x] = new System.Net.Mail.MailAddress(bccAddress);
                    x++;
                }
            }

            MOBOT.Utility.EmailSupport emailSupport = new EmailSupport(
                Config.ConfigurationManager.AppSettings["SMTPHost"]);
            return emailSupport.Send(toAddresses, fromAddress, subject, body, null, 
                bccAddresses, ccAddresses, System.Net.Mail.MailPriority.Normal, null);
        }

        #endregion Email Methods
    }
}
