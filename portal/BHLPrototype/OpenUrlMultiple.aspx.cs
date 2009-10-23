using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MOBOT.BHL.Server;
using MOBOT.BHL.DataObjects;


namespace MOBOT.BHL.Web
{
    public partial class OpenUrlMultiple : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BHLProvider provider = new BHLProvider();

                // Show the citations that were found
                int id;
                string idList = Request.QueryString["id"] as String;

                if (idList != null)
                {
                    string[] idStrings = idList.Split('|');
                    foreach (string idString in idStrings)
                    {
                        if (idString.Length > 1)
                        {
                            if (idString.Substring(0, 1) == "p")
                            {
                                if (Int32.TryParse(idString.Substring(1), out id))
                                {
                                    DataObjects.Page page = provider.PageMetadataSelectByPageID(id);
                                    this.AddPageToTable(page);
                                }
                            }
                            else if (idString.Substring(0, 1) == "i")
                            {
                                if (Int32.TryParse(idString.Substring(1), out id))
                                {
                                    DataObjects.PageSummaryView psv = provider.PageSummarySelectByItemId(id);
                                    this.AddItemToTable(psv);
                                }
                            }
                            else if (idString.Substring(0, 1) == "t")
                            {
                                if (Int32.TryParse(idString.Substring(1), out id))
                                {
                                    DataObjects.Title title = provider.TitleSelect(id);
                                    this.AddTitleToTable(title);
                                }
                            }
                        }
                    }
                }
            }
        }

        private void AddPageToTable(DataObjects.Page page)
        {
            System.Web.UI.HtmlControls.HtmlTableRow row = new System.Web.UI.HtmlControls.HtmlTableRow();

            System.Web.UI.HtmlControls.HtmlTableCell cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            cell.InnerHtml = "<a href='/page/" + page.PageID.ToString() + "'>" + page.ShortTitle + "</a>";
            row.Cells.Add(cell);
            cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            cell.InnerText = page.Volume;
            row.Cells.Add(cell);
            cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            cell.InnerText = page.Issue;
            row.Cells.Add(cell);
            cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            cell.InnerText = page.Year;
            row.Cells.Add(cell);
            cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            cell.InnerText = page.IndicatedPages;
            row.Cells.Add(cell);

            tblPages.Rows.Add(row);
        }

        private void AddItemToTable(DataObjects.PageSummaryView psv)
        {
            System.Web.UI.HtmlControls.HtmlTableRow row = new System.Web.UI.HtmlControls.HtmlTableRow();

            System.Web.UI.HtmlControls.HtmlTableCell cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            cell.InnerHtml = "<a href='/item/" + psv.ItemID.ToString() + "'>" + psv.ShortTitle + "</a>";
            row.Cells.Add(cell);
            cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            cell.InnerText = psv.Volume;
            row.Cells.Add(cell);
            cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            row.Cells.Add(cell);
            cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            row.Cells.Add(cell);
            cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            row.Cells.Add(cell);

            tblPages.Rows.Add(row);
        }

        private void AddTitleToTable(DataObjects.Title title)
        {
            System.Web.UI.HtmlControls.HtmlTableRow row = new System.Web.UI.HtmlControls.HtmlTableRow();

            System.Web.UI.HtmlControls.HtmlTableCell cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            cell.InnerHtml = "<a href='/bibliography/" + title.TitleID.ToString() + "'>" + title.ShortTitle + "</a>";
            row.Cells.Add(cell);
            cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            row.Cells.Add(cell);
            cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            row.Cells.Add(cell);
            cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            row.Cells.Add(cell);
            cell = new System.Web.UI.HtmlControls.HtmlTableCell();
            row.Cells.Add(cell);

            tblPages.Rows.Add(row);
        }
    }
}
