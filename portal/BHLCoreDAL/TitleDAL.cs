using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;
using SortOrder = CustomDataAccess.SortOrder;

namespace MOBOT.BHL.DAL
{
	public partial class TitleDAL
	{
		#region Select methods

		public static Title TitleSelectExtended( SqlConnection sqlConnection, SqlTransaction sqlTransaction, int titleId )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			Title title = new TitleDAL().TitleSelectAuto( connection, transaction, titleId );

			if ( title != null )
			{
				title.TitleCreators = Title_CreatorDAL.Title_CreatorSelectByTitle( connection, transaction, titleId );
				if ( title.TitleCreators != null && title.TitleCreators.Count > 0 )
				{
					CreatorDAL creatorDAL = new CreatorDAL();
					foreach ( Title_Creator titleCreator in title.TitleCreators )
					{
						titleCreator.Creator = creatorDAL.CreatorSelectAuto( connection, transaction, titleCreator.CreatorID );
					}
				}

                title.TitleIdentifiers = new Title_TitleIdentifierDAL().Title_TitleIdentifierSelectByTitleID(connection, transaction, titleId);

				title.TitleTypes = Title_TitleTypeDAL.SelectByTitle( connection, transaction, titleId );

				title.Items = ItemDAL.ItemSelectByTitleID( connection, transaction, titleId );

                title.TitleItems = new TitleItemDAL().TitleItemSelectByTitle(connection, transaction, titleId);

                title.TitleTags = TitleTagDAL.TitleTagSelectByTitle(connection, transaction, titleId);

                title.TitleAssociations = new TitleAssociationDAL().TitleAssociationSelectExtendedForTitle(connection, transaction, titleId);

                title.TitleLanguages = new TitleLanguageDAL().TitleLanguageSelectByTitleID(connection, transaction, titleId);
			}

			return title;
		}

		/// <summary>
		/// Select all values from Title.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <returns>Object of type Title.</returns>
		public CustomGenericList<Title> TitleSelectAll(
						SqlConnection sqlConnection,
						SqlTransaction sqlTransaction )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;
			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSelectAll", connection, transaction ) )
			{
				using ( CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>() )
				{
					CustomGenericList<Title> list = helper.ExecuteReader( command );
					return ( list );
				}
			}
		}

		/// <summary>
		/// Select all values from Title.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <returns>Object of type Title.</returns>
		public CustomGenericList<Title> TitleSelectAllPublished(
						SqlConnection sqlConnection,
						SqlTransaction sqlTransaction )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;
			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSelectAll", connection, transaction,
					 CustomSqlHelper.CreateInputParameter( "IsPublished", SqlDbType.Bit, 1, false, true ) ) )
			{
				using ( CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>() )
				{
					CustomGenericList<Title> list = helper.ExecuteReader( command );
					return ( list );
				}
			}
		}

        /// <summary>
        /// Select all values from Title that are published and are related to the
        /// specified institution.
        /// </summary>
        /// <param name="sqlConnection">Sql connection or null.</param>
        /// <param name="sqlTransaction">Sql transaction or null.</param>
        /// <param name="institutionCode">ID of the institution for which to retrieve titles</param>
        /// <returns>List of objects of type Title.</returns>
        public CustomGenericList<Title> TitleSelectPublishedByInstitution(
                        SqlConnection sqlConnection,
                        SqlTransaction sqlTransaction,
                        String institutionCode)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;
            using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleSelectPublishedByInstitution", connection, transaction,
                     CustomSqlHelper.CreateInputParameter("IsPublished", SqlDbType.Bit, 1, false, true),
                     CustomSqlHelper.CreateInputParameter("InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode)))
            {
                using (CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>())
                {
                    CustomGenericList<Title> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }

        public CustomGenericList<Title> TitleSelectByFullTitle(SqlConnection sqlConnection, SqlTransaction sqlTransaction, string fullTitle)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;
			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSelectByFullTitle", connection, transaction,
					CustomSqlHelper.CreateInputParameter( "FullTitle", SqlDbType.NVarChar, 2000, false, fullTitle ) ) )
			{
				using ( CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>() )
				{
					return helper.ExecuteReader( command );
				}
			}
		}

		public CustomGenericList<Title> TitleSelectByAbbreviation( SqlConnection sqlConnection, SqlTransaction sqlTransaction, string abbreviation )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;
			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSelectByAbbreviation", connection, transaction,
					CustomSqlHelper.CreateInputParameter( "Abbreviation", SqlDbType.NVarChar, 125, false, abbreviation ) ) )
			{
				using ( CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>() )
				{
					return helper.ExecuteReader( command );
				}
			}
		}

		/// <summary>
		/// Select all values from Title.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <returns>Object of type Title.</returns>
		public CustomGenericList<Title> TitleSelectAllNonPublished(
						SqlConnection sqlConnection,
						SqlTransaction sqlTransaction )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;
			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSelectAll", connection, transaction,
					 CustomSqlHelper.CreateInputParameter( "IsPublished", SqlDbType.Bit, 1, false, false ) ) )
			{
				using ( CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>() )
				{
					CustomGenericList<Title> list = helper.ExecuteReader( command );
					return ( list );
				}
			}
		}

		/// <summary>
		/// Select all values from Title published between the specified dates
        /// and contributed by the specified institution.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <returns>Object of type Title.</returns>
		public CustomGenericList<Title> TitleSelectByDateRangeAndInstitution(
						SqlConnection sqlConnection,
						SqlTransaction sqlTransaction,
						int startYear, int endYear, 
                        String institutionCode,
                        String languageCode)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSelectByDateRangeAndInstitution", connection, transaction,
							CustomSqlHelper.CreateInputParameter( "StartDate", SqlDbType.Int, null, false, startYear ),
							CustomSqlHelper.CreateInputParameter( "EndDate", SqlDbType.Int, null, false, endYear ),
                            CustomSqlHelper.CreateInputParameter("InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode),
                            CustomSqlHelper.CreateInputParameter("LanguageCode", SqlDbType.NVarChar, 10, false, languageCode)))
			{
				using ( CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>() )
				{
					CustomGenericList<Title> list = helper.ExecuteReader( command );
					return ( list );
				}
			}
		}

		/// <summary>
		/// Select all values from Title like a particular string.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <returns>Object of type Title.</returns>
		public CustomGenericList<Title> TitleSelectByNameLike(
						SqlConnection sqlConnection,
						SqlTransaction sqlTransaction,
						string name,
                        string institutionCode,
                        string languageCode)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSelectByNameLike", connection, transaction,
							CustomSqlHelper.CreateInputParameter( "Name", SqlDbType.VarChar, 1000, false, name ),
                            CustomSqlHelper.CreateInputParameter("InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode),
                            CustomSqlHelper.CreateInputParameter("LanguageCode", SqlDbType.NVarChar, 10, false, languageCode)))
			{
				using ( CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>() )
				{
					CustomGenericList<Title> list = helper.ExecuteReader( command );
					return ( list );
				}
			}
		}

		/// <summary>
		/// Select all values from Title like a particular string.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <returns>Object of type Title.</returns>
		public CustomGenericList<Title> TitleSelectSearchName(
						SqlConnection sqlConnection,
						SqlTransaction sqlTransaction,
                        string name, 
                        bool publishReady, 
                        string languageCode, 
                        string includeSecondaryTitles, 
                        int returnCount)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSelectSearchName", connection, transaction,
							CustomSqlHelper.CreateInputParameter( "Name", SqlDbType.VarChar, 1000, false, name ),
							CustomSqlHelper.CreateInputParameter( "PublishReady", SqlDbType.Bit, 1, false, publishReady ),
                            CustomSqlHelper.CreateInputParameter( "LanguageCode", SqlDbType.NVarChar, 10, false, languageCode),
                            CustomSqlHelper.CreateInputParameter("IncludeSecondaryTitles", SqlDbType.Char, 1, false, includeSecondaryTitles),
                            CustomSqlHelper.CreateInputParameter("ReturnCount", SqlDbType.Int, null, false, returnCount)))
			{
				using ( CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>() )
				{
					CustomGenericList<Title> list = helper.ExecuteReader( command );
					return ( list );
				}
			}
		}

		/// <summary>
		/// Select all values from Title for a particular Creator.
		/// </summary>
		/// <param name="sqlConnection">Sql connection or null.</param>
		/// <param name="sqlTransaction">Sql transaction or null.</param>
		/// <returns>Object of type Creator.</returns>
		public CustomGenericList<Title> TitleSelectByCreator(
						SqlConnection sqlConnection,
						SqlTransaction sqlTransaction,
						int creatorId,
                        String includeSecondaryTitles)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSelectByCreator", connection, transaction,
							CustomSqlHelper.CreateInputParameter( "CreatorId", SqlDbType.Int, null, false, creatorId ),
                            CustomSqlHelper.CreateInputParameter("IncludeSecondaryTitles", SqlDbType.Char, 1, false, includeSecondaryTitles)))
			{
				using ( CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>() )
				{
					CustomGenericList<Title> list = helper.ExecuteReader( command );
					return list;
				}
			}
		}

		public CustomGenericList<Title> TitleSelectByTagTextInstitutionAndLanguage( SqlConnection sqlConnection, SqlTransaction sqlTransaction, 
            string tagText,
            string institutionCode,
            string languageCode,
            string includeSecondaryTitles)
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSelectByTagTextInstitutionAndLanguage", connection, transaction,
							CustomSqlHelper.CreateInputParameter( "TagText", SqlDbType.NVarChar, 50, false, tagText ),
                            CustomSqlHelper.CreateInputParameter("InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode),
                            CustomSqlHelper.CreateInputParameter("LanguageCode", SqlDbType.NVarChar, 10, false, languageCode),
                            CustomSqlHelper.CreateInputParameter("IncludeSecondaryTitles", SqlDbType.Char, 1, false, includeSecondaryTitles)))
			{
				using ( CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>() )
				{
					CustomGenericList<Title> list = helper.ExecuteReader( command );
					return ( list );
				}
			}
		}

		#endregion

		public static CustomGenericList<Title> TitleSearch( SqlConnection sqlConnection, SqlTransaction sqlTransaction,
			TitleSearchCriteria tsc )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSearchPaging", connection, transaction,
				CustomSqlHelper.CreateInputParameter( "TitleID", SqlDbType.Int, null, true, tsc.TitleID ),
				CustomSqlHelper.CreateInputParameter( "MARCBibID", SqlDbType.NVarChar, 50, true, tsc.MARCBibID ),
				CustomSqlHelper.CreateInputParameter( "Title", SqlDbType.NVarChar, 255, true, tsc.Title ),
				CustomSqlHelper.CreateInputParameter( "StartRow", SqlDbType.BigInt, null, false, tsc.StartRow ),
				CustomSqlHelper.CreateInputParameter( "PageSize", SqlDbType.Int, null, false, tsc.PageSize ),
				CustomSqlHelper.CreateInputParameter( "OrderBy", SqlDbType.Int, null, false,
				(int)tsc.OrderBy * ( tsc.SortOrder == SortOrder.Ascending ? 1 : -1 ) ) ) )
			{
				using ( CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>() )
				{
					return helper.ExecuteReader( command );
				}
			}
		}

		public static int TitleSearchCount( SqlConnection sqlConnection, SqlTransaction sqlTransaction,
			TitleSearchCriteria tsc )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSearchCount", connection, transaction,
				CustomSqlHelper.CreateInputParameter( "TitleID", SqlDbType.Int, null, true, tsc.TitleID ),
				CustomSqlHelper.CreateInputParameter( "MARCBibID", SqlDbType.NVarChar, 50, true, tsc.MARCBibID ),
				CustomSqlHelper.CreateInputParameter( "Title", SqlDbType.NVarChar, 255, true, tsc.Title ) ) )
			{
				using ( CustomSqlHelper<int> helper = new CustomSqlHelper<int>() )
				{
					CustomGenericList<int> k = helper.ExecuteReader( command );

					return k[ 0 ];
				}
			}
		}

		public CustomGenericList<CreatorTitle> TitleSimpleSelectByCreator( SqlConnection sqlConnection,
			SqlTransaction sqlTransaction, int creatorId )
		{
			SqlConnection connection = CustomSqlHelper.CreateConnection(
				CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ), sqlConnection );
			SqlTransaction transaction = sqlTransaction;

			using ( SqlCommand command = CustomSqlHelper.CreateCommand( "TitleSimpleSelectByCreator", connection, transaction,
				CustomSqlHelper.CreateInputParameter( "CreatorId", SqlDbType.Int, null, false, creatorId ) ) )
			{
				using ( CustomSqlHelper<CreatorTitle> helper = new CustomSqlHelper<CreatorTitle>() )
				{
					CustomGenericList<CreatorTitle> list = helper.ExecuteReader( command );

					return list;
				}
			}
		}

        /// <summary>
        /// Select all Titles for the specified Item.
        /// </summary>
        /// <param name="sqlConnection">Sql connection or null.</param>
        /// <param name="sqlTransaction">Sql transaction or null.</param>
        /// <param name="itemID">Identifier of the item for which to get titles</param>
        /// <returns>Object of type Title.</returns>
        public CustomGenericList<Title> TitleSelectByItem(
                        SqlConnection sqlConnection,
                        SqlTransaction sqlTransaction,
                        int itemID)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;
            using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleSelectByItem", connection, transaction,
                     CustomSqlHelper.CreateInputParameter("ItemID", SqlDbType.Int, null, false, itemID)))
            {
                using (CustomSqlHelper<Title> helper = new CustomSqlHelper<Title>())
                {
                    CustomGenericList<Title> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }

        /// <summary>
        /// Select data for BibTex item citations for all Titles.
        /// </summary>
        /// <param name="sqlConnection">Sql connection or null.</param>
        /// <param name="sqlTransaction">Sql transaction or null.</param>
        /// <returns>List of type TitleBibTeX.</returns>
        public CustomGenericList<TitleBibTeX> TitleBibTeXSelectAllItemCitations(
                        SqlConnection sqlConnection,
                        SqlTransaction sqlTransaction)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;
            using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleBibTeXSelectAllItemCitations", connection, transaction))
            {
                using (CustomSqlHelper<TitleBibTeX> helper = new CustomSqlHelper<TitleBibTeX>())
                {
                    CustomGenericList<TitleBibTeX> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }

        /// <summary>
        /// Select data for BibTex all title citations.
        /// </summary>
        /// <param name="sqlConnection">Sql connection or null.</param>
        /// <param name="sqlTransaction">Sql transaction or null.</param>
        /// <returns>List of type TitleBibTeX.</returns>
        public CustomGenericList<TitleBibTeX> TitleBibTeXSelectAllTitleCitations(
                        SqlConnection sqlConnection,
                        SqlTransaction sqlTransaction)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;
            using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleBibTeXSelectAllTitleCitations", connection, transaction))
            {
                using (CustomSqlHelper<TitleBibTeX> helper = new CustomSqlHelper<TitleBibTeX>())
                {
                    CustomGenericList<TitleBibTeX> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }

        /// <summary>
        /// Select data for EndNote item citations for all Titles.
        /// </summary>
        /// <param name="sqlConnection">Sql connection or null.</param>
        /// <param name="sqlTransaction">Sql transaction or null.</param>
        /// <returns>List of type TitleEndNote.</returns>
        public CustomGenericList<TitleEndNote> TitleEndNoteSelectAllItemCitations(
                        SqlConnection sqlConnection,
                        SqlTransaction sqlTransaction)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;
            using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleEndNoteSelectAllItemCitations", connection, transaction))
            {
                using (CustomSqlHelper<TitleEndNote> helper = new CustomSqlHelper<TitleEndNote>())
                {
                    CustomGenericList<TitleEndNote> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }

        /// <summary>
        /// Select data for EndNote all title citations.
        /// </summary>
        /// <param name="sqlConnection">Sql connection or null.</param>
        /// <param name="sqlTransaction">Sql transaction or null.</param>
        /// <returns>List of type TitleEndNote.</returns>
        public CustomGenericList<TitleEndNote> TitleEndNoteSelectAllTitleCitations(
                        SqlConnection sqlConnection,
                        SqlTransaction sqlTransaction)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;
            using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleEndNoteSelectAllTitleCitations", connection, transaction))
            {
                using (CustomSqlHelper<TitleEndNote> helper = new CustomSqlHelper<TitleEndNote>())
                {
                    CustomGenericList<TitleEndNote> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }

        /// <summary>
        /// Select data for BibTex references for the specified Title.
        /// </summary>
        /// <param name="sqlConnection">Sql connection or null.</param>
        /// <param name="sqlTransaction">Sql transaction or null.</param>
        /// <param name="titleId">Title identifier for which to get BibTex data</param>
        /// <returns>List of type TitleBibTeX.</returns>
        public CustomGenericList<TitleBibTeX> TitleBibTeXSelectForTitleID(
                        SqlConnection sqlConnection,
                        SqlTransaction sqlTransaction,
                        int titleId)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;
            using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleBibTeXSelectForTitleID", connection, transaction,
                CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleId)))
            {
                using (CustomSqlHelper<TitleBibTeX> helper = new CustomSqlHelper<TitleBibTeX>())
                {
                    CustomGenericList<TitleBibTeX> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }

        /// <summary>
        /// Select data for EndNote reference for the specified Title.
        /// </summary>
        /// <param name="sqlConnection">Sql connection or null.</param>
        /// <param name="sqlTransaction">Sql transaction or null.</param>
        /// <param name="titleId">Title identifier for which to get EndNote data</param>
        /// <returns>List of type TitleEndNote.</returns>
        public CustomGenericList<TitleEndNote> TitleEndNoteSelectForTitleID(
                        SqlConnection sqlConnection,
                        SqlTransaction sqlTransaction,
                        int titleId)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;
            using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleEndNoteSelectForTitleID", connection, transaction,
                CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, false, titleId)))
            {
                using (CustomSqlHelper<TitleEndNote> helper = new CustomSqlHelper<TitleEndNote>())
                {
                    CustomGenericList<TitleEndNote> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }

        public static void Save(SqlConnection sqlConnection, SqlTransaction sqlTransaction, Title title, int userId)
		{
			SqlConnection connection = sqlConnection;
			SqlTransaction transaction = sqlTransaction;

			if ( connection == null )
			{
				connection =
					CustomSqlHelper.CreateConnection( CustomSqlHelper.GetConnectionStringFromConnectionStrings( "BHL" ) );
			}

			bool isTransactionCoordinator = CustomSqlHelper.IsTransactionCoordinator( transaction );

			try
			{
				transaction = CustomSqlHelper.BeginTransaction( connection, transaction, isTransactionCoordinator );

                CustomDataAccessStatus<Title> updatedTitle = 
				    new TitleDAL().TitleManageAuto( connection, transaction, title, userId );

				if ( title.TitleCreators.Count > 0 )
				{
					Title_CreatorDAL titleCreatorDAL = new Title_CreatorDAL();
					foreach ( Title_Creator titleCreator in title.TitleCreators )
					{
                        if (titleCreator.TitleID == 0) titleCreator.TitleID = updatedTitle.ReturnObject.TitleID;
						titleCreatorDAL.Title_CreatorManageAuto( connection, transaction, titleCreator, userId );
					}
				}

                if (title.TitleTags.Count > 0)
                {
                    TitleTagDAL titleTagDAL = new TitleTagDAL();
                    foreach (TitleTag titleTag in title.TitleTags)
                    {
                        if (titleTag.TitleID == 0) titleTag.TitleID = updatedTitle.ReturnObject.TitleID;
                        titleTagDAL.TitleTagManageAuto(connection, transaction, titleTag);
                    }
                }

                if (title.TitleIdentifiers.Count > 0)
                {
                    Title_TitleIdentifierDAL titleTitleIdentifierDAL = new Title_TitleIdentifierDAL();
                    foreach (Title_TitleIdentifier titleTitleIdentifier in title.TitleIdentifiers)
                    {
                        if (titleTitleIdentifier.TitleID == 0) titleTitleIdentifier.TitleID = updatedTitle.ReturnObject.TitleID;
                        titleTitleIdentifierDAL.Title_TitleIdentifierManageAuto(connection, transaction, titleTitleIdentifier);
                    }
                }

                if (title.TitleAssociations.Count > 0)
                {
                    TitleAssociationDAL titleAssociationDAL = new TitleAssociationDAL();
                    foreach (TitleAssociation titleAssociation in title.TitleAssociations)
                    {
                        if (titleAssociation.TitleID == 0) titleAssociation.TitleID = updatedTitle.ReturnObject.TitleID;
                        TitleAssociationDAL.Save(connection, transaction, titleAssociation);
                    }
                }

                if (title.TitleLanguages.Count > 0)
                {
                    TitleLanguageDAL titleLanguageDAL = new TitleLanguageDAL();
                    foreach (TitleLanguage titleLanguage in title.TitleLanguages)
                    {
                        if (titleLanguage.TitleID == 0) titleLanguage.TitleID = updatedTitle.ReturnObject.TitleID;
                        titleLanguageDAL.TitleLanguageManageAuto(connection, transaction, titleLanguage);
                    }
                }

				if ( title.TitleTypes.Count > 0 )
				{
					Title_TitleTypeDAL titleTypeDAL = new Title_TitleTypeDAL();
					foreach ( Title_TitleType titleType in title.TitleTypes )
					{
                        if (titleType.TitleID == 0) titleType.TitleID = updatedTitle.ReturnObject.TitleID;
						titleTypeDAL.Title_TitleTypeManageAuto( connection, transaction, titleType );
					}
				}

				if ( title.TitleItems.Count > 0 )
				{
					ItemDAL itemDAL = new ItemDAL();
                    TitleItemDAL titleItemDAL = new TitleItemDAL();
					foreach ( TitleItem titleItem in title.TitleItems )
					{
                        // Update the item
                        if (titleItem.TitleID == 0) titleItem.TitleID = updatedTitle.ReturnObject.TitleID;
						titleItemDAL.TitleItemManageAuto( connection, transaction, titleItem );
                        // Update the primary title id (stored on the Item table)
                        itemDAL.ItemUpdatePrimaryTitleID(connection, transaction, titleItem.ItemID, titleItem.PrimaryTitleID);
					}
				}

				CustomSqlHelper.CommitTransaction( transaction, isTransactionCoordinator );
			}
			catch ( Exception ex )
			{
				CustomSqlHelper.RollbackTransaction( transaction, isTransactionCoordinator );

				throw new Exception( "Exception in Save", ex );
			}
			finally
			{
				CustomSqlHelper.CloseConnection( connection, isTransactionCoordinator );
			}

		}

        /// <summary>
        /// Returns a list of titles that have suspected character encoding problems.
        /// </summary>
        /// <param name="sqlConnection"></param>
        /// <param name="sqlTransaction"></param>
        /// <param name="institutionCode">Institution for which to return titles</param>
        /// <param name="maxAge">Age in days of titles to consider (i.e. titles new in the last 30 days)</param>
        /// <returns></returns>
        public CustomGenericList<TitleSuspectCharacter> TitleSelectWithSuspectCharacters(
                SqlConnection sqlConnection,
                SqlTransaction sqlTransaction,
                String institutionCode,
                int maxAge)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;
            using (SqlCommand command = CustomSqlHelper.CreateCommand("TitleSelectWithSuspectCharacters", connection, transaction,
                CustomSqlHelper.CreateInputParameter("InstitutionCode", SqlDbType.NVarChar, 10, false, institutionCode),
                CustomSqlHelper.CreateInputParameter("MaxAge", SqlDbType.Int, null, false, maxAge)))
            {
                using (CustomSqlHelper<TitleSuspectCharacter> helper = new CustomSqlHelper<TitleSuspectCharacter>())
                {
                    CustomGenericList<TitleSuspectCharacter> list = helper.ExecuteReader(command);
                    return (list);
                }
            }
        }
	}
}
