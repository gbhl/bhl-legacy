using System;
using System.Collections.Generic;
using System.Text;

namespace MOBOT.BHL.DataObjects
{
	public class NameSearchPage
	{
		private int pageID = 0;
		private int sequenceOrder = 0;
		private string indicatedPages = "";
		private int _nameBankId;

		public int PageID
		{
			get
			{
				return pageID;
			}
			set
			{
				pageID = value;
			}
		}

		public int SequenceOrder
		{
			get
			{
				return sequenceOrder;
			}
			set
			{
				sequenceOrder = value;
			}
		}

		public string IndicatedPages
		{
			get
			{
				return indicatedPages;
			}
			set
			{
				indicatedPages = value;
			}
		}

		public int NameBankId
		{
			get { return this._nameBankId; }
			set { this._nameBankId = value; }
		}
	}
}
