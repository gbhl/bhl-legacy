using System;
using CustomDataAccess;

namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class Creator : __Creator
	{
		private int creatorRoleTypeForTitle = 0;

		/// <summary>
		/// Overloaded constructor specifying each column value.
		/// </summary>
		/// <param name="creatorID"></param>
		/// <param name="creatorName"></param>
		/// <param name="firstNameFirst"></param>
		/// <param name="simpleName"></param>
		/// <param name="dOB"></param>
		/// <param name="dOD"></param>
		/// <param name="biography"></param>
		/// <param name="creatorNote"></param>
		/// <param name="mARCDataFieldTag"></param>
		/// <param name="mARCCreator_a"></param>
		/// <param name="mARCCreator_b"></param>
		/// <param name="mARCCreator_c"></param>
		/// <param name="mARCCreator_d"></param>
		/// <param name="mARCCreator_Full"></param>
		public Creator( int creatorID,
			string creatorName,
			string firstNameFirst,
			string simpleName,
			string dOB,
			string dOD,
			string biography,
			string creatorNote,
			string mARCDataFieldTag,
			string mARCCreator_a,
			string mARCCreator_b,
			string mARCCreator_c,
			string mARCCreator_d,
			string mARCCreator_Full )
			: base( creatorID, creatorName, firstNameFirst, simpleName, dOB, dOD, biography, creatorNote,
			mARCDataFieldTag, mARCCreator_a, mARCCreator_b, mARCCreator_c, mARCCreator_d, mARCCreator_Full, DateTime.Now, 
            DateTime.Now )
		{
		}

		public Creator()
		{
		}

		public int CreatorRoleTypeForTitle
		{
			get
			{
				return creatorRoleTypeForTitle;
			}
		}

		public override void SetValues( CustomDataAccess.CustomDataRow row )
		{
			foreach ( CustomDataColumn column in row )
			{
				if ( column.Name == "CreatorRoleTypeID" )
					creatorRoleTypeForTitle = Utility.ZeroIfNull( column.Value );
			}
			base.SetValues( row );
		}
	}
}
