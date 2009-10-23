
#region Using

using System;

#endregion Using

namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class Institution : __Institution
	{
		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="institutionCode"></param>
		/// <param name="institutionName"></param>
		/// <param name="note"></param>
		/// <param name="institutionUrl"></param>
		public Institution( string institutionCode, string institutionName, string note, string institutionUrl, bool bHLMemberLibrary )
			: base( institutionCode, institutionName, note, institutionUrl, bHLMemberLibrary )
		{
		}

		public Institution()
		{
		}
	}
}
