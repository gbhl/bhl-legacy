using System;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;
using CustomDataAccess;

namespace MOBOT.BHL.Server
{
	public partial class BHLProvider
	{
        public CustomGenericList<TitleTag> TitleTagSelectLikeTag(string tag, string languageCode, string includeSecondaryTitles, int returnCount)
		{
            return TitleTagDAL.TitleTagSelectLikeTag(null, null, tag, languageCode, includeSecondaryTitles, returnCount);
		}

		public CustomGenericList<CustomDataRow> TitleTagSelectCountByInstitution( int numberToReturn, string institutionCode, string languageCode )
		{
			return new TitleTagDAL().TitleTagSelectCountByInstitution( null, null, numberToReturn, institutionCode, languageCode );
		}

		public CustomGenericList<CustomDataRow> TitleTagSelectNewLocations()
		{
			return new TitleTagDAL().TitleTagSelectNewLocations( null, null );
		}

		public CustomGenericList<TitleTag> TitleTagSelectByTitleId( int titleId )
		{
			return TitleTagDAL.TitleTagSelectByTitle( null, null, titleId );
		}

        public CustomGenericList<TitleTag> TitleTagSelectTagTextByTitleId(int titleId)
        {
            return TitleTagDAL.TitleTagSelectTagTextByTitle(null, null, titleId);
        }

        public CustomGenericList<TitleTagSuspectCharacter> TitleTagSelectWithSuspectCharacters(String institutionCode, int maxAge)
        {
            return new TitleTagDAL().TitleTagSelectWithSuspectCharacters(null, null, institutionCode, maxAge);
        }
    }
}
