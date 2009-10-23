using System;
using System.Collections.Generic;
using System.Text;
using CustomDataAccess;
using MOBOT.Utility;
using SortOrder = CustomDataAccess.SortOrder;

namespace MOBOT.BHL.DataObjects
{
	public class PageNameComparer : System.Collections.IComparer
	{
		public enum CompareEnum
		{
			NameFound,
			NameConfirmed,
			NameBankID,
			Active
		}

		private CompareEnum _compareEnum;
		private SortOrder _sortOrder;

		public PageNameComparer( CompareEnum compareEnum, SortOrder sortOrder )
		{
			_compareEnum = compareEnum;
			_sortOrder = sortOrder;
		}

		public int Compare( object obj1, object obj2 )
		{
			PageName pageName1 = (PageName)obj1;
			PageName pageName2 = (PageName)obj2;

			int ret = 0;
			string s1 = "";
			string s2 = "";

			switch ( _compareEnum )
			{
				case CompareEnum.Active:
					{
						ret = pageName1.Active.CompareTo( pageName2.Active );
						break;
					}
				case CompareEnum.NameFound:
					{
						ret = TypeHelper.EmptyIfNull( pageName1.NameFound ).CompareTo(
							TypeHelper.EmptyIfNull( pageName2.NameFound ) );
						break;
					}
				case CompareEnum.NameConfirmed:
					{
						ret = TypeHelper.EmptyIfNull( pageName1.NameConfirmed ).CompareTo(
							TypeHelper.EmptyIfNull( pageName2.NameConfirmed ) );
						break;
					}
				case CompareEnum.NameBankID:
					{
						ret = ( TypeHelper.ZeroIfNull( (int?)pageName1.NameBankID ) ).CompareTo(
							( TypeHelper.ZeroIfNull( (int?)pageName2.NameBankID ) ) );
						break;
					}
			}

			if ( _sortOrder == SortOrder.Descending )
			{
				ret = ret * -1;
			}

			return ret;
		}
	}
}
