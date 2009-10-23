using System;
using System.Collections.Generic;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.Server;
using CustomDataAccess;

namespace MOBOT.BHL.Web.Admin
{
    public partial class ReportCharacterEncodingProblems : System.Web.UI.Page
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                BHLProvider bp = new BHLProvider();

                CustomGenericList<Institution> institutions = bp.InstituationSelectAll();

                Institution emptyInstitution = new Institution();
                emptyInstitution.InstitutionName = "(select institution)";
                emptyInstitution.InstitutionCode = "";
                institutions.Insert(0, emptyInstitution);
                listInstitutions.DataSource = institutions;
                listInstitutions.DataBind();
            }
            else
            {
                spanTitle.Visible = chkTitle.Checked;
                spanSubject.Visible = chkSubject.Checked;
                spanAssociation.Visible = chkAssociation.Checked;
                spanCreator.Visible = chkCreator.Checked;
                spanItem.Visible = chkItem.Checked;
            }

            Page.SetFocus(listInstitutions);
            Page.Title = "BHL Admin - Character Encoding Problems";
        }

        protected void buttonShow_Click(object sender, EventArgs e)
        {
            string institutionCode = listInstitutions.SelectedValue;
            int maxAge = Convert.ToInt32(listAddedSince.SelectedValue);

            BHLProvider bp = new BHLProvider();

            // Load gridviews with data
            if (chkTitle.Checked)
            {
                CustomGenericList<TitleSuspectCharacter> titles = bp.TitleSelectWithSuspectCharacters(institutionCode, maxAge);
                gvwTitles.DataSource = titles;
                gvwTitles.DataBind();
                litNoTitles.Visible = (titles.Count == 0) ? true : false;
                divTitle.Visible = !litNoTitles.Visible;
            }
            else
            {
                litNoTitles.Visible = false;
                divTitle.Visible = false;
            }

            if (chkSubject.Checked)
            {
                CustomGenericList<TitleTagSuspectCharacter> titleTags = bp.TitleTagSelectWithSuspectCharacters(institutionCode, maxAge);
                gvwTitleTags.DataSource = titleTags;
                gvwTitleTags.DataBind();
                litNoTitleTags.Visible = (titleTags.Count == 0) ? true : false;
                divTitleTag.Visible = !litNoTitleTags.Visible;
            }
            else
            {
                litNoTitleTags.Visible = false;
                divTitleTag.Visible = false;
            }

            if (chkAssociation.Checked)
            {
                CustomGenericList<TitleAssociationSuspectCharacter> titleAssociations = bp.TitleAssociationSelectWithSuspectCharacters(institutionCode, maxAge);
                gvwAssociations.DataSource = titleAssociations;
                gvwAssociations.DataBind();
                litNoAssociations.Visible = (titleAssociations.Count == 0) ? true : false;
                divAssociation.Visible = !litNoAssociations.Visible;
            }
            else
            {
                litNoAssociations.Visible = false;
                divAssociation.Visible = false;
            }

            if (chkCreator.Checked)
            {
                CustomGenericList<CreatorSuspectCharacter> creators = bp.CreatorSelectWithSuspectCharacters(institutionCode, maxAge);
                gvwCreators.DataSource = creators;
                gvwCreators.DataBind();
                litNoCreators.Visible = (creators.Count == 0) ? true : false;
                divCreator.Visible = !litNoCreators.Visible;
            }
            else
            {
                litNoCreators.Visible = false;
                divCreator.Visible = false;
            }

            if (chkItem.Checked)
            {
                CustomGenericList<ItemSuspectCharacter> items = bp.ItemSelectWithSuspectCharacters(institutionCode, maxAge);
                gvwItems.DataSource = items;
                gvwItems.DataBind();
                litNoItems.Visible = (items.Count == 0) ? true : false;
                divItem.Visible = !litNoItems.Visible;
            }
            else
            {
                litNoItems.Visible = false;
                divItem.Visible = false;
            }
        }
    }
}
