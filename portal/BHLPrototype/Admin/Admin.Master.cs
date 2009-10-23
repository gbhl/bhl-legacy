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
using MOBOT.Security.Client;
using MOBOT.Security.Client.MOBOTSecurity;

namespace MOBOT.BHL.Web.Admin
{
	public partial class Admin : System.Web.UI.MasterPage
	{
		protected void Page_Load( object sender, EventArgs e )
		{
			Response.Cookies[ "CallingUrl" ].Value = Request.Url.ToString();

			// if logged in change to logout and vice versa
			//HttpCookie tokenCookie = Request.Cookies[ "MOBOTSecurityToken" ];

			//if ( tokenCookie == null || tokenCookie.Value.Length == 0 )
			//{
			//	Response.Redirect( "/Default.aspx" );
			//}
			//else
			//{
				loginLink.Text = "Logout";
				loginLink.NavigateUrl = "/Ligustrum.aspx?send=2";
			//}
/*
			// Make sure user is an admin
			if ( Helper.IsAdmin( Request ) == false )
			{
				Response.Redirect( "/Default.aspx" );
			}

            // Make sure that the authorized user is valid for the production site (some are
            // restricted to test)
            String isProduction = ConfigurationManager.AppSettings["IsProduction"] as String;
            if (String.Compare(isProduction, "true", true) == 0)
            {
                SecUser user = Helper.GetSecProvider().SecUserSelect(tokenCookie.Value);
                String userName = user.UserName;

                String invalidProductionUserString = ConfigurationManager.AppSettings["InvalidProductionUsers"] as String;
                String[] invalidProductionUsers = invalidProductionUserString.Split('|');

                for (int i = 0; i < invalidProductionUsers.Length; i++)
                {
                    if (String.Compare(userName, invalidProductionUsers[i], true) == 0)
                    {
                        Response.Redirect("/Default.aspx");
                    }
                }
            }
*/            
		}

		protected override void OnInit( EventArgs e )
		{
			base.OnInit( e );

			HttpCookie tokenCookie = Request.Cookies[ "MOBOTSecurityToken" ];
			if ( tokenCookie == null || tokenCookie.Value.Length == 0 )
			{
				//Response.Redirect( "/Default.aspx" );
			}
		}
	}
}
