
#region Using

using System;

#endregion Using

namespace MOBOT.BHL.DataObjects
{
    [Serializable]
    public class TitleIdentifier : __TitleIdentifier
    {
        #region Properties

        public string IdentifierNameFull
        {
            get
            {
                if (this.MarcDataFieldTag != String.Empty)
                    return this.IdentifierName + " (MARC " + this.MarcDataFieldTag + this.MarcSubFieldCode + ")";
                else
                    return this.IdentifierName;
            }
        }

        #endregion Properties
    }
}
