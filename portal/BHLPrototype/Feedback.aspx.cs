using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Text;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using CounterSoft.Gemini.Commons;

namespace MOBOT.BHL.Web
{
	public partial class Feedback : System.Web.UI.Page
	{
		protected void Page_Load( object sender, EventArgs e )
		{
			if ( !IsPostBack )
			{
                if (Page.PreviousPage != null)
                {
                    string previousPageName = Page.PreviousPage.AppRelativeVirtualPath.ToLower();
                    if (previousPageName.Contains("bibliography"))
                    {
                        HiddenField titleIDField = (HiddenField)this.myFindControl(Page.PreviousPage.Controls, "hidTitleID");
                        if (titleIDField.Value != string.Empty) ViewState["TitleID"] = titleIDField.Value;
                    }
                    else if (previousPageName.Contains("titlepage"))
                    {
                        HiddenField pageIDField = (HiddenField)this.myFindControl(Page.PreviousPage.Controls, "hidPageID");
                        if (pageIDField.Value != string.Empty) ViewState["PageID"] = pageIDField.Value;
                    }
                }

                ViewState["FeedbackRefererURL"] = (Request.UrlReferrer != null) ? Request.UrlReferrer.ToString() : "/";

				string page = Request.QueryString[ "page" ];
				if ( page != null )
				{
					ViewState[ "PageID" ] = page;
				}
			}
		}

        /// <summary>
        /// Replaces the built-in "FindControl" method by doing a "contains" search instead
        /// of an exact match.
        /// </summary>
        /// <param name="controls"></param>
        /// <param name="searchTerm"></param>
        /// <returns></returns>
        protected Control myFindControl(ControlCollection controls, string searchTerm)
        {
            Control found = null;

            foreach (Control control in controls)
            {
                if ((control.ID == null ? "" : control.ID).Contains(searchTerm))
                {
                    found = control;
                }
                else
                {
                    if (control.Controls != null) found = this.myFindControl(control.Controls, searchTerm);
                }
                if (found != null) break;
            }

            return found;
        }

		protected void submitButton_Click( object sender, EventArgs e )
		{
			// Get Gemini data from web.config file
			string geminiWebServiceURL = ConfigurationManager.AppSettings.GetValues( "GeminiURL" )[ 0 ];
			string geminiUserName = ConfigurationManager.AppSettings.GetValues( "GeminiUser" )[ 0 ];
			string geminiUserPassword = ConfigurationManager.AppSettings.GetValues( "GeminiPassword" )[ 0 ];
			string issueSummary = ConfigurationManager.AppSettings.GetValues( "GeminiDesc" )[ 0 ];
			if ( emailTextBox.Text.Trim().Length > 0 )
			{
				issueSummary = emailTextBox.Text.Trim();
			}
			int projectId = int.Parse( ConfigurationManager.AppSettings.GetValues( "GeminiProjectId" )[ 0 ] );
			string issueLongDesc = getComment();

			CounterSoft.Gemini.Services.ServiceManager smProxyManager =
				new CounterSoft.Gemini.Services.ServiceManager( geminiWebServiceURL );

			if ( smProxyManager.SetAuthenticationTokenOnAllServices( geminiUserName, geminiUserPassword ) )
			{
				try
				{
					UserEN user = smProxyManager.AuthorisationServices.LogIn( geminiUserName, "" );

					// This is just for safety.
					// If we are here then we've logged in successfully.
					if ( user.UserID > 0 )
					{
						smProxyManager.UserID = user.UserID;

						IssueEN data = new IssueEN();

						IssueComponentEN[] iceComps = new IssueComponentEN[ 1 ];
						iceComps[ 0 ] = new IssueComponentEN();
						iceComps[ 0 ].ComponentID = 56;	// Web-Other
						data.Components = iceComps;

						data.FixedInVersion = 0;
						data.IsPrivate = false;
						data.IssueLongDesc = issueLongDesc;
						data.IssuePriority = 1;		// 1=Trivial, 2=Minor, 3=Major, 4=Show Stopper
						data.IssueResolution = 1;	// 1=Unresolved
						data.IssueStatus = 1;			// 1=Unassigned
						data.IssueSummary = issueSummary;
						data.IssueType = int.Parse( rbList.SelectedValue ); // 1=Technical Issues, 5=Suggestion, 6=Bibliographic Issues
						data.ReportedBy = user.UserID;
						data.RiskLevel = 1;
						data.ProjectID = projectId;

						try
						{
							// Note that this might throw a security exception.
							data.IssueID = smProxyManager.IssueServices.CreateIssue( data );
							Response.Redirect( createReturnUrl() );
						}
						catch
						{
							errorPanel.Visible = true;
							errorLabel.Text = "There was a problem sending your comment. Your feedback is important to us, we apologize.";
						}
					}
				}
				catch
				{
					errorPanel.Visible = true;
					errorLabel.Text = "There was a problem sending your comment. Your feedback is important to us, we apologize.";
				}
			}
			else
			{
				errorPanel.Visible = true;
				errorLabel.Text = "Server appears to be down, we apologize. Your feedback is important to us, we apologize.";
			}
		}

		protected void closeButton_Click( object sender, EventArgs e )
		{
			Response.Redirect( createReturnUrl() );
		}

		private string createReturnUrl()
		{
			string fburl = ViewState[ "FeedbackRefererURL" ].ToString();

            if (ViewState["TitleID"] != null)
            {
                fburl = String.Format(ConfigurationManager.AppSettings["BibPageUrl"], ViewState["TitleID"].ToString());
            }
            else if (ViewState["PageID"] != null) 
			{
				// if it comes from the names page then just redirect to orig fburl
				int x = fburl.IndexOf( "/", 10 ) + 1;
				int y = fburl.IndexOf( "/", x );

				if ( y > 0 )
				{
					string name = fburl.Substring( x, y - x );
					if ( name.ToLower().Equals( "name" ) )
					{
						return fburl;
					}
				}

				fburl = fburl.Substring( 0, fburl.IndexOf( '/', 10 ) ) + "/page/" + ViewState[ "PageID" ].ToString();
			}

			return fburl;
		}

		private string getComment()
		{
			StringBuilder sb = new StringBuilder();

			if ( nameTextBox.Text.Trim().Length > 0 )
			{
				sb.Append( "<b>Name: </b>" );
				sb.Append( nameTextBox.Text.Trim() );
			}

			sb.Append( "<br>" );
			sb.Append( "<b>URL: </b>" );
			sb.Append( ViewState[ "FeedbackRefererURL" ].ToString() );

			if ( ViewState[ "PageID" ] != null )
			{
				sb.Append( "<br>" );
				sb.Append( "<b>Viewed Page: </b>" );
				sb.Append( ViewState[ "PageID" ].ToString() );
			}

            if (ViewState["TitleID"] != null)
            {
                sb.Append("<br>");
                sb.Append("<b>Viewed Title:</b>");
                sb.Append(ViewState["TitleID"].ToString());
            }

			if ( sb.Length > 0 )
			{
				sb.Append( "<br><br>" );
			}
			sb.Append( commentTextBox.Text.Trim() );

			return sb.ToString();
		}
	}
}
