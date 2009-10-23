using System;
using System.Collections.Generic;
using System.Text;

namespace MOBOT.BHL.DataObjects
{
	public class NameSearchResult
	{
		private string queryDate = "";
		private List<NameSearchTitle> titles = new List<NameSearchTitle>();

		public string QueryDate
		{
			get
			{
				return queryDate;
			}
			set
			{
				queryDate = value;
			}
		}

		public List<NameSearchTitle> Titles
		{
			get
			{
				return titles;
			}
			set
			{
				titles = value;
			}
		}

		public int TitleCount
		{
			get
			{
				return titles.Count;
			}
			set
			{ }
		}

		public int PageCount
		{
			get
			{
				int k = 0;
				foreach ( NameSearchTitle title in Titles )
				{
					k = k + title.TotalPageCount;
				}

				return k;
			}
			set
			{ }
		}
	}
}
