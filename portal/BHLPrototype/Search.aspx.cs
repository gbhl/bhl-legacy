using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Web.Utilities;
using CustomDataAccess;

namespace MOBOT.BHL.Web
{
	public partial class Search : BasePage
	{
		protected void Page_Load( object sender, EventArgs e )
		{
			ControlGenerator.AddScriptControl( Page.Master.Page.Header.Controls, "/Scripts/ResizeBrowseUtils.js" );
			ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onload",
			"ResizeBrowseDivs();ResizeContentPanel('browseContentPanel', 258);" );
			ControlGenerator.AddAttributesAndPreserveExisting( main.Body, "onresize",
			"ResizeBrowseDivs();ResizeContentPanel('browseContentPanel', 258);" );

			string searchTerm = String.Empty;
            string searchLang = String.Empty;
            string titleMax = "0";
            string authorMax = "0";
            string nameMax = "0";
            string subjectMax = "0";

			if ( Request[ "SearchTerm" ] != null )
			{
				searchTerm = Request[ "SearchTerm" ].ToString();
                if (Request["lang"] != null) searchLang = Request["lang"].ToString();
                if (Request["tMax"] != null) titleMax = Request["tMax"].ToString();
                if (Request["aMax"] != null) authorMax = Request["aMax"].ToString();
                if (Request["nMax"] != null) nameMax = Request["nMax"].ToString();
                if (Request["sMax"] != null) subjectMax = Request["sMax"].ToString();
                Response.Cookies.Add(new HttpCookie("nameSearchLang", searchLang));
				searchResultsLabel.Text = searchTerm;
				PerformSearch( searchTerm, searchLang, titleMax, authorMax, nameMax, subjectMax );
			}
		}

		private void PerformSearch( string searchTerm, string searchLang, string titleMax, string authorMax, 
            string nameMax, string subjectMax )
		{
            string searchSecondary = Request["sec"] ?? "";
            string searchCat = Request["SearchCat"];
			if ( searchCat != null && searchCat.Length > 0 )
			{
				creatorPanel.Visible = searchCat.ToUpper().Contains( "A" );
				namesPanel.Visible = searchCat.ToUpper().Contains( "N" );
				titlesPanel.Visible = searchCat.ToUpper().Contains( "T" );
				subjectPanel.Visible = searchCat.ToUpper().Contains( "S" );
            }
			else
			{
				creatorPanel.Visible = true;
				namesPanel.Visible = true;
				titlesPanel.Visible = true;
				subjectPanel.Visible = true;
			}

            spanAuthorSummary.Visible = creatorPanel.Visible;
            spanNameSummary.Visible = namesPanel.Visible;
            spanSubjectSummary.Visible = subjectPanel.Visible;
            spanTitleSummary.Visible = titlesPanel.Visible;

            int maxExpandedResults = Convert.ToInt32(ConfigurationManager.AppSettings["MaximumExpandedResults"].ToString());
            int maxDefaultResults = Convert.ToInt32(ConfigurationManager.AppSettings["MaximumDefaultResults"].ToString());
            int titleReturnCount = (titleMax == "1" ? maxExpandedResults : maxDefaultResults);
            int creatorReturnCount = (authorMax == "1" ? maxExpandedResults : maxDefaultResults);
            int nameReturnCount = (nameMax == "1" ? maxExpandedResults : maxDefaultResults);
            int subjectReturnCount = (subjectMax == "1" ? maxExpandedResults : maxDefaultResults);

			if ( creatorPanel.Visible )
			{
                if (searchTerm != String.Empty)
                {
                    CustomGenericList<Creator> creators = bhlProvider.CreatorSelectByCreatorNameLike(searchTerm, searchLang, searchSecondary, creatorReturnCount);
                    if ((creators.Count == maxDefaultResults) && (authorMax == "0"))
                    {
                        lnkCreatorMore.NavigateUrl = String.Format("{0}?searchTerm={1}&searchCat={2}&lang={3}&tMax={4}&aMax=1&nMax={5}&sMax={6}&sec={7}", Request.Path, searchTerm, searchCat, searchLang, titleMax, nameMax, subjectMax, searchSecondary);
                        lnkCreatorMore.Visible = true;
                    }
                    if (creators.Count == maxExpandedResults) litCreatorRefine.Visible = true;
                    creatorRepeater.DataSource = creators;
                    creatorRepeater.DataBind();
                }
				txtAuthorsCount.Text = creatorRepeater.Items.Count.ToString();
                
			}
			if ( titlesPanel.Visible )
			{
                if (searchTerm != String.Empty)
                {
                    CustomGenericList<Title> titles = bhlProvider.TitleSelectSearchName(searchTerm, true, searchLang, searchSecondary, titleReturnCount);
                    if ((titles.Count == maxDefaultResults) && (titleMax == "0"))
                    {
                        lnkTitleMore.NavigateUrl = String.Format("{0}?searchTerm={1}&searchCat={2}&lang={3}&tMax=1&aMax={4}&nMax={5}&sMax={6}&sec={7}", Request.Path, searchTerm, searchCat, searchLang, authorMax, nameMax, subjectMax, searchSecondary);
                        lnkTitleMore.Visible = true;
                    }
                    if (titles.Count == maxExpandedResults) litTitleRefine.Visible = true;
                    titlesRepeater.DataSource = titles;
                    titlesRepeater.DataBind();
                }
				titleOnlineCountLiteral.Text = titlesRepeater.Items.Count.ToString();
			}
			if ( namesPanel.Visible )
			{
                // We don't include the "searchSecondary" parameter here, because searching 
                // primary vs secondary titles for page names makes no difference (page names 
                // are tied to items; the title relationship is irrelevant)
                if (searchTerm != String.Empty)
                {
                    CustomGenericList<PageName> pagenames = bhlProvider.PageNameSelectByNameLike(searchTerm, searchLang, nameReturnCount);
                    if ((pagenames.Count == maxDefaultResults) && (nameMax == "0"))
                    {
                        lnkNameMore.NavigateUrl = String.Format("{0}?searchTerm={1}&searchCat={2}&lang={3}&tMax={4}&aMax={5}&nMax=1&sMax={6}&sec={7}", Request.Path, searchTerm, searchCat, searchLang, titleMax, authorMax, subjectMax, searchSecondary);
                        lnkNameMore.Visible = true;
                    }
                    if (pagenames.Count == maxExpandedResults) litNameRefine.Visible = true;
                    nameRepeater.DataSource = pagenames;
                    nameRepeater.DataBind();
                }
				txtNamesCount.Text = nameRepeater.Items.Count.ToString();
			}
			if ( subjectPanel.Visible )
			{
                if (searchTerm != String.Empty)
                {
                    CustomGenericList<TitleTag> titleTags = bhlProvider.TitleTagSelectLikeTag(searchTerm, searchLang, searchSecondary, titleReturnCount);
                    if ((titleTags.Count == maxDefaultResults) && (subjectMax == "0"))
                    {
                        lnkSubjectMore.NavigateUrl = String.Format("{0}?searchTerm={1}&searchCat={2}&lang={3}&tMax={4}&aMax={5}&nMax={6}&sMax=1&sec={7}", Request.Path, searchTerm, searchCat, searchLang, titleMax, authorMax, nameMax, searchSecondary);
                        lnkSubjectMore.Visible = true;
                    }
                    if (titleTags.Count == maxExpandedResults) litSubjectRefine.Visible = true;
                    foreach (TitleTag titleTag in titleTags)
                    {
                        titleTag.MarcDataFieldTag = titleTag.TagText.Replace(' ', '+');
                    }
                    subjectRepeater.DataSource = titleTags;
                    subjectRepeater.DataBind();
                }
				txtSubjectCount.Text = subjectRepeater.Items.Count.ToString();
			}
		}

	}
}
