using System;
using CustomDataAccess;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Server
{
  public partial class BHLProvider
  {
    public CustomGenericList<Creator> CreatorSelectAll()
    {
      return CreatorDAL.CreatorSelectAll( null, null );
    }

    /// <summary>
    /// Select all values from Creator.
    /// </summary>
    /// <returns>Object of type Creator.</returns>
    public CustomGenericList<Creator> CreatorSelectList()
    {
      return ( new CreatorDAL().CreatorSelectList( null, null ) );
    }

    public CustomGenericList<Creator> CreatorSelectByTitleId( int titleId )
    {
      return ( new CreatorDAL().SelectByTitleId( null, null, titleId ) );
    }

    public CustomGenericList<Creator> CreatorSelectByInstitution(string institutionCode, string languageCode)
    {
        return (new CreatorDAL().CreatorSelectByInstitution(null, null, institutionCode, languageCode));
    }

    /// <summary>
    /// Select all values from Creator by BibID.
    /// </summary>
    /// <returns>Object of type Creator.</returns>
    public CustomGenericList<Creator> CreatorSelectByCreatorNameLike( string creatorName, string languageCode, string includeSecondaryTitles, int returnCount )
    {
      return ( new CreatorDAL().CreatorSelectByCreatorNameLike( null, null, creatorName, languageCode, includeSecondaryTitles, returnCount ) );
    }

    /// <summary>
    /// Select all values from Creator by name starting with a specified string and
    /// associated with a title contributed by the specified institution.
    /// </summary>
    /// <returns>Object of type Creator.</returns>
    public CustomGenericList<Creator> CreatorSelectByCreatorNameLikeAndInstitution(string creatorName, string institutionCode, string languageCode)
    {
        return (new CreatorDAL().CreatorSelectByCreatorNameLikeAndInstitution(null, null, creatorName, institutionCode, languageCode));
    }

    /// <summary>
    /// Select all values from Creator by Name starting with specified string.
    /// </summary>
    /// <returns>Object of type Creator.</returns>
    public CustomGenericList<Creator> CreatorSelectByCreatorStartsWith( string creatorName )
    {
      return ( new CreatorDAL().CreatorSelectByCreatorStartsWith( null, null, creatorName ) );
    }

    /// <summary>
    /// Select one value from Creator.
    /// </summary>
    /// <returns>Object of type Creator.</returns>
    public Creator CreatorSelectAuto( int creatorID )
    {
      return ( new CreatorDAL().CreatorSelectAuto( null, null, creatorID ) );
    }

    public void SaveCreator( Creator creator )
    {
      CreatorDAL.Save( null, null, creator );
    }

    public CustomGenericList<CreatorSuspectCharacter> CreatorSelectWithSuspectCharacters(String institutionCode, int maxAge)
    {
        return new CreatorDAL().CreatorSelectWithSuspectCharacters(null, null, institutionCode, maxAge);
    }
  }
}
