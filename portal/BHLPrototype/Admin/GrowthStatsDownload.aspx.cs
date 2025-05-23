﻿using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MOBOT.BHL.Server;
using MOBOT.BHL.DataObjects;
using CustomDataAccess;

namespace MOBOT.BHL.Web.Admin
{
    public partial class GrowthStatsDownload : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            String institutionName = Request.QueryString["i"] as String;
            if (institutionName == null) institutionName = "";

            Response.Clear();
            Response.AppendHeader("Content-Type", "application/vnd.ms-excel");
            Response.AppendHeader("Content-Disposition", "attachment; filename=BHLGrowthStats.xls");

            CustomGenericList<MonthlyStats> titleStats = new CustomGenericList<MonthlyStats>();
            CustomGenericList<MonthlyStats> itemStats = new CustomGenericList<MonthlyStats>();
            CustomGenericList<MonthlyStats> pageStats = new CustomGenericList<MonthlyStats>();
            CustomGenericList<MonthlyStats> nameStats = new CustomGenericList<MonthlyStats>();

            BHLProvider provider = new BHLProvider();
            CustomGenericList<MonthlyStats> stats = provider.MonthlyStatsSelectByDateAndInstitution(2000, 1, 2099, 12, institutionName);
            foreach(MonthlyStats stat in stats)
            {
                switch (stat.StatType)
                {
                    case "Titles Created":
                        titleStats.Add(stat);
                        break;
                    case "Items Created":
                        itemStats.Add(stat);
                        break;
                    case "Pages Created":
                        pageStats.Add(stat);
                        break;
                    case "PageNames Created":
                        nameStats.Add(stat);
                        break;
                }
            }

            litInstitution.Text = institutionName;
            gvTitles.DataSource = titleStats;
            gvItems.DataSource = itemStats;
            gvPages.DataSource = pageStats;
            gvNames.DataSource = nameStats;
            gvTitles.DataBind();
            gvItems.DataBind();
            gvPages.DataBind();
            gvNames.DataBind();
        }
    }
}
