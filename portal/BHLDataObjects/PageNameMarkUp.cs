using System;
using System.Collections.Generic;
using System.Configuration;
using System.Text;

namespace MOBOT.BHL.DataObjects
{
	public class PageNameMarkup
	{
		private string text = "";
		private string _uBioText = "";
		private string nameBankUrlPrefix = "";

		public PageNameMarkup()
		{
			text = String.Empty;
		}

		public PageNameMarkup( string nameFound, string nameConfirmed, int? nameBankID )
		{
			if ( nameBankID == null )
			{
				nameBankID = 0;
			}

			nameBankUrlPrefix = ConfigurationManager.AppSettings[ "nameBankUrlPrefix" ];
			//revert to default value if no config value found
			if ( nameBankUrlPrefix == null || nameBankUrlPrefix.Trim().Length == 0 )
			{
				nameBankUrlPrefix = "http://names.ubio.org/browser/details.php?namebankID=";
			}
			SetMarkupText( nameFound, nameConfirmed, (int)nameBankID );
		}

		public PageNameMarkup( string errorMessage )
		{
			text = errorMessage;
		}

		public string Text
		{
			get
			{
				return text;
			}
		}

		public string UBioText
		{
			get
			{
				return _uBioText;
			}
		}

		private void SetMarkupText( string nameFound, string nameConfirmed, int nameBankID )
		{
			//first trim the input values
			nameFound = nameFound.Trim();
			nameConfirmed = nameConfirmed.Trim();
			if ( nameFound.ToLower() == nameConfirmed.ToLower() )
			{
				text = GetAnchorMarkup( nameFound, nameBankID );
			}
			else
			{
				string prefix = nameFound.Substring( 0, nameFound.ToUpper().IndexOf( nameConfirmed.ToUpper() ) );
				string suffix = nameFound.Substring( ( nameFound.ToUpper().IndexOf( nameConfirmed.ToUpper() ) + 
					nameConfirmed.Length ) );
				string link = GetAnchorMarkup( nameConfirmed, nameBankID );
				text = prefix + link + suffix;
			}
			_uBioText = GetAnchorMarkup( "View NameBank record", nameBankID );
		}

		private string GetAnchorMarkup( string text, int nameBankID )
		{
			return "<a href=\"" + nameBankUrlPrefix + nameBankID.ToString() + "\" target=\"_blank\">" + text + "</a>";
		}
	}
}
