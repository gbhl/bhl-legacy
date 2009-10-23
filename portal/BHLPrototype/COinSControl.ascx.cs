using System;
using System.Collections;
using System.Configuration;
using System.Data;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.HtmlControls;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using MOBOT.BHL.Web.Utilities;
using MOBOT.BHL.Server;
using Data = MOBOT.BHL.DataObjects;
using CustomDataAccess;

namespace MOBOT.BHL.Web
{
    public partial class COinSControl : System.Web.UI.UserControl
    {
        private int _titleID = 0;

        public int TitleID
        {
            get { return _titleID; }
            set { _titleID = value; }
        }
        private int _itemID = 0;

        public int ItemID
        {
            get { return _itemID; }
            set { _itemID = value; }
        }

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // NOTE:  This section could benefit from refactoring.

                BHLProvider provider = new BHLProvider();
                Data.ItemCOinSView coins = null;

                // Get the data
                if (this.TitleID != 0) coins = provider.ItemCOinSSelectByTitleId(this.TitleID);
                else if (this.ItemID != 0) coins = provider.ItemCOinSSelectByItemId(this.ItemID);

                if (coins != null)
                {
                    // Build the COinS
                    StringBuilder output = new StringBuilder();
                    output.Append("ctx_ver=Z39.88-2004");

                    // Add identifiers
                    if (coins.Oclc != String.Empty) output.Append("&amp;rft_id=" + Server.UrlEncode("info:oclcnum/" + coins.Oclc));
                    if (coins.Rft_issn != String.Empty) output.Append("&amp;rft_id=" + Server.UrlEncode("urn:ISSN:" + coins.Rft_issn));
                    if (coins.Rft_isbn != String.Empty) output.Append("&amp;rft_id=" + Server.UrlEncode("urn:ISBN:" + coins.Rft_isbn));
                    if (coins.Lccn != String.Empty) output.Append("&amp;rft_id=" + Server.UrlEncode("info:lccn/" + coins.Lccn));
                    if (this.TitleID != 0) output.Append("&amp;rft_id=" + Server.UrlEncode("http://www.biodiversitylibrary.org/bibliography/" + this.TitleID.ToString()));
                    if (this.ItemID != 0) output.Append("&amp;rft_id=" + Server.UrlEncode("http://www.biodiversitylibrary.org/item/" + this.ItemID.ToString()));

                    // Add format-specific attributes
                    switch(coins.Rft_genre)
                    {
                        case "book":    // book
                            output.Append("&amp;rft_val_fmt=" + Server.UrlEncode("info:ofi/fmt:kev:mtx:book"));
                            output.Append("&amp;rft.genre=book");
                            if (coins.Rft_title != String.Empty) output.Append("&amp;rft.btitle=" + Server.UrlEncode(coins.Rft_title));
                            if (coins.Rft_place != String.Empty) output.Append("&amp;rft.place=" + Server.UrlEncode(coins.Rft_place));
                            if (coins.Rft_pub != String.Empty) output.Append("&amp;rft.pub=" + Server.UrlEncode(coins.Rft_pub));
                            if (coins.Rft_edition != String.Empty) output.Append("&amp;rft.edition=" + Server.UrlEncode(coins.Rft_edition));

                            if (coins.Rft_issn != String.Empty) output.Append("&amp;rft.issn=" + Server.UrlEncode(coins.Rft_issn));
                            if (coins.Rft_isbn != String.Empty) output.Append("&amp;rft.isbn=" + Server.UrlEncode(coins.Rft_isbn));
                            if (coins.Rft_aufirst != String.Empty) output.Append("&amp;rft.aufirst=" + Server.UrlEncode(coins.Rft_aufirst));
                            if (coins.Rft_aulast != String.Empty) output.Append("&amp;rft.aulast=" + Server.UrlEncode(coins.Rft_aulast));
                            if (coins.Rft_aucorp != String.Empty) output.Append("&amp;rft.aucorp=" + Server.UrlEncode(coins.Rft_aucorp));
                            if (coins.Rft_au_BOOK != String.Empty)
                            {
                                String[] authors = coins.Rft_au_BOOK.Split('|');
                                foreach (String author in authors)
                                {
                                    if (author != String.Empty) output.Append("&amp;rft.au=" + Server.UrlEncode(author));
                                }
                            }
                            if ((coins.Rft_tpages ?? 0) != 0)
                            {
                                output.Append("&amp;rft.pages=1-" + coins.Rft_tpages.ToString());
                                output.Append("&amp;rft.tpages=" + coins.Rft_tpages.ToString());
                            }

                            break;
                        case "journal":   // journal
                            output.Append("&amp;rft_val_fmt=" + Server.UrlEncode("info:ofi/fmt:kev:mtx:journal"));
                            output.Append("&amp;rft.genre=journal");
                            if (coins.Rft_title != String.Empty) output.Append("&amp;rft.jtitle=" + Server.UrlEncode(coins.Rft_title));
                            if (coins.Rft_stitle != String.Empty) output.Append("&amp;rft.stitle=" + Server.UrlEncode(coins.Rft_stitle));
                            if (coins.Rft_volume != String.Empty && this.ItemID != 0) output.Append("&amp;rft.volume=" + Server.UrlEncode(coins.Rft_volume));
                            if (coins.Rft_coden != String.Empty) output.Append("&amp;rft.coden=" + Server.UrlEncode(coins.Rft_coden));

                            if (coins.Rft_issn != String.Empty) output.Append("&amp;rft.issn=" + Server.UrlEncode(coins.Rft_issn));
                            if (coins.Rft_isbn != String.Empty) output.Append("&amp;rft.isbn=" + Server.UrlEncode(coins.Rft_isbn));
                            if (coins.Rft_aufirst != String.Empty) output.Append("&amp;rft.aufirst=" + Server.UrlEncode(coins.Rft_aufirst));
                            if (coins.Rft_aulast != String.Empty) output.Append("&amp;rft.aulast=" + Server.UrlEncode(coins.Rft_aulast));
                            if (coins.Rft_aucorp != String.Empty) output.Append("&amp;rft.aucorp=" + Server.UrlEncode(coins.Rft_aucorp));
                            if (coins.Rft_au_BOOK != String.Empty)
                            {
                                String[] authors = coins.Rft_au_BOOK.Split('|');
                                foreach (String author in authors)
                                {
                                    if (author != String.Empty) output.Append("&amp;rft.au=" + Server.UrlEncode(author));
                                }
                            }

                            // rft.pages does not apply to journals
                            //if ((coins.Rft_tpages ?? 0) != 0) output.Append("&amp;rft.pages=" + coins.Rft_tpages.ToString());

                            break;
                        default:    // dublin core
                            output.Append("&amp;rft_val_fmt=" + Server.UrlEncode("info:ofi/fmt:kev:mtx:dc"));
                            output.Append("&amp;rft.source=" + Server.UrlEncode("Biodiversity Heritage Library"));
                            output.Append("&amp;rft.rights=" + Server.UrlEncode("Creative Commons Attribution 3.0"));
                            if (this.TitleID != 0) output.Append("&amp;rtf.identifier=" + Server.UrlEncode("http://www.biodiversitylibrary.org/bibliography/" + this.TitleID.ToString()));
                            if (this.ItemID != 0) output.Append("&amp;rft.identifier=" + Server.UrlEncode("http://www.biodiversitylibrary.org/item/" + this.ItemID.ToString()));
                            if (coins.Rft_title != String.Empty) output.Append("&amp;rft.title=" + Server.UrlEncode(coins.Rft_title));
                            if (coins.Rft_language != String.Empty) output.Append("&amp;rft.language=" + Server.UrlEncode(coins.Rft_language));
                            if (coins.Rft_au_DC != String.Empty)
                            {
                                String[] authors = coins.Rft_au_DC.Split('|');
                                foreach (String author in authors)
                                {
                                    if (author != String.Empty) output.Append("&amp;rft.creator=" + Server.UrlEncode(author));
                                }
                            }
                            if (coins.Rft_publisher != String.Empty) output.Append("&amp;rft.publisher=" + Server.UrlEncode(coins.Rft_publisher));
                            if (this.TitleID != 0)
                            {
                                if (coins.Rft_contributor_TITLE != String.Empty) output.Append("&amp;rft.contributor=" + Server.UrlEncode(coins.Rft_contributor_TITLE));
                            }
                            else if (this.ItemID != 0)
                            {
                                if (coins.Rft_contributor_ITEM != String.Empty) output.Append("&amp;rft.contributor=" + Server.UrlEncode(coins.Rft_contributor_ITEM));
                            }

                            if (coins.Rft_subject != String.Empty)
                            {
                                String[] subjects = coins.Rft_subject.Split('|');
                                foreach (String subject in subjects)
                                {
                                    if (subject != String.Empty) output.Append("&amp;rft.subject=" + Server.UrlEncode(subject));
                                }
                            }

                            break;
                    }

                    // Add additional elements common to all formats
                    if (this.TitleID != 0)
                    {
                        if (coins.Rft_date_TITLE != String.Empty) output.Append("&amp;rft.date=" + Server.UrlEncode(coins.Rft_date_TITLE.ToString()));
                    }
                    else if (this.ItemID != 0)
                    {
                        if (coins.Rft_date_ITEM != String.Empty) output.Append("&amp;rft.date=" + Server.UrlEncode(coins.Rft_date_ITEM.ToString()));
                    }

                    // Render the COinS to the control
                    this.Controls.Add(new LiteralControl("<span class=\"Z3988\" title=\"" + 
                                                        output.ToString() +
                                                        "\"></span>"));
                }
            }
        }
    }
}