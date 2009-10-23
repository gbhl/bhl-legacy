
#region Using

using System;
using CustomDataAccess;

#endregion Using

namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class Location : __Location
    {
        #region Properties

        private int _numberOfTitles = 0;

        public int NumberOfTitles
        {
            get { return _numberOfTitles; }
            set { _numberOfTitles = value; }
        }

        #endregion Properties

        #region ISet override

        public override void SetValues(CustomDataRow row)
        {
            foreach (CustomDataColumn column in row)
            {
                switch (column.Name)
                {
                    case "NumberOfTitles":
                        {
                            _numberOfTitles = Utility.ZeroIfNull(column.Value);
                            break;
                        }
                }
            }

            base.SetValues(row);
        }

        #endregion

	}
}
