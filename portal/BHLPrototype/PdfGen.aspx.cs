using System;
using System.Collections;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Text;
using System.Net.Mail;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CustomDataAccess;
using Data = MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using MOBOT.BHL.Web.Utilities;

namespace MOBOT.BHL.Web
{
    public partial class PdfGen : BasePage
    {
        private String _errMsg = String.Empty;

        protected void Page_Load(object sender, EventArgs e)
        {
            main.SetPageType(Main.PageType.Content);
            ControlGenerator.AddScriptControl(Page.Master.Page.Header.Controls, "/Scripts/ResizeBrowseUtils.js");
            ControlGenerator.AddScriptControl(Page.Master.Page.Header.Controls, "/Scripts/jquery-1.4.2.min.js");
            ControlGenerator.AddAttributesAndPreserveExisting(main.Body, "onload",
                "ResizeContentPanel('browseContentPanel', 258);ResizeBrowseDivs();");
            ControlGenerator.AddAttributesAndPreserveExisting(main.Body, "onresize",
                "ResizeContentPanel('browseContentPanel', 258);ResizeBrowseDivs();");

            if (!IsPostBack)
            {
                // Retrieve the pages for the item
                String itemIDString = Request.QueryString["ItemID"] as String;
                int itemID;
                if (itemIDString != null)
                {
                    if (Int32.TryParse(itemIDString, out itemID))
                    {
                        BHLProvider provider = new BHLProvider();

                        // If this is a Botanicus item, make sure the PDF actually exists.
                        // Remove the DownloadUrl if it does not.
                        Data.Item item = provider.ItemSelectByBarcodeOrItemID(itemID, null);
                        if (!String.IsNullOrEmpty(item.DownloadUrl) && item.ItemSourceID == 2)
                        {
                            // This is kludgy... should find a better way to do this
                            String pdfLocation = item.DownloadUrl.Replace("http://www.botanicus.org/", "\\\\server\\").Replace('/', '\\');
                            if (provider.GetFileAccessProvider(ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true").FileExists(pdfLocation))
                                item.DownloadUrl = ConfigurationManager.AppSettings["PdfAuthUrl"] != null ? String.Format(ConfigurationManager.AppSettings["PdfAuthUrl"], item.BarCode) : String.Empty;
                            else
                                item.DownloadUrl = String.Empty;
                        }

                        if (String.IsNullOrEmpty(item.DownloadUrl))
                        {
                        	litDownloadLink.Text = ConfigurationManager.AppSettings["PdfGenDownloadNone"].ToString();
                        }
                        else if (item.ItemSourceID == 1)
                        {
                            litDownloadLink.Text = String.Format(ConfigurationManager.AppSettings["PdfGenDownloadIA"], item.BarCode, item.BarCode);
                        }
                        else
                        {
                            litDownloadLink.Text = String.Format(ConfigurationManager.AppSettings["PdfGenDownloadBotanicus"], item.DownloadUrl);
                        }

                        // Get the page information for this item
                        CustomGenericList<Data.Page> pages = provider.PageMetadataSelectByItemID(itemID);

                        dlPages.DataSource = pages;
                        dlPages.DataBind();
                    }
                }
            }
        }

        protected override void Render(HtmlTextWriter writer)
        {
            base.Render(new UrlRewriterFormWriter(writer));
        }

        protected void btnDone_Click(object sender, EventArgs e)
        {
            // Get the item to which this PDF is related
            int itemID;
            String itemIDString = Request.QueryString["ItemID"] as String;
            List<int> pageIDs = new List<int>();

            // Get the page numbers being requested
            foreach (DataListItem dlItem in dlPages.Items)
            {
                HtmlInputCheckBox pageCheckbox = (HtmlInputCheckBox)dlItem.FindControl("chkPage");
                if (pageCheckbox.Checked) pageIDs.Add(Int32.Parse(pageCheckbox.Value));
            }

            String shareWith = txtShareWith.Text;
            String articleTitle = txtArticleTitle.Text;
            String articleCreators = txtAuthors.Text;
            String articleTags = txtSubjects.Text;
            String emailAddress = txtEmail.Text;
            bool imagesOnly = rdoImages.Checked;

            if (shareWith.StartsWith("Enter email addresses")) shareWith = String.Empty;
            if (articleCreators.StartsWith("Enter names")) articleCreators = String.Empty;
            if (articleTags.StartsWith("Enter subjects")) articleTags = String.Empty;

            // Validate submitted data
            if (this.ValidatePage(itemIDString, pageIDs, emailAddress, shareWith, out itemID))
            {
                litError.Text = this._errMsg;

                // Save submitted data
                BHLProvider provider = new BHLProvider();
                MOBOT.BHL.DataObjects.PDF pdf = provider.AddNewPdf(itemID, emailAddress, shareWith, 
                    imagesOnly, articleTitle, articleCreators, articleTags, pageIDs);

                this.SendEmail(emailAddress, pdf.PdfID);

                Response.Cookies["pdf"]["id"] = pdf.PdfID.ToString();
                Response.Cookies["pdf"].Expires = DateTime.Now.AddDays(1);
                Response.Redirect("/PdfGenDone.aspx");
            }
            else
            {
                // Return and give error message to user
                litError.Text = this._errMsg;
            }
        }

        private bool ValidatePage(String itemIDString, List<int> pageIDs, String emailAddress,
            String shareWith, out int itemID)
        {
            bool valid = true;

            this._errMsg = String.Empty;

            if (!Int32.TryParse(itemIDString, out itemID))
            {
                valid = false;
                this._errMsg += "<br/>No valid item identifier.";
            }

            if (pageIDs.Count == 0)
            {
                valid = false;
                this._errMsg += "<br/>Please specify a range of pages images or select individual page images.";
            }

            if (emailAddress == String.Empty)
            {
                valid = false;
                this._errMsg += "<br/>Please enter an email address.";
            }
            else
            {
                RegexStringValidator validator = new RegexStringValidator("\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*");
                try
                {
                    validator.Validate(emailAddress);
                }
                catch
                {
                    valid = false;
                    this._errMsg += "<br/>Please enter a valid email address.";
                }
            }

            if (shareWith != String.Empty)
            {
                String[] shareWithAddresses = shareWith.Split(',');

                foreach (String shareWithAddress in shareWithAddresses)
                {
                    RegexStringValidator validator = new RegexStringValidator("\\w+([-+.']\\w+)*@\\w+([-.]\\w+)*\\.\\w+([-.]\\w+)*");
                    try
                    {
                        validator.Validate(shareWithAddress.Trim());
                    }
                    catch
                    {
                        valid = false;
                        this._errMsg += "<br/>Make sure that all email addresses are valid.";
                        break;
                    }
                }
            }

            return valid;
        }

        private string GetEmailBody(int pdfId)
        {
            StringBuilder sb = new StringBuilder();
            const string endOfLine = "\r\n";

            sb.Append("Your PDF generation request has been received and will be processed shortly.");
            sb.Append(endOfLine);
            sb.Append(endOfLine);
            sb.Append("When the PDF has been created, a message will be sent to this address and to any email addresses that you chose to share this PDF with. ");
            sb.Append("That message will contain a link to download your PDF.");
            sb.Append(endOfLine);
            sb.Append(endOfLine);
            sb.Append("If you have questions or need to report a problem, please contact us via our Feedback page: http://www.biodiversitylibrary.org/feedback");
            sb.Append(endOfLine);
            sb.Append(endOfLine);
            sb.Append("Thank you for your interest.");

            return sb.ToString();
        }

        private void SendEmail(String recipient, int pdfId)
        {
            try
            {
                String[] recipients = new String[1];
                recipients[0] = recipient;
                BHLWebService.BHLWS service = new MOBOT.BHL.Web.BHLWebService.BHLWS();
                service.SendEmail("noreply@biodiversitylibrary.org", recipients, null, null,
                    "BHL PDF Generation request #" + pdfId.ToString(), GetEmailBody(pdfId));

            }
            catch (Exception ex)
            {
                // What to do if email fails?
            }
        }

    }
}
