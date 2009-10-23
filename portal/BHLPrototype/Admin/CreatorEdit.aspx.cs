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
using MOBOT.BHL.Server;
using CustomDataAccess;
using MOBOT.Utility;
using FredCK.FCKeditorV2;

namespace MOBOT.BHL.Web.Admin
{
	public partial class CreatorEdit : System.Web.UI.Page
	{
		protected void Page_Load( object sender, EventArgs e )
		{
			if ( !IsPostBack )
			{
				bioTextBox.ToolbarSet = "BHL";

				BHLProvider bp = new BHLProvider();
				CustomGenericList<Creator> creators = bp.CreatorSelectAll();

				Creator emptyCreator = new Creator();
				emptyCreator.CreatorID = -1;
				emptyCreator.CreatorName = "";
				creators.Insert( 0, emptyCreator );

				ddlAuthors.DataSource = creators;
				ddlAuthors.DataTextField = "CreatorName";
				ddlAuthors.DataValueField = "CreatorId";
				ddlAuthors.DataBind();

                string idString = Request.QueryString["id"];
                int id = 0;
                if (idString != null && int.TryParse(idString, out id))
                {
                    ddlAuthors.SelectedValue = idString;
                    populateForm();
                }
			}
			errorControl.Visible = false;
		}

		private void clearForm( ControlCollection controls )
		{
			foreach ( Control c in controls )
			{
				if ( c is TextBox && !c.ID.Equals( "idTextBox" ) )
				{
					TextBox textBox = (TextBox)c;
					textBox.Text = "";
				}
				else if ( c.HasControls() )
				{
					clearForm( c.Controls );
				}
				else if ( c is FCKeditor )
				{
					FCKeditor fck = (FCKeditor)c;
					fck.Value = "";
				}
			}
		}

		private bool validate()
		{
			bool flag = false;
			if ( creatorNameTextBox.Text.Trim().Length == 0 )
			{
				flag = true;
				errorControl.AddErrorText( "Creator name is missing" );
			}

			errorControl.Visible = flag;

			return !flag;
		}

        private void populateForm()
        {
            bool flag = false;
            clearForm(this.Controls);
            int creatorId = int.Parse(ddlAuthors.SelectedValue);
            if (creatorId > 0)
            {
                BHLProvider bp = new BHLProvider();
                Creator c = bp.CreatorSelectAuto(creatorId);
                if (c != null)
                {
                    idTextBox.Text = c.CreatorID.ToString();
                    creatorNameTextBox.Text = c.CreatorName;
                    firstNameFirstTextBox.Text = TypeHelper.EmptyIfNull(c.FirstNameFirst);
                    simpleNameTextBox.Text = TypeHelper.EmptyIfNull(c.SimpleName);
                    dobTextBox.Text = TypeHelper.EmptyIfNull(c.DOB);
                    dodTextBox.Text = TypeHelper.EmptyIfNull(c.DOD);
                    bioTextBox.Value = TypeHelper.EmptyIfNull(c.Biography);
                    creatorNoteTextBox.Text = TypeHelper.EmptyIfNull(c.CreatorNote);
                    marcDataFieldTagTextBox.Text = TypeHelper.EmptyIfNull(c.MARCDataFieldTag);
                    marcCreatorATextBox.Text = TypeHelper.EmptyIfNull(c.MARCCreator_a);
                    marcCreatorBTextBox.Text = TypeHelper.EmptyIfNull(c.MARCCreator_b);
                    marcCreatorCTextBox.Text = TypeHelper.EmptyIfNull(c.MARCCreator_c);
                    marcCreatorDTextBox.Text = TypeHelper.EmptyIfNull(c.MARCCreator_d);
                    marcCreatorFullTextBox.Text = TypeHelper.EmptyIfNull(c.MARCCreator_Full);

                    ddlAuthors.SelectedValue = c.CreatorID.ToString();
                    flag = true;
                }
            }

            titlesButton.Text = "Show Titles";
            titlePanel.Visible = false;
            titlesButton.Enabled = flag;
        }

		#region Event handlers

		protected void saveButton_Click( object sender, EventArgs e )
		{
			if ( validate() )
			{
				if ( idTextBox.Text.Trim().Length == 0 )
				{
					errorControl.AddErrorText( "Please select a creator before saving" );
					errorControl.Visible = true;
					return;
				}

				Creator creator = new Creator( int.Parse( idTextBox.Text ), creatorNameTextBox.Text.Trim(),
					firstNameFirstTextBox.Text.Trim(), simpleNameTextBox.Text.Trim(), dobTextBox.Text.Trim(), dodTextBox.Text.Trim(),
					bioTextBox.Value, creatorNoteTextBox.Text.Trim(),
					marcDataFieldTagTextBox.Text.Trim(), marcCreatorATextBox.Text.Trim(), marcCreatorBTextBox.Text.Trim(),
					marcCreatorCTextBox.Text.Trim(), marcCreatorDTextBox.Text.Trim(), marcCreatorFullTextBox.Text.Trim() );

				creator.IsNew = false;

				BHLProvider bp = new BHLProvider();
				bp.SaveCreator( creator );
			}
			else
			{
				return;
			}

			Response.Redirect( "/Admin/Dashboard.aspx" );
		}

		protected void saveAsNewButton_Click( object sender, EventArgs e )
		{
			if ( validate() )
			{
				Creator creator = new Creator( 0, creatorNameTextBox.Text.Trim(),
					firstNameFirstTextBox.Text.Trim(), simpleNameTextBox.Text.Trim(), dobTextBox.Text.Trim(), dodTextBox.Text.Trim(),
					bioTextBox.Value, creatorNoteTextBox.Text.Trim(),
					marcDataFieldTagTextBox.Text.Trim(), marcCreatorATextBox.Text.Trim(), marcCreatorBTextBox.Text.Trim(),
					marcCreatorCTextBox.Text.Trim(), marcCreatorDTextBox.Text.Trim(), marcCreatorFullTextBox.Text.Trim() );

				creator.IsNew = true;

				BHLProvider bp = new BHLProvider();
				bp.SaveCreator( creator );
			}
			else
			{
				return;
			}

			Response.Redirect( "/Admin/Dashboard.aspx" );
		}

		protected void clearButton_Click( object sender, EventArgs e )
		{
			clearForm( this.Controls );
		}

		protected void ddlAuthors_SelectedIndexChanged( object sender, EventArgs e )
		{
            populateForm();
		}

        protected void titlesButton_Click(object sender, EventArgs e)
        {
            if (titlesButton.Text.Equals("Show Titles"))
            {
                int creatorId = int.Parse(ddlAuthors.SelectedValue);
                // search titles
                BHLProvider bp = new BHLProvider();
                CustomGenericList<CreatorTitle> cdr = bp.TitleSimpleSelectByCreator(creatorId);

                gvwResults.DataSource = cdr;
                gvwResults.DataBind();

                titlePanel.Visible = true;
                titlesButton.Text = "Hide Titles";
            }
            else
            {
                titlePanel.Visible = false;
                titlesButton.Text = "Show Titles";
            }
        }

        #endregion
	}
}
