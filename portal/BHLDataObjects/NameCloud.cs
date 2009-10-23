using System;
using System.Collections.Generic;
using System.Text;
using CustomDataAccess;

namespace MOBOT.BHL.DataObjects
{
	public class NameCloud : ISetValues
	{
		int _qty;
		string _nameConfirmed;

		public int Qty
		{
			get { return this._qty; }
			set { this._qty = value; }
		}

		public string NameConfirmed
		{
			get { return this._nameConfirmed; }
			set { this._nameConfirmed = value; }
		}

		#region ISetValues Members

		void ISetValues.SetValues( CustomDataRow row )
		{
			foreach ( CustomDataColumn column in row )
			{
				switch ( column.Name )
				{
					case "Qty":
						{
							_qty = (int)column.Value;
							break;
						}
					case "NameConfirmed":
						{
							_nameConfirmed = (string)column.Value;
							break;
						}
				}
			}
		}

		#endregion

	}
}
