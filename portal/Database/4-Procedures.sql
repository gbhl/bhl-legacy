
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ConfigurationSelectByName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ConfigurationSelectByName]
GO


/****** Object:  StoredProcedure [dbo].[ConfigurationSelectByName]    Script Date: 10/16/2009 16:26:48 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.ConfigurationSelectByName

@ConfigurationName nvarchar(50)

AS
BEGIN

SET NOCOUNT ON

SELECT	ConfigurationID,
		ConfigurationName,
		ConfigurationValue
FROM	dbo.Configuration
WHERE	ConfigurationName = @ConfigurationName

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSelectByNameLike]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSelectByNameLike]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSelectByNameLike]    Script Date: 10/16/2009 16:26:48 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PageNameSelectByNameLike]

@NameConfirmed NVARCHAR(100),
@LanguageCode NVARCHAR(10) = '',
@ReturnCount INT = 100

AS 

SET NOCOUNT ON


IF (@LanguageCode = '')
BEGIN
	-- No LanguageCode specified, so do the "simple" query (for better performance)
	SELECT TOP (@ReturnCount)
		pn.[NameConfirmed],
		pn.[NameBankID],
		COUNT(pn.Active) AS [PageCount]
	FROM [dbo].[PageName] pn
	WHERE
		pn.[Active] = 1 AND
		pn.[NameBankID] IS NOT NULL AND
		pn.[NameConfirmed] LIKE LTRIM(RTRIM(@NameConfirmed)) + '%'
	GROUP BY pn.[NameConfirmed], pn.[NameBankID]
	ORDER BY pn.[NameConfirmed] ASC
END
ELSE
BEGIN
	SELECT TOP (@ReturnCount)
		pn.[NameConfirmed],
		pn.[NameBankID],
		COUNT(pn.Active) AS [PageCount]
	FROM [dbo].[PageName] pn
		INNER JOIN dbo.Page p ON pn.PageID = p.PageID
		INNER JOIN dbo.Item i ON p.ItemID = i.ItemID
		INNER JOIN dbo.Title t ON i.PrimaryTitleID = t.TitleID
		LEFT JOIN dbo.TitleLanguage tl ON t.TitleID = tl.TitleID
		LEFT JOIN dbo.ItemLanguage il ON i.ItemID = il.ItemID
	WHERE
		pn.[Active] = 1 AND
		pn.[NameBankID] IS NOT NULL AND
		pn.[NameConfirmed] LIKE LTRIM(RTRIM(@NameConfirmed)) + '%' AND
		(t.LanguageCode = @LanguageCode OR
			i.LanguageCode = @LanguageCode OR
			ISNULL(tl.LanguageCode, '') = @LanguageCode OR
			ISNULL(il.LanguageCode, '') = @LanguageCode OR
			@LanguageCode = '')
	GROUP BY pn.[NameConfirmed], pn.[NameBankID]
	ORDER BY pn.[NameConfirmed] ASC
END

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameSelectByNameLike. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSelectTop]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSelectTop]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSelectTop]    Script Date: 10/16/2009 16:26:49 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PageNameSelectTop] 
	@Number INT = 100
AS

SELECT TOP (@Number) NameConfirmed, Qty
FROM PageNameCount




GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorSelectList]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorSelectList]
GO


/****** Object:  StoredProcedure [dbo].[CreatorSelectList]    Script Date: 10/16/2009 16:26:49 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatorSelectList]
AS 

SET NOCOUNT ON

SELECT DISTINCT 
	Creator.CreatorID,
	Creator.CreatorName,
	Creator.FirstNameFirst,
	Creator.SimpleName, 
	Creator.DOB, 
	Creator.DOD, 
	'' AS Biography, 
	Creator.CreatorNote, 
	Creator.MARCDataFieldTag, 
	Creator.MARCCreator_a, 
	Creator.MARCCreator_b, 
	Creator.MARCCreator_c, 
	Creator.MARCCreator_d, 
	Creator.MARCCreator_Full,
	Creator.CreationDate,
	Creator.LastModifiedDate
FROM Title 
	INNER JOIN Title_Creator ON Title.TitleID = Title_Creator.TitleID 
	INNER JOIN Creator ON Creator.CreatorID = Title_Creator.CreatorID
WHERE
	(Title.PublishReady = 1)
ORDER BY Creator.CreatorName

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorSelectList. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorSelectNameStartsWith]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorSelectNameStartsWith]
GO


/****** Object:  StoredProcedure [dbo].[CreatorSelectNameStartsWith]    Script Date: 10/16/2009 16:26:50 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatorSelectNameStartsWith]

@CreatorName nvarchar(255)

AS 

SET NOCOUNT ON

SELECT 

	Creator.[CreatorID],
	[CreatorName],
	[FirstNameFirst],
	[SimpleName],
	[DOB],
	[DOD],
	[Biography],
	[CreatorNote],
	[MARCDataFieldTag],
	[MARCCreator_a],
	[MARCCreator_b],
	[MARCCreator_c],
	[MARCCreator_d],
	[MARCCreator_Full],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[Creator]
WHERE
CreatorID IN (SELECT CreatorID 
				FROM Title_Creator
				INNER JOIN Title ON Title.TitleID = Title_Creator.TitleID AND Title.PublishReady=1
			)
AND
	[CreatorName] like (@CreatorName + '%') 
ORDER BY CreatorName

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorSelectByCreatorNameLike. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END





GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorSelectNameStartWith]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorSelectNameStartWith]
GO


/****** Object:  StoredProcedure [dbo].[CreatorSelectNameStartWith]    Script Date: 10/16/2009 16:26:50 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatorSelectNameStartWith]

@CreatorName nvarchar(255)

AS 

SET NOCOUNT ON

SELECT 

	Creator.[CreatorID],
	[CreatorName],
	[FirstNameFirst],
	[SimpleName],
	[DOB],
	[DOD],
	[Biography],
	[CreatorNote],
	[MARCDataFieldTag],
	[MARCCreator_a],
	[MARCCreator_b],
	[MARCCreator_c],
	[MARCCreator_d],
	[MARCCreator_Full],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[Creator]
WHERE
CreatorID IN (SELECT CreatorID 
				FROM Title_Creator
				INNER JOIN Title ON Title.TitleID = Title_Creator.TitleID AND Title.PublishReady=1
			)
AND
	[CreatorName] like (@CreatorName + '%') 
ORDER BY CreatorName

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorSelectByCreatorNameLike. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END





GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorSelectWithSuspectCharacters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorSelectWithSuspectCharacters]
GO


/****** Object:  StoredProcedure [dbo].[CreatorSelectWithSuspectCharacters]    Script Date: 10/16/2009 16:26:50 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[CreatorSelectWithSuspectCharacters]

@InstitutionCode NVARCHAR(10) = '',
@MaxAge INT = 30

AS
BEGIN

SET NOCOUNT ON

SELECT	t.TitleID,
		t.InstitutionCode,
		inst.InstitutionName,
		c.CreationDate,
		c.CreatorID,
		CHAR(dbo.fnContainsSuspectCharacter(c.CreatorName)) as NameSuspect, c.CreatorName,
		CHAR(dbo.fnContainsSuspectCharacter(c.MarcCreator_a)) as MarcASuspect, c.MarcCreator_a,
		CHAR(dbo.fnContainsSuspectCharacter(c.MarcCreator_b)) as MarcBSuspect, c.MarcCreator_b,
		CHAR(dbo.fnContainsSuspectCharacter(c.MarcCreator_c)) as MarcCSuspect, c.MarcCreator_c,
		CHAR(dbo.fnContainsSuspectCharacter(c.MarcCreator_d)) as MarcDSuspect, c.MarcCreator_d,
		CHAR(dbo.fnContainsSuspectCharacter(c.MarcCreator_Full)) as FullSuspect, c.MarcCreator_Full,
		oclc.IdentifierValue as OCLC,
		MIN(i.ZQuery) AS ZQuery
FROM	dbo.Creator c LEFT JOIN dbo.Title_Creator tc
			ON c.CreatorID = tc.CreatorID
		INNER JOIN dbo.Title t 
			ON tc.TitleID = t.TitleID
		LEFT JOIN (SELECT * FROM dbo.Title_TitleIdentifier WHERE TitleIdentifierID = 1) AS oclc
			ON t.TitleID = oclc.TitleID
		INNER JOIN dbo.TitleItem ti
			ON t.TitleID = ti.TitleID
		INNER JOIN dbo.Item i
			ON ti.ItemID = i.ItemID
		INNER JOIN dbo.Institution inst
			ON t.InstitutionCode = inst.InstitutionCode
WHERE	(dbo.fnContainsSuspectCharacter(c.CreatorName) > 0
OR		dbo.fnContainsSuspectCharacter(c.MarcCreator_a) > 0
OR		dbo.fnContainsSuspectCharacter(c.MarcCreator_b) > 0
OR		dbo.fnContainsSuspectCharacter(c.MarcCreator_c) > 0
OR		dbo.fnContainsSuspectCharacter(c.MarcCreator_d) > 0
OR		dbo.fnContainsSuspectCharacter(c.MarcCreator_Full) > 0)
AND		(t.InstitutionCode = @InstitutionCode OR @InstitutionCode = '')
AND		c.CreationDate > DATEADD(dd, (@MaxAge * -1), GETDATE())
GROUP BY 
		c.CreatorID,
		t.InstitutionCode,
		inst.InstitutionName,
		c.CreationDate,
		CHAR(dbo.fnContainsSuspectCharacter(c.CreatorName)), c.CreatorName,
		CHAR(dbo.fnContainsSuspectCharacter(c.MarcCreator_a)), c.MarcCreator_a,
		CHAR(dbo.fnContainsSuspectCharacter(c.MarcCreator_b)),  c.MarcCreator_b,
		CHAR(dbo.fnContainsSuspectCharacter(c.MarcCreator_c)), c.MarcCreator_c,
		CHAR(dbo.fnContainsSuspectCharacter(c.MarcCreator_d)), c.MarcCreator_d, 
		CHAR(dbo.fnContainsSuspectCharacter(c.MarcCreator_Full)), c.MarcCreator_Full,
		t.TitleID, 
		oclc.IdentifierValue
ORDER BY
		inst.InstitutionName, c.CreationDate DESC
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[CreatorUpdateAuto]    Script Date: 10/16/2009 16:26:51 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- CreatorUpdateAuto PROCEDURE
-- Generated 4/4/2008 2:40:57 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for Creator

CREATE PROCEDURE CreatorUpdateAuto

@CreatorID INT /* Unique identifier for each Creator record. */,
@CreatorName NVARCHAR(255) /* Creator name in last name first order. */,
@FirstNameFirst NVARCHAR(255) /* Creator name in first name first order. */,
@SimpleName NVARCHAR(255) /* Name using simple English alphabet (first name first). */,
@DOB NVARCHAR(50) /* Creator's date of birth. */,
@DOD NVARCHAR(50) /* Creator's date of death. */,
@Biography NTEXT /* Biography of the Creator. */,
@CreatorNote NVARCHAR(255) /* Notes about this Creator. */,
@MARCDataFieldTag NVARCHAR(3) /* MARC XML DataFieldTag providing this record. */,
@MARCCreator_a NVARCHAR(450) /* "a" field from MARC XML */,
@MARCCreator_b NVARCHAR(450) /* "b" field from MARC XML */,
@MARCCreator_c NVARCHAR(450) /* "c" field from MARC XML */,
@MARCCreator_d NVARCHAR(450) /* "d" field from MARC XML */,
@MARCCreator_Full NVARCHAR(450) /* "Full" Creator information from MARC XML */

AS 

SET NOCOUNT ON

UPDATE [dbo].[Creator]

SET

	[CreatorName] = @CreatorName,
	[FirstNameFirst] = @FirstNameFirst,
	[SimpleName] = @SimpleName,
	[DOB] = @DOB,
	[DOD] = @DOD,
	[Biography] = @Biography,
	[CreatorNote] = @CreatorNote,
	[MARCDataFieldTag] = @MARCDataFieldTag,
	[MARCCreator_a] = @MARCCreator_a,
	[MARCCreator_b] = @MARCCreator_b,
	[MARCCreator_c] = @MARCCreator_c,
	[MARCCreator_d] = @MARCCreator_d,
	[MARCCreator_Full] = @MARCCreator_Full,
	[LastModifiedDate] = getdate()

WHERE
	[CreatorID] = @CreatorID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[CreatorID],
		[CreatorName],
		[FirstNameFirst],
		[SimpleName],
		[DOB],
		[DOD],
		[Biography],
		[CreatorNote],
		[MARCDataFieldTag],
		[MARCCreator_a],
		[MARCCreator_b],
		[MARCCreator_c],
		[MARCCreator_d],
		[MARCCreator_Full],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[Creator]
	
	WHERE
		[CreatorID] = @CreatorID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorSelectByTitleId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorSelectByTitleId]
GO


/****** Object:  StoredProcedure [dbo].[CreatorSelectByTitleId]    Script Date: 10/16/2009 16:26:51 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatorSelectByTitleId]
@TitleID int
AS 

SET NOCOUNT ON

SELECT DISTINCT
		v.CreatorID,
		v.MARCCreator_Full,
		tc.CreatorRoleTypeID
FROM	dbo.PrimaryTitleCreatorView v INNER JOIN Title_Creator tc
			ON v.TitleID = tc.TitleID
			AND v.CreatorID = tc.CreatorID
WHERE	v.PrimaryTitleID = @TitleID
UNION
SELECT DISTINCT
		v.CreatorID,
		v.MARCCreator_Full,
		tc.CreatorRoleTypeID
FROM	dbo.PrimaryTitleCreatorView v INNER JOIN Title_Creator tc
			ON v.TitleID = tc.TitleID
			AND v.CreatorID = tc.CreatorID
WHERE	v.TitleID = @TitleID
ORDER BY v.MARCCreator_Full

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure [CreatorSelectByTitleId]. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSelectByBarCodeAndSequence]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSelectByBarCodeAndSequence]
GO


/****** Object:  StoredProcedure [dbo].[PageSelectByBarCodeAndSequence]    Script Date: 10/16/2009 16:26:51 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSelectByBarCodeAndSequence]

@BarCode nvarchar(40),
@SequenceOrder int

AS 

SET NOCOUNT ON

SELECT 

	p.[PageID],
	p.[ItemID],
	p.[FileNamePrefix],
	p.[SequenceOrder],
	p.[PageDescription],
	p.[Illustration],
	p.[Note],
	p.[FileSize_Temp],
	p.[FileExtension],
	p.[CreationDate],
	p.[LastModifiedDate],
	p.[CreationUserID],
	p.[LastModifiedUserID],
	p.[Active],
	p.[Year],
	p.[Series],
	p.[Volume],
	p.[Issue],
	p.[ExternalURL],
	p.[AltExternalURL],
	p.[IssuePrefix]

FROM [dbo].[Page] p
JOIN [dbo].[Item] i on p.ItemID = i.ItemID

WHERE
	i.BarCode = @BarCode AND
	p.SequenceOrder = @SequenceOrder

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSelectByBarCodeAndSequence. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorSelectByInstitution]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorSelectByInstitution]
GO


/****** Object:  StoredProcedure [dbo].[CreatorSelectByInstitution]    Script Date: 10/16/2009 16:26:52 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatorSelectByInstitution]

@InstitutionCode nvarchar(10) = '',
@LanguageCode nvarchar(10) = ''

AS 

SET NOCOUNT ON

SELECT 
	[CreatorID],
	[CreatorName],
	[DOB],
	[DOD],
	[MARCCreator_a],
	[MARCCreator_b]
FROM [dbo].[Creator]
WHERE
	[CreatorID] IN (	SELECT DISTINCT v.CreatorID
						FROM dbo.PrimaryTitleCreatorView v LEFT JOIN dbo.TitleLanguage tl
								ON v.TitleID = tl.TitleID
							LEFT JOIN dbo.ItemLanguage il
								ON v.ItemID = il.ItemID
						WHERE (v.TitleInstitutionCode = @InstitutionCode OR 
								v.ItemInstitutionCode = @InstitutionCode OR 
								@InstitutionCode = '')
						AND	(v.TitleLanguageCode = @LanguageCode OR
								v.ItemInstitutionCode = @LanguageCode OR
								ISNULL(tl.LanguageCode, '') = @LanguageCode OR
								ISNULL(il.LanguageCode, '') = @LanguageCode OR
								@LanguageCode = '')
						AND v.PublishReady = 1
			)
AND CreatorName <> ''
ORDER BY MARCCreator_a, MARCCreator_b, MARCCreator_c, MARCCreator_d

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorSelectByInstitution. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorSelectByCreatorNameLikeAndInstitution]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorSelectByCreatorNameLikeAndInstitution]
GO


/****** Object:  StoredProcedure [dbo].[CreatorSelectByCreatorNameLikeAndInstitution]    Script Date: 10/16/2009 16:26:52 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatorSelectByCreatorNameLikeAndInstitution]

@CreatorName nvarchar(255),
@InstitutionCode nvarchar(10) = '',
@LanguageCode nvarchar(10) = ''

AS 

SET NOCOUNT ON

SELECT DISTINCT
		v.CreatorID,
		v.CreatorName, 
		v.MARCCreator_a, 
		v.MARCCreator_b, 
		v.MARCCreator_c,
		v.MARCCreator_d,
		v.DOB, 
		v.DOD
FROM	dbo.PrimaryTitleCreatorView v LEFT JOIN dbo.TitleLanguage tl
			ON v.TitleID = tl.TitleID
		LEFT JOIN dbo.ItemLanguage il
			ON v.ItemID = il.ItemID
WHERE	v.CreatorName LIKE (@CreatorName + '%')
AND		(v.TitleInstitutionCode = @InstitutionCode OR 
		 v.ItemInstitutionCode = @InstitutionCode OR 
		 @InstitutionCode = '')
AND		(v.TitleLanguageCode = @LanguageCode OR
		 v.ItemLanguageCode = @LanguageCode OR
		 ISNULL(tl.LanguageCode, '') = @LanguageCode OR
		 ISNULL(il.LanguageCode, '') = @LanguageCode OR
		 @LanguageCode = '')
AND		v.PublishReady = 1
ORDER BY v.MARCCreator_a, v.MARCCreator_b, v.MARCCreator_c, v.MARCCreator_d ASC

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorSelectByCreatorNameLikeAndInstitution. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorSelectByCreatorNameLike]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorSelectByCreatorNameLike]
GO


/****** Object:  StoredProcedure [dbo].[CreatorSelectByCreatorNameLike]    Script Date: 10/16/2009 16:26:53 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatorSelectByCreatorNameLike]

@CreatorName nvarchar(255),
@LanguageCode nvarchar(10) = '',
@IncludeSecondaryTitles char(1) = '',
@ReturnCount	int = 100

AS 

SET NOCOUNT ON

SELECT DISTINCT TOP (@ReturnCount)
		v.[CreatorID],
		v.[CreatorName],
		v.[MARCCreator_a],
		v.[MARCCreator_b],
		v.[MARCCreator_c],
		v.[MARCCreator_d],
		v.[DOB],
		v.[DOD]
FROM	dbo.PrimaryTitleCreatorView v LEFT JOIN dbo.TitleLanguage tl
			ON v.TitleID = tl.TitleID
		LEFT JOIN dbo.ItemLanguage il
			ON v.ItemID = il.ItemID
WHERE	v.[CreatorName] like (@CreatorName + '%') 
AND		v.[PublishReady]=1
AND		(v.[TitleLanguageCode] = @LanguageCode OR 
		 v.[ItemLanguageCode] = @LanguageCode OR 
		 ISNULL(tl.LanguageCode, '') = @LanguageCode OR
		 ISNULL(il.LanguageCode, '') = @LanguageCode OR
		 @LanguageCode = '')
-- 10/09/2008 MWL
-- Every creator will be associated with a primary title (directly or 
-- indirectly), so the following search criteria is not necessary.  
-- Even if the title to which an author is directly related is NOT a 
-- primary title, each of the items related to that title WILL have 
-- some other primary title, and so the creator is indirectly related
-- to that title.
--
-- Only consider Primary titles unless @IncludeSecondaryTitles = '1'
--AND		([TitleID] IN (SELECT DISTINCT PrimaryTitleID FROM dbo.Item) OR 
--		 [PrimaryTitleID] IN (SELECT DISTINCT PrimaryTitleID FROM dbo.Item) OR 
--		@IncludeSecondaryTitles = '1')
ORDER BY 
		[MARCCreator_a], [MARCCreator_b],
		[MARCCreator_c], [MARCCreator_d] ASC

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorSelectByCreatorNameLike. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorSelectByCreatorName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorSelectByCreatorName]
GO


/****** Object:  StoredProcedure [dbo].[CreatorSelectByCreatorName]    Script Date: 10/16/2009 16:26:53 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatorSelectByCreatorName]

@CreatorName nvarchar(255)

AS 

SET NOCOUNT ON

SELECT 

	[CreatorID],
	[CreatorName],
	[FirstNameFirst],
	[SimpleName],
	[DOB],
	[DOD],
	[Biography],
	[CreatorNote],
	[MARCDataFieldTag],
	[MARCCreator_a],
	[MARCCreator_b],
	[MARCCreator_c],
	[MARCCreator_d],
	[MARCCreator_Full],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[Creator]

WHERE
	[CreatorName] = @CreatorName

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorSelectByCreatorName. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[CreatorSelectAuto]    Script Date: 10/16/2009 16:26:53 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- CreatorSelectAuto PROCEDURE
-- Generated 4/4/2008 2:40:57 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for Creator

CREATE PROCEDURE CreatorSelectAuto

@CreatorID INT /* Unique identifier for each Creator record. */

AS 

SET NOCOUNT ON

SELECT 

	[CreatorID],
	[CreatorName],
	[FirstNameFirst],
	[SimpleName],
	[DOB],
	[DOD],
	[Biography],
	[CreatorNote],
	[MARCDataFieldTag],
	[MARCCreator_a],
	[MARCCreator_b],
	[MARCCreator_c],
	[MARCCreator_d],
	[MARCCreator_Full],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[Creator]

WHERE
	[CreatorID] = @CreatorID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[CreatorSelectAll]    Script Date: 10/16/2009 16:26:54 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CreatorSelectAll]
AS 

SET NOCOUNT ON

SELECT 
	[CreatorID],
	[CreatorName],
	[FirstNameFirst],
	[SimpleName],
	[DOB],
	[DOD],
	[Biography],
	[CreatorNote],
	[MARCDataFieldTag],
	[MARCCreator_a],
	[MARCCreator_b],
	[MARCCreator_c],
	[MARCCreator_d],
	[MARCCreator_Full],
	[CreationDate],
	[LastModifiedDate]
FROM [dbo].[Creator]
ORDER BY CreatorName 

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorRoleTypeUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorRoleTypeUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[CreatorRoleTypeUpdateAuto]    Script Date: 10/16/2009 16:26:55 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- CreatorRoleTypeUpdateAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for CreatorRoleType

CREATE PROCEDURE CreatorRoleTypeUpdateAuto

@CreatorRoleTypeID INT /* Unique identifier for each Creator Role Type. */,
@CreatorRoleType NVARCHAR(25) /* A type of Role performed by a Creator. */,
@CreatorRoleTypeDescription NVARCHAR(255) /* Description of a Creator Role Type. */,
@MARCDataFieldTag NVARCHAR(3) /* Data Field Tag from MARC XML. */

AS 

SET NOCOUNT ON

UPDATE [dbo].[CreatorRoleType]

SET

	[CreatorRoleTypeID] = @CreatorRoleTypeID,
	[CreatorRoleType] = @CreatorRoleType,
	[CreatorRoleTypeDescription] = @CreatorRoleTypeDescription,
	[MARCDataFieldTag] = @MARCDataFieldTag

WHERE
	[CreatorRoleTypeID] = @CreatorRoleTypeID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorRoleTypeUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[CreatorRoleTypeID],
		[CreatorRoleType],
		[CreatorRoleTypeDescription],
		[MARCDataFieldTag]

	FROM [dbo].[CreatorRoleType]
	
	WHERE
		[CreatorRoleTypeID] = @CreatorRoleTypeID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorRoleTypeSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorRoleTypeSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[CreatorRoleTypeSelectAuto]    Script Date: 10/16/2009 16:26:56 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- CreatorRoleTypeSelectAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for CreatorRoleType

CREATE PROCEDURE CreatorRoleTypeSelectAuto

@CreatorRoleTypeID INT /* Unique identifier for each Creator Role Type. */

AS 

SET NOCOUNT ON

SELECT 

	[CreatorRoleTypeID],
	[CreatorRoleType],
	[CreatorRoleTypeDescription],
	[MARCDataFieldTag]

FROM [dbo].[CreatorRoleType]

WHERE
	[CreatorRoleTypeID] = @CreatorRoleTypeID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorRoleTypeSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorRoleTypeSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorRoleTypeSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[CreatorRoleTypeSelectAll]    Script Date: 10/16/2009 16:26:56 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[CreatorRoleTypeSelectAll]
AS 

SET NOCOUNT ON

SELECT 
	[CreatorRoleTypeID],
	[CreatorRoleType],
	[CreatorRoleTypeDescription],
	[MARCDataFieldTag]
FROM [dbo].[CreatorRoleType]
ORDER BY CreatorRoleTypeDescription
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorRoleTypeInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorRoleTypeInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[CreatorRoleTypeInsertAuto]    Script Date: 10/16/2009 16:26:57 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- CreatorRoleTypeInsertAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for CreatorRoleType

CREATE PROCEDURE CreatorRoleTypeInsertAuto

@CreatorRoleTypeID INT /* Unique identifier for each Creator Role Type. */,
@CreatorRoleType NVARCHAR(25) /* A type of Role performed by a Creator. */,
@CreatorRoleTypeDescription NVARCHAR(255) = null /* Description of a Creator Role Type. */,
@MARCDataFieldTag NVARCHAR(3) = null /* Data Field Tag from MARC XML. */

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[CreatorRoleType]
(
	[CreatorRoleTypeID],
	[CreatorRoleType],
	[CreatorRoleTypeDescription],
	[MARCDataFieldTag]
)
VALUES
(
	@CreatorRoleTypeID,
	@CreatorRoleType,
	@CreatorRoleTypeDescription,
	@MARCDataFieldTag
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorRoleTypeInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[CreatorRoleTypeID],
		[CreatorRoleType],
		[CreatorRoleTypeDescription],
		[MARCDataFieldTag]	

	FROM [dbo].[CreatorRoleType]
	
	WHERE
		[CreatorRoleTypeID] = @CreatorRoleTypeID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorRoleTypeDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorRoleTypeDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[CreatorRoleTypeDeleteAuto]    Script Date: 10/16/2009 16:26:57 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- CreatorRoleTypeDeleteAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for CreatorRoleType

CREATE PROCEDURE CreatorRoleTypeDeleteAuto

@CreatorRoleTypeID INT /* Unique identifier for each Creator Role Type. */

AS 

DELETE FROM [dbo].[CreatorRoleType]

WHERE

	[CreatorRoleTypeID] = @CreatorRoleTypeID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorRoleTypeDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSelectByNameBankID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSelectByNameBankID]
GO


/****** Object:  StoredProcedure [dbo].[PageSelectByNameBankID]    Script Date: 10/16/2009 16:26:58 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PageSelectByNameBankID]

@NameBankID int

AS 

SET NOCOUNT ON

-- Thumbnail viewer URLs
DECLARE @WHThumbnail nvarchar(500)
DECLARE @BotThumbnail nvarchar(500)

-- Replace {0} with ExternalUrl value
SET @WHThumbnail = 'http://whbhl01.ubio.org/adore-djatoka/resolver?url_ver=Z39.88-2004&rft_id={0}&svc_id=info:lanl-repo/svc/getRegion&svc_val_fmt=info:ofi/fmt:kev:mtx:jpeg2000&svc.format=image/jpeg&svc.scale=100'

-- Replace {0} with v.WebVirtualDirectory, {1} with i.FileRootFolder, {2} with i.BarCode {3} with p.FileNamePrefix
SET @BotThumbnail = 'http://images.biodiversitylibrary.org/adore-djatoka/resolver?url_ver=Z39.88-2004&rft_id=http://mbgserv09:8057/{0}/{1}/{2}/jp2/{3}.jp2&svc_id=info:lanl-repo/svc/getRegion&svc_val_fmt=info:ofi/fmt:kev:mtx:jpeg2000&svc.format=image/jpeg&svc.scale=100'


DECLARE @Abbreviation int
DECLARE @BPH int
DECLARE @TL2 int

SELECT @Abbreviation = TitleIdentifierID FROM TitleIdentifier WHERE IdentifierName = 'Abbreviation'
SELECT @BPH = TitleIdentifierID FROM TitleIdentifier WHERE IdentifierName = 'BPH'
SELECT @TL2 = TitleIdentifierID FROM TitleIdentifier WHERE IdentifierName = 'TL2'

-- Get the detail for the specified NameBankID
SELECT	pn.NameBankID, pn.NameConfirmed,
		t.TitleID, t.MARCBibID, t.ShortTitle, t.PublicationDetails, t.TL2Author, 
		bph.IdentifierValue AS BPH, tl2.IdentifierValue AS TL2, 
		abbrev.IdentifierValue AS Abbreviation,
		'http://www.biodiversitylibrary.org/title/' + CONVERT(nvarchar(20), t.TitleID) AS TitleURL,
		i.ItemID, i.BarCode, i.MARCItemID, i.CallNumber, i.Volume AS VolumeInfo,
		'http://www.biodiversitylibrary.org/item/' + CONVERT(nvarchar(20), i.ItemID) AS ItemURL,
		p.PageID, p.[Year], p.Volume, p.Issue,
		ip.PagePrefix, ip.PageNumber,
		'http://www.biodiversitylibrary.org/page/' + CONVERT(nvarchar(20), p.PageID) AS PageURL,
		CASE WHEN p.ExternalURL IS NOT NULL THEN 
			--''
			REPLACE(@WHThumbnail, '{0}', p.ExternalUrl)
		ELSE 
			--'http://images.mobot.org/viewer/viewerthumbnail.asp?cat=' + v.WebVirtualDirectory + '&client=' + t.MarcBibID + '/' + i.BarCode + '/jp2&image=' + p.FileNamePrefix + '.jp2' 
			REPLACE(REPLACE(REPLACE(REPLACE(@BotThumbnail, '{0}', v.WebVirtualDirectory), '{1}', i.FileRootFolder), '{2}', i.BarCode), '{3}', p.FileNamePrefix)
		END AS ThumbnailURL,
		--'http://images.biodiversitylibrary.org/adore-djatoka/viewer.jsp?cat=' + v.WebVirtualDirectory + '&client=' + t.MarcBibID + '/' + i.BarCode + '/jp2&image=' + p.FileNamePrefix + '.jp2&imageURL=' + ISNULL(p.ExternalURL, '') + '&imageDetailURL=' + ISNULL(p.AltExternalURL, '') AS ImageURL,
		REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(its.ImageServerUrlFormat, '{0}', CASE WHEN p.ExternalUrl IS NULL THEN v.WebVirtualDirectory ELSE '' END), '{1}', CASE WHEN p.ExternalUrl IS NULL THEN i.FileRootFolder + '/' + i.BarCode + '/jp2' ELSE '' END), '{2}', CASE WHEN p.ExternalUrl IS NULL THEN p.FileNamePrefix + '.jp2' ELSE '' END), '{3}', ISNULL(p.ExternalUrl, '')), '{4}', ISNULL(p.AltExternalUrl, '')), '&amp;', '&') AS ImageURL,
		pt.PageTypeName
FROM	PageName pn	INNER JOIN Page p
			ON pn.PageID = p.PageID
		INNER JOIN IndicatedPage ip
			ON p.PageID = ip.PageID
		INNER JOIN Item i
			ON p.ItemID = i.ItemID
		INNER JOIN Title t
			ON i.PrimaryTitleID = t.TitleID
		INNER JOIN Vault v
			ON i.VaultID = v.VaultID
		INNER JOIN ItemSource its
			ON i.ItemSourceID = its.ItemSourceID
		LEFT JOIN Page_PageType ppt
			ON p.PageID = ppt.PageID
		LEFT JOIN PageType pt
			ON ppt.PageTypeID = pt.PageTypeID
		LEFT JOIN Title_TitleIdentifier	abbrev
			ON t.TitleID = abbrev.TitleID AND abbrev.TitleIdentifierID = @Abbreviation
		LEFT JOIN Title_TitleIdentifier bph
			ON t.TitleID = bph.TitleID AND bph.TitleIdentifierID = @BPH
		LEFT JOIN Title_TitleIdentifier tl2 
			ON t.TitleID = tl2.TitleID AND tl2.TitleIdentifierID = @TL2
WHERE	pn.NameBankID = @NameBankID
ORDER BY
		t.SortTitle, i.ItemID, p.[Year], p.Volume, ip.PageNumber

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSelectByNameBankID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSummarySelectBarcodeForTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSummarySelectBarcodeForTitleID]
GO


/****** Object:  StoredProcedure [dbo].[PageSummarySelectBarcodeForTitleID]    Script Date: 10/16/2009 16:26:58 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PageSummarySelectBarcodeForTitleID]

@TitleID int

AS 
BEGIN

SET NOCOUNT ON

SELECT DISTINCT BarCode FROM PageSummaryView WHERE TitleID = @TitleID
UNION
SELECT DISTINCT MarcBibID FROM PageSummaryView WHERE TitleID = @TitleID

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[CreatorInsertAuto]    Script Date: 10/16/2009 16:26:58 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- CreatorInsertAuto PROCEDURE
-- Generated 4/4/2008 2:40:57 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Creator

CREATE PROCEDURE CreatorInsertAuto

@CreatorID INT OUTPUT /* Unique identifier for each Creator record. */,
@CreatorName NVARCHAR(255) /* Creator name in last name first order. */,
@FirstNameFirst NVARCHAR(255) = null /* Creator name in first name first order. */,
@SimpleName NVARCHAR(255) = null /* Name using simple English alphabet (first name first). */,
@DOB NVARCHAR(50) = null /* Creator's date of birth. */,
@DOD NVARCHAR(50) = null /* Creator's date of death. */,
@Biography NTEXT = null /* Biography of the Creator. */,
@CreatorNote NVARCHAR(255) = null /* Notes about this Creator. */,
@MARCDataFieldTag NVARCHAR(3) = null /* MARC XML DataFieldTag providing this record. */,
@MARCCreator_a NVARCHAR(450) = null /* "a" field from MARC XML */,
@MARCCreator_b NVARCHAR(450) = null /* "b" field from MARC XML */,
@MARCCreator_c NVARCHAR(450) = null /* "c" field from MARC XML */,
@MARCCreator_d NVARCHAR(450) = null /* "d" field from MARC XML */,
@MARCCreator_Full NVARCHAR(450) = null /* "Full" Creator information from MARC XML */

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Creator]
(
	[CreatorName],
	[FirstNameFirst],
	[SimpleName],
	[DOB],
	[DOD],
	[Biography],
	[CreatorNote],
	[MARCDataFieldTag],
	[MARCCreator_a],
	[MARCCreator_b],
	[MARCCreator_c],
	[MARCCreator_d],
	[MARCCreator_Full],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@CreatorName,
	@FirstNameFirst,
	@SimpleName,
	@DOB,
	@DOD,
	@Biography,
	@CreatorNote,
	@MARCDataFieldTag,
	@MARCCreator_a,
	@MARCCreator_b,
	@MARCCreator_c,
	@MARCCreator_d,
	@MARCCreator_Full,
	getdate(),
	getdate()
)

SET @CreatorID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[CreatorID],
		[CreatorName],
		[FirstNameFirst],
		[SimpleName],
		[DOB],
		[DOD],
		[Biography],
		[CreatorNote],
		[MARCDataFieldTag],
		[MARCCreator_a],
		[MARCCreator_b],
		[MARCCreator_c],
		[MARCCreator_d],
		[MARCCreator_Full],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[Creator]
	
	WHERE
		[CreatorID] = @CreatorID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[CreatorDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[CreatorDeleteAuto]    Script Date: 10/16/2009 16:26:59 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- CreatorDeleteAuto PROCEDURE
-- Generated 4/4/2008 2:40:57 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Creator

CREATE PROCEDURE CreatorDeleteAuto

@CreatorID INT /* Unique identifier for each Creator record. */

AS 

DELETE FROM [dbo].[Creator]

WHERE

	[CreatorID] = @CreatorID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure CreatorDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSelectWithoutPageNamesByItemID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSelectWithoutPageNamesByItemID]
GO


/****** Object:  StoredProcedure [dbo].[PageSelectWithoutPageNamesByItemID]    Script Date: 10/16/2009 16:27:00 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSelectWithoutPageNamesByItemID]

@ItemID INT

AS 

SET NOCOUNT ON

SELECT 
	[PageID],
	[FileNamePrefix]
FROM [dbo].[Page]
WHERE
	[ItemID] = @ItemID
AND	[Active] = 1
AND	[LastPageNameLookupDate] IS NULL
ORDER BY
	[SequenceOrder] ASC

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSelectWithoutPageNamesByItemID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IndicatedPageDeleteAllForPage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[IndicatedPageDeleteAllForPage]
GO


/****** Object:  StoredProcedure [dbo].[IndicatedPageDeleteAllForPage]    Script Date: 10/16/2009 16:27:00 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[IndicatedPageDeleteAllForPage]

@PageID INT /* Unique identifier for each Page record. */
AS 

DELETE FROM [dbo].[IndicatedPage]

WHERE

	[PageID] = @PageID 

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure IndicatedPageDeleteAllForPage. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IndicatedPageDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[IndicatedPageDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[IndicatedPageDeleteAuto]    Script Date: 10/16/2009 16:27:00 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- IndicatedPageDeleteAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for IndicatedPage

CREATE PROCEDURE IndicatedPageDeleteAuto

@PageID INT /* Unique identifier for each Page record. */,
@Sequence SMALLINT /* A number to separately identify various series of Indicated Pages. */

AS 

DELETE FROM [dbo].[IndicatedPage]

WHERE

	[PageID] = @PageID AND
	[Sequence] = @Sequence

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure IndicatedPageDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IndicatedPageInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[IndicatedPageInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[IndicatedPageInsertAuto]    Script Date: 10/16/2009 16:27:01 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- IndicatedPageInsertAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for IndicatedPage

CREATE PROCEDURE IndicatedPageInsertAuto

@PageID INT /* Unique identifier for each Page record. */,
@Sequence SMALLINT /* A number to separately identify various series of Indicated Pages. */,
@PagePrefix NVARCHAR(20) = null /* Prefix portion of Indicated Page. */,
@PageNumber NVARCHAR(20) = null /* Page Number portion of Indicated Page. */,
@Implied BIT,
@CreationUserID INT = null,
@LastModifiedUserID INT = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[IndicatedPage]
(
	[PageID],
	[Sequence],
	[PagePrefix],
	[PageNumber],
	[Implied],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID]
)
VALUES
(
	@PageID,
	@Sequence,
	@PagePrefix,
	@PageNumber,
	@Implied,
	getdate(),
	getdate(),
	@CreationUserID,
	@LastModifiedUserID
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure IndicatedPageInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PageID],
		[Sequence],
		[PagePrefix],
		[PageNumber],
		[Implied],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID]	

	FROM [dbo].[IndicatedPage]
	
	WHERE
		[PageID] = @PageID AND
		[Sequence] = @Sequence
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IndicatedPageInsertNext]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[IndicatedPageInsertNext]
GO


/****** Object:  StoredProcedure [dbo].[IndicatedPageInsertNext]    Script Date: 10/16/2009 16:27:01 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[IndicatedPageInsertNext]

@PageID INT /* Unique identifier for each Page record. */,
@PagePrefix NVARCHAR(20) = null /* Prefix portion of Indicated Page. */,
@PageNumber NVARCHAR(20) = null /* Page Number portion of Indicated Page. */,
@Implied BIT,
@CreationUserID INT = null,
@LastModifiedUserID INT = null

AS 

SET NOCOUNT ON

DECLARE @Sequence SMALLINT /* A number to separately identify various series of Indicated Pages. */

SELECT @Sequence = MAX(Sequence) 
FROM [dbo].[IndicatedPage]
WHERE PageID = @PageID

IF (@Sequence IS NULL) SELECT @Sequence = 1
ELSE SELECT @Sequence = @Sequence + 1

INSERT INTO [dbo].[IndicatedPage]
(
	[PageID],
	[Sequence],
	[PagePrefix],
	[PageNumber],
	[Implied],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID]
)
VALUES
(
	@PageID,
	@Sequence,
	@PagePrefix,
	@PageNumber,
	@Implied,
	getdate(),
	getdate(),
	@CreationUserID,
	@LastModifiedUserID
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure IndicatedPageInsertNext. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PageID],
		[Sequence],
		[PagePrefix],
		[PageNumber],
		[Implied],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID]		

	FROM [dbo].[IndicatedPage]
	
	WHERE
		[PageID] = @PageID AND
		[Sequence] = @Sequence
	
	RETURN -- insert successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IndicatedPageSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[IndicatedPageSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[IndicatedPageSelectAuto]    Script Date: 10/16/2009 16:27:02 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- IndicatedPageSelectAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for IndicatedPage

CREATE PROCEDURE IndicatedPageSelectAuto

@PageID INT /* Unique identifier for each Page record. */,
@Sequence SMALLINT /* A number to separately identify various series of Indicated Pages. */

AS 

SET NOCOUNT ON

SELECT 

	[PageID],
	[Sequence],
	[PagePrefix],
	[PageNumber],
	[Implied],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID]

FROM [dbo].[IndicatedPage]

WHERE
	[PageID] = @PageID AND
	[Sequence] = @Sequence

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure IndicatedPageSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IndicatedPageUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[IndicatedPageUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[IndicatedPageUpdateAuto]    Script Date: 10/16/2009 16:27:02 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- IndicatedPageUpdateAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for IndicatedPage

CREATE PROCEDURE IndicatedPageUpdateAuto

@PageID INT /* Unique identifier for each Page record. */,
@Sequence SMALLINT /* A number to separately identify various series of Indicated Pages. */,
@PagePrefix NVARCHAR(20) /* Prefix portion of Indicated Page. */,
@PageNumber NVARCHAR(20) /* Page Number portion of Indicated Page. */,
@Implied BIT,
@LastModifiedUserID INT

AS 

SET NOCOUNT ON

UPDATE [dbo].[IndicatedPage]

SET

	[PageID] = @PageID,
	[Sequence] = @Sequence,
	[PagePrefix] = @PagePrefix,
	[PageNumber] = @PageNumber,
	[Implied] = @Implied,
	[LastModifiedDate] = getdate(),
	[LastModifiedUserID] = @LastModifiedUserID

WHERE
	[PageID] = @PageID AND
	[Sequence] = @Sequence
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure IndicatedPageUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PageID],
		[Sequence],
		[PagePrefix],
		[PageNumber],
		[Implied],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID]

	FROM [dbo].[IndicatedPage]
	
	WHERE
		[PageID] = @PageID AND 
		[Sequence] = @Sequence
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSummarySelectByBarcode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSummarySelectByBarcode]
GO


/****** Object:  StoredProcedure [dbo].[PageSummarySelectByBarcode]    Script Date: 10/16/2009 16:27:02 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSummarySelectByBarcode]
@Barcode	nvarchar(40)
AS 

SET NOCOUNT ON

	SELECT MARCBibID, TitleID, FullTitle, PartNumber, PartName, RareBooks, 
		ItemStatusID, ItemID, BarCode, PageID, FileNamePrefix, PageDescription, SequenceOrder, 
		Illustration, PDFSize, ShortTitle, Volume, WebVirtualDirectory,
		OCRFolderShare, ExternalURL, AltExternalURL, DownloadUrl, FileRootFolder
	FROM PageSummaryView
	WHERE Barcode = @Barcode AND SequenceOrder=1 AND Active=1
	ORDER BY SortTitle

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSummarySelectByBarcode. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InstitutionDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[InstitutionDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[InstitutionDeleteAuto]    Script Date: 10/16/2009 16:27:03 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- InstitutionDeleteAuto PROCEDURE
-- Generated 10/15/2009 3:36:51 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Institution

CREATE PROCEDURE InstitutionDeleteAuto

@InstitutionCode NVARCHAR(10) /* Code for Institution providing assistance. */

AS 

DELETE FROM [dbo].[Institution]

WHERE

	[InstitutionCode] = @InstitutionCode

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure InstitutionDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InstitutionInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[InstitutionInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[InstitutionInsertAuto]    Script Date: 10/16/2009 16:27:03 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- InstitutionInsertAuto PROCEDURE
-- Generated 10/15/2009 3:36:51 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Institution

CREATE PROCEDURE InstitutionInsertAuto

@InstitutionCode NVARCHAR(10) /* Code for Institution providing assistance. */,
@InstitutionName NVARCHAR(255) /* Name for the Institution. */,
@Note NVARCHAR(255) = null /* Notes about this Institution. */,
@InstitutionUrl NVARCHAR(255) = null,
@BHLMemberLibrary BIT

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Institution]
(
	[InstitutionCode],
	[InstitutionName],
	[Note],
	[InstitutionUrl],
	[BHLMemberLibrary]
)
VALUES
(
	@InstitutionCode,
	@InstitutionName,
	@Note,
	@InstitutionUrl,
	@BHLMemberLibrary
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure InstitutionInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[InstitutionCode],
		[InstitutionName],
		[Note],
		[InstitutionUrl],
		[BHLMemberLibrary]	

	FROM [dbo].[Institution]
	
	WHERE
		[InstitutionCode] = @InstitutionCode
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InstitutionSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[InstitutionSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[InstitutionSelectAll]    Script Date: 10/16/2009 16:27:04 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InstitutionSelectAll]

AS 

SET NOCOUNT ON

SELECT 

	[InstitutionCode],
	[InstitutionName],
[InstitutionUrl],
	[Note]

FROM [dbo].[Institution]
ORDER BY [InstitutionCode]

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure InstitutionSelectAll. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END




GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InstitutionSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[InstitutionSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[InstitutionSelectAuto]    Script Date: 10/16/2009 16:27:04 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- InstitutionSelectAuto PROCEDURE
-- Generated 10/15/2009 3:36:51 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for Institution

CREATE PROCEDURE InstitutionSelectAuto

@InstitutionCode NVARCHAR(10) /* Code for Institution providing assistance. */

AS 

SET NOCOUNT ON

SELECT 

	[InstitutionCode],
	[InstitutionName],
	[Note],
	[InstitutionUrl],
	[BHLMemberLibrary]

FROM [dbo].[Institution]

WHERE
	[InstitutionCode] = @InstitutionCode

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure InstitutionSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InstitutionSelectByItemID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[InstitutionSelectByItemID]
GO


/****** Object:  StoredProcedure [dbo].[InstitutionSelectByItemID]    Script Date: 10/16/2009 16:27:05 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[InstitutionSelectByItemID]

@ItemID int

AS 

SET NOCOUNT ON

SELECT 

	[Institution].[InstitutionCode],
	[Institution].[InstitutionName],
	[Institution].[Note],
	[Institution].[InstitutionUrl]

FROM [dbo].[Item]
JOIN [dbo].[Institution] ON [Item].[InstitutionCode] = [Institution].[InstitutionCode]

WHERE
	[Item].[ItemID] = @ItemID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure InstitutionSelectByItemID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InstitutionSelectWithPublishedItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[InstitutionSelectWithPublishedItems]
GO


/****** Object:  StoredProcedure [dbo].[InstitutionSelectWithPublishedItems]    Script Date: 10/16/2009 16:27:05 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[InstitutionSelectWithPublishedItems]

@OnlyMemberLibraries bit = 1

AS 

SET NOCOUNT ON

SELECT DISTINCT 
		ins.InstitutionCode,
		ins.InstitutionName,
		ins.Note,
		ins.InstitutionUrl
FROM	dbo.Institution ins INNER JOIN dbo.Item it 
			ON ins.InstitutionCode = it.InstitutionCode
WHERE	it.ItemStatusID = 40
AND		((ins.BHLMemberLibrary = 1 AND @OnlyMemberLibraries = 1) OR	@OnlyMemberLibraries = 0)
ORDER BY
		ins.InstitutionName

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure InstitutionSelectWithPublishedItems. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[InstitutionUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[InstitutionUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[InstitutionUpdateAuto]    Script Date: 10/16/2009 16:27:05 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- InstitutionUpdateAuto PROCEDURE
-- Generated 10/15/2009 3:36:51 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for Institution

CREATE PROCEDURE InstitutionUpdateAuto

@InstitutionCode NVARCHAR(10) /* Code for Institution providing assistance. */,
@InstitutionName NVARCHAR(255) /* Name for the Institution. */,
@Note NVARCHAR(255) /* Notes about this Institution. */,
@InstitutionUrl NVARCHAR(255),
@BHLMemberLibrary BIT

AS 

SET NOCOUNT ON

UPDATE [dbo].[Institution]

SET

	[InstitutionCode] = @InstitutionCode,
	[InstitutionName] = @InstitutionName,
	[Note] = @Note,
	[InstitutionUrl] = @InstitutionUrl,
	[BHLMemberLibrary] = @BHLMemberLibrary

WHERE
	[InstitutionCode] = @InstitutionCode
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure InstitutionUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[InstitutionCode],
		[InstitutionName],
		[Note],
		[InstitutionUrl],
		[BHLMemberLibrary]

	FROM [dbo].[Institution]
	
	WHERE
		[InstitutionCode] = @InstitutionCode
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSummarySelectByPrefix]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSummarySelectByPrefix]
GO


/****** Object:  StoredProcedure [dbo].[PageSummarySelectByPrefix]    Script Date: 10/16/2009 16:27:06 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSummarySelectByPrefix]
@Prefix	varchar(50)
AS 

SET NOCOUNT ON

	SELECT MARCBibID, TitleID, FullTitle, PartNumber, PartName, RareBooks, 
		ItemStatusID, ItemID, BarCode, PageID, FileNamePrefix, PageDescription, SequenceOrder, 
		Illustration, PDFSize, ShortTitle, Volume, WebVirtualDirectory,
		OCRFolderShare, ExternalURL, AltExternalURL, DownloadUrl, FileRootFolder
	FROM PageSummaryView
	WHERE FileNamePrefix = @Prefix

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSummarySelectByPrefix. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemCOinSSelectByItemID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemCOinSSelectByItemID]
GO


/****** Object:  StoredProcedure [dbo].[ItemCOinSSelectByItemID]    Script Date: 10/16/2009 16:27:06 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ItemCOinSSelectByItemID]

@ItemID int

AS

BEGIN

SET NOCOUNT ON

SELECT DISTINCT 
		TitleID
		,ItemID
		,lccn
		,oclc
		,rft_title
		,rft_stitle
		,rft_volume
		,rft_language
		,rft_isbn
		,rft_aulast
		,rft_aufirst
		,rft_au_BOOK
		,rft_au_DC
		,rft_aucorp
		,rft_place
		,rft_pub
		,rft_publisher
		,rft_date_ITEM
		,rft_date_TITLE
		,rft_edition
		,rft_tpages
		,rft_issn
		,rft_coden
		,rft_subject
		,rft_contributor_ITEM
		,rft_contributor_TITLE
		,rft_genre
FROM	dbo.ItemCOinSView
WHERE	ItemID = @ItemID

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemCOinSSelectByTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemCOinSSelectByTitleID]
GO


/****** Object:  StoredProcedure [dbo].[ItemCOinSSelectByTitleID]    Script Date: 10/16/2009 16:27:06 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ItemCOinSSelectByTitleID]

@TitleID int

AS

BEGIN

SET NOCOUNT ON

SELECT DISTINCT 
		TitleID
		,ItemID
		,lccn
		,oclc
		,rft_title
		,rft_stitle
		,rft_volume
		,rft_language
		,rft_isbn
		,rft_aulast
		,rft_aufirst
		,rft_au_BOOK
		,rft_au_DC
		,rft_aucorp
		,rft_place
		,rft_pub
		,rft_publisher
		,rft_date_ITEM
		,rft_date_TITLE
		,rft_edition
		,rft_tpages
		,rft_issn
		,rft_coden
		,rft_subject
		,rft_contributor_ITEM
		,rft_contributor_TITLE
		,rft_genre
FROM	dbo.ItemCOinSView
WHERE	TitleID = @TitleID

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaultUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[VaultUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[VaultUpdateAuto]    Script Date: 10/16/2009 16:27:07 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- VaultUpdateAuto PROCEDURE
-- Generated 1/24/2008 10:03:58 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for Vault

CREATE PROCEDURE VaultUpdateAuto

@VaultID INT /* Unique identifier for each Vault entry. */,
@Server NVARCHAR(30) /* Name of server for this Vault entry. */,
@FolderShare NVARCHAR(30) /* Name for the folder share for this Vault entry. */,
@WebVirtualDirectory NVARCHAR(30) /* Name for the Web Virtual Directory for this Vault entry. */,
@OCRFolderShare NVARCHAR(100)

AS 

SET NOCOUNT ON

UPDATE [dbo].[Vault]

SET

	[VaultID] = @VaultID,
	[Server] = @Server,
	[FolderShare] = @FolderShare,
	[WebVirtualDirectory] = @WebVirtualDirectory,
	[OCRFolderShare] = @OCRFolderShare

WHERE
	[VaultID] = @VaultID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure VaultUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[VaultID],
		[Server],
		[FolderShare],
		[WebVirtualDirectory],
		[OCRFolderShare]

	FROM [dbo].[Vault]
	
	WHERE
		[VaultID] = @VaultID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[ItemDeleteAuto]    Script Date: 10/16/2009 16:27:07 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ItemDeleteAuto PROCEDURE
-- Generated 12/18/2008 5:26:54 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Item

CREATE PROCEDURE ItemDeleteAuto

@ItemID INT

AS 

DELETE FROM [dbo].[Item]

WHERE

	[ItemID] = @ItemID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[ItemInsertAuto]    Script Date: 10/16/2009 16:27:07 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ItemInsertAuto PROCEDURE
-- Generated 12/18/2008 5:26:54 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Item

CREATE PROCEDURE ItemInsertAuto

@ItemID INT OUTPUT,
@PrimaryTitleID INT,
@BarCode NVARCHAR(40),
@MARCItemID NVARCHAR(50) = null,
@CallNumber NVARCHAR(100) = null,
@Volume NVARCHAR(100) = null,
@InstitutionCode NVARCHAR(10) = null,
@LanguageCode NVARCHAR(10) = null,
@Sponsor NVARCHAR(100) = null,
@ItemDescription NTEXT = null,
@ScannedBy INT = null,
@PDFSize INT = null,
@VaultID INT = null,
@NumberOfFiles SMALLINT = null,
@Note NVARCHAR(255) = null,
@CreationUserID INT = null,
@LastModifiedUserID INT = null,
@ItemStatusID INT,
@ScanningUser NVARCHAR(100) = null,
@ScanningDate DATETIME = null,
@PaginationCompleteUserID INT = null,
@PaginationCompleteDate DATETIME = null,
@PaginationStatusID INT = null,
@PaginationStatusUserID INT = null,
@PaginationStatusDate DATETIME = null,
@LastPageNameLookupDate DATETIME = null,
@ItemSourceID INT = null,
@Year NVARCHAR(20) = null,
@IdentifierBib NVARCHAR(50) = null,
@FileRootFolder NVARCHAR(250) = null,
@ZQuery NVARCHAR(200) = null,
@LicenseUrl NVARCHAR(MAX) = null,
@Rights NVARCHAR(MAX) = null,
@DueDiligence NVARCHAR(MAX) = null,
@CopyrightStatus NVARCHAR(MAX) = null,
@CopyrightRegion NVARCHAR(50) = null,
@CopyrightComment NVARCHAR(MAX) = null,
@CopyrightEvidence NVARCHAR(MAX) = null,
@CopyrightEvidenceOperator NVARCHAR(100) = null,
@CopyrightEvidenceDate NVARCHAR(30) = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Item]
(
	[PrimaryTitleID],
	[BarCode],
	[MARCItemID],
	[CallNumber],
	[Volume],
	[InstitutionCode],
	[LanguageCode],
	[Sponsor],
	[ItemDescription],
	[ScannedBy],
	[PDFSize],
	[VaultID],
	[NumberOfFiles],
	[Note],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID],
	[ItemStatusID],
	[ScanningUser],
	[ScanningDate],
	[PaginationCompleteUserID],
	[PaginationCompleteDate],
	[PaginationStatusID],
	[PaginationStatusUserID],
	[PaginationStatusDate],
	[LastPageNameLookupDate],
	[ItemSourceID],
	[Year],
	[IdentifierBib],
	[FileRootFolder],
	[ZQuery],
	[LicenseUrl],
	[Rights],
	[DueDiligence],
	[CopyrightStatus],
	[CopyrightRegion],
	[CopyrightComment],
	[CopyrightEvidence],
	[CopyrightEvidenceOperator],
	[CopyrightEvidenceDate]
)
VALUES
(
	@PrimaryTitleID,
	@BarCode,
	@MARCItemID,
	@CallNumber,
	@Volume,
	@InstitutionCode,
	@LanguageCode,
	@Sponsor,
	@ItemDescription,
	@ScannedBy,
	@PDFSize,
	@VaultID,
	@NumberOfFiles,
	@Note,
	getdate(),
	getdate(),
	@CreationUserID,
	@LastModifiedUserID,
	@ItemStatusID,
	@ScanningUser,
	@ScanningDate,
	@PaginationCompleteUserID,
	@PaginationCompleteDate,
	@PaginationStatusID,
	@PaginationStatusUserID,
	@PaginationStatusDate,
	@LastPageNameLookupDate,
	@ItemSourceID,
	@Year,
	@IdentifierBib,
	@FileRootFolder,
	@ZQuery,
	@LicenseUrl,
	@Rights,
	@DueDiligence,
	@CopyrightStatus,
	@CopyrightRegion,
	@CopyrightComment,
	@CopyrightEvidence,
	@CopyrightEvidenceOperator,
	@CopyrightEvidenceDate
)

SET @ItemID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[ItemID],
		[PrimaryTitleID],
		[BarCode],
		[MARCItemID],
		[CallNumber],
		[Volume],
		[InstitutionCode],
		[LanguageCode],
		[Sponsor],
		[ItemDescription],
		[ScannedBy],
		[PDFSize],
		[VaultID],
		[NumberOfFiles],
		[Note],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID],
		[ItemStatusID],
		[ScanningUser],
		[ScanningDate],
		[PaginationCompleteUserID],
		[PaginationCompleteDate],
		[PaginationStatusID],
		[PaginationStatusUserID],
		[PaginationStatusDate],
		[LastPageNameLookupDate],
		[ItemSourceID],
		[Year],
		[IdentifierBib],
		[FileRootFolder],
		[ZQuery],
		[LicenseUrl],
		[Rights],
		[DueDiligence],
		[CopyrightStatus],
		[CopyrightRegion],
		[CopyrightComment],
		[CopyrightEvidence],
		[CopyrightEvidenceOperator],
		[CopyrightEvidenceDate]	

	FROM [dbo].[Item]
	
	WHERE
		[ItemID] = @ItemID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaultSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[VaultSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[VaultSelectAll]    Script Date: 10/16/2009 16:27:08 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[VaultSelectAll]
AS 

SET NOCOUNT ON

SELECT 
	[VaultID],
	[Server],
	[FolderShare],
	[WebVirtualDirectory],
	[OCRFolderShare]
FROM [dbo].[Vault]
order by Server, FolderShare

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemLanguageDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemLanguageDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[ItemLanguageDeleteAuto]    Script Date: 10/16/2009 16:27:08 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ItemLanguageDeleteAuto PROCEDURE
-- Generated 1/7/2009 2:04:17 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for ItemLanguage

CREATE PROCEDURE ItemLanguageDeleteAuto

@ItemLanguageID INT

AS 

DELETE FROM [dbo].[ItemLanguage]

WHERE

	[ItemLanguageID] = @ItemLanguageID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemLanguageDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemLanguageInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemLanguageInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[ItemLanguageInsertAuto]    Script Date: 10/16/2009 16:27:08 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ItemLanguageInsertAuto PROCEDURE
-- Generated 1/7/2009 2:04:17 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for ItemLanguage

CREATE PROCEDURE ItemLanguageInsertAuto

@ItemLanguageID INT OUTPUT,
@ItemID INT,
@LanguageCode NVARCHAR(10)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[ItemLanguage]
(
	[ItemID],
	[LanguageCode],
	[CreationDate]
)
VALUES
(
	@ItemID,
	@LanguageCode,
	getdate()
)

SET @ItemLanguageID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemLanguageInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[ItemLanguageID],
		[ItemID],
		[LanguageCode],
		[CreationDate]	

	FROM [dbo].[ItemLanguage]
	
	WHERE
		[ItemLanguageID] = @ItemLanguageID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemLanguageSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemLanguageSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[ItemLanguageSelectAuto]    Script Date: 10/16/2009 16:27:09 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ItemLanguageSelectAuto PROCEDURE
-- Generated 1/7/2009 2:04:17 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for ItemLanguage

CREATE PROCEDURE ItemLanguageSelectAuto

@ItemLanguageID INT

AS 

SET NOCOUNT ON

SELECT 

	[ItemLanguageID],
	[ItemID],
	[LanguageCode],
	[CreationDate]

FROM [dbo].[ItemLanguage]

WHERE
	[ItemLanguageID] = @ItemLanguageID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemLanguageSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemLanguageSelectByItemID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemLanguageSelectByItemID]
GO


/****** Object:  StoredProcedure [dbo].[ItemLanguageSelectByItemID]    Script Date: 10/16/2009 16:27:09 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ItemLanguageSelectByItemID]

@ItemID INT

AS 

SET NOCOUNT ON

SELECT	il.ItemLanguageID,
		il.ItemID,
		il.LanguageCode,
		l.LanguageName,
		il.CreationDate
FROM	dbo.ItemLanguage il INNER JOIN dbo.Language l
			ON il.LanguageCode = l.LanguageCode
WHERE	il.ItemID = @ItemID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemLanguageSelectByItemID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemLanguageUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemLanguageUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[ItemLanguageUpdateAuto]    Script Date: 10/16/2009 16:27:09 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ItemLanguageUpdateAuto PROCEDURE
-- Generated 1/7/2009 2:04:17 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for ItemLanguage

CREATE PROCEDURE ItemLanguageUpdateAuto

@ItemLanguageID INT,
@ItemID INT,
@LanguageCode NVARCHAR(10)

AS 

SET NOCOUNT ON

UPDATE [dbo].[ItemLanguage]

SET

	[ItemID] = @ItemID,
	[LanguageCode] = @LanguageCode

WHERE
	[ItemLanguageID] = @ItemLanguageID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemLanguageUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[ItemLanguageID],
		[ItemID],
		[LanguageCode],
		[CreationDate]

	FROM [dbo].[ItemLanguage]
	
	WHERE
		[ItemLanguageID] = @ItemLanguageID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[ItemSelectAuto]    Script Date: 10/16/2009 16:27:10 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ItemSelectAuto PROCEDURE
-- Generated 12/18/2008 5:26:54 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for Item

CREATE PROCEDURE ItemSelectAuto

@ItemID INT

AS 

SET NOCOUNT ON

SELECT 

	[ItemID],
	[PrimaryTitleID],
	[BarCode],
	[MARCItemID],
	[CallNumber],
	[Volume],
	[InstitutionCode],
	[LanguageCode],
	[Sponsor],
	[ItemDescription],
	[ScannedBy],
	[PDFSize],
	[VaultID],
	[NumberOfFiles],
	[Note],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID],
	[ItemStatusID],
	[ScanningUser],
	[ScanningDate],
	[PaginationCompleteUserID],
	[PaginationCompleteDate],
	[PaginationStatusID],
	[PaginationStatusUserID],
	[PaginationStatusDate],
	[LastPageNameLookupDate],
	[ItemSourceID],
	[Year],
	[IdentifierBib],
	[FileRootFolder],
	[ZQuery],
	[LicenseUrl],
	[Rights],
	[DueDiligence],
	[CopyrightStatus],
	[CopyrightRegion],
	[CopyrightComment],
	[CopyrightEvidence],
	[CopyrightEvidenceOperator],
	[CopyrightEvidenceDate]

FROM [dbo].[Item]

WHERE
	[ItemID] = @ItemID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSelectByBarcode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSelectByBarcode]
GO


/****** Object:  StoredProcedure [dbo].[ItemSelectByBarcode]    Script Date: 10/16/2009 16:27:10 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ItemSelectByBarcode]

@BarCode nvarchar(40)

AS 

SET NOCOUNT ON

SELECT 

	[ItemID],
	[PrimaryTitleID],
	[BarCode],
	[MARCItemID],
	[CallNumber],
	[Volume],
	[InstitutionCode],
	[LanguageCode],
	[Sponsor],
	[ItemDescription],
	[ScannedBy],
	[PDFSize],
	[VaultID],
	[NumberOfFiles],
	[Note],
	[ItemStatusID],
	[ItemSourceID],
	[ScanningUser],
	[ScanningDate],
	[Year],
	[IdentifierBib],
	[LicenseUrl],
	[Rights],
	[DueDiligence],
	[CopyrightStatus],
	[CopyrightRegion],
	[CopyrightComment],
	[CopyrightEvidence],
	[CopyrightEvidenceOperator],
	[CopyrightEvidenceDate],
	[PaginationCompleteUserID],
	[PaginationCompleteDate],
	[PaginationStatusID],
	[PaginationStatusUserID],
	[PaginationStatusDate],
	[LastPageNameLookupDate],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID]

FROM [dbo].[Item] 

WHERE
	[BarCode] = @BarCode

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemSelectByBarcode. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSelectByBarCodeOrItemID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSelectByBarCodeOrItemID]
GO


/****** Object:  StoredProcedure [dbo].[ItemSelectByBarCodeOrItemID]    Script Date: 10/16/2009 16:27:11 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ItemSelectByBarCodeOrItemID]

@ItemID INT,
@BarCode nvarchar(40)

AS 

SET NOCOUNT ON

SELECT 
	[ItemID],
	I.[PrimaryTitleID],
	[BarCode],
	[MARCItemID],
	I.[CallNumber],
	[Volume],
	I.[InstitutionCode],
	I.[LanguageCode],
	[Sponsor],
	[ItemDescription],
	[ScannedBy],
	[PDFSize],
	i.[VaultID],
	[NumberOfFiles],
	I.[Note],
	[ItemStatusID],
	i.[ItemSourceID],
	CASE WHEN ISNULL(s.[DownloadUrl], '') = '' 
		THEN ISNULL('http://www.botanicus.org/' + v.WebVirtualDirectory + '/' + t.MARCBibID + '/' + i.BarCode + '/' + i.Barcode + '.pdf', '')
		ELSE ISNULL(s.[DownloadUrl] + i.BarCode, '')
		END AS [DownloadUrl],
	[ScanningUser],
	[ScanningDate],
	[Year],
	[IdentifierBib],
	[FileRootFolder],
	[ZQuery],
	[LicenseUrl],
	[Rights],
	[DueDiligence],
	[CopyrightStatus],
	[CopyrightRegion],
	[CopyrightComment],
	[CopyrightEvidence],
	[CopyrightEvidenceOperator],
	[CopyrightEvidenceDate],
	[PaginationCompleteUserID],
	[PaginationCompleteDate],
	[PaginationStatusID],
	[PaginationStatusUserID],
	[PaginationStatusDate],
	[LastPageNameLookupDate],
	I.[CreationDate],
	I.[LastModifiedDate],
	I.[CreationUserID],
	I.[LastModifiedUserID],
	T.ShortTitle AS TitleName
FROM [dbo].[Item] I
	INNER JOIN dbo.Title T ON T.TitleID = I.PrimaryTitleID
	LEFT JOIN [dbo].[ItemSource] s ON i.[ItemSourceID] = s.[ItemSourceID]
	LEFT JOIN [dbo].[Vault] v ON i.[VaultID] = v.[VaultID]
WHERE
	[ItemID] = @ItemID OR
	Barcode = @Barcode

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSelectByMARCBibID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSelectByMARCBibID]
GO


/****** Object:  StoredProcedure [dbo].[ItemSelectByMARCBibID]    Script Date: 10/16/2009 16:27:11 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ItemSelectByMARCBibID]
@MARCBibID nvarchar(50)
AS 

SET NOCOUNT ON

SELECT	i.[ItemID],
		i.[BarCode],
		ti.[ItemSequence],
		i.[Volume]
FROM	[dbo].[Item] i INNER JOIN [dbo].[TitleItem] ti
			ON i.ItemID = ti.ItemID
		INNER JOIN [dbo].[Title] t
			ON ti.TitleID = t.TitleID
WHERE	t.MARCBibID = @MARCBibID
ORDER BY 
		ti.ItemSequence


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSelectByTitle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSelectByTitle]
GO


/****** Object:  StoredProcedure [dbo].[ItemSelectByTitle]    Script Date: 10/16/2009 16:27:11 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ItemSelectByTitle]
@TitleId int
AS 

SET NOCOUNT ON

SELECT 
	i.[ItemID],
	i.[PrimaryTitleID],
	i.[BarCode],
	ti.[ItemSequence],
	i.[MARCItemID],
	i.[CallNumber],
	i.[Volume],
	i.[InstitutionCode],
	i.[LanguageCode],
	i.[ItemDescription],
	i.[ScannedBy],
	i.[PDFSize],
	i.[VaultID],
	i.[NumberOfFiles],
	i.[Note],
	i.[CreationDate],
	i.[LastModifiedDate],
	i.[CreationUserID],
	i.[LastModifiedUserID],
	i.[ItemStatusID],
	i.[ItemSourceID],
	ISNULL(s.[DownloadUrl], '') AS [DownloadUrl],
	i.[ScanningDate],
	i.[Year],
	i.[IdentifierBib],
	i.[ZQuery],
	i.[PaginationCompleteUserID],
	i.[PaginationCompleteDate]
FROM [dbo].[Item] i LEFT JOIN [dbo].[ItemSource] s
		ON i.[ItemSourceID] = s.[ItemSourceID]
	INNER JOIN [dbo].[TitleItem] ti
		ON i.ItemID = ti.ItemID

WHERE ti.TitleId = @TitleId
ORDER BY ti.ItemSequence



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSelectByTitleId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSelectByTitleId]
GO


/****** Object:  StoredProcedure [dbo].[ItemSelectByTitleId]    Script Date: 10/16/2009 16:27:12 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ItemSelectByTitleId]
@TitleId int
AS 

SET NOCOUNT ON

SELECT 

	i.[ItemID],
	i.[BarCode],
	i.[Volume],
	inst.[InstitutionName],
	inst.[InstitutionUrl],
	i.[Sponsor],
	i.[ItemSourceID],
	CASE WHEN ISNULL(s.[DownloadUrl], '') = '' 
		THEN ISNULL('http://www.botanicus.org/' + v.WebVirtualDirectory + '/' + t.MARCBibID + '/' + i.BarCode + '/' + i.Barcode + '.pdf', '')
		ELSE ISNULL(s.[DownloadUrl] + i.BarCode, '')
		END AS [DownloadUrl],
	i.[ScanningDate],
	ISNULL(i.LicenseUrl, '') AS LicenseUrl,
	ISNULL(i.Rights, '') AS Rights,
	ISNULL(i.DueDiligence, '') AS DueDiligence,
	ISNULL(i.CopyrightStatus, '') AS CopyrightStatus,
	ISNULL(i.CopyrightRegion, '') AS CopyrightRegion,
	ISNULL(i.CopyrightComment, '') AS CopyrightComment,
	ISNULL(i.CopyrightEvidence, '') AS CopyrightEvidence
FROM [dbo].[Item] i LEFT JOIN [dbo].[ItemSource] s
		ON i.[ItemSourceID] = s.[ItemSourceID]
	LEFT JOIN [dbo].[Vault] v
		ON i.[VaultID] = v.[VaultID]
	INNER JOIN [dbo].[Institution] inst
		ON i.[InstitutionCode] = inst.[InstitutionCode]
	INNER JOIN [dbo].[TitleItem] ti
		ON i.ItemID = ti.ItemID
	INNER JOIN [dbo].[Title] t
		ON ti.[TitleID] = t.[TitleID]

WHERE t.TitleId = @TitleId AND i.ItemStatusID = 40
ORDER BY ti.ItemSequence

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemSelectByTitleId. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSelectPagination]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSelectPagination]
GO


/****** Object:  StoredProcedure [dbo].[ItemSelectPagination]    Script Date: 10/16/2009 16:27:12 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[ItemSelectPagination]
@ItemID int
AS 

SELECT 
	I.[ItemID],
	I.[BarCode],
	I.[ItemStatusID],
	I.[PaginationStatusID],
	I.PaginationStatusDate,
	I.PaginationStatusUserID,
	' ' AS PaginationUserName,
	PS.PaginationStatusName
FROM [dbo].[Item] I
	LEFT OUTER JOIN dbo.PaginationStatus PS ON PS.PaginationStatusID = I.PaginationStatusID
	--LEFT OUTER JOIN dbo.MOBOTSecuritySecUserSyn U ON U.UserID = I.PaginationStatusUserID
WHERE
	I.ItemID = @ItemID
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSelectPaginationReport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSelectPaginationReport]
GO


/****** Object:  StoredProcedure [dbo].[ItemSelectPaginationReport]    Script Date: 10/16/2009 16:27:13 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ItemSelectPaginationReport]
AS 

SELECT 
	I.[ItemID],
	I.[BarCode],
	I.[ItemStatusID],
	I.[PaginationStatusID],
	I.PaginationStatusDate,
	I.PaginationStatusUserID,
	' ' AS PaginationUserName,
	PS.PaginationStatusName
FROM [dbo].[Item] I
	LEFT OUTER JOIN dbo.PaginationStatus PS ON PS.PaginationStatusID = I.PaginationStatusID
	-- LEFT OUTER JOIN dbo.MOBOTSecuritySecUserSyn U ON U.UserID = I.PaginationStatusUserID
WHERE
	I.PaginationStatusID < 30 AND I.ItemStatusID = 40
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSelectRecent]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSelectRecent]
GO


/****** Object:  StoredProcedure [dbo].[ItemSelectRecent]    Script Date: 10/16/2009 16:27:13 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ItemSelectRecent]

@Top INT = 25,
@LanguageCode NVARCHAR(10) = '',
@InstitutionCode NVARCHAR(10) = ''

AS
BEGIN
	SET NOCOUNT ON

	SELECT DISTINCT TOP (@Top) t.TitleID, 
			i.ItemID, t.ShortTitle, i.Volume, i.ScanningDate, 
			i.Sponsor, inst.InstitutionName, 
			i.LicenseUrl, i.Rights, i.DueDiligence, 
			i.CopyrightStatus, i.CopyrightRegion,
			i.CopyrightComment, i.CopyrightEvidence,
			t.PublicationDetails, t.CallNumber 
	INTO	#tmpRecent
	FROM	dbo.Item i INNER JOIN dbo.Title t
				ON t.TitleID = i.PrimaryTitleID
			LEFT JOIN dbo.Institution inst
				ON i.InstitutionCode = inst.InstitutionCode
			LEFT JOIN dbo.TitleLanguage tl 
				ON t.TitleID = tl.TitleID
			LEFT JOIN dbo.ItemLanguage il 
				ON i.ItemID = il.ItemID
	WHERE	t.PublishReady = 1
	AND		i.ItemStatusID = 40
	AND		(t.InstitutionCode = @InstitutionCode OR 
			i.InstitutionCode = @InstitutionCode OR 
			@InstitutionCode = '')
	AND		(t.LanguageCode = @LanguageCode OR
			i.LanguageCode = @LanguageCode OR
			 ISNULL(tl.LanguageCode, '') = @LanguageCode OR
			 ISNULL(il.LanguageCode, '') = @LanguageCode OR
			@LanguageCode = '')
	ORDER BY ScanningDate DESC

	SELECT	ItemID, ShortTitle, Volume, ScanningDate, 
			Sponsor, InstitutionName, 
			LicenseUrl, Rights, DueDiligence, 
			CopyrightStatus, CopyrightRegion,
			CopyrightComment, CopyrightEvidence,
			PublicationDetails, CallNumber, 
			dbo.fnAuthorStringForTitle(TitleID) AS CreatorTextString,
			dbo.fnTagTextStringForTitle(TitleID) AS TagTextString,
			dbo.fnAssociationStringForTitle(TitleID) AS AssociationTextString
	FROM	#tmpRecent
	ORDER BY ScanningDate DESC

	DROP TABLE #tmpRecent
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSelectWithExpiredPageNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSelectWithExpiredPageNames]
GO


/****** Object:  StoredProcedure [dbo].[ItemSelectWithExpiredPageNames]    Script Date: 10/16/2009 16:27:13 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ItemSelectWithExpiredPageNames]

@MaxAge INT  -- Maximum allowed age of page names (in days)

AS 

SET NOCOUNT ON

SELECT 

	[ItemID],
	[PrimaryTitleID],
	[BarCode],
	[MARCItemID],
	[CallNumber],
	[Volume],
	[InstitutionCode],
	[LanguageCode],
	[ItemDescription],
	[ScannedBy],
	[PDFSize],
	[VaultID],
	[NumberOfFiles],
	[Note],
		[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID],
	[ItemStatusID],
	[ItemSourceID],
	[ScanningUser],
	[ScanningDate],
	[Year],
	[IdentifierBib],
	[PaginationCompleteUserID],
	[PaginationCompleteDate],
	[PaginationStatusID],
	[PaginationStatusUserID],
	[PaginationStatusDate],
	[LastPageNameLookupDate]

FROM [dbo].[Item]

WHERE
	DATEDIFF(day, [LastPageNameLookupDate], GETDATE()) > @MaxAge
AND	[ItemStatusID] = 40

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemSelectWithExpiredPageNames. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSelectWithoutPageNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSelectWithoutPageNames]
GO


/****** Object:  StoredProcedure [dbo].[ItemSelectWithoutPageNames]    Script Date: 10/16/2009 16:27:14 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ItemSelectWithoutPageNames]

AS 

SET NOCOUNT ON

SELECT 

	[ItemID],
	[PrimaryTitleID],
	[BarCode],
	[MARCItemID],
	[CallNumber],
	[Volume],
	[InstitutionCode],
	[LanguageCode],
	[ItemDescription],
	[ScannedBy],
	[PDFSize],
	[VaultID],
	[NumberOfFiles],
	[Note],
		[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID],
	[ItemStatusID],
	[ItemSourceID],
	[ScanningUser],
	[ScanningDate],
	[Year],
	[IdentifierBib],
	[PaginationCompleteUserID],
	[PaginationCompleteDate],
	[PaginationStatusID],
	[PaginationStatusUserID],
	[PaginationStatusDate],
	[LastPageNameLookupDate]

FROM [dbo].[Item]

WHERE
	[LastPageNameLookupDate] IS NULL
AND	[ItemStatusID] = 40

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemSelectWithoutPageNames. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSelectWithSuspectCharacters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSelectWithSuspectCharacters]
GO


/****** Object:  StoredProcedure [dbo].[ItemSelectWithSuspectCharacters]    Script Date: 10/16/2009 16:27:14 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ItemSelectWithSuspectCharacters]

@InstitutionCode NVARCHAR(10) = '',
@MaxAge INT = 30

AS
BEGIN

SET NOCOUNT ON

-- Item
SELECT	t.TitleID,
		t.ShortTitle,
		i.ItemID,
		i.BarCode,
		i.InstitutionCode,
		inst.InstitutionName,
		i.CreationDate,
		CHAR(dbo.fnContainsSuspectCharacter(i.Volume)) AS VolumeSuspect, 
		i.Volume,
		oclc.IdentifierValue AS OCLC,
		MIN(i.ZQuery) AS ZQuery
FROM	dbo.Item i INNER JOIN dbo.TitleItem ti
			ON i.ItemID = ti.ItemID
		INNER JOIN dbo.Title t
			ON ti.TitleID = t.TitleID
		LEFT JOIN (SELECT * FROM dbo.Title_TitleIdentifier WHERE TitleIdentifierID = 1) AS oclc
			ON t.TitleID = oclc.TitleID
		INNER JOIN dbo.Institution inst
			ON i.InstitutionCode = inst.InstitutionCode
WHERE	dbo.fnContainsSuspectCharacter(i.Volume) > 0
AND		(i.InstitutionCode = @InstitutionCode OR @InstitutionCode = '')
AND		i.CreationDate > DATEADD(dd, (@MaxAge * -1), GETDATE())
GROUP BY
		CHAR(dbo.fnContainsSuspectCharacter(i.Volume)), 
		i.Volume,
		t.TitleID,
		t.ShortTitle,
		i.ItemID,
		i.CreationDate,
		i.BarCode,
		oclc.IdentifierValue,
		i.InstitutionCode,
		inst.InstitutionName
ORDER BY
		inst.InstitutionName, i.CreationDate DESC
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaultInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[VaultInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[VaultInsertAuto]    Script Date: 10/16/2009 16:27:14 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- VaultInsertAuto PROCEDURE
-- Generated 1/24/2008 10:03:58 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Vault

CREATE PROCEDURE VaultInsertAuto

@VaultID INT /* Unique identifier for each Vault entry. */,
@Server NVARCHAR(30) = null /* Name of server for this Vault entry. */,
@FolderShare NVARCHAR(30) = null /* Name for the folder share for this Vault entry. */,
@WebVirtualDirectory NVARCHAR(30) = null /* Name for the Web Virtual Directory for this Vault entry. */,
@OCRFolderShare NVARCHAR(100) = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Vault]
(
	[VaultID],
	[Server],
	[FolderShare],
	[WebVirtualDirectory],
	[OCRFolderShare]
)
VALUES
(
	@VaultID,
	@Server,
	@FolderShare,
	@WebVirtualDirectory,
	@OCRFolderShare
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure VaultInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[VaultID],
		[Server],
		[FolderShare],
		[WebVirtualDirectory],
		[OCRFolderShare]	

	FROM [dbo].[Vault]
	
	WHERE
		[VaultID] = @VaultID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSourceSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemSourceSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[ItemSourceSelectAll]    Script Date: 10/16/2009 16:27:15 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.ItemSourceSelectAll
AS
BEGIN

SET NOCOUNT ON

SELECT	ItemSourceID,
		SourceName,
		DownloadUrl,
		ImageServerUrlFormat,
		CreationDate,
		LastModifiedDate
FROM	dbo.ItemSource

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTypeUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTypeUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleTypeUpdateAuto]    Script Date: 10/16/2009 16:27:15 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleTypeUpdateAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for TitleType

CREATE PROCEDURE TitleTypeUpdateAuto

@TitleTypeID INT /* Unique identifier for each Title Type record. */,
@TitleType NVARCHAR(25) /* A Type to be associated with a Title. */,
@TitleTypeDescription NVARCHAR(80) /* Description of a Title Type. */

AS 

SET NOCOUNT ON

UPDATE [dbo].[TitleType]

SET

	[TitleTypeID] = @TitleTypeID,
	[TitleType] = @TitleType,
	[TitleTypeDescription] = @TitleTypeDescription

WHERE
	[TitleTypeID] = @TitleTypeID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleTypeUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleTypeID],
		[TitleType],
		[TitleTypeDescription]

	FROM [dbo].[TitleType]
	
	WHERE
		[TitleTypeID] = @TitleTypeID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemStatusDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemStatusDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[ItemStatusDeleteAuto]    Script Date: 10/16/2009 16:27:16 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ItemStatusDeleteAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for ItemStatus

CREATE PROCEDURE ItemStatusDeleteAuto

@ItemStatusID INT

AS 

DELETE FROM [dbo].[ItemStatus]

WHERE

	[ItemStatusID] = @ItemStatusID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemStatusDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemStatusInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemStatusInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[ItemStatusInsertAuto]    Script Date: 10/16/2009 16:27:16 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ItemStatusInsertAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for ItemStatus

CREATE PROCEDURE ItemStatusInsertAuto

@ItemStatusID INT,
@ItemStatusName NVARCHAR(50)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[ItemStatus]
(
	[ItemStatusID],
	[ItemStatusName]
)
VALUES
(
	@ItemStatusID,
	@ItemStatusName
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemStatusInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[ItemStatusID],
		[ItemStatusName]	

	FROM [dbo].[ItemStatus]
	
	WHERE
		[ItemStatusID] = @ItemStatusID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemStatusSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemStatusSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[ItemStatusSelectAll]    Script Date: 10/16/2009 16:27:16 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[ItemStatusSelectAll]
AS 

SET NOCOUNT ON

SELECT 
	[ItemStatusID],
	[ItemStatusName]
FROM [dbo].[ItemStatus]
order by itemstatusname
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemStatusSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemStatusSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[ItemStatusSelectAuto]    Script Date: 10/16/2009 16:27:17 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ItemStatusSelectAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for ItemStatus

CREATE PROCEDURE ItemStatusSelectAuto

@ItemStatusID INT

AS 

SET NOCOUNT ON

SELECT 

	[ItemStatusID],
	[ItemStatusName]

FROM [dbo].[ItemStatus]

WHERE
	[ItemStatusID] = @ItemStatusID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemStatusSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemStatusUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemStatusUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[ItemStatusUpdateAuto]    Script Date: 10/16/2009 16:27:17 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ItemStatusUpdateAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for ItemStatus

CREATE PROCEDURE ItemStatusUpdateAuto

@ItemStatusID INT,
@ItemStatusName NVARCHAR(50)

AS 

SET NOCOUNT ON

UPDATE [dbo].[ItemStatus]

SET

	[ItemStatusID] = @ItemStatusID,
	[ItemStatusName] = @ItemStatusName

WHERE
	[ItemStatusID] = @ItemStatusID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemStatusUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[ItemStatusID],
		[ItemStatusName]

	FROM [dbo].[ItemStatus]
	
	WHERE
		[ItemStatusID] = @ItemStatusID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[ItemUpdateAuto]    Script Date: 10/16/2009 16:27:17 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- ItemUpdateAuto PROCEDURE
-- Generated 12/18/2008 5:26:54 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for Item

CREATE PROCEDURE ItemUpdateAuto

@ItemID INT,
@PrimaryTitleID INT,
@BarCode NVARCHAR(40),
@MARCItemID NVARCHAR(50),
@CallNumber NVARCHAR(100),
@Volume NVARCHAR(100),
@InstitutionCode NVARCHAR(10),
@LanguageCode NVARCHAR(10),
@Sponsor NVARCHAR(100),
@ItemDescription NTEXT,
@ScannedBy INT,
@PDFSize INT,
@VaultID INT,
@NumberOfFiles SMALLINT,
@Note NVARCHAR(255),
@LastModifiedUserID INT,
@ItemStatusID INT,
@ScanningUser NVARCHAR(100),
@ScanningDate DATETIME,
@PaginationCompleteUserID INT,
@PaginationCompleteDate DATETIME,
@PaginationStatusID INT,
@PaginationStatusUserID INT,
@PaginationStatusDate DATETIME,
@LastPageNameLookupDate DATETIME,
@ItemSourceID INT,
@Year NVARCHAR(20),
@IdentifierBib NVARCHAR(50),
@FileRootFolder NVARCHAR(250),
@ZQuery NVARCHAR(200),
@LicenseUrl NVARCHAR(MAX),
@Rights NVARCHAR(MAX),
@DueDiligence NVARCHAR(MAX),
@CopyrightStatus NVARCHAR(MAX),
@CopyrightRegion NVARCHAR(50),
@CopyrightComment NVARCHAR(MAX),
@CopyrightEvidence NVARCHAR(MAX),
@CopyrightEvidenceOperator NVARCHAR(100),
@CopyrightEvidenceDate NVARCHAR(30)

AS 

SET NOCOUNT ON

UPDATE [dbo].[Item]

SET

	[PrimaryTitleID] = @PrimaryTitleID,
	[BarCode] = @BarCode,
	[MARCItemID] = @MARCItemID,
	[CallNumber] = @CallNumber,
	[Volume] = @Volume,
	[InstitutionCode] = @InstitutionCode,
	[LanguageCode] = @LanguageCode,
	[Sponsor] = @Sponsor,
	[ItemDescription] = @ItemDescription,
	[ScannedBy] = @ScannedBy,
	[PDFSize] = @PDFSize,
	[VaultID] = @VaultID,
	[NumberOfFiles] = @NumberOfFiles,
	[Note] = @Note,
	[LastModifiedDate] = getdate(),
	[LastModifiedUserID] = @LastModifiedUserID,
	[ItemStatusID] = @ItemStatusID,
	[ScanningUser] = @ScanningUser,
	[ScanningDate] = @ScanningDate,
	[PaginationCompleteUserID] = @PaginationCompleteUserID,
	[PaginationCompleteDate] = @PaginationCompleteDate,
	[PaginationStatusID] = @PaginationStatusID,
	[PaginationStatusUserID] = @PaginationStatusUserID,
	[PaginationStatusDate] = @PaginationStatusDate,
	[LastPageNameLookupDate] = @LastPageNameLookupDate,
	[ItemSourceID] = @ItemSourceID,
	[Year] = @Year,
	[IdentifierBib] = @IdentifierBib,
	[FileRootFolder] = @FileRootFolder,
	[ZQuery] = @ZQuery,
	[LicenseUrl] = @LicenseUrl,
	[Rights] = @Rights,
	[DueDiligence] = @DueDiligence,
	[CopyrightStatus] = @CopyrightStatus,
	[CopyrightRegion] = @CopyrightRegion,
	[CopyrightComment] = @CopyrightComment,
	[CopyrightEvidence] = @CopyrightEvidence,
	[CopyrightEvidenceOperator] = @CopyrightEvidenceOperator,
	[CopyrightEvidenceDate] = @CopyrightEvidenceDate

WHERE
	[ItemID] = @ItemID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[ItemID],
		[PrimaryTitleID],
		[BarCode],
		[MARCItemID],
		[CallNumber],
		[Volume],
		[InstitutionCode],
		[LanguageCode],
		[Sponsor],
		[ItemDescription],
		[ScannedBy],
		[PDFSize],
		[VaultID],
		[NumberOfFiles],
		[Note],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID],
		[ItemStatusID],
		[ScanningUser],
		[ScanningDate],
		[PaginationCompleteUserID],
		[PaginationCompleteDate],
		[PaginationStatusID],
		[PaginationStatusUserID],
		[PaginationStatusDate],
		[LastPageNameLookupDate],
		[ItemSourceID],
		[Year],
		[IdentifierBib],
		[FileRootFolder],
		[ZQuery],
		[LicenseUrl],
		[Rights],
		[DueDiligence],
		[CopyrightStatus],
		[CopyrightRegion],
		[CopyrightComment],
		[CopyrightEvidence],
		[CopyrightEvidenceOperator],
		[CopyrightEvidenceDate]

	FROM [dbo].[Item]
	
	WHERE
		[ItemID] = @ItemID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemUpdateLastPageNameLookupDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemUpdateLastPageNameLookupDate]
GO


/****** Object:  StoredProcedure [dbo].[ItemUpdateLastPageNameLookupDate]    Script Date: 10/16/2009 16:27:18 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[ItemUpdateLastPageNameLookupDate]

@ItemID INT

AS 

SET NOCOUNT ON

UPDATE [dbo].[Item]

SET
	[LastPageNameLookupDate] = GETDATE(),
	[LastModifiedDate] = GETDATE()

WHERE
	[ItemID] = @ItemID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemUpdateLastPageNameLookupDate. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT 

		[ItemID],
		[PrimaryTitleID],
		[BarCode],
		[MARCItemID],
		[CallNumber],
		[Volume],
		[InstitutionCode],
		[LanguageCode],
		[ItemDescription],
		[ScannedBy],
		[PDFSize],
		[VaultID],
		[NumberOfFiles],
		[Note],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID],
		[ItemStatusID],
		[ScanningUser],
		[ScanningDate],
		[PaginationCompleteUserID],
		[PaginationCompleteDate],
		[PaginationStatusID],
		[PaginationStatusUserID],
		[PaginationStatusDate],
		[LastPageNameLookupDate]

	FROM [dbo].[Item]

	WHERE
		[ItemID] = @ItemID
	
	RETURN -- update successful
END




GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemUpdatePrimaryTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[ItemUpdatePrimaryTitleID]
GO


/****** Object:  StoredProcedure [dbo].[ItemUpdatePrimaryTitleID]    Script Date: 10/16/2009 16:27:19 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[ItemUpdatePrimaryTitleID]

@ItemID INT,
@TitleID INT

AS 

SET NOCOUNT ON

UPDATE	[dbo].[Item]
SET		[PrimaryTitleID] = @TitleID,
		[LastModifiedDate] = GETDATE()
WHERE	[ItemID] = @ItemID
AND		[PrimaryTitleID] <> @TitleID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure ItemUpdatePrimaryTitleID. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT 

		[ItemID],
		[PrimaryTitleID],
		[BarCode],
		[MARCItemID],
		[CallNumber],
		[Volume],
		[InstitutionCode],
		[LanguageCode],
		[ItemDescription],
		[ScannedBy],
		[PDFSize],
		[VaultID],
		[NumberOfFiles],
		[Note],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID],
		[ItemStatusID],
		[ScanningUser],
		[ScanningDate],
		[PaginationCompleteUserID],
		[PaginationCompleteDate],
		[PaginationStatusID],
		[PaginationStatusUserID],
		[PaginationStatusDate],
		[LastPageNameLookupDate]

	FROM [dbo].[Item]

	WHERE
		[ItemID] = @ItemID
	
	RETURN -- update successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaginationStatusDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PaginationStatusDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[PaginationStatusDeleteAuto]    Script Date: 10/16/2009 16:27:19 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PaginationStatusDeleteAuto PROCEDURE
-- Generated 6/28/2007 2:15:43 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for PaginationStatus

CREATE PROCEDURE [dbo].[PaginationStatusDeleteAuto]

@PaginationStatusID INT

AS 

DELETE FROM [dbo].[PaginationStatus]

WHERE

	[PaginationStatusID] = @PaginationStatusID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PaginationStatusDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LanguageDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LanguageDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[LanguageDeleteAuto]    Script Date: 10/16/2009 16:27:20 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- LanguageDeleteAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Language

CREATE PROCEDURE LanguageDeleteAuto

@LanguageCode NVARCHAR(10) /* Code for a language. */

AS 

DELETE FROM [dbo].[Language]

WHERE

	[LanguageCode] = @LanguageCode

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure LanguageDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LanguageInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LanguageInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[LanguageInsertAuto]    Script Date: 10/16/2009 16:27:21 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- LanguageInsertAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Language

CREATE PROCEDURE LanguageInsertAuto

@LanguageCode NVARCHAR(10) /* Code for a language. */,
@LanguageName NVARCHAR(20) /* Name used for the language. */,
@Note NVARCHAR(255) = null /* Notes about this Language and its use. */

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Language]
(
	[LanguageCode],
	[LanguageName],
	[Note]
)
VALUES
(
	@LanguageCode,
	@LanguageName,
	@Note
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure LanguageInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[LanguageCode],
		[LanguageName],
		[Note]	

	FROM [dbo].[Language]
	
	WHERE
		[LanguageCode] = @LanguageCode
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LanguageSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LanguageSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[LanguageSelectAll]    Script Date: 10/16/2009 16:27:22 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LanguageSelectAll]

AS 

SELECT 
	[LanguageCode],
	[LanguageName],
	[Note]
FROM [dbo].[Language]
ORDER BY LanguageName

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LanguageSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LanguageSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[LanguageSelectAuto]    Script Date: 10/16/2009 16:27:23 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- LanguageSelectAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for Language

CREATE PROCEDURE LanguageSelectAuto

@LanguageCode NVARCHAR(10) /* Code for a language. */

AS 

SET NOCOUNT ON

SELECT 

	[LanguageCode],
	[LanguageName],
	[Note]

FROM [dbo].[Language]

WHERE
	[LanguageCode] = @LanguageCode

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure LanguageSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LanguageSelectWithPublishedItems]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LanguageSelectWithPublishedItems]
GO


/****** Object:  StoredProcedure [dbo].[LanguageSelectWithPublishedItems]    Script Date: 10/16/2009 16:27:23 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[LanguageSelectWithPublishedItems]

AS

SET NOCOUNT ON

BEGIN

SELECT 	l.LanguageCode,
		l.LanguageName
FROM	dbo.[Language] l INNER JOIN dbo.Item i
			ON l.LanguageCode = i.LanguageCode
WHERE	i.ItemStatusID = 40
AND		LanguageName <> ''
UNION
SELECT	l.LanguageCode,
		l.LanguageName
FROM	dbo.Language l INNER JOIN dbo.ItemLanguage il
			ON l.LanguageCode = il.LanguageCode
		INNER JOIN dbo.Item i
			ON il.ItemID = i.ItemID
WHERE	i.ItemStatusID = 40
AND		l.LanguageName <> ''
ORDER BY 
		LanguageName

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure LanguageSelectWithPublishedItems. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LanguageUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LanguageUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[LanguageUpdateAuto]    Script Date: 10/16/2009 16:27:23 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- LanguageUpdateAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for Language

CREATE PROCEDURE LanguageUpdateAuto

@LanguageCode NVARCHAR(10) /* Code for a language. */,
@LanguageName NVARCHAR(20) /* Name used for the language. */,
@Note NVARCHAR(255) /* Notes about this Language and its use. */

AS 

SET NOCOUNT ON

UPDATE [dbo].[Language]

SET

	[LanguageCode] = @LanguageCode,
	[LanguageName] = @LanguageName,
	[Note] = @Note

WHERE
	[LanguageCode] = @LanguageCode
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure LanguageUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[LanguageCode],
		[LanguageName],
		[Note]

	FROM [dbo].[Language]
	
	WHERE
		[LanguageCode] = @LanguageCode
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaginationStatusUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PaginationStatusUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[PaginationStatusUpdateAuto]    Script Date: 10/16/2009 16:27:24 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PaginationStatusUpdateAuto PROCEDURE
-- Generated 6/28/2007 2:15:43 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for PaginationStatus

CREATE PROCEDURE [dbo].[PaginationStatusUpdateAuto]

@PaginationStatusID INT,
@PaginationStatusName NVARCHAR(50)

AS 

SET NOCOUNT ON

UPDATE [dbo].[PaginationStatus]

SET

	[PaginationStatusID] = @PaginationStatusID,
	[PaginationStatusName] = @PaginationStatusName

WHERE
	[PaginationStatusID] = @PaginationStatusID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PaginationStatusUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PaginationStatusID],
		[PaginationStatusName]

	FROM [dbo].[PaginationStatus]
	
	WHERE
		[PaginationStatusID] = @PaginationStatusID
	
	RETURN -- update successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocationDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LocationDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[LocationDeleteAuto]    Script Date: 10/16/2009 16:27:24 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- LocationDeleteAuto PROCEDURE
-- Generated 4/30/2008 10:05:00 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Location

CREATE PROCEDURE LocationDeleteAuto

@LocationName NVARCHAR(50)

AS 

DELETE FROM [dbo].[Location]

WHERE

	[LocationName] = @LocationName

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure LocationDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocationInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LocationInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[LocationInsertAuto]    Script Date: 10/16/2009 16:27:24 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- LocationInsertAuto PROCEDURE
-- Generated 4/30/2008 10:05:00 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Location

CREATE PROCEDURE LocationInsertAuto

@LocationName NVARCHAR(50),
@Latitude VARCHAR(20) = null,
@Longitude VARCHAR(20) = null,
@NextAttemptDate DATETIME = null,
@IncludeInUI BIT

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Location]
(
	[LocationName],
	[Latitude],
	[Longitude],
	[NextAttemptDate],
	[IncludeInUI],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@LocationName,
	@Latitude,
	@Longitude,
	@NextAttemptDate,
	@IncludeInUI,
	getdate(),
	getdate()
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure LocationInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[LocationName],
		[Latitude],
		[Longitude],
		[NextAttemptDate],
		[IncludeInUI],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[Location]
	
	WHERE
		[LocationName] = @LocationName
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocationSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LocationSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[LocationSelectAll]    Script Date: 10/16/2009 16:27:25 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[LocationSelectAll]

AS 

SET NOCOUNT ON

SELECT 
	[LocationName],
	[Latitude],
	[Longitude],
	[NextAttemptDate],
	[IncludeInUI],
	[CreationDate],
	[LastModifiedDate]
FROM [dbo].[Location]

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure LocationSelectAll. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocationSelectAllInvalid]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LocationSelectAllInvalid]
GO


/****** Object:  StoredProcedure [dbo].[LocationSelectAllInvalid]    Script Date: 10/16/2009 16:27:25 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[LocationSelectAllInvalid]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT

	[LocationName],
	[Latitude],
	[Longitude],
	[NextAttemptDate]

	FROM [dbo].[Location]
	JOIN [dbo].[TitleTag] ON [TagText] = [LocationName]
	JOIN [dbo].[Title] ON [Title].[TitleID] = [TitleTag].[TitleID]

	WHERE
		[Latitude] IS NULL AND
		[Longitude] IS NULL AND
		[NextAttemptDate] IS NOT NULL AND
		[PublishReady] = 1

	IF @@ERROR <> 0
	BEGIN
		-- raiserror will throw a SqlException
		RAISERROR('An error occurred in procedure LocationSelectAuto. No information was selected.', 16, 1)
		RETURN 9 -- error occurred
	END
	ELSE BEGIN
		RETURN -- select successful
	END
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocationSelectAllValid]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LocationSelectAllValid]
GO


/****** Object:  StoredProcedure [dbo].[LocationSelectAllValid]    Script Date: 10/16/2009 16:27:26 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[LocationSelectAllValid]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT

	[LocationName],
	[Latitude],
	[Longitude],
	[NextAttemptDate]

	FROM [dbo].[Location]
	JOIN [dbo].[TitleTag] ON [TagText] = [LocationName]
	JOIN [dbo].[Title] ON [Title].[TitleID] = [TitleTag].[TitleID]

	WHERE
		[Latitude] IS NOT NULL AND
		[Longitude] IS NOT NULL AND
		[NextAttemptDate] IS NULL AND
		[IncludeInUI] = 1 AND
		[PublishReady] = 1

	IF @@ERROR <> 0
	BEGIN
		-- raiserror will throw a SqlException
		RAISERROR('An error occurred in procedure LocationSelectAuto. No information was selected.', 16, 1)
		RETURN 9 -- error occurred
	END
	ELSE BEGIN
		RETURN -- select successful
	END
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocationSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LocationSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[LocationSelectAuto]    Script Date: 10/16/2009 16:27:26 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- LocationSelectAuto PROCEDURE
-- Generated 4/30/2008 10:05:00 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for Location

CREATE PROCEDURE LocationSelectAuto

@LocationName NVARCHAR(50)

AS 

SET NOCOUNT ON

SELECT 

	[LocationName],
	[Latitude],
	[Longitude],
	[NextAttemptDate],
	[IncludeInUI],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[Location]

WHERE
	[LocationName] = @LocationName

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure LocationSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocationSelectValidByInstitution]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LocationSelectValidByInstitution]
GO


/****** Object:  StoredProcedure [dbo].[LocationSelectValidByInstitution]    Script Date: 10/16/2009 16:27:26 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[LocationSelectValidByInstitution]

@InstitutionCode nvarchar(10) = '',
@LanguageCode nvarchar(10) = ''

AS
BEGIN
	SET NOCOUNT ON;

	SELECT LocationName, Latitude, Longitude, NextAttemptDate, COUNT(*) AS NumberOfTitles
	FROM (
		SELECT DISTINCT
				REPLACE(l.[LocationName], ',', '') AS [LocationName],
				l.[Latitude],
				l.[Longitude],
				l.[NextAttemptDate],
				t.[TitleID]
		FROM	[dbo].[Location] l
				INNER JOIN dbo.PrimaryTitleTagView v ON l.LocationName = v.TagText
				INNER JOIN dbo.Title t ON v.PrimaryTitleID = t.TitleID
				LEFT JOIN dbo.TitleLanguage tl ON v.TitleID = tl.TitleID
				LEFT JOIN dbo.ItemLanguage il ON v.ItemID = il.ItemID
		WHERE	l.[Latitude] IS NOT NULL AND
				l.[Longitude] IS NOT NULL AND
				l.[NextAttemptDate] IS NULL AND
				l.[IncludeInUI] = 1 AND
				t.[PublishReady] = 1 AND
				(v.[TitleInstitutionCode] = @InstitutionCode OR 
					v.[ItemInstitutionCode] = @InstitutionCode OR 
					@InstitutionCode = '') AND
				(v.TitleLanguageCode = @LanguageCode OR
					v.ItemLanguageCode = @LanguageCode OR
					ISNULL(tl.LanguageCode, '') = @LanguageCode OR
					ISNULL(il.LanguageCode, '') = @LanguageCode OR
					@LanguageCode = '')
		) X
	GROUP BY
		[LocationName],
		[Latitude],
		[Longitude],
		[NextAttemptDate]

	IF @@ERROR <> 0
	BEGIN
		-- raiserror will throw a SqlException
		RAISERROR('An error occurred in procedure LocationSelectValidByInstitution. No information was selected.', 16, 1)
		RETURN 9 -- error occurred
	END
	ELSE BEGIN
		RETURN -- select successful
	END
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[LocationUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[LocationUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[LocationUpdateAuto]    Script Date: 10/16/2009 16:27:27 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- LocationUpdateAuto PROCEDURE
-- Generated 4/30/2008 10:05:00 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for Location

CREATE PROCEDURE LocationUpdateAuto

@LocationName NVARCHAR(50),
@Latitude VARCHAR(20),
@Longitude VARCHAR(20),
@NextAttemptDate DATETIME,
@IncludeInUI BIT

AS 

SET NOCOUNT ON

UPDATE [dbo].[Location]

SET

	[LocationName] = @LocationName,
	[Latitude] = @Latitude,
	[Longitude] = @Longitude,
	[NextAttemptDate] = @NextAttemptDate,
	[IncludeInUI] = @IncludeInUI,
	[LastModifiedDate] = getdate()

WHERE
	[LocationName] = @LocationName
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure LocationUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[LocationName],
		[Latitude],
		[Longitude],
		[NextAttemptDate],
		[IncludeInUI],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[Location]
	
	WHERE
		[LocationName] = @LocationName
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[PDFInsertAuto]    Script Date: 10/16/2009 16:27:27 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PDFInsertAuto PROCEDURE
-- Generated 1/21/2009 11:41:21 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for PDF

CREATE PROCEDURE PDFInsertAuto

@PdfID INT OUTPUT,
@ItemID INT,
@EmailAddress NVARCHAR(200),
@ShareWithEmailAddresses NVARCHAR(MAX),
@ImagesOnly BIT,
@ArticleTitle NVARCHAR(MAX),
@ArticleCreators NVARCHAR(MAX),
@ArticleTags NVARCHAR(MAX),
@FileLocation NVARCHAR(200),
@FileUrl NVARCHAR(200),
@FileGenerationDate DATETIME = null,
@FileDeletionDate DATETIME = null,
@PdfStatusID INT,
@NumberImagesMissing INT,
@NumberOcrMissing INT,
@Comment NVARCHAR(MAX)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[PDF]
(
	[ItemID],
	[EmailAddress],
	[ShareWithEmailAddresses],
	[ImagesOnly],
	[ArticleTitle],
	[ArticleCreators],
	[ArticleTags],
	[FileLocation],
	[FileUrl],
	[FileGenerationDate],
	[FileDeletionDate],
	[PdfStatusID],
	[NumberImagesMissing],
	[NumberOcrMissing],
	[Comment],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@ItemID,
	@EmailAddress,
	@ShareWithEmailAddresses,
	@ImagesOnly,
	@ArticleTitle,
	@ArticleCreators,
	@ArticleTags,
	@FileLocation,
	@FileUrl,
	@FileGenerationDate,
	@FileDeletionDate,
	@PdfStatusID,
	@NumberImagesMissing,
	@NumberOcrMissing,
	@Comment,
	getdate(),
	getdate()
)

SET @PdfID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PDFInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PdfID],
		[ItemID],
		[EmailAddress],
		[ShareWithEmailAddresses],
		[ImagesOnly],
		[ArticleTitle],
		[ArticleCreators],
		[ArticleTags],
		[FileLocation],
		[FileUrl],
		[FileGenerationDate],
		[FileDeletionDate],
		[PdfStatusID],
		[NumberImagesMissing],
		[NumberOcrMissing],
		[Comment],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[PDF]
	
	WHERE
		[PdfID] = @PdfID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFPageSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFPageSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[PDFPageSelectAuto]    Script Date: 10/16/2009 16:27:27 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PDFPageSelectAuto PROCEDURE
-- Generated 11/24/2008 4:39:21 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for PDFPage

CREATE PROCEDURE PDFPageSelectAuto

@PdfPageID INT

AS 

SET NOCOUNT ON

SELECT 

	[PdfPageID],
	[PdfID],
	[PageID]

FROM [dbo].[PDFPage]

WHERE
	[PdfPageID] = @PdfPageID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PDFPageSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcControlDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcControlDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcControlDeleteAuto]    Script Date: 10/16/2009 16:27:28 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcControlDeleteAuto PROCEDURE
-- Generated 4/15/2009 3:34:26 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for MarcControl

CREATE PROCEDURE MarcControlDeleteAuto

@MarcControlID INT

AS 

DELETE FROM [dbo].[MarcControl]

WHERE

	[MarcControlID] = @MarcControlID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcControlDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcControlInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcControlInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcControlInsertAuto]    Script Date: 10/16/2009 16:27:28 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcControlInsertAuto PROCEDURE
-- Generated 4/15/2009 3:34:26 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for MarcControl

CREATE PROCEDURE MarcControlInsertAuto

@MarcControlID INT OUTPUT,
@MarcID INT,
@Tag NCHAR(3),
@Value NVARCHAR(200)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[MarcControl]
(
	[MarcID],
	[Tag],
	[Value],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@MarcID,
	@Tag,
	@Value,
	getdate(),
	getdate()
)

SET @MarcControlID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcControlInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[MarcControlID],
		[MarcID],
		[Tag],
		[Value],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[MarcControl]
	
	WHERE
		[MarcControlID] = @MarcControlID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcControlSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcControlSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcControlSelectAuto]    Script Date: 10/16/2009 16:27:29 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcControlSelectAuto PROCEDURE
-- Generated 4/15/2009 3:34:26 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for MarcControl

CREATE PROCEDURE MarcControlSelectAuto

@MarcControlID INT

AS 

SET NOCOUNT ON

SELECT 

	[MarcControlID],
	[MarcID],
	[Tag],
	[Value],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[MarcControl]

WHERE
	[MarcControlID] = @MarcControlID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcControlSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcControlUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcControlUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcControlUpdateAuto]    Script Date: 10/16/2009 16:27:30 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcControlUpdateAuto PROCEDURE
-- Generated 4/15/2009 3:34:26 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for MarcControl

CREATE PROCEDURE MarcControlUpdateAuto

@MarcControlID INT,
@MarcID INT,
@Tag NCHAR(3),
@Value NVARCHAR(200)

AS 

SET NOCOUNT ON

UPDATE [dbo].[MarcControl]

SET

	[MarcID] = @MarcID,
	[Tag] = @Tag,
	[Value] = @Value,
	[LastModifiedDate] = getdate()

WHERE
	[MarcControlID] = @MarcControlID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcControlUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[MarcControlID],
		[MarcID],
		[Tag],
		[Value],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[MarcControl]
	
	WHERE
		[MarcControlID] = @MarcControlID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTypeSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTypeSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[TitleTypeSelectAll]    Script Date: 10/16/2009 16:27:30 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[TitleTypeSelectAll]
AS 

SET NOCOUNT ON

SELECT 

	[TitleTypeID],
	[TitleType],
	[TitleTypeDescription]

FROM [dbo].[TitleType]
ORDER BY [TitleType]

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcDataFieldDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcDataFieldDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcDataFieldDeleteAuto]    Script Date: 10/16/2009 16:27:31 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcDataFieldDeleteAuto PROCEDURE
-- Generated 4/15/2009 3:34:26 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for MarcDataField

CREATE PROCEDURE MarcDataFieldDeleteAuto

@MarcDataFieldID INT

AS 

DELETE FROM [dbo].[MarcDataField]

WHERE

	[MarcDataFieldID] = @MarcDataFieldID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcDataFieldDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcDataFieldInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcDataFieldInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcDataFieldInsertAuto]    Script Date: 10/16/2009 16:27:31 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcDataFieldInsertAuto PROCEDURE
-- Generated 4/15/2009 3:34:26 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for MarcDataField

CREATE PROCEDURE MarcDataFieldInsertAuto

@MarcDataFieldID INT OUTPUT,
@MarcID INT,
@Tag NCHAR(3),
@Indicator1 NCHAR(1),
@Indicator2 NCHAR(1)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[MarcDataField]
(
	[MarcID],
	[Tag],
	[Indicator1],
	[Indicator2],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@MarcID,
	@Tag,
	@Indicator1,
	@Indicator2,
	getdate(),
	getdate()
)

SET @MarcDataFieldID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcDataFieldInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[MarcDataFieldID],
		[MarcID],
		[Tag],
		[Indicator1],
		[Indicator2],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[MarcDataField]
	
	WHERE
		[MarcDataFieldID] = @MarcDataFieldID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcDataFieldSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcDataFieldSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcDataFieldSelectAuto]    Script Date: 10/16/2009 16:27:32 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcDataFieldSelectAuto PROCEDURE
-- Generated 4/15/2009 3:34:26 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for MarcDataField

CREATE PROCEDURE MarcDataFieldSelectAuto

@MarcDataFieldID INT

AS 

SET NOCOUNT ON

SELECT 

	[MarcDataFieldID],
	[MarcID],
	[Tag],
	[Indicator1],
	[Indicator2],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[MarcDataField]

WHERE
	[MarcDataFieldID] = @MarcDataFieldID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcDataFieldSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcDataFieldUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcDataFieldUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcDataFieldUpdateAuto]    Script Date: 10/16/2009 16:27:32 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcDataFieldUpdateAuto PROCEDURE
-- Generated 4/15/2009 3:34:26 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for MarcDataField

CREATE PROCEDURE MarcDataFieldUpdateAuto

@MarcDataFieldID INT,
@MarcID INT,
@Tag NCHAR(3),
@Indicator1 NCHAR(1),
@Indicator2 NCHAR(1)

AS 

SET NOCOUNT ON

UPDATE [dbo].[MarcDataField]

SET

	[MarcID] = @MarcID,
	[Tag] = @Tag,
	[Indicator1] = @Indicator1,
	[Indicator2] = @Indicator2,
	[LastModifiedDate] = getdate()

WHERE
	[MarcDataFieldID] = @MarcDataFieldID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcDataFieldUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[MarcDataFieldID],
		[MarcID],
		[Tag],
		[Indicator1],
		[Indicator2],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[MarcDataField]
	
	WHERE
		[MarcDataFieldID] = @MarcDataFieldID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcDeleteAuto]    Script Date: 10/16/2009 16:27:33 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcDeleteAuto PROCEDURE
-- Generated 4/21/2009 3:39:50 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Marc

CREATE PROCEDURE MarcDeleteAuto

@MarcID INT

AS 

DELETE FROM [dbo].[Marc]

WHERE

	[MarcID] = @MarcID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFPageUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFPageUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[PDFPageUpdateAuto]    Script Date: 10/16/2009 16:27:33 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PDFPageUpdateAuto PROCEDURE
-- Generated 11/24/2008 4:39:21 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for PDFPage

CREATE PROCEDURE PDFPageUpdateAuto

@PdfPageID INT,
@PdfID INT,
@PageID INT

AS 

SET NOCOUNT ON

UPDATE [dbo].[PDFPage]

SET

	[PdfID] = @PdfID,
	[PageID] = @PageID

WHERE
	[PdfPageID] = @PdfPageID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PDFPageUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PdfPageID],
		[PdfID],
		[PageID]

	FROM [dbo].[PDFPage]
	
	WHERE
		[PdfPageID] = @PdfPageID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcImportBatchDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcImportBatchDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcImportBatchDeleteAuto]    Script Date: 10/16/2009 16:27:33 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcImportBatchDeleteAuto PROCEDURE
-- Generated 4/16/2009 11:23:06 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for MarcImportBatch

CREATE PROCEDURE MarcImportBatchDeleteAuto

@MarcImportBatchID INT

AS 

DELETE FROM [dbo].[MarcImportBatch]

WHERE

	[MarcImportBatchID] = @MarcImportBatchID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcImportBatchDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcImportBatchInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcImportBatchInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcImportBatchInsertAuto]    Script Date: 10/16/2009 16:27:35 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcImportBatchInsertAuto PROCEDURE
-- Generated 4/16/2009 11:23:06 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for MarcImportBatch

CREATE PROCEDURE MarcImportBatchInsertAuto

@MarcImportBatchID INT OUTPUT,
@FileName NVARCHAR(500),
@InstitutionCode NVARCHAR(10) = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[MarcImportBatch]
(
	[FileName],
	[InstitutionCode],
	[CreationDate]
)
VALUES
(
	@FileName,
	@InstitutionCode,
	getdate()
)

SET @MarcImportBatchID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcImportBatchInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[MarcImportBatchID],
		[FileName],
		[InstitutionCode],
		[CreationDate]	

	FROM [dbo].[MarcImportBatch]
	
	WHERE
		[MarcImportBatchID] = @MarcImportBatchID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcImportBatchSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcImportBatchSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcImportBatchSelectAuto]    Script Date: 10/16/2009 16:27:35 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcImportBatchSelectAuto PROCEDURE
-- Generated 4/16/2009 11:23:06 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for MarcImportBatch

CREATE PROCEDURE MarcImportBatchSelectAuto

@MarcImportBatchID INT

AS 

SET NOCOUNT ON

SELECT 

	[MarcImportBatchID],
	[FileName],
	[InstitutionCode],
	[CreationDate]

FROM [dbo].[MarcImportBatch]

WHERE
	[MarcImportBatchID] = @MarcImportBatchID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcImportBatchSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcImportBatchSelectStatsByInstitution]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcImportBatchSelectStatsByInstitution]
GO


/****** Object:  StoredProcedure [dbo].[MarcImportBatchSelectStatsByInstitution]    Script Date: 10/16/2009 16:27:36 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.MarcImportBatchSelectStatsByInstitution

@InstitutionCode nvarchar(10) = ''

AS

SET NOCOUNT ON

SELECT	b.MarcImportBatchID,
		b.FileName,
		i.InstitutionName,
		b.CreationDate,
		COUNT(m.MarcID) AS NumberOfRecords,
		SUM(CASE WHEN m.MarcImportStatusID = 10 THEN 1 ELSE 0 END) AS New,
		SUM(CASE WHEN m.MarcImportStatusID = 20 THEN 1 ELSE 0 END) AS PendingImport,
		SUM(CASE WHEN m.MarcImportStatusID = 30 THEN 1 ELSE 0 END) AS Complete,
		SUM(CASE WHEN m.MarcImportStatusID = 99 THEN 1 ELSE 0 END) AS Error
FROM	dbo.MarcImportBatch b INNER JOIN dbo.Institution i
			ON b.InstitutionCode = i.InstitutionCode
		INNER JOIN dbo.Marc m
			ON b.MarcImportBatchID = m.MarcImportBatchID
WHERE	b.InstitutionCode = @InstitutionCode OR @InstitutionCode = ''
GROUP BY
		b.MarcImportBatchID,
		b.FileName,
		i.InstitutionName,
		b.CreationDate
ORDER BY
		b.CreationDate DESC

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcImportBatchUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcImportBatchUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcImportBatchUpdateAuto]    Script Date: 10/16/2009 16:27:37 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcImportBatchUpdateAuto PROCEDURE
-- Generated 4/16/2009 11:23:06 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for MarcImportBatch

CREATE PROCEDURE MarcImportBatchUpdateAuto

@MarcImportBatchID INT,
@FileName NVARCHAR(500),
@InstitutionCode NVARCHAR(10)

AS 

SET NOCOUNT ON

UPDATE [dbo].[MarcImportBatch]

SET

	[FileName] = @FileName,
	[InstitutionCode] = @InstitutionCode

WHERE
	[MarcImportBatchID] = @MarcImportBatchID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcImportBatchUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[MarcImportBatchID],
		[FileName],
		[InstitutionCode],
		[CreationDate]

	FROM [dbo].[MarcImportBatch]
	
	WHERE
		[MarcImportBatchID] = @MarcImportBatchID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFSelectForDeletion]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFSelectForDeletion]
GO


/****** Object:  StoredProcedure [dbo].[PDFSelectForDeletion]    Script Date: 10/16/2009 16:27:37 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PDFSelectForDeletion]
AS
BEGIN

SET NOCOUNT ON

-- Select PDFs generated more than 45 days ago that
-- do not have article information and have not yet
-- been deleted
SELECT	PdfID,
		FileLocation
FROM	PDF
WHERE	ArticleTitle = ''
AND		ArticleCreators = ''
AND		ArticleTags = ''
AND		DATEDIFF(d, FileGenerationDate, GETDATE()) > 45
AND		FileDeletionDate IS NULL

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PdfStatsSelectExpanded]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PdfStatsSelectExpanded]
GO


/****** Object:  StoredProcedure [dbo].[PdfStatsSelectExpanded]    Script Date: 10/16/2009 16:27:38 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.PdfStatsSelectExpanded
AS
BEGIN

SET NOCOUNT ON 

-- Detailed stats (by week and status)
SELECT	DATEPART(year, CreationDate) AS [Year],
		DATEPART(week, CreationDate) AS [Week],
		s.PdfStatusID,
		s.PdfStatusName, 
		COUNT(*) as [NumberOfPDFs],
		SUM(CASE WHEN ImagesOnly = 1 THEN 0 ELSE 1 END) AS [PDFsWithOCR],
		SUM(CASE WHEN ArticleTitle <> '' OR ArticleCreators <> '' OR ArticleTags <> '' THEN 1 ELSE 0 END) AS [PDFsWithArticleMetadata],
		SUM(DATEDIFF(minute, CreationDate, FileGenerationDate)) AS [TotalMinutesToGenerate],
		CONVERT(decimal(10,2), AVG(CONVERT(decimal, DATEDIFF(minute, CreationDate, FileGenerationDate)))) AS [AvgMinutesToGenerate],
		SUM(CASE WHEN NumberImagesMissing > 0 THEN 1 ELSE 0 END) AS [PDFsWithMissingImages],
		SUM(NumberImagesMissing) AS [TotalMissingImages],
		SUM(CASE WHEN NumberOCRMissing > 0 THEN 1 ELSE 0 END) AS [PDFsWithMissingOCR],
		SUM(NumberOCRMissing) AS [TotalMissingOCR]
FROM	dbo.PDF p INNER JOIN dbo.PDFStatus s
			ON p.PdfStatusID = s.PdfStatusID
GROUP BY
		s.PdfStatusId,
		s.PdfStatusName,
		DATEPART(year, CreationDate),
		DATEPART(week, CreationDate)
ORDER BY
		[Year] desc, [Week] desc, s.PdfStatusID
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcInsertAuto]    Script Date: 10/16/2009 16:27:38 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcInsertAuto PROCEDURE
-- Generated 4/21/2009 3:39:50 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Marc

CREATE PROCEDURE MarcInsertAuto

@MarcID INT OUTPUT,
@MarcImportStatusID INT,
@MarcImportBatchID INT,
@MarcFileLocation NVARCHAR(500),
@InstitutionCode NVARCHAR(10) = null,
@Leader NVARCHAR(200),
@TitleID INT = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Marc]
(
	[MarcImportStatusID],
	[MarcImportBatchID],
	[MarcFileLocation],
	[InstitutionCode],
	[Leader],
	[TitleID],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@MarcImportStatusID,
	@MarcImportBatchID,
	@MarcFileLocation,
	@InstitutionCode,
	@Leader,
	@TitleID,
	getdate(),
	getdate()
)

SET @MarcID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[MarcID],
		[MarcImportStatusID],
		[MarcImportBatchID],
		[MarcFileLocation],
		[InstitutionCode],
		[Leader],
		[TitleID],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[Marc]
	
	WHERE
		[MarcID] = @MarcID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcResolveTitles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcResolveTitles]
GO


/****** Object:  StoredProcedure [dbo].[MarcResolveTitles]    Script Date: 10/16/2009 16:27:38 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.MarcResolveTitles

@MarcImportBatchID INT

AS
BEGIN

SET NOCOUNT ON

-- =======================================================================
-- =======================================================================
-- =======================================================================
-- Create temp tables

CREATE TABLE #tmpTitle (
	[MarcID] int NOT NULL,
	[InstitutionCode] [nvarchar](10) NULL,
	[MARCBibID] [nvarchar](50) NULL,
	[ShortTitle] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[TitleID] [int] NULL
	)

CREATE TABLE #tmpTitleIdentifier
	(
	[MarcID] int NOT NULL,
	[IdentifierName] [nvarchar](40) NOT NULL,
	[IdentifierValue] [nvarchar](125) NULL,
	)

BEGIN TRY
	-- =======================================================================
	-- =======================================================================
	-- =======================================================================
	-- Get Titles

	-- Get the initial list of titles
	INSERT	#tmpTitle (MarcID, InstitutionCode)
	SELECT	MarcID, InstitutionCode
	FROM	dbo.Marc
	WHERE	MarcImportStatusID = 10 -- New
	AND		MarcImportBatchID = @MarcImportBatchID

	-- Get the MARC BIB ID
	UPDATE	#tmpTitle
	SET		MARCBibID = REPLACE(m.Leader, ' ', 'x')
	FROM	#tmpTitle t INNER JOIN dbo.Marc m
				ON t.MarcID = m.MarcID

	-- Get the publication titles
	UPDATE	#tmpTitle
	SET		ShortTitle = df.SubFieldValue
	FROM	#tmpTitle t INNER JOIN dbo.vwMarcDataField df
				ON t.MarcID = df.MarcID
	WHERE	df.DataFieldTag = '245'
	AND		df.Code = 'a'

	-- =======================================================================
	-- =======================================================================
	-- =======================================================================
	-- Get Title Identifiers

	-- Get the OCLC numbers from the 035a and 010o MARC fields (in most cases it's located in one
	-- or the other of these)
	INSERT INTO #tmpTitleIdentifier
	SELECT	t.MarcID,
			'OCLC',
			COALESCE(CONVERT(NVARCHAR(30), CONVERT(BIGINT, dbo.fnFilterString(m.subfieldvalue, '[0-9]', ''))), 
					CONVERT(NVARCHAR(30), CONVERT(BIGINT, dbo.fnFilterString(m2.subfieldvalue, '[0-9]', ''))))
	FROM	#tmpTitle t 
			LEFT JOIN (SELECT * FROM dbo.vwMarcDataField 
						WHERE DataFieldTag = '035' AND code = 'a' AND 
						(SubFieldValue LIKE '(OCoLC)%' OR SubFieldValue LIKE 'ocm%' OR SubFieldValue LIKE 'ocn%')
						) m
				ON t.MarcID = m.MarcID
			LEFT JOIN (SELECT * FROM dbo.vwMarcDataField
						WHERE DataFieldTag = '010' AND Code = 'o') m2
				ON t.MarcID = m2.MarcID

	-- Next check MARC control 001 record for the OCLC number (not too many of these)
	INSERT INTO #tmpTitleIdentifier
	SELECT	t.MarcID,
			'OCLC',
			CONVERT(NVARCHAR(30), CONVERT(INT, dbo.fnFilterString(mc.value, '[0-9]', '')))
	FROM	#tmpTitle t 
			LEFT JOIN (SELECT * FROM dbo.vwMarcControl WHERE tag = '001' AND [value] NOT LIKE 'Catkey%') mc
				ON t.MarcID = mc.MarcID
			LEFT JOIN (SELECT * FROM dbo.vwMarcControl WHERE tag = '003' AND [value] = 'OCoLC') mc2
				ON t.MarcID = mc2.MarcID
	WHERE	(mc.[Value] LIKE 'oc%' OR mc2.[value] = 'OCoLC')
	AND		NOT EXISTS (SELECT IdentifierValue FROM #tmpTitleIdentifier 
						WHERE MarcID = t.MarcID
						AND IdentifierValue IS NOT NULL)

	-- Get the Library Of Congress Control numbers
	INSERT INTO #tmpTitleIdentifier
	SELECT DISTINCT
			t.MarcID,
			'DLC',
			LTRIM(RTRIM(m.SubFieldValue))
	FROM	#tmpTitle t INNER JOIN dbo.vwMarcDataField m
				ON t.MarcID = m.MarcID
	WHERE	DataFieldTag = '010'
	AND		Code = 'a'

	-- Get the ISBN identifiers
	INSERT INTO #tmpTitleIdentifier
	SELECT DISTINCT
			t.MarcID,
			'ISBN',
			m.SubFieldValue
	FROM	#tmpTitle t INNER JOIN dbo.vwMarcDataField m
				ON t.MarcID = m.MarcID
	WHERE	m.DataFieldTag = '020'
	AND		m.Code = 'a'

	-- Get the ISSN identifiers
	INSERT INTO #tmpTitleIdentifier
	SELECT DISTINCT
			t.MarcID,
			'ISSN',
			m.SubFieldValue
	FROM	#tmpTitle t INNER JOIN dbo.vwMarcDataField m
				ON t.MarcID = m.MarcID
	WHERE	m.DataFieldTag = '022'
	AND		m.Code = 'a'

	-- Get the WonderFetch identifiers (look for a MARC
	-- 001 control record with a value including 'catkey')
	INSERT INTO #tmpTitleIdentifier
	SELECT DISTINCT 
			t.MarcID,
			'WonderFetch',
			LTRIM(RTRIM(REPLACE(m.[Value], 'catkey', ''))) 
	FROM	#tmpTitle t INNER JOIN dbo.vwMarcControl m
				ON t.MarcID = m.MarcID
	WHERE	m.Tag = '001' 
	AND		m.[Value] LIKE 'catkey%'

	-- Get the non-OCLC and non-WonderFetch local identifiers from the 
	-- MARC 001 control record
	INSERT INTO #tmpTitleIdentifier
	SELECT DISTINCT
			t.MarcID,
			'MARC001',
			m.[Value]
	FROM	#tmpTitle t INNER JOIN dbo.vwMarcControl m
				ON t.MarcID = m.MarcID
	WHERE	m.Tag = '001'
	AND		m.[Value] NOT LIKE 'catkey%'
	AND		m.[Value] NOT LIKE 'oc%'

	-- Remove null values
	DELETE FROM #tmpTitleIdentifier WHERE IdentifierValue IS NULL

	-- =======================================================================
	-- =======================================================================
	-- =======================================================================
	-- Resolve titles.  

	-- Titles are unique by institution.  That is, a given title may only 
	-- appear more than once if it is contributed by more than one institution.
	-- Multiple attempts are made to find a matching title in production.  In
	-- order, the following criteria are used to find a match:
	--
	--	1) OCLC
	--	2) Library of Congress Control number
	--	3) ISBN
	--	4) ISSN
	--	5) WonderFetch TitleID
	--	6) MARC 001 value
	--	7) MARC Bib ID + Short Title
	--

	-- Match on OCLC + Institution Code
	UPDATE	#tmpTitle
	SET		TitleID = bt.TitleID
	FROM	#tmpTitle t INNER JOIN #tmpTitleIdentifier tti
				ON t.MarcID = tti.MarcID
				AND 'OCLC' = tti.IdentifierName
			INNER JOIN dbo.Title_TitleIdentifier btti
				ON tti.IdentifierValue = btti.IdentifierValue
			INNER JOIN dbo.TitleIdentifier bti
				ON btti.TitleIdentifierID = bti.TitleIdentifierID
				AND tti.IdentifierName = bti.IdentifierName
			INNER JOIN dbo.Title bt
				ON btti.TitleID = bt.TitleID
				AND t.InstitutionCode = bt.InstitutionCode
				AND 1 = bt.PublishReady
	WHERE	t.TitleID IS NULL

	-- Match on Lib of Cong Control # + Institution Code
	UPDATE	#tmpTitle
	SET		TitleID = bt.TitleID
	FROM	#tmpTitle t INNER JOIN #tmpTitleIdentifier tti
				ON t.MarcID = tti.MarcID
				AND 'DLC' = tti.IdentifierName
			INNER JOIN dbo.Title_TitleIdentifier btti
				ON tti.IdentifierValue = btti.IdentifierValue
			INNER JOIN dbo.TitleIdentifier bti
				ON btti.TitleIdentifierID = bti.TitleIdentifierID
				AND tti.IdentifierName = bti.IdentifierName
			INNER JOIN dbo.Title bt
				ON btti.TitleID = bt.TitleID
				AND t.InstitutionCode = bt.InstitutionCode
				AND 1 = bt.PublishReady
	WHERE	t.TitleID IS NULL

	-- Match on ISBN + Institution Code
	UPDATE	#tmpTitle
	SET		TitleID = bt.TitleID
	FROM	#tmpTitle t INNER JOIN #tmpTitleIdentifier tti
				ON t.MarcID = tti.MarcID
				AND 'ISBN' = tti.IdentifierName
			INNER JOIN dbo.Title_TitleIdentifier btti
				ON tti.IdentifierValue = btti.IdentifierValue
			INNER JOIN dbo.TitleIdentifier bti
				ON btti.TitleIdentifierID = bti.TitleIdentifierID
				AND tti.IdentifierName = bti.IdentifierName
			INNER JOIN dbo.Title bt
				ON btti.TitleID = bt.TitleID
				AND t.InstitutionCode = bt.InstitutionCode
				AND 1 = bt.PublishReady
	WHERE	t.TitleID IS NULL

	-- Match on ISSN + Institution Code
	UPDATE	#tmpTitle
	SET		TitleID = bt.TitleID
	FROM	#tmpTitle t INNER JOIN #tmpTitleIdentifier tti
				ON t.MarcID = tti.MarcID
				AND 'ISSN' = tti.IdentifierName
			INNER JOIN dbo.Title_TitleIdentifier btti
				ON tti.IdentifierValue = btti.IdentifierValue
			INNER JOIN dbo.TitleIdentifier bti
				ON btti.TitleIdentifierID = bti.TitleIdentifierID
				AND tti.IdentifierName = bti.IdentifierName
			INNER JOIN dbo.Title bt
				ON btti.TitleID = bt.TitleID
				AND t.InstitutionCode = bt.InstitutionCode
				AND 1 = bt.PublishReady
	WHERE	t.TitleID IS NULL

	-- Match on WonderFetch Title ID + Institution Code
	UPDATE	#tmpTitle
	SET		TitleID = bt.TitleID
	FROM	#tmpTitle t INNER JOIN #tmpTitleIdentifier tti
				ON t.MarcID = tti.MarcID
				AND 'WonderFetch' = tti.IdentifierName
			INNER JOIN dbo.Title_TitleIdentifier btti
				ON tti.IdentifierValue = btti.IdentifierValue
			INNER JOIN dbo.TitleIdentifier bti
				ON btti.TitleIdentifierID = bti.TitleIdentifierID
				AND tti.IdentifierName = bti.IdentifierName
			INNER JOIN dbo.Title bt
				ON btti.TitleID = bt.TitleID
				AND t.InstitutionCode = bt.InstitutionCode
				AND 1 = bt.PublishReady
	WHERE	t.TitleID IS NULL

	-- Match on MARC 001 Value + Institution Code
	UPDATE	#tmpTitle
	SET		TitleID = bt.TitleID
	FROM	#tmpTitle t INNER JOIN #tmpTitleIdentifier tti
				ON t.MarcID = tti.MarcID
				AND 'MARC001' = tti.IdentifierName
			INNER JOIN dbo.Title_TitleIdentifier btti
				ON tti.IdentifierValue = btti.IdentifierValue
			INNER JOIN dbo.TitleIdentifier bti
				ON btti.TitleIdentifierID = bti.TitleIdentifierID
				AND tti.IdentifierName = bti.IdentifierName
			INNER JOIN dbo.Title bt
				ON btti.TitleID = bt.TitleID
				AND t.InstitutionCode = bt.InstitutionCode
				AND 1 = bt.PublishReady
	WHERE	t.TitleID IS NULL

	-- Match on MARC Bib ID + Short Title
	UPDATE	#tmpTitle
	SET		TitleID = bt.TitleID
	FROM	#tmpTitle t INNER JOIN dbo.Title bt
				ON t.MARCBibID = bt.MARCBibID
				AND t.ShortTitle = bt.ShortTitle
	WHERE	t.TitleID IS NULL

	-- DEBUG STATEMENTS
	--select * from #tmpTitle
	--select * from #tmpTitleIdentifier

	-- =======================================================================
	-- =======================================================================
	-- =======================================================================
	-- Update the Marc records with the resolved title identifiers, and set
	-- the batch import status to 20 (Resolved)

	UPDATE	dbo.Marc
	SET		TitleID = t.TitleID,
			MarcImportStatusID = 20
	FROM	dbo.Marc m INNER JOIN #tmpTitle t
				ON m.MarcID = t.MarcID

	SELECT 1 AS Result
END TRY
BEGIN CATCH
	-- Record the error
	INSERT INTO dbo.MarcImportError (MarcImportBatchID, ErrorDate, Number, Severity, State, 
		[Procedure], Line, [Message])
	SELECT	@MarcImportBatchID, GETDATE(), ERROR_NUMBER(), ERROR_SEVERITY(),
		ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE()

	-- Mark the item as in error
	UPDATE	dbo.Marc
	SET		MarcImportStatusID = 99	-- Error
	WHERE	MarcImportBatchID = @MarcImportBatchID

	SELECT 0 AS RESULT
END CATCH

-- =======================================================================
-- =======================================================================
-- =======================================================================
-- Clean up temp tables

DROP TABLE #tmpTitle
DROP TABLE #tmpTitleIdentifier

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSelectAssociationIdsByMarcDataFieldID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSelectAssociationIdsByMarcDataFieldID]
GO


/****** Object:  StoredProcedure [dbo].[MarcSelectAssociationIdsByMarcDataFieldID]    Script Date: 10/16/2009 16:27:39 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarcSelectAssociationIdsByMarcDataFieldID]

@MarcDataFieldID int

AS
BEGIN

SET NOCOUNT ON

-- =======================================================================
-- Build temp table

CREATE TABLE #tmpIdentifier (
	[TitleIdentifierID] [int] NOT NULL,
	[IdentifierValue] [varchar](125) NOT NULL DEFAULT ('')
)

-- =======================================================================
-- Populate the temp table

DECLARE @OCLC int
DECLARE @DLC int
DECLARE @ISSN int

SELECT @OCLC = TitleIdentifierID FROM dbo.TitleIdentifier WHERE IdentifierName = 'OCLC'
SELECT @DLC = TitleIdentifierID FROM dbo.TitleIdentifier WHERE IdentifierName = 'DLC'
SELECT @ISSN = TitleIdentifierID FROM dbo.TitleIdentifier WHERE IdentifierName = 'ISSN'

-- OCLC
INSERT INTO #tmpIdentifier (TitleIdentifierID, IdentifierValue)
SELECT	@OCLC, 
		LTRIM(RTRIM(REPLACE(m.SubFieldValue, '(OCoLC)', '')))
FROM	vwMarcDataField m
WHERE	m.Code = 'w' 
AND		m.SubFieldValue LIKE '(OCoLC)%'
AND		m.MarcDataFieldID = @MarcDataFieldID

-- DLC (Library of Congress)
INSERT INTO #tmpIdentifier (TitleIdentifierID, IdentifierValue)
SELECT	@DLC, 
		LTRIM(RTRIM(REPLACE(m.SubFieldValue, '(DLC)', '')))
FROM	vwMarcDataField m
WHERE	m.Code = 'w' 
AND		m.SubFieldValue LIKE '(DLC)%'
AND		m.MarcDataFieldID = @MarcDataFieldID

-- ISSN
INSERT INTO #tmpIdentifier (TitleIdentifierID, IdentifierValue)
SELECT	@ISSN, 
		LTRIM(RTRIM(REPLACE(m.SubFieldValue, ';', '')))
FROM	vwMarcDataField m
WHERE	Code = 'x'
AND		m.MarcDataFieldID = @MarcDataFieldID

-- =======================================================================
-- Deliver the final result set
SELECT	TitleIdentifierID,
		IdentifierValue
FROM	#tmpIdentifier
WHERE	IdentifierValue <> ''

DROP TABLE #tmpIdentifier

SET NOCOUNT OFF

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSelectAssociationsByMarcID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSelectAssociationsByMarcID]
GO


/****** Object:  StoredProcedure [dbo].[MarcSelectAssociationsByMarcID]    Script Date: 10/16/2009 16:27:39 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarcSelectAssociationsByMarcID]

@MarcID int

AS
BEGIN

SET NOCOUNT ON

-- =======================================================================
-- Build temp table

CREATE TABLE #tmpTitleAssociation(
	[Sequence] [int] NOT NULL,
	[MARCDataFieldID] [int] NOT NULL,
	[MARCTag] [nvarchar](20) NOT NULL,
	[MARCIndicator1] [nchar](1) NOT NULL DEFAULT (''),
	[MARCIndicator2] [nchar](1) NOT NULL DEFAULT (''),
	[Title] [nvarchar](500) NOT NULL DEFAULT (''),
	[Section] [nvarchar](500) NOT NULL DEFAULT (''),
	[Volume] [nvarchar](500) NOT NULL DEFAULT (''),
	[Heading] [nvarchar](500) NOT NULL DEFAULT (''),
	[Publication] [nvarchar](500) NOT NULL DEFAULT (''),
	[Relationship] [nvarchar](500) NOT NULL DEFAULT ('')
	)

-- =======================================================================
-- Populate the temp table

-- Get 440 and 490 tag with an 'a' code
INSERT INTO #tmpTitleAssociation
SELECT	ROW_NUMBER() OVER (PARTITION BY m.MarcDataFieldID
							ORDER BY m.MarcSubFieldID) AS Sequence,
		m.MarcDataFieldID,
		m.DataFieldTag, 
		m.Indicator1 AS MARCIndicator1,
		'' AS MARCIndicator2, 
		m.SubFieldValue AS Title, 
		'' AS Section, 
		'' AS Volume,
		'' AS Heading,
		'' AS Publication,
		'' AS Relationship
FROM	vwMarcDataField m
WHERE	m.DataFieldTag IN ('440', '490')
AND		m.Code = 'a'
AND		m.SubFieldValue <> ''
AND		m.MarcID = @MarcID

-- Add the section and volume information to the original data set.
-- Use generated sequence numbers to match the sections/volumes
-- with titles (there's no guaranteed relational way of making the
-- matches, so this is the best guess approach).
UPDATE	#tmpTitleAssociation
SET		Section = x.SubFieldValue
FROM	#tmpTitleAssociation t INNER JOIN (
				SELECT	ROW_NUMBER() OVER (PARTITION BY m.MarcDataFieldID
											ORDER BY m.MarcSubFieldID) AS NewSequence,
						m.*
				FROM	vwMarcDataField m
				WHERE	m.DataFieldTag IN ('440', '490')
				AND		m.Code = 'p'
				AND		m.SubFieldValue <> ''
				AND		m.MarcID = @MarcID
				) x
			ON t.MarcDataFieldID = x.MarcDataFieldID
			AND t.Sequence = x.NewSequence

UPDATE	#tmpTitleAssociation
SET		Volume = x.SubFieldValue
FROM	#tmpTitleAssociation t INNER JOIN (
				SELECT	ROW_NUMBER() OVER (PARTITION BY m.MarcDataFieldID
											ORDER BY m.MarcSubFieldID) AS NewSequence,
						m.*
				FROM	vwMarcDataField m
				WHERE	m.DataFieldTag IN ('440', '490')
				AND		m.Code = 'v'
				AND		m.SubFieldValue <> ''
				AND		m.MarcID = @MarcID
				) x
			ON t.MarcDataFieldID = x.MarcDataFieldID
			AND t.Sequence = x.NewSequence

-- Get the 830 records (these will be used to replace or augment certain 490 records)
SELECT	x.MarcDataFieldID, 
		x.DataFieldTag, 
		MIN([a]) AS Title, 
		MIN([p]) AS Section, 
		MIN([v]) AS Volume
INTO	#tmp830
FROM	(
		SELECT	MarcDataFieldID, DataFieldTag, Indicator1, [a], [p], [v]
		FROM	(SELECT * FROM dbo.vwMarcDataField
				WHERE DataFieldTag IN ('830')
				AND MarcID = @MarcID) AS m
		PIVOT	(MIN(SubFieldValue) FOR Code IN ([a], [p], [v])) AS Pvt
		) x
GROUP BY
		x.MarcDataFieldID, x.DataFieldTag

-- Delete the 490 records for which we have an 830 record, UNLESS there is
-- an identifier (code = x) associated with the 490.  The identifier gives
-- us a known, exact way to identify the series, and we don't want to throw
-- that away.
DELETE	#tmpTitleAssociation
WHERE	MARCTag = '490'
AND		MARCIndicator1 = '1'
AND		EXISTS(SELECT * FROM #tmp830)
AND		NOT EXISTS(	SELECT * FROM dbo.vwMarcDataField 
					WHERE DataFieldTag = '490' AND Code = 'x' AND MarcID = @MarcID)

-- Insert the 830 title associations when we haven't already collected a 490 record.
INSERT INTO #tmpTitleAssociation
SELECT DISTINCT
		0 AS Sequence,
		t8.MarcDatafieldID,
		t8.DataFieldTag,
		'',
		'',
		ISNULL(t8.Title, ''),
		ISNULL(t8.Section, ''),
		ISNULL(t8.Volume, ''),
		'',
		'',
		''
FROM	#tmp830 t8
WHERE	NOT EXISTS(SELECT * FROM #tmpTitleAssociation WHERE MARCTag = '490' AND MarcIndicator1 = '1')

DROP TABLE #tmp830

-- Get 780 and 785 tags with 't' or 'a' code (give preference to 't')
INSERT INTO #tmpTitleAssociation
SELECT DISTINCT
		0 AS Sequence, 
		m.MarcDataFieldID, 
		m.DataFieldTag, 
		'',
		m.Indicator2, 
		'' AS Title, 
		'' AS Section, 
		'' AS Volume,
		'' AS Heading,
		'' AS Publication,
		'' AS Relationship
FROM	vwMarcDataField m
WHERE	m.DataFieldTag IN ('780', '785')
AND		m.Code IN ('t','a')
AND		m.SubFieldValue <> ''
AND		m.MarcID = @MarcID

UPDATE	#tmpTitleAssociation
SET		Title = m.SubFieldValue
FROM	#tmpTitleAssociation t INNER JOIN vwMarcDataField m
			ON t.MarcDataFieldID = m.MarcDataFieldID
WHERE	m.Code = 't'
AND		m.DataFieldTag IN ('780', '785')

UPDATE	#tmpTitleAssociation
SET		Title = CONVERT(NVARCHAR(200), m.SubFieldValue + ' ' + Title)
FROM	#tmpTitleAssociation t INNER JOIN vwMarcDataField m
			ON t.MarcDataFieldID = m.MarcDataFieldID
WHERE	m.Code = 'a'
AND		m.DataFieldTag IN ('780', '785')

-- Get 773 tags (this is Host Item information... defines "container" items for 
-- titles that are also articles)
INSERT INTO #tmpTitleAssociation
SELECT	0 AS Sequence,
		x.MarcDataFieldID,
		x.DataFieldTag,
		'',
		'',
		ISNULL(MIN([t]), '') AS Title,
		'' AS Section,
		'' AS Volume,
		ISNULL(MIN([a]), '') AS Heading, 
		ISNULL(MIN([d]), '') AS Publication, 
		ISNULL(MIN([g]), '') AS Relationship
FROM	(
		SELECT	MarcDataFieldID, DataFieldTag, [a], [d], [g], [t]
		FROM	(SELECT * FROM dbo.vwMarcDataField
				WHERE DataFieldTag = '773'
				AND MarcID = @MarcID) AS m
		PIVOT	(MIN(SubFieldValue) FOR Code in ([a], [d], [g], [t])) AS Pvt
		) x
GROUP BY x.MarcDataFieldID, x.DataFieldTag

-- =======================================================================
-- Deliver the final result set
SELECT	Sequence,
		MARCDataFieldID,
		t.MARCTag,
		MARCIndicator1,
		t.MARCIndicator2,
		tat.TitleAssociationTypeID,
		Title,
		Section,
		Volume,
		Heading,
		Publication,
		Relationship
FROM	#tmpTitleAssociation t INNER JOIN dbo.TitleAssociationType tat
			ON t.MARCTag = tat.MARCTag
			AND t.MARCIndicator2 = tat.MARCIndicator2

DROP TABLE #tmpTitleAssociation

SET NOCOUNT OFF

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcSelectAuto]    Script Date: 10/16/2009 16:27:40 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcSelectAuto PROCEDURE
-- Generated 4/21/2009 3:39:50 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for Marc

CREATE PROCEDURE MarcSelectAuto

@MarcID INT

AS 

SET NOCOUNT ON

SELECT 

	[MarcID],
	[MarcImportStatusID],
	[MarcImportBatchID],
	[MarcFileLocation],
	[InstitutionCode],
	[Leader],
	[TitleID],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[Marc]

WHERE
	[MarcID] = @MarcID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSelectCreatorsByMarcID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSelectCreatorsByMarcID]
GO


/****** Object:  StoredProcedure [dbo].[MarcSelectCreatorsByMarcID]    Script Date: 10/16/2009 16:27:41 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarcSelectCreatorsByMarcID]

@MarcID int

AS
BEGIN

SET NOCOUNT ON

-- =======================================================================
-- Build temp table

CREATE TABLE #tmpCreator (
	[CreatorRoleTypeID] [int] NOT NULL,
	[CreatorName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
	[DOB] [nvarchar](50) NULL,
	[DOD] [nvarchar](50) NULL,
	[MARCDataFieldID] [int] NULL,
	[MARCDataFieldTag] [nvarchar](3) NULL,
	[MARCCreator_a] [nvarchar](450) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MARCCreator_b] [nvarchar](450) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MARCCreator_c] [nvarchar](450) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MARCCreator_d] [nvarchar](450) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MARCCreator_Full] [nvarchar](450) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[CreatorID] [int] NULL
	)

-- =======================================================================
-- Populate the temp table

-- Get the initial creator information (MARC subfield code 'a')
INSERT INTO #tmpCreator (CreatorName, CreatorRoleTypeID, MARCDataFieldID, 
						MARCDataFieldTag, MARCCreator_a)
SELECT	m.SubFieldValue,
		0,
		m.MARCDataFieldID, 
		m.DataFieldTag,
		m.SubFieldValue
FROM	dbo.vwMarcDataField m
WHERE	m.DataFieldTag IN ('100', '110', '111', '700', '710', '711')
AND		m.Code = 'a'
AND		m.MarcID = @MarcID

-- Get creator MARC subfield 'b'
UPDATE	#tmpCreator
SET		MARCCreator_b = m.SubFieldValue
FROM	#tmpCreator t INNER JOIN dbo.vwMarcDataField m
			ON t.MarcDataFieldID = m.MarcDataFieldID
			AND t.MarcDataFieldTag = m.DataFieldTag
			AND m.Code = 'b'

-- Get creator MARC subfield 'c'
UPDATE	#tmpCreator
SET		MARCCreator_c = m.SubFieldValue
FROM	#tmpCreator t INNER JOIN dbo.vwMarcDataField m
			ON t.MarcDataFieldID = m.MarcDataFieldID
			AND t.MarcDataFieldTag = m.DataFieldTag
			AND m.Code = 'c'

-- Get creator MARC subfield 'd'
UPDATE	#tmpCreator
SET		MARCCreator_d = m.SubFieldValue
FROM	#tmpCreator t INNER JOIN dbo.vwMarcDataField m
			ON t.MarcDataFieldID = m.MarcDataFieldID
			AND t.MarcDataFieldTag = m.DataFieldTag
			AND m.Code = 'd'

-- Build the MarcCreatorFull from the information we now have
UPDATE	#tmpCreator
SET		MARCCreator_Full = LEFT(ISNULL(MarcCreator_a, '') + ' ' + 
								ISNULL(MarcCreator_b, '') + ' ' +
								ISNULL(MarcCreator_c, '') + ' ' + 
								ISNULL(MarcCreator_d, ''), 450)

-- Get the creator role type identifier
UPDATE	#tmpCreator
SET		CreatorRoleTypeID = rt.CreatorRoleTypeID
FROM	#tmpCreator t INNER JOIN dbo.CreatorRoleType rt
			ON t.MARCDataFieldTag = rt.MARCDataFieldTag

-- Get the creator DOB and DOD values
SELECT	MARCCreator_a,
		MARCCreator_b,
		MARCCreator_c,
		MARCCreator_d,
		LTRIM(RTRIM(
			REPLACE(
			REPLACE(
			REPLACE(MARCCreator_d, 
				'b.', ''), 
				'.', ''), 
				',', '')
		)) AS Dates
INTO	#tmpCreatorDates
FROM	#tmpCreator
WHERE	ISNULL(MARCCreator_d, '') <> ''

UPDATE	#tmpCreator
SET		DOB = SUBSTRING(d.Dates, 1, 4),
		DOD = CASE WHEN LEN(d.Dates) > 5 THEN SUBSTRING(d.Dates, 6, 4) END
FROM	#tmpCreator c INNER JOIN #tmpCreatorDates d
			ON ISNULL(c.MARCCreator_a, '') = ISNULL(d.MARCCreator_a, '')
			AND ISNULL(c.MARCCreator_b, '') = ISNULL(d.MARCCreator_b, '')
			AND ISNULL(c.MARCCreator_c, '') = ISNULL(d.MARCCreator_c, '')
			AND ISNULL(c.MARCCreator_d, '') = ISNULL(d.MARCCreator_d, '')

DROP TABLE #tmpCreatorDates

-- =======================================================================
-- Add new creator records, if necessary
BEGIN TRY
	-- Insert new creators into the production database
	INSERT INTO dbo.Creator (CreatorName, DOB, DOD,MARCDataFieldTag, 
		MARCCreator_a, MARCCreator_b, MARCCreator_c, MARCCreator_d, 
		MARCCreator_Full, CreationDate, LastModifiedDate)
	SELECT	t.CreatorName, t.DOB, t.DOD, MIN(t.MARCDataFieldTag), 
			t.MARCCreator_a, t.MARCCreator_b, t.MARCCreator_c, t.MARCCreator_d, 
			t.MARCCreator_Full, GETDATE(), GETDATE()
	FROM	#tmpCreator t LEFT JOIN dbo.Creator c
				ON ISNULL(t.MARCCreator_a, '') = ISNULL(c.MARCCreator_a, '')
				AND ISNULL(t.MARCCreator_b, '') = ISNULL(c.MARCCreator_b, '')
				AND ISNULL(t.MARCCreator_c, '') = ISNULL(c.MARCCreator_c, '')
				AND (ISNULL(t.MARCCreator_d, '') = ISNULL(c.MARCCreator_d, '') OR
					ISNULL(t.MARCCreator_d, '') + '.' = ISNULL(c.MARCCreator_d, '') OR
					ISNULL(t.MARCCreator_d, '') = ISNULL(c.MARCCreator_d, '') + '.')
	WHERE	c.CreatorID IS NULL
	GROUP BY t.CreatorName, t.DOB, t.DOD, t.MARCCreator_a, t.MARCCreator_b, 
			t.MARCCreator_c, t.MARCCreator_d, t.MARCCreator_Full
END TRY
BEGIN CATCH
	-- Record the error
	INSERT INTO dbo.MarcImportError (ErrorDate, Number, Severity, State, 
		[Procedure], Line, [Message])
	SELECT	GETDATE(), ERROR_NUMBER(), ERROR_SEVERITY(),
		ERROR_STATE(), ERROR_PROCEDURE(), ERROR_LINE(), ERROR_MESSAGE()
END CATCH

-- =======================================================================
-- Add the production creator IDs to the temp table
UPDATE	#tmpCreator
SET		CreatorID = c.CreatorID
FROM	#tmpCreator t INNER JOIN dbo.Creator c
			ON ISNULL(t.MARCCreator_a, '') = ISNULL(c.MARCCreator_a, '')
			AND ISNULL(t.MARCCreator_b, '') = ISNULL(c.MARCCreator_b, '')
			AND ISNULL(t.MARCCreator_c, '') = ISNULL(c.MARCCreator_c, '')
			AND (ISNULL(t.MARCCreator_d, '') = ISNULL(c.MARCCreator_d, '') OR
				ISNULL(t.MARCCreator_d, '') + '.' = ISNULL(c.MARCCreator_d, '') OR
				ISNULL(t.MARCCreator_d, '') = ISNULL(c.MARCCreator_d, '') + '.')

-- =======================================================================
-- Deliver the final result set
SELECT DISTINCT
		CreatorRoleTypeID,
		CreatorName,
		DOB,
		DOD,
--		MARCDataFieldID,
		MARCDataFieldTag,
		MARCCreator_a,
		MARCCreator_b,
		MARCCreator_c,
		MARCCreator_d,
		MARCCreator_Full,
		CreatorID
FROM	#tmpCreator
WHERE	CreatorID IS NOT NULL

DROP TABLE #tmpCreator

SET NOCOUNT OFF

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSelectForImportByBatchID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSelectForImportByBatchID]
GO


/****** Object:  StoredProcedure [dbo].[MarcSelectForImportByBatchID]    Script Date: 10/16/2009 16:27:41 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarcSelectForImportByBatchID]

@MarcImportBatchID int

AS
BEGIN

SET NOCOUNT ON

SELECT	MarcID, MarcFileLocation, InstitutionCode, Leader, TitleID AS BHLTitleID
FROM	dbo.Marc
WHERE	MarcImportBatchID = @MarcImportBatchID
AND		MarcImportStatusID = 20

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSelectFullDetailsForMarcID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSelectFullDetailsForMarcID]
GO


/****** Object:  StoredProcedure [dbo].[MarcSelectFullDetailsForMarcID]    Script Date: 10/16/2009 16:27:41 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarcSelectFullDetailsForMarcID]

@MarcID INT

AS
BEGIN

SET NOCOUNT ON

SELECT	TOP 1 '_Leader' AS DataFieldTag, '' AS Indicator1, '' AS Indicator2, '' AS Code, Leader AS [SubFieldValue]
FROM	vwMarcControl
WHERE	MarcID = @MarcID
UNION
SELECT	Tag AS DataFieldTag, '' AS Indicator1, '' AS Indicator2, '' AS Code, [Value] AS SubFieldValue
FROM	vwMarcControl
WHERE	MarcID = @MarcID
UNION
SELECT	DataFieldTag, Indicator1, Indicator2, Code, SubFieldValue
FROM	vwMarcDataField 
WHERE	MarcID = @MarcID
ORDER BY
		DataFieldTag,
		Code,
		SubFieldValue

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSelectPendingImport]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSelectPendingImport]
GO


/****** Object:  StoredProcedure [dbo].[MarcSelectPendingImport]    Script Date: 10/16/2009 16:27:42 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarcSelectPendingImport]

@MarcImportBatchID INT

AS
BEGIN

SET NOCOUNT ON

SELECT	MarcID, 
		ISNULL([a], '') AS [TitlePart1],
		ISNULL([b], '') AS [TitlePart2],
		ISNULL([c], '') AS [Responsible], 
		ISNULL([n], '') AS [Number],
		ISNULL([p], '') AS [Part],
		TitleID AS [BHLTitleID],
		ShortTitle AS [BHLShortTitle]
FROM 
(
	SELECT	v.MarcID, 
			v.Code, 
			v.SubFieldValue,
			m.TitleID,
			t.ShortTitle
	FROM	dbo.vwMarcDataField v INNER JOIN dbo.Marc m
				ON v.MarcID = m.MarcID
			LEFT JOIN dbo.Title t
				ON m.TitleID = t.TitleID
	WHERE	DataFieldTag = '245'
	AND		Code in ('a', 'b', 'c', 'n', 'p')
	AND		m.MarcImportStatusID = 20
	AND		m.MarcImportBatchID = @MarcImportBatchID
) m
PIVOT
(
	MIN(SubFieldValue)
	FOR Code in ([a], [b], [c], [n], [p])
) pvt
ORDER BY [TitlePart1]
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSelectTitleDetailsByMarcID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSelectTitleDetailsByMarcID]
GO


/****** Object:  StoredProcedure [dbo].[MarcSelectTitleDetailsByMarcID]    Script Date: 10/16/2009 16:27:42 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarcSelectTitleDetailsByMarcID]

@MarcID int

AS
BEGIN

SET NOCOUNT ON

-- =======================================================================
-- Build temp table

CREATE TABLE #tmpTitle (
	[MARCBibID] [nvarchar](50) NOT NULL,
	[MARCLeader] [nvarchar](24) NULL,
	[FullTitle] [ntext] NOT NULL,
	[ShortTitle] [nvarchar](255) NULL,
	[UniformTitle] [nvarchar](255) NULL,
	[SortTitle] [nvarchar](65) NULL,
	[CallNumber] [nvarchar](100) NULL,
	[PublicationDetails] [nvarchar](255) NULL,
	[StartYear] [smallint] NULL,
	[EndYear] [smallint] NULL,
	[Datafield_260_a] [nvarchar](150) NULL,
	[Datafield_260_b] [nvarchar](255) NULL,
	[Datafield_260_c] [nvarchar](100) NULL,
	[LanguageCode] [nvarchar](10) NULL,
	[OriginalCatalogingSource] [nvarchar](100) NULL,
	[EditionStatement] [nvarchar](450) NULL,
	[CurrentPublicationFrequency] [nvarchar](100) NULL
	)


-- =======================================================================
-- Populate the temp table

-- Get the MARC leader and MARC BIB ID
INSERT	#tmpTitle (MARCBibID, MARCLeader, FullTitle)
SELECT	MARCBibID = REPLACE(Leader, ' ', 'x'),
		MARCLeader = Leader,
		''
FROM	dbo.Marc 
WHERE	MarcID = @MarcID

-- Get the start year, end year, and language code from the MARC control data
UPDATE	#tmpTitle
SET		StartYear = CASE WHEN ISNUMERIC(SUBSTRING(c.[Value], 8, 4)) = 1 THEN SUBSTRING(c.[Value], 8, 4) ELSE NULL END,
		EndYear = CASE WHEN ISNUMERIC(SUBSTRING(c.[Value], 12, 4)) = 1 THEN SUBSTRING(c.[Value], 12, 4) ELSE NULL END,
		LanguageCode = SUBSTRING(c.[Value], 36, 3)
FROM	dbo.vwMarcControl c
WHERE	c.Tag = '008' 
AND		c.MarcID = @MarcID

-- Get the publication titles
UPDATE	#tmpTitle
SET		ShortTitle = df.SubFieldValue
FROM	dbo.vwMarcDataField df
WHERE	df.DataFieldTag = '245'
AND		df.Code = 'a'
AND		df.MarcID = @MarcID

-- Get the uniform title (stored in either MARC 130 or MARC 240)
UPDATE	#tmpTitle
SET		UniformTitle = df.SubFieldValue
FROM	dbo.vwMarcDataField df
WHERE	df.DataFieldTag in ('130', '240')
AND		df.Code = 'a'
AND		df.MarcID = @MarcID

-- Full Title
UPDATE	#tmpTitle
SET		FullTitle = dfA.SubFieldValue + ' ' + 
					ISNULL(dfB.SubFieldValue, '') + ' ' + 
					ISNULL(dfC.SubFieldValue, '')
FROM	dbo.Marc m INNER JOIN dbo.vwMarcDataField dfA
			ON m.MarcID = dfA.MarcID
			AND dfA.DataFieldTag = '245' 
			AND dfA.Code = 'a'
		LEFT JOIN dbo.vwMarcDataField dfB
			ON m.MarcID = dfB.MarcID
			AND dfB.DataFieldTag = '245'
			AND dfB.Code = 'b'
		LEFT JOIN dbo.vwMarcDataField dfC
			ON m.MarcID = dfC.MarcID
			AND dfC.DataFieldTag = '245'
			AND dfC.Code = 'c'
WHERE	m.MarcID = @MarcID

-- Get datafield 260 information
UPDATE	#tmpTitle
SET		Datafield_260_a = df.SubFieldValue
FROM	dbo.vwMarcDataField df
WHERE	df.DataFieldTag = '260'
AND		df.Code = 'a'
AND		df.MarcID = @MarcID

UPDATE	#tmpTitle
SET		Datafield_260_b = df.SubFieldValue
FROM	dbo.vwMarcDataField df
WHERE	df.DataFieldTag = '260'
AND		df.Code = 'b'
AND		df.MarcID = @MarcID

UPDATE	#tmpTitle
SET		Datafield_260_c = df.SubFieldValue
FROM	dbo.vwMarcDataField df
WHERE	df.DataFieldTag = '260'
AND		df.Code = 'c'
AND		df.MarcID = @MarcID

-- Get publication details
UPDATE	#tmpTitle
SET		PublicationDetails = ISNULL(Datafield_260_a, '') + ISNULL(Datafield_260_b, '') + ISNULL(Datafield_260_c, '')

-- Get the call number (first check the 050 record, then the 090... use the 050 value if both exist)
UPDATE	#tmpTitle
SET		CallNumber = dfA.SubFieldValue + ' ' + ISNULL(dfB.SubFieldValue, '')
FROM	dbo.Marc m INNER JOIN dbo.vwMarcDataField dfA
			ON m.MarcID = dfA.MarcID
			AND dfA.DataFieldTag = '050' 
			AND dfA.Code = 'a'
		LEFT JOIN dbo.vwMarcDataField dfB
			ON m.MarcID = dfB.MarcID
			AND dfB.DataFieldTag = '050'
			AND dfB.Code = 'b'
WHERE	m.MarcID = @MarcID

UPDATE	#tmpTitle
SET		CallNumber = CASE WHEN CallNumber IS NULL 
					THEN dfA.SubFieldValue + ' ' + ISNULL(dfB.SubFieldValue, '')
					ELSE CallNumber
					END
FROM	dbo.Marc m INNER JOIN dbo.vwMarcDataField dfA
			ON m.MarcID = dfA.MarcID
			AND dfA.DataFieldTag = '090' 
			AND dfA.Code = 'a'
		LEFT JOIN dbo.vwMarcDataField dfB
			ON m.MarcID = dfB.MarcID
			AND dfB.DataFieldTag = '090'
			AND dfB.Code = 'b'
WHERE	m.MarcID = @MarcID

-- Get the Original Cataloging Source (only pull the original agency, not any
-- modifying agencies)
UPDATE	#tmpTitle
SET 	OriginalCatalogingSource = m.SubFieldValue
FROM	dbo.vwMarcDataField m
WHERE	m.DataFieldTag = '040'
AND		m.Code = 'a'
AND		m.MarcID = @MarcID

	-- Get the Edition Statement
UPDATE	#tmpTitle
SET		EditionStatement = t.SubFieldValue
FROM	dbo.Marc m INNER JOIN (
				SELECT	MarcID, MarcDataFieldID, 
						LTRIM(ISNULL(MIN([a]), '') + ' ' + ISNULL(MIN([b]), '')) AS SubFieldValue
				FROM	(
						SELECT	MarcID, MarcDataFieldID, [a], [b]
						FROM	(SELECT * FROM dbo.vwMarcDataField
								WHERE DataFieldTag = '250' AND Code IN ('a', 'b')) AS z
						PIVOT	(MIN(SubFieldValue) FOR Code IN ([a], [b])) AS Pvt
						) X
				GROUP BY MarcID, MarcDataFieldID
				) t
			ON m.MarcID = t.MarcID
WHERE	m.MarcID = @MarcID

-- Get the Current Publication Frequency
UPDATE	#tmpTitle
SET		CurrentPublicationFrequency = m.SubFieldValue
FROM	dbo.vwMarcDataField m
WHERE	m.DataFieldTag = '310'
AND		m.Code = 'a'
AND		m.MarcID = @MarcID

-- =======================================================================

-- Get the sort titles for all titles
-- Remove keywords from the full title
UPDATE	#tmpTitle
SET		SortTitle = SUBSTRING(
						LTRIM(RTRIM(
						REPLACE(
						REPLACE(
						REPLACE(
						REPLACE(
						REPLACE(
						REPLACE(CONVERT(NVARCHAR(4000), FullTitle), 
							' A ', ' '),
							' An ', ' '),
							' Les ', ' '),
							' Las ', ' '),
							' Los ', ' '),
							' L'' ', ' ')
						))
					, 1, 65)

-- Remove keywords from the beginning of the sort titles
UPDATE	#tmpTitle
SET		SortTitle = CASE 
					WHEN SUBSTRING(SortTitle, 1, 4) = 'The ' THEN SUBSTRING(SortTitle, 5, 60)
					WHEN SUBSTRING(SortTitle, 1, 2) = 'A ' THEN SUBSTRING(SortTitle, 3, 60)
					WHEN SUBSTRING(SortTitle, 1, 3) = 'An ' THEN SUBSTRING(SortTitle, 4, 60)
					WHEN SUBSTRING(SortTitle, 1, 4) = 'Les ' THEN SUBSTRING(SortTitle, 5, 60)
					WHEN SUBSTRING(SortTitle, 1, 4) = 'Las ' THEN SUBSTRING(SortTitle, 5, 60)
					WHEN SUBSTRING(SortTitle, 1, 4) = 'Los ' THEN SUBSTRING(SortTitle, 5, 60)
					WHEN SUBSTRING(SortTitle, 1, 3) = 'L'' ' THEN SUBSTRING(SortTitle, 4, 60)
					WHEN SUBSTRING(SortTitle, 1, 3) = '...' THEN LTRIM(SUBSTRING(SortTitle, 4, 60))
					WHEN SUBSTRING(SortTitle, 1, 1) = '[' THEN SUBSTRING(SortTitle, 2, 60)
					ELSE SUBSTRING(SortTitle, 1, 60)
					END

-- =======================================================================
-- Deliver the final result set
SELECT	[MARCBibID],
		[MARCLeader],
		[FullTitle],
		[ShortTitle],
		[UniformTitle],
		[SortTitle],
		[CallNumber],
		[PublicationDetails],
		[StartYear],
		CASE WHEN [EndYear] = 9999 THEN NULL ELSE [EndYear] END AS [EndYear],
		[Datafield_260_a],
		[Datafield_260_b],
		[Datafield_260_c],
		UPPER([LanguageCode]) AS LanguageCode,
		[OriginalCatalogingSource],
		[EditionStatement],
		[CurrentPublicationFrequency]
FROM	#tmpTitle

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSelectTitleIdentifiersByMarcID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSelectTitleIdentifiersByMarcID]
GO


/****** Object:  StoredProcedure [dbo].[MarcSelectTitleIdentifiersByMarcID]    Script Date: 10/16/2009 16:27:42 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[MarcSelectTitleIdentifiersByMarcID]

@MarcID int

AS
BEGIN

SET NOCOUNT ON

-- =======================================================================
-- Build temp table

CREATE TABLE #tmpTitleIdentifier
	(
	[IdentifierName] [nvarchar](40) NOT NULL,
	[IdentifierValue] [nvarchar](125) NULL
	)

-- =======================================================================
-- Populate the temp table

-- Get the OCLC numbers from the 035a and 010o MARC fields (in most cases it's located in one
-- or the other of these)
INSERT INTO #tmpTitleIdentifier
SELECT	'OCLC',
		COALESCE(CONVERT(NVARCHAR(30), CONVERT(BIGINT, dbo.fnFilterString(m.subfieldvalue, '[0-9]', ''))), 
				CONVERT(NVARCHAR(30), CONVERT(BIGINT, dbo.fnFilterString(m2.subfieldvalue, '[0-9]', ''))))
FROM	dbo.Marc t 
		LEFT JOIN (SELECT * FROM dbo.vwMarcDataField 
					WHERE DataFieldTag = '035' AND code = 'a' AND 
					(SubFieldValue LIKE '(OCoLC)%' OR SubFieldValue LIKE 'ocm%' OR SubFieldValue LIKE 'ocn%')
					) m
			ON t.MarcID = m.MarcID
		LEFT JOIN (SELECT * FROM dbo.vwMarcDataField
					WHERE DataFieldTag = '010' AND Code = 'o') m2
			ON t.MarcID = m2.MarcID
WHERE	t.MarcID = @MarcID

-- Next check MARC control 001 record for the OCLC number (not too many of these)
INSERT INTO #tmpTitleIdentifier
SELECT	'OCLC',
		CONVERT(NVARCHAR(30), CONVERT(INT, dbo.fnFilterString(mc.value, '[0-9]', '')))
FROM	dbo.Marc t 
		LEFT JOIN (SELECT * FROM dbo.vwMarcControl WHERE tag = '001' AND [value] NOT LIKE 'Catkey%') mc
			ON t.MarcID = mc.MarcID
		LEFT JOIN (SELECT * FROM dbo.vwMarcControl WHERE tag = '003' AND [value] = 'OCoLC') mc2
			ON t.MarcID = mc2.MarcID
WHERE	(mc.[Value] LIKE 'oc%' OR mc2.[value] = 'OCoLC')
AND		NOT EXISTS (SELECT IdentifierValue FROM #tmpTitleIdentifier 
					WHERE IdentifierValue IS NOT NULL)
AND		t.MarcID = @MarcID

-- Get the Library Of Congress Control numbers
INSERT INTO #tmpTitleIdentifier
SELECT DISTINCT
		'DLC',
		LTRIM(RTRIM(m.SubFieldValue))
FROM	dbo.vwMarcDataField m
WHERE	DataFieldTag = '010'
AND		Code = 'a'
AND		m.MarcID = @MarcID

-- Get the ISBN identifiers
INSERT INTO #tmpTitleIdentifier
SELECT DISTINCT
		'ISBN',
		m.SubFieldValue
FROM	dbo.vwMarcDataField m
WHERE	m.DataFieldTag = '020'
AND		m.Code = 'a'
AND		m.MarcID = @MarcID

-- Get the ISSN identifiers
INSERT INTO #tmpTitleIdentifier
SELECT DISTINCT
		'ISSN',
		m.SubFieldValue
FROM	dbo.vwMarcDataField m
WHERE	m.DataFieldTag = '022'
AND		m.Code = 'a'
AND		m.MarcID = @MarcID

-- Get the CODEN codes
INSERT INTO #tmpTitleIdentifier
SELECT DISTINCT
		'CODEN',
		m.SubFieldValue
FROM	dbo.vwMarcDataField m
WHERE	m.DataFieldTag = '030'
AND		m.Code = 'a'
AND		m.MarcID = @MarcID

-- Get the National Library of Medicine call numbers
INSERT INTO #tmpTitleIdentifier
SELECT DISTINCT
		'NLM', 
		Z.SubFieldValue
FROM	(SELECT	MarcID, MarcDataFieldID, 
				LTRIM(ISNULL(MIN([a]), '') + ' ' + ISNULL(MIN([b]), '')) AS SubFieldValue
		FROM	(
				SELECT	MarcID, MarcDataFieldID, [a], [b]
				FROM	(SELECT * FROM dbo.vwMarcDataField 
						WHERE DataFieldTag = '060' AND Code in ('a', 'b')) AS m
				PIVOT	(MIN(SubFieldValue) FOR Code IN ([a], [b])) AS Pvt
				) X
		GROUP BY MarcID, MarcDataFieldID
		) Z
WHERE	MarcID = @MarcID

-- Get the National Agricultural Library call numbers
INSERT INTO #tmpTitleIdentifier
SELECT DISTINCT
		'NAL', 
		Z.SubFieldValue
FROM	(
		SELECT	MarcID, MarcDataFieldID, 
				LTRIM(ISNULL(MIN([a]), '') + ' ' + ISNULL(MIN([b]), '')) AS SubFieldValue
		FROM	(
				SELECT	MarcID, MarcDataFieldID, [a], [b]
				FROM	(SELECT * FROM dbo.vwMarcDataField 
						WHERE DataFieldTag = '070' AND Code in ('a', 'b')) AS m
				PIVOT	(MIN(SubFieldValue) FOR Code IN ([a], [b])) AS Pvt
				) X
		GROUP BY MarcID, MarcDataFieldID
		) Z
WHERE	MarcID = @MarcID

-- Get the Government Printing Office
INSERT INTO #tmpTitleIdentifier
SELECT DISTINCT
		'GPO',
		m.SubFieldValue
FROM	dbo.vwMarcDataField m
WHERE	m.DataFieldTag = '074'
AND		m.Code = 'a'
AND		m.MarcID = @MarcID

-- Get the Dewey Decimal Classifiers
INSERT INTO #tmpTitleIdentifier
SELECT DISTINCT
		'DDC',
		m.SubFieldValue
FROM	dbo.vwMarcDataField m
WHERE	m.DataFieldTag = '082'
AND		m.Code = 'a'
AND		m.MarcID = @MarcID

-- Get the Abbreviations
INSERT INTO #tmpTitleIdentifier
SELECT DISTINCT
		'Abbreviation',
		m.SubFieldValue
FROM	dbo.vwMarcDataField m
WHERE	m.DataFieldTag = '210'
AND		m.Code = 'a'
AND		m.MarcID = @MarcID

-- Get the WonderFetch identifiers (look for a MARC
-- 001 control record with a value including 'catkey')
INSERT INTO #tmpTitleIdentifier
SELECT DISTINCT 
		'WonderFetch',
		LTRIM(RTRIM(REPLACE(m.[Value], 'catkey', ''))) 
FROM	dbo.vwMarcControl m
WHERE	m.Tag = '001' 
AND		m.[Value] LIKE 'catkey%'
AND		m.MarcID = @MarcID

-- Get the non-OCLC and non-WonderFetch local identifiers from the 
-- MARC 001 control record
INSERT INTO #tmpTitleIdentifier
SELECT DISTINCT
		'MARC001',
		m.[Value]
FROM	dbo.vwMarcControl m
WHERE	m.Tag = '001'
AND		m.[Value] NOT LIKE 'catkey%'
AND		m.[Value] NOT LIKE 'oc%'
AND		m.MarcID = @MarcID

-- =======================================================================
-- Deliver the final result set
SELECT	ti.TitleIdentifierID,
		t.IdentifierName,
		t.IdentifierValue
FROM	#tmpTitleIdentifier t INNER JOIN dbo.TitleIdentifier ti
			ON t.IdentifierName = ti.IdentifierName
WHERE	IdentifierValue IS NOT NULL

DROP TABLE #tmpTitleIdentifier

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSelectTitleLanguagesByMarcID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSelectTitleLanguagesByMarcID]
GO


/****** Object:  StoredProcedure [dbo].[MarcSelectTitleLanguagesByMarcID]    Script Date: 10/16/2009 16:27:43 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MarcSelectTitleLanguagesByMarcID]

@MarcID int

AS
BEGIN

SET NOCOUNT ON

-- =======================================================================
-- Build temp table

CREATE TABLE #tmpTitleLanguage(
	[LanguageCode] [nvarchar](10) NOT NULL DEFAULT('')
	)		

-- =======================================================================
-- Populate the temp table

INSERT INTO #tmpTitleLanguage (LanguageCode)
SELECT DISTINCT LanguageCode
FROM	dbo.fnSplitLanguage(@MarcID)


-- =======================================================================
-- Deliver the final result set
SELECT	LanguageCode
FROM	#tmpTitleLanguage

DROP TABLE #tmpTitleLanguage

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSelectTitleTagsByMarcID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSelectTitleTagsByMarcID]
GO


/****** Object:  StoredProcedure [dbo].[MarcSelectTitleTagsByMarcID]    Script Date: 10/16/2009 16:27:43 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[MarcSelectTitleTagsByMarcID]

@MarcID int

AS
BEGIN

SET NOCOUNT ON

-- =======================================================================
-- Build temp table

CREATE TABLE #tmpTitleTag
	(
	[TagText] [nvarchar](200) NOT NULL,
	[MarcDataFieldTag] [nvarchar](50) NULL,
	[MarcSubFieldCode] [nvarchar](50) NULL
	)

-- =======================================================================
-- Populate the temp table

INSERT INTO #tmpTitleTag
SELECT	m.SubFieldValue,
		m.DataFieldTag,
		m.Code
FROM	dbo.vwMarcDataField m
WHERE	m.DataFieldTag IN ('600', '610', '611', '630', '648', '650', '651', '652', 
							'653', '654', '655', '656', '657', '658', '662', '690')
AND		m.MarcID = @MarcID

-- =======================================================================
-- Deliver the final result set

-- Strip trailing periods from tags
UPDATE	#tmpTitleTag
SET		TagText = CASE WHEN RIGHT(TagText, 1) = '.'
					THEN LEFT(TagText, LEN(TagText) - 1)
					ELSE TagText
					END

SELECT	TagText,
		MIN(MarcDataFieldTag) AS MarcDataFieldTag,
		MIN(MarcSubFieldCode) AS MarcSubFieldCode
FROM	#tmpTitleTag
GROUP BY
		TagText

DROP TABLE #tmpTitleTag

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFSelectForWeekAndStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFSelectForWeekAndStatus]
GO


/****** Object:  StoredProcedure [dbo].[PDFSelectForWeekAndStatus]    Script Date: 10/16/2009 16:27:44 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.PDFSelectForWeekAndStatus
@Year INT,
@Week INT,
@PdfStatusID INT
AS
BEGIN

SET NOCOUNT ON 

SELECT	p.PdfID,
		p.ItemID,
		p.EmailAddress,
--		p.ShareWithEmailAddresses,
		p.ImagesOnly,
		p.ArticleTitle,
		p.ArticleCreators,
		p.ArticleTags,
--		p.FileLocation,
		p.FileUrl,
--		p.Creationdate,
--		p.FileGenerationDate,
		DATEDIFF(minute, p.CreationDate, p.FileGenerationDate) AS [MinutesToGenerate],
--		p.FileDeletionDate,
		p.NumberImagesMissing,
		p.NumberOcrMissing,
--		p.Comment,
		(SELECT COUNT(*) FROM PDFPage WHERE PdfID = p.PdfID) AS [NumberOfPages]
FROM	PDF p
WHERE	DATEPART(year, p.CreationDate) = @Year
AND		DATEPART(week, p.CreationDate) = @Week
AND		p.PdfStatusID = @PdfStatusID

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSubFieldDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSubFieldDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcSubFieldDeleteAuto]    Script Date: 10/16/2009 16:27:44 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcSubFieldDeleteAuto PROCEDURE
-- Generated 4/15/2009 3:34:26 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for MarcSubField

CREATE PROCEDURE MarcSubFieldDeleteAuto

@MarcSubFieldID INT

AS 

DELETE FROM [dbo].[MarcSubField]

WHERE

	[MarcSubFieldID] = @MarcSubFieldID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcSubFieldDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSubFieldInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSubFieldInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcSubFieldInsertAuto]    Script Date: 10/16/2009 16:27:45 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcSubFieldInsertAuto PROCEDURE
-- Generated 4/15/2009 3:34:26 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for MarcSubField

CREATE PROCEDURE MarcSubFieldInsertAuto

@MarcSubFieldID INT OUTPUT,
@MarcDataFieldID INT,
@Code NCHAR(1),
@Value NVARCHAR(200)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[MarcSubField]
(
	[MarcDataFieldID],
	[Code],
	[Value],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@MarcDataFieldID,
	@Code,
	@Value,
	getdate(),
	getdate()
)

SET @MarcSubFieldID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcSubFieldInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[MarcSubFieldID],
		[MarcDataFieldID],
		[Code],
		[Value],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[MarcSubField]
	
	WHERE
		[MarcSubFieldID] = @MarcSubFieldID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSubFieldSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSubFieldSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcSubFieldSelectAuto]    Script Date: 10/16/2009 16:27:45 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcSubFieldSelectAuto PROCEDURE
-- Generated 4/15/2009 3:34:26 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for MarcSubField

CREATE PROCEDURE MarcSubFieldSelectAuto

@MarcSubFieldID INT

AS 

SET NOCOUNT ON

SELECT 

	[MarcSubFieldID],
	[MarcDataFieldID],
	[Code],
	[Value],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[MarcSubField]

WHERE
	[MarcSubFieldID] = @MarcSubFieldID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcSubFieldSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSubFieldUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcSubFieldUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcSubFieldUpdateAuto]    Script Date: 10/16/2009 16:27:46 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcSubFieldUpdateAuto PROCEDURE
-- Generated 4/15/2009 3:34:26 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for MarcSubField

CREATE PROCEDURE MarcSubFieldUpdateAuto

@MarcSubFieldID INT,
@MarcDataFieldID INT,
@Code NCHAR(1),
@Value NVARCHAR(200)

AS 

SET NOCOUNT ON

UPDATE [dbo].[MarcSubField]

SET

	[MarcDataFieldID] = @MarcDataFieldID,
	[Code] = @Code,
	[Value] = @Value,
	[LastModifiedDate] = getdate()

WHERE
	[MarcSubFieldID] = @MarcSubFieldID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcSubFieldUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[MarcSubFieldID],
		[MarcDataFieldID],
		[Code],
		[Value],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[MarcSubField]
	
	WHERE
		[MarcSubFieldID] = @MarcSubFieldID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[MarcUpdateAuto]    Script Date: 10/16/2009 16:27:46 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MarcUpdateAuto PROCEDURE
-- Generated 4/21/2009 3:39:50 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for Marc

CREATE PROCEDURE MarcUpdateAuto

@MarcID INT,
@MarcImportStatusID INT,
@MarcImportBatchID INT,
@MarcFileLocation NVARCHAR(500),
@InstitutionCode NVARCHAR(10),
@Leader NVARCHAR(200),
@TitleID INT

AS 

SET NOCOUNT ON

UPDATE [dbo].[Marc]

SET

	[MarcImportStatusID] = @MarcImportStatusID,
	[MarcImportBatchID] = @MarcImportBatchID,
	[MarcFileLocation] = @MarcFileLocation,
	[InstitutionCode] = @InstitutionCode,
	[Leader] = @Leader,
	[TitleID] = @TitleID,
	[LastModifiedDate] = getdate()

WHERE
	[MarcID] = @MarcID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MarcUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[MarcID],
		[MarcImportStatusID],
		[MarcImportBatchID],
		[MarcFileLocation],
		[InstitutionCode],
		[Leader],
		[TitleID],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[Marc]
	
	WHERE
		[MarcID] = @MarcID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcUpdateStatusError]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcUpdateStatusError]
GO


/****** Object:  StoredProcedure [dbo].[MarcUpdateStatusError]    Script Date: 10/16/2009 16:27:46 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.MarcUpdateStatusError

@MarcID int

AS
BEGIN

SET NOCOUNT ON

UPDATE	dbo.Marc
SET		MarcImportStatusID = 99
WHERE	MarcID = @MarcID

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcUpdateStatusImported]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MarcUpdateStatusImported]
GO


/****** Object:  StoredProcedure [dbo].[MarcUpdateStatusImported]    Script Date: 10/16/2009 16:27:47 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE dbo.MarcUpdateStatusImported

@MarcID int

AS
BEGIN

SET NOCOUNT ON

UPDATE	dbo.Marc
SET		MarcImportStatusID = 30
WHERE	MarcID = @MarcID

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFStatusUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFStatusUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[PDFStatusUpdateAuto]    Script Date: 10/16/2009 16:27:48 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PDFStatusUpdateAuto PROCEDURE
-- Generated 1/23/2009 8:46:39 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for PDFStatus

CREATE PROCEDURE PDFStatusUpdateAuto

@PdfStatusID INT,
@PdfStatusName NCHAR(10)

AS 

SET NOCOUNT ON

UPDATE [dbo].[PDFStatus]

SET

	[PdfStatusID] = @PdfStatusID,
	[PdfStatusName] = @PdfStatusName

WHERE
	[PdfStatusID] = @PdfStatusID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PDFStatusUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PdfStatusID],
		[PdfStatusName]

	FROM [dbo].[PDFStatus]
	
	WHERE
		[PdfStatusID] = @PdfStatusID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonthlyStatsDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MonthlyStatsDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[MonthlyStatsDeleteAuto]    Script Date: 10/16/2009 16:27:48 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MonthlyStatsDeleteAuto PROCEDURE
-- Generated 10/29/2008 10:12:36 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for MonthlyStats

CREATE PROCEDURE MonthlyStatsDeleteAuto

@Year INT,
@Month INT,
@InstitutionName NVARCHAR(255),
@StatType NVARCHAR(100)

AS 

DELETE FROM [dbo].[MonthlyStats]

WHERE

	[Year] = @Year AND
	[Month] = @Month AND
	[InstitutionName] = @InstitutionName AND
	[StatType] = @StatType

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MonthlyStatsDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonthlyStatsInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MonthlyStatsInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[MonthlyStatsInsertAuto]    Script Date: 10/16/2009 16:27:48 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MonthlyStatsInsertAuto PROCEDURE
-- Generated 10/29/2008 10:12:36 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for MonthlyStats

CREATE PROCEDURE MonthlyStatsInsertAuto

@Year INT,
@Month INT,
@InstitutionName NVARCHAR(255),
@StatType NVARCHAR(100),
@StatValue INT

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[MonthlyStats]
(
	[Year],
	[Month],
	[InstitutionName],
	[StatType],
	[StatValue],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@Year,
	@Month,
	@InstitutionName,
	@StatType,
	@StatValue,
	getdate(),
	getdate()
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MonthlyStatsInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[Year],
		[Month],
		[InstitutionName],
		[StatType],
		[StatValue],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[MonthlyStats]
	
	WHERE
		[Year] = @Year AND
		[Month] = @Month AND
		[InstitutionName] = @InstitutionName AND
		[StatType] = @StatType
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonthlyStatsSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MonthlyStatsSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[MonthlyStatsSelectAuto]    Script Date: 10/16/2009 16:27:49 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MonthlyStatsSelectAuto PROCEDURE
-- Generated 10/29/2008 10:12:36 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for MonthlyStats

CREATE PROCEDURE MonthlyStatsSelectAuto

@Year INT,
@Month INT,
@InstitutionName NVARCHAR(255),
@StatType NVARCHAR(100)

AS 

SET NOCOUNT ON

SELECT 

	[Year],
	[Month],
	[InstitutionName],
	[StatType],
	[StatValue],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[MonthlyStats]

WHERE
	[Year] = @Year AND
	[Month] = @Month AND
	[InstitutionName] = @InstitutionName AND
	[StatType] = @StatType

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MonthlyStatsSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonthlyStatsSelectByDateAndInstitution]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MonthlyStatsSelectByDateAndInstitution]
GO


/****** Object:  StoredProcedure [dbo].[MonthlyStatsSelectByDateAndInstitution]    Script Date: 10/16/2009 16:27:49 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.MonthlyStatsSelectByDateAndInstitution

@StartYear int,
@StartMonth int,
@EndYear int,
@EndMonth int,
@InstitutionName nvarchar(255) = ''

AS
BEGIN

SET NOCOUNT ON

SELECT	StatType, [Year], [Month], SUM(StatValue) AS StatValue
--FROM	dbo.MonthlyStats
FROM	(
		SELECT	InstitutionName, StatType, Year, Month, StatValue FROM MonthlyStats WHERE StatType NOT LIKE '%Scanned'
		UNION
		-- Make sure we have at least a zero entry for every institution and stattype in every month
		SELECT	InstitutionName, StatType, Year, Month, 0
		FROM	(SELECT DISTINCT StatType FROM MonthlyStats WHERE StatType NOT LIKE '%Scanned') X
				CROSS JOIN
				(SELECT DISTINCT InstitutionName, Year, Month FROM MonthlyStats WHERE StatType NOT LIKE '%Scanned') Y
		) Z
WHERE	[Year] >= 2006
AND		StatType NOT LIKE '%Scanned%'
AND		([Year] > @StartYear OR ([Year] = @StartYear AND [Month] >= @StartMonth))
AND		([Year] < @EndYear OR ([Year] = @EndYear AND [Month] <= @EndMonth))
AND		(InstitutionName = @InstitutionName OR @InstitutionName = '')
GROUP BY
		StatType, [Year], [Month]
ORDER BY
		CASE StatType
		WHEN 'Titles Created' THEN 1
		WHEN 'Items Created' THEN 2
		WHEN 'Pages Created' THEN 3
		WHEN 'PageNames Created' THEN 4
		END,
		[Year], [Month]

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonthlyStatsSelectByStatType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MonthlyStatsSelectByStatType]
GO


/****** Object:  StoredProcedure [dbo].[MonthlyStatsSelectByStatType]    Script Date: 10/16/2009 16:27:49 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[MonthlyStatsSelectByStatType]

@StatType nvarchar(100),
@InstitutionName nvarchar(255) = '',
@ShowMonthly bit = 0

AS
BEGIN

SET NOCOUNT ON

SELECT	InstitutionName,
		CASE WHEN @ShowMonthly = 1 THEN [Year] ELSE 0 END AS [Year],
		CASE WHEN @ShowMonthly = 1 THEN [Month] ELSE 0 END AS [Month],
		Sum(StatValue) AS StatValue
FROM	MonthlyStats
WHERE	StatType = @StatType
AND		(InstitutionName = @InstitutionName OR @InstitutionName = '')
GROUP BY
		CASE WHEN @ShowMonthly = 1 THEN [Year] ELSE 0 END,
		CASE WHEN @ShowMonthly = 1 THEN [Month] ELSE 0 END,
		InstitutionName
ORDER BY
		InstitutionName,
		[Year],
		[Month]
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonthlyStatsSelectCurrentMonthSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MonthlyStatsSelectCurrentMonthSummary]
GO


/****** Object:  StoredProcedure [dbo].[MonthlyStatsSelectCurrentMonthSummary]    Script Date: 10/16/2009 16:27:50 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.MonthlyStatsSelectCurrentMonthSummary

AS
BEGIN

SET NOCOUNT ON

DECLARE @CurrentYear int
DECLARE @CurrentMonth int
SELECT @CurrentYear = DATEPART(YEAR, GETDATE())
SELECT @CurrentMonth = DATEPART(MONTH, GETDATE())

SELECT	StatType, SUM(StatValue) AS 'StatValue'
FROM	dbo.MonthlyStats
WHERE	[Year] = @CurrentYear
AND		[Month] = @CurrentMonth
AND		StatType = 'Titles Created'
GROUP BY StatType
UNION
SELECT	StatType, SUM(StatValue) AS 'StatValue'
FROM	dbo.MonthlyStats
WHERE	[Year] = @CurrentYear
AND		[Month] = @CurrentMonth
AND		StatType = 'Items Created'
GROUP BY StatType
UNION
SELECT	StatType, SUM(StatValue) AS 'StatValue'
FROM	dbo.MonthlyStats
WHERE	[Year] = @CurrentYear
AND		[Month] = @CurrentMonth
AND		StatType = 'Pages Created'
GROUP BY StatType
UNION
SELECT	StatType, SUM(StatValue) AS 'StatValue'
FROM	dbo.MonthlyStats
WHERE	[Year] = @CurrentYear
AND		[Month] = @CurrentMonth
AND		StatType = 'PageNames Created'
GROUP BY StatType

END
GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonthlyStatsSelectCurrentYearSummary]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MonthlyStatsSelectCurrentYearSummary]
GO


/****** Object:  StoredProcedure [dbo].[MonthlyStatsSelectCurrentYearSummary]    Script Date: 10/16/2009 16:27:50 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.MonthlyStatsSelectCurrentYearSummary

AS
BEGIN

SET NOCOUNT ON

DECLARE @CurrentYear int
SELECT @CurrentYear = DATEPART(YEAR, GETDATE())

SELECT	StatType, SUM(StatValue) AS 'StatValue'
FROM	dbo.MonthlyStats
WHERE	[Year] = @CurrentYear
AND		StatType = 'Titles Created'
GROUP BY StatType
UNION
SELECT	StatType, SUM(StatValue) AS 'StatValue'
FROM	dbo.MonthlyStats
WHERE	[Year] = @CurrentYear
AND		StatType = 'Items Created'
GROUP BY StatType
UNION
SELECT	StatType, SUM(StatValue) AS 'StatValue'
FROM	dbo.MonthlyStats
WHERE	[Year] = @CurrentYear
AND		StatType = 'Pages Created'
GROUP BY StatType
UNION
SELECT	StatType, SUM(StatValue) AS 'StatValue'
FROM	dbo.MonthlyStats
WHERE	[Year] = @CurrentYear
AND		StatType = 'PageNames Created'
GROUP BY StatType

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonthlyStatsUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MonthlyStatsUpdate]
GO


/****** Object:  StoredProcedure [dbo].[MonthlyStatsUpdate]    Script Date: 10/16/2009 16:27:51 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE MonthlyStatsUpdate
AS
BEGIN

SET NOCOUNT ON

CREATE TABLE #tmpMonthlyStats
	(
	[Year] int NULL,
	[Month] int NULL,
	[InstitutionName] nvarchar(255) NULL,
	[StatType] nvarchar(100) NULL,
	[StatValue] int NULL
	)

-- Titles by institution
INSERT	#tmpMonthlyStats
SELECT	[Year], 
		[Month], 
		InstitutionName, 
		'Titles Created', 
		COUNT(*)
FROM	(
		SELECT DISTINCT 
			n.institutionname, 
			t.titleid,
			DATEPART(year, t.CreationDate) AS [Year],
			DATEPART(month, t.CreationDate) AS [Month]
		FROM item i INNER JOIN title t
				ON i.primarytitleid = t.titleid
			INNER JOIN institution n
				ON i.institutioncode = n.institutioncode
		WHERE i.itemstatusid = 40
		AND t.publishready = 1
		) x
GROUP BY [Year], [Month], InstitutionName
		
-- Items by institution
INSERT	#tmpMonthlyStats
SELECT	DATEPART(year, i.CreationDate) AS [Year],
		DATEPART(month, i.CreationDate) AS [Month],
		n.InstitutionName,
		'Items Created',
		COUNT(*)
FROM	dbo.Item i INNER JOIN institution n
			ON i.institutioncode = n.institutioncode
WHERE	i.ItemStatusID = 40
GROUP BY
		DATEPART(year, i.CreationDate),
		DATEPART(month, i.CreationDate),
		n.InstitutionName

-- Items scanned by institution
INSERT	#tmpMonthlyStats
SELECT	DATEPART(year, i.ScanningDate) AS [Year],
		DATEPART(month, i.ScanningDate) AS [Month],
		n.InstitutionName,
		'Items Scanned',
		COUNT(*)
FROM	dbo.Item i INNER JOIN institution n
			ON i.institutioncode = n.institutioncode
WHERE	i.ItemStatusID = 40
GROUP BY
		DATEPART(year, i.ScanningDate),
		DATEPART(month, i.ScanningDate),
		n.InstitutionName

-- Pages by institution
INSERT	#tmpMonthlyStats
SELECT 	DATEPART(year, p.CreationDate) AS [Year],
		DATEPART(month, p.CreationDate) AS [Month],
		n.institutionname, 
		'Pages Created',
		COUNT(*)
FROM	item i INNER JOIN institution n
			ON i.institutioncode = n.institutioncode
		INNER JOIN page p
			ON i.itemid = p.itemid
WHERE	itemstatusid = 40
AND		p.active = 1
GROUP BY DATEPART(year, p.CreationDate),
		DATEPART(month, p.CreationDate),
		n.institutionname

-- Pagenames by institution
INSERT	#tmpMonthlyStats
SELECT	DATEPART(year, pn.CreateDate) AS [Year],
		DATEPART(month, pn.CreateDate) AS [Month],
		n.institutionname, 
		'PageNames Created',
		COUNT(*)
FROM	item i INNER JOIN institution n
			ON i.institutioncode = n.institutioncode
		INNER JOIN page p
			ON i.itemid = p.itemid
		INNER JOIN pagename pn
			ON p.pageid = pn.pageid
WHERE	itemstatusid = 40
AND		p.active = 1
GROUP BY DATEPART(year, pn.CreateDate),
		DATEPART(month, pn.CreateDate),
		n.institutionname

UPDATE	#tmpMonthlyStats
SET		[Year] = ISNULL([Year], 0),
		[Month] = ISNULL([Month], 0),
		InstitutionName = ISNULL(InstitutionName, '')

UPDATE	MonthlyStats
SET		StatValue = t.StatValue,
		LastModifiedDate = GETDATE()
FROM	#tmpMonthlyStats t INNER JOIN MonthlyStats s
			ON t.[Year] = s.[Year]
			AND t.[Month] = s.[Month]
			AND t.InstitutionName = s.InstitutionName
			AND t.StatType = s.StatType
WHERE	t.StatValue <> s.StatValue

INSERT	MonthlyStats
SELECT	t.[Year],
		t.[Month],
		t.InstitutionName,
		t.StatType,
		t.StatValue,
		GETDATE(),
		GETDATE()
FROM	#tmpMonthlyStats t LEFT JOIN MonthlyStats s
			ON t.[Year] = s.[Year]
			AND t.[Month] = s.[Month]
			AND t.InstitutionName = s.InstitutionName
			AND t.StatType = s.StatType
WHERE	s.StatValue IS NULL

DROP TABLE #tmpMonthlyStats

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonthlyStatsUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[MonthlyStatsUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[MonthlyStatsUpdateAuto]    Script Date: 10/16/2009 16:27:52 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- MonthlyStatsUpdateAuto PROCEDURE
-- Generated 10/29/2008 10:12:36 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for MonthlyStats

CREATE PROCEDURE MonthlyStatsUpdateAuto

@Year INT,
@Month INT,
@InstitutionName NVARCHAR(255),
@StatType NVARCHAR(100),
@StatValue INT

AS 

SET NOCOUNT ON

UPDATE [dbo].[MonthlyStats]

SET

	[Year] = @Year,
	[Month] = @Month,
	[InstitutionName] = @InstitutionName,
	[StatType] = @StatType,
	[StatValue] = @StatValue,
	[LastModifiedDate] = getdate()

WHERE
	[Year] = @Year AND
	[Month] = @Month AND
	[InstitutionName] = @InstitutionName AND
	[StatType] = @StatType
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure MonthlyStatsUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[Year],
		[Month],
		[InstitutionName],
		[StatType],
		[StatValue],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[MonthlyStats]
	
	WHERE
		[Year] = @Year AND 
		[Month] = @Month AND 
		[InstitutionName] = @InstitutionName AND 
		[StatType] = @StatType
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OpenUrlCitationSelectByCitationDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[OpenUrlCitationSelectByCitationDetails]
GO


/****** Object:  StoredProcedure [dbo].[OpenUrlCitationSelectByCitationDetails]    Script Date: 10/16/2009 16:27:52 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[OpenUrlCitationSelectByCitationDetails]

@TitleID int = 0,
@OCLC nvarchar(125) = '',
@LCCN nvarchar(125) = '',
@ISBN nvarchar(125) = '',
@ISSN nvarchar(125) = '',
@Abbreviation nvarchar(125) = '',
@CODEN nvarchar(125) = '',
@Title nvarchar(2000) = '',
@AuthorLast nvarchar(150) = '',
@AuthorFirst nvarchar(100) = '',
@AuthorCorporation nvarchar(255) = '',
@PublisherName nvarchar(255) = '',
@PublisherPlace nvarchar(150) = '',
@Publisher nvarchar(255) = '',
@Volume nvarchar(100) = '',
@Issue nvarchar(20) = '',
@Year nvarchar(20) = '',
@StartPage nvarchar(20) = ''

AS

BEGIN

/*

TEST CASE (WEB)

/openurl?url_ver=Z39.88-2004&ctx_ver=Z39.88-2004&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook&rft.genre=book&rft.btitle=List%20of%20the%20Coleoptera%20of%20southern%20California%2C&rft.publisher=San%20Francisco%2CCalifornia%20Academy%20of%20Sciences%2C&rft.aufirst=Henry%20Clinton&rft.aulast=Fall&rft.au=Henry%20Clinton%20Fall&rft.date=1901

/openurl?url_ver=Z39.88-2004
&ctx_ver=Z39.88-2004
&rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Abook
&rft.genre=book
&rft.btitle=List%20of%20the%20Coleoptera%20of%20southern%20California%2C
&rft.publisher=San%20Francisco%2CCalifornia%20Academy%20of%20Sciences%2C
&rft.aufirst=Henry%20Clinton
&rft.aulast=Fall
&rft.au=Henry%20Clinton%20Fall
&rft.date=1901

TEST CASES (SQL)

-- ORIGINAL
exec OpenUrlCitationSelectByTitleDetails 
	'danmarks fauna, biller.', 
	'forening',	'dansk naturhistorisk',
	'',	'',	'',	'københavn :g. e. c. gad,'

exec OpenUrlCitationSelectByTitleDetails 
	'genera of european and northamerican bryineae (mosses)',
	'kindberg',	'n. c',
	'',	'',	'',	'linkoeping, sweden:p. m. sahlstroems bookselling (c.v. zickerman),'

exec OpenUrlCitationSelectByTitleDetails 
	'list of the coleoptera of southern california,',
	'fall',	'henry clinton',
	'',	'',	'',	'san francisco,california academy of sciences,'

-----------------------------------------------------------------------

-- NEW
exec [OpenUrlCitationSelectByCitationDetails] 0, '', '', '', '', '', '', 'plants'

exec [OpenUrlCitationSelectByCitationDetails] 0, '', '', '', '', '', '', 
	'genera of european and northamerican bryineae (mosses)',
	'kindberg',	'n. c',
	'',	'',	'',	'linkoeping, sweden:p. m. sahlstroems bookselling (c.v. zickerman),'

exec [OpenUrlCitationSelectByCitationDetails] 0, '', '', '', '', '', '', 
	'danmarks fauna, biller.', 
	'forening',	'dansk naturhistorisk',
	'',	'',	'',	'københavn :g. e. c. gad,',
	'',	'',	'1908',	''

exec [OpenUrlCitationSelectByCitationDetails] 0, '', '', '', '', '', '', 
	'list of the coleoptera of southern california,',
	'fall',	'henry clinton',
	'',	'',	'',	'san francisco,california academy of sciences,'

*/

SET NOCOUNT ON

-- ***************************************************************
-- Set up parameters

DECLARE @ItemCount int
SET @ItemCount = 0

-- Need to check for both "Last, First" and "First Last"
DECLARE @Author nvarchar(255)
DECLARE @AuthorAlt nvarchar(255)
SET @Author = ''
SET @AuthorAlt = ''

IF (@AuthorCorporation <> '')
BEGIN
	SET @Author = @AuthorCorporation + '%'
END
ELSE
BEGIN
	IF (@AuthorFirst = '' AND @AuthorLast <> '') SET @Author = @AuthorLast + '%'
	IF (@AuthorFirst <> '' AND @AuthorLast = '') SET @Author = @AuthorFirst + '%'
	IF (@AuthorFirst <> '' AND @AuthorLast <> '') 
	BEGIN
		SET @Author = @AuthorLast + ', ' + @AuthorFirst + '%'
		SET @AuthorAlt = @AuthorFirst + ' ' + @AuthorLast + '%'
	END
END
IF @AuthorAlt = '' SET @AuthorAlt = @Author

-- ***************************************************************
-- Build the temp table

CREATE TABLE #tmpOpenUrlCitation
	(
	PageID int NULL,
	ItemID int NULL,
	TitleID int NULL,
	FullTitle nvarchar(2000) NOT NULL DEFAULT(''),
	PublisherPlace nvarchar(150) NOT NULL DEFAULT(''),
	PublisherName nvarchar(255) NOT NULL DEFAULT(''),
	Date nvarchar(20) NOT NULL DEFAULT(''),
	LanguageName nvarchar(20) NOT NULL DEFAULT(''),
	Volume nvarchar(100) NOT NULL DEFAULT(''),
	EditionStatement nvarchar(450) NOT NULL DEFAULT(''),
	CurrentPublicationFrequency nvarchar(100) NOT NULL DEFAULT(''),
	Genre nvarchar(20) NOT NULL DEFAULT(''),
	Authors nvarchar(2000) NOT NULL DEFAULT(''),
	Subjects nvarchar(1000) NOT NULL DEFAULT(''),
	StartPage nvarchar(40) NOT NULL DEFAULT(''),
	EndPage nvarchar(40) NOT NULL DEFAULT(''),
	Pages nvarchar(40) NOT NULL DEFAULT(''),
	ISSN nvarchar(125) NOT NULL DEFAULT(''),
	ISBN nvarchar(125) NOT NULL DEFAULT(''),
	LCCN nvarchar(125) NOT NULL DEFAULT(''),
	OCLC nvarchar(125) NOT NULL DEFAULT(''),
	Abbreviation nvarchar(125) NOT NULL DEFAULT('')
	)




-- ***************************************************************
-- Try searching by TitleID

IF (@TitleID <> 0) INSERT INTO #tmpOpenUrlCitation EXEC dbo.OpenUrlCitationSelectByTitleID @TitleID


-- ***************************************************************
-- If TitleID did't work, search using the various title identifiers

IF NOT EXISTS(SELECT TitleID FROM #tmpOpenUrlCitation)
BEGIN
	INSERT INTO #tmpOpenUrlCitation EXEC dbo.OpenUrlCitationSelectByTitleIdentifier 'OCLC', @OCLC
END

IF NOT EXISTS(SELECT TitleID FROM #tmpOpenUrlCitation)
BEGIN
	INSERT INTO #tmpOpenUrlCitation EXEC dbo.OpenUrlCitationSelectByTitleIdentifier 'DLC', @LCCN
END

IF NOT EXISTS(SELECT TitleID FROM #tmpOpenUrlCitation)
BEGIN
	INSERT INTO #tmpOpenUrlCitation EXEC dbo.OpenUrlCitationSelectByTitleIdentifier 'ISSN', @ISSN
END

IF NOT EXISTS(SELECT TitleID FROM #tmpOpenUrlCitation)
BEGIN
	INSERT INTO #tmpOpenUrlCitation EXEC dbo.OpenUrlCitationSelectByTitleIdentifier 'ISBN', @ISBN
END

IF NOT EXISTS(SELECT TitleID FROM #tmpOpenUrlCitation)
BEGIN
	INSERT INTO #tmpOpenUrlCitation EXEC dbo.OpenUrlCitationSelectByTitleIdentifier 'DLC', @LCCN
END

IF NOT EXISTS(SELECT TitleID FROM #tmpOpenUrlCitation)
BEGIN
	INSERT INTO #tmpOpenUrlCitation EXEC dbo.OpenUrlCitationSelectByTitleIdentifier 'Abbreviation', @Abbreviation
END

IF NOT EXISTS(SELECT TitleID FROM #tmpOpenUrlCitation)
BEGIN
	INSERT INTO #tmpOpenUrlCitation EXEC dbo.OpenUrlCitationSelectByTitleIdentifier 'CODEN', @CODEN
END


-- ***************************************************************
-- Still nothing?  Try using title, author, and publisher information
IF NOT EXISTS(SELECT TitleID FROM #tmpOpenUrlCitation)
BEGIN
	INSERT INTO #tmpOpenUrlCitation 
		EXEC dbo.OpenUrlCitationSelectByTitleDetails @Title, @AuthorLast,
			@AuthorFirst, @AuthorCorporation, @PublisherName, @PublisherPlace,
			@Publisher
END


-- ***************************************************************
-- If we have one or more title citations, find requested pages

IF EXISTS(SELECT TitleID FROM #tmpOpenUrlCitation)
BEGIN
	CREATE TABLE #items
	(
		ItemID int
	)

	CREATE TABLE #pages
	(
		PageID int,
		ItemID int,
		Issue nvarchar(20),
		Year nvarchar(20),
		Volume nvarchar(20),
		PagePrefix nvarchar(20),
		PageNumber nvarchar(20)
	)

	-- See if we can narrow it down to an item
	IF @Volume <> ''
	BEGIN
		-- Check the Volume field in the Page table
		-- First try an exact match
		INSERT INTO #items 
		SELECT DISTINCT
				p.ItemID
		FROM	Page p INNER JOIN Item i ON p.ItemID = i.ItemID
				INNER JOIN TitleItem ti ON i.ItemID = ti.ItemID
				INNER JOIN Title t ON ti.TitleID = t.TitleID
				INNER JOIN #tmpOpenUrlCitation ou ON t.TitleID = ou.TitleID
		WHERE	t.PublishReady = 1 
		AND		i.ItemStatusID = 40
		AND		p.Active = 1
		AND		p.Volume = @Volume

		SELECT @ItemCount = COUNT(*) FROM #items
		IF @ItemCount = 0
		BEGIN
			-- If no items found, check the Volume field in the Item table
			INSERT INTO #items 
			SELECT DISTINCT 
					i.ItemID
			FROM	Item i INNER JOIN TitleItem ti ON i.ItemID = ti.ItemID
					INNER JOIN Title t ON ti.TitleID = t.TitleID
					INNER JOIN #tmpOpenUrlCitation ou ON t.TitleID = ou.TitleID
			WHERE	t.PublishReady = 1 
			AND		i.ItemStatusID = 40
			AND		i.Volume = @Volume

			SELECT @ItemCount = COUNT(*) FROM #items
		END

		-- If we don't have any volumes, then try "LIKE" queries
		-- First try the Page table
		IF @ItemCount = 0
		BEGIN
			INSERT INTO #items 
			SELECT DISTINCT
					p.ItemID
			FROM	Page p INNER JOIN Item i ON p.ItemID = i.ItemID
					INNER JOIN TitleItem ti ON i.ItemID = ti.ItemID
					INNER JOIN Title t ON ti.TitleID = t.TitleID
					INNER JOIN #tmpOpenUrlCitation ou ON t.TitleID = ou.TitleID
			WHERE	t.PublishReady = 1 
			AND		i.ItemStatusID = 40
			AND		p.Active = 1
			--AND		p.Volume LIKE '%' + @Volume + '%'
			AND		(p.Volume LIKE @Volume + '%'
			OR		p.Volume LIKE '%[^0-9]' + @Volume + '%')

			SELECT @ItemCount = COUNT(*) FROM #items
		END

		IF @ItemCount = 0
		BEGIN
			-- If still no items found, again check the Volume field in the Item table
			INSERT INTO #items 
			SELECT DISTINCT 
					i.ItemID
			FROM	Item i INNER JOIN TitleItem ti ON i.ItemID = ti.ItemID
					INNER JOIN Title t ON ti.TitleID = t.TitleID
					INNER JOIN #tmpOpenUrlCitation ou ON t.TitleID = ou.TitleID
			WHERE	t.PublishReady = 1 
			AND		i.ItemStatusID = 40
			--AND		i.Volume LIKE '%' + @Volume + '%'
			AND		(i.Volume LIKE @Volume + '%'
			OR		i.Volume LIKE '%[^0-9]' + @Volume + '%')

			SELECT @ItemCount = COUNT(*) FROM #items
		END
	END

	-- Do the initial population of the #pages table
	IF @StartPage <> ''
	BEGIN
		IF @ItemCount > 0
		BEGIN
			INSERT INTO #pages
			SELECT	p.PageID, it.ItemID, p.Issue, p.Year, p.Volume, ISNULL(ip.PagePrefix, ''), ISNULL(ip.PageNumber, '')
			FROM	#items it INNER JOIN Page p ON it.ItemID = p.ItemID
					INNER JOIN IndicatedPage ip ON p.PageID = ip.PageID
			WHERE	ip.PageNumber = @StartPage 
			AND		p.Active = 1
		END
		ELSE
		BEGIN
			---- If we had a volume to search for and didn't find any items, then don't look for pages
			--IF (@Volume = '')
			--BEGIN
				INSERT INTO #pages
				SELECT	p.PageID, i.ItemID, p.Issue, p.Year, p.Volume, ISNULL(ip.PagePrefix, ''), ISNULL(ip.PageNumber, '')
				FROM	Item i INNER JOIN Page p ON i.ItemID = p.ItemID
						INNER JOIN IndicatedPage ip ON p.PageID = ip.PageID
						INNER JOIN TitleItem ti ON i.ItemID = ti.ItemID
						INNER JOIN #tmpOpenUrlCitation ou ON ti.TitleID = ou.TitleID
				WHERE	ip.PageNumber = @StartPage 
				AND		p.Active = 1
				AND		i.ItemStatusID = 40
			--END
		END
	END

	-- If no pages were inserted based on start page, then look for a title page
	IF (SELECT COUNT(*) FROM #pages) = 0
	BEGIN
		IF @ItemCount > 0
		BEGIN
			INSERT INTO #pages
			SELECT	p.PageID, it.ItemID, p.Issue, p.Year, p.Volume, ISNULL(ip.PagePrefix, ''), ISNULL(ip.PageNumber, '')
			FROM	#items it INNER JOIN Page p ON it.ItemID = p.ItemID
					LEFT JOIN IndicatedPage ip ON p.PageID = ip.PageID
					INNER JOIN Page_PageType ppt ON p.PageID = ppt.PageID
			WHERE	ppt.PageTypeID = 1 -- title page
			AND		p.Active = 1
		END
		ELSE
		BEGIN
			---- If we had a volume to search for and didn't find any items, then don't look for pages
			--IF (@Volume = '')
			--BEGIN
				INSERT INTO #pages
				SELECT	p.PageID, i.ItemID, p.Issue, p.Year, p.Volume, ISNULL(ip.PagePrefix, ''), ISNULL(ip.PageNumber, '')
				FROM	Item i INNER JOIN Page p ON i.ItemID = p.ItemID
						LEFT JOIN IndicatedPage ip ON p.PageID = ip.PageID
						INNER JOIN Page_PageType ppt ON p.PageID = ppt.PageID
						INNER JOIN TitleItem ti ON i.ItemID = ti.ItemID
						INNER JOIN #tmpOpenUrlCitation ou ON ti.TitleID = ou.TitleID
				WHERE	ppt.PageTypeID = 1 -- title page
				AND		p.Active = 1
				AND		i.ItemStatusID = 40
			--END
		END
	END

	-- If an issue was specified, drop any rows from our #pages table that don't match
	IF (@Issue <> '') DELETE FROM #pages WHERE Issue <> @Issue

	-- Populate the final result set
	IF (SELECT COUNT(*) FROM #pages) > 0
	BEGIN
		-- Clear out the title citations
		TRUNCATE TABLE #tmpOpenUrlCitation

		-- Add page citations
		INSERT INTO #tmpOpenUrlCitation	(
			PageID, ItemID, TitleID, FullTitle, PublisherPlace, PublisherName, Date, LanguageName,
			Volume, EditionStatement, CurrentPublicationFrequency, Genre, Authors, Subjects,
			StartPage
			)
		SELECT	p.PageID,
				i.ItemID,
				t.TitleID,
				ISNULL(t.FullTitle, ''),
				ISNULL(t.Datafield_260_a, '') AS PublisherPlace,
				ISNULL(t.Datafield_260_b, '') AS PublisherName,
				ISNULL(p.Year, ISNULL(i.Year, CONVERT(nvarchar(20), ISNULL(t.StartYear, '')))) AS [Date],
				ISNULL(l.LanguageName, ''),
				CASE WHEN ISNULL(p.Volume, '') = '' THEN ISNULL(i.Volume, '') ELSE p.Volume END,
				ISNULL(t.EditionStatement, ''),
				ISNULL(t.CurrentPublicationFrequency, ''),
				CASE WHEN SUBSTRING(t.MarcBibID, 8, 1) IN ('m', 'a') THEN 'Book' ELSE 'Journal' END AS Genre,
				dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
				dbo.fnTagTextStringForTitle(t.TitleID) AS Subjects,
				LTRIM(p.PagePrefix + ' ' + p.PageNumber) AS StartPage
		FROM	#pages p INNER JOIN dbo.Item i
					ON p.ItemID = i.ItemID
				INNER JOIN dbo.Title t
					ON i.PrimaryTitleID = t.TitleID
				LEFT JOIN dbo.Language l
					ON i.LanguageCode = l.LanguageCode
		WHERE	t.PublishReady = 1
	END
	ELSE 
	BEGIN 
		IF (SELECT COUNT(*) FROM #items) > 0
		BEGIN
			-- Clear out the title citations
			TRUNCATE TABLE #tmpOpenUrlCitation

			--- Add item citations
			INSERT INTO #tmpOpenUrlCitation	(
				PageID, ItemID, TitleID, FullTitle, PublisherPlace, PublisherName, Date, LanguageName,
				Volume, EditionStatement, CurrentPublicationFrequency, Genre, Authors, Subjects,
				StartPage
				)
			SELECT	0,
					i.ItemID,
					t.TitleID,
					ISNULL(t.FullTitle, ''),
					ISNULL(t.Datafield_260_a, '') AS PublisherPlace,
					ISNULL(t.Datafield_260_b, '') AS PublisherName,
					ISNULL(i.Year, CONVERT(nvarchar(20), ISNULL(t.StartYear, ''))) AS [Date],
					ISNULL(l.LanguageName, ''),
					ISNULL(i.Volume, ''),
					ISNULL(t.EditionStatement, ''),
					ISNULL(t.CurrentPublicationFrequency, ''),
					CASE WHEN SUBSTRING(t.MarcBibID, 8, 1) IN ('m', 'a') THEN 'Book' ELSE 'Journal' END AS Genre,
					dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
					dbo.fnTagTextStringForTitle(t.TitleID) AS Subjects,
					'' AS StartPage
			FROM	#items it INNER JOIN dbo.Item i
						ON it.ItemID = i.ItemID
					INNER JOIN dbo.Title t
						ON i.PrimaryTitleID = t.TitleID
					LEFT JOIN dbo.Language l
						ON i.LanguageCode = l.LanguageCode
			WHERE	t.PublishReady = 1
		END
	END

	-- If a year was specified, drop any rows that don't match
	IF @Year <> ''
	BEGIN
		--if deleting based on year would wipe out all of our results, then don't filter on year
		IF (SELECT COUNT(*) FROM #tmpOpenUrlCitation WHERE [Date] = @Year) > 0
			DELETE FROM #tmpOpenUrlCitation WHERE [Date] <> @Year
	END

	DROP TABLE #pages
	DROP TABLE #items
END


-- ***************************************************************
-- Add the title identifiers to the final result set
UPDATE	#tmpOpenUrlCitation
SET		ISSN = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 2

UPDATE	#tmpOpenUrlCitation
SET		ISBN = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 3

UPDATE	#tmpOpenUrlCitation
SET		LCCN = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 5

UPDATE	#tmpOpenUrlCitation
SET		OCLC = REPLACE(tti.IdentifierValue, 'ocm', '')
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 1

UPDATE	#tmpOpenUrlCitation
SET		Abbreviation = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 6


-- ***************************************************************
-- Return the final result set

SELECT DISTINCT t.*, ti.ItemSequence
FROM #tmpOpenUrlCitation t LEFT JOIN dbo.TitleItem ti
		ON t.TitleID = ti.TitleID
		AND t.ItemID = ti.ItemID
ORDER BY t.FullTitle, ti.ItemSequence, t.Date, t.StartPage


DROP TABLE #tmpOpenUrlCitation

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OpenUrlCitationSelectByPageID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[OpenUrlCitationSelectByPageID]
GO


/****** Object:  StoredProcedure [dbo].[OpenUrlCitationSelectByPageID]    Script Date: 10/16/2009 16:27:53 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[OpenUrlCitationSelectByPageID]

@PageID int

AS

BEGIN

SET NOCOUNT ON

CREATE TABLE #tmpOpenUrlCitation
	(
	PageID int NULL,
	ItemID int NULL,
	TitleID int NULL,
	FullTitle nvarchar(2000) NOT NULL DEFAULT(''),
	PublisherPlace nvarchar(150) NOT NULL DEFAULT(''),
	PublisherName nvarchar(255) NOT NULL DEFAULT(''),
	Date nvarchar(20) NOT NULL DEFAULT(''),
	LanguageName nvarchar(20) NOT NULL DEFAULT(''),
	Volume nvarchar(100) NOT NULL DEFAULT(''),
	EditionStatement nvarchar(450) NOT NULL DEFAULT(''),
	CurrentPublicationFrequency nvarchar(100) NOT NULL DEFAULT(''),
	Genre nvarchar(20) NOT NULL DEFAULT(''),
	Authors nvarchar(1000) NOT NULL DEFAULT(''),
	Subjects nvarchar(1000) NOT NULL DEFAULT(''),
	StartPage nvarchar(40) NOT NULL DEFAULT(''),
	EndPage nvarchar(40) NOT NULL DEFAULT(''),
	Pages nvarchar(40) NOT NULL DEFAULT(''),
	ISSN nvarchar(125) NOT NULL DEFAULT(''),
	ISBN nvarchar(125) NOT NULL DEFAULT(''),
	LCCN nvarchar(125) NOT NULL DEFAULT(''),
	OCLC nvarchar(125) NOT NULL DEFAULT(''),
	Abbreviation nvarchar(125) NOT NULL DEFAULT('')
	)

-- Get the basic title/item/page information
INSERT INTO #tmpOpenUrlCitation	(
	PageID, ItemID, TitleID, FullTitle, PublisherPlace, PublisherName, Date, LanguageName,
	Volume, EditionStatement, CurrentPublicationFrequency, Genre, Authors, Subjects,
	StartPage
	)
SELECT	p.PageID,
		i.ItemID,
		t.TitleID,
		ISNULL(t.FullTitle, ''),
		ISNULL(t.Datafield_260_a, '') AS PublisherPlace,
		ISNULL(t.Datafield_260_b, '') AS PublisherName,
		ISNULL(p.Year, ISNULL(i.Year, CONVERT(nvarchar(20), ISNULL(t.StartYear, '')))) AS [Date],
		ISNULL(l.LanguageName, ''),
		ISNULL(i.Volume, ''),
		ISNULL(t.EditionStatement, ''),
		ISNULL(t.CurrentPublicationFrequency, ''),
		CASE WHEN SUBSTRING(t.MarcBibID, 8, 1) IN ('m', 'a') THEN 'Book' ELSE 'Journal' END AS Genre,
		dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
		dbo.fnTagTextStringForTitle(t.TitleID) AS Subjects,
		dbo.fnIndicatedPageStringForPage(p.PageID) AS StartPage
FROM	dbo.Page p INNER JOIN dbo.Item i
			ON p.ItemID = i.ItemID
		INNER JOIN dbo.Title t
			ON i.PrimaryTitleID = t.TitleID
		INNER JOIN dbo.Language l
			ON i.LanguageCode = l.LanguageCode
WHERE	p.PageID = @PageID
AND		p.Active = 1
AND		i.ItemStatusID = 40
AND		t.PublishReady = 1

-- Get the title identifiers
UPDATE	#tmpOpenUrlCitation
SET		ISSN = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 2

UPDATE	#tmpOpenUrlCitation
SET		ISBN = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 3

UPDATE	#tmpOpenUrlCitation
SET		LCCN = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 5

UPDATE	#tmpOpenUrlCitation
SET		OCLC = REPLACE(tti.IdentifierValue, 'ocm', '')
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 1

UPDATE	#tmpOpenUrlCitation
SET		Abbreviation = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 6

-- Return the final result set
SELECT * FROM #tmpOpenUrlCitation ORDER BY FullTitle, Volume, Date, StartPage

-- Clean up
DROP TABLE #tmpOpenUrlCitation

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OpenUrlCitationSelectByTitleDetails]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[OpenUrlCitationSelectByTitleDetails]
GO


/****** Object:  StoredProcedure [dbo].[OpenUrlCitationSelectByTitleDetails]    Script Date: 10/16/2009 16:27:53 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[OpenUrlCitationSelectByTitleDetails]

@Title nvarchar(2000) = '',
@AuthorLast nvarchar(150) = '',
@AuthorFirst nvarchar(100) = '',
@AuthorCorporation nvarchar(255) = '',
@PublisherName nvarchar(255) = '',
@PublisherPlace nvarchar(150) = '',
@Publisher nvarchar(255) = ''

AS

BEGIN

SET NOCOUNT ON

-- Need to check for both "Last, First" and "First Last"
DECLARE @Author nvarchar(255)
DECLARE @AuthorAlt nvarchar(255)
SET @Author = ''
SET @AuthorAlt = ''

IF (@AuthorCorporation <> '')
BEGIN
	SET @Author = @AuthorCorporation + '%'
END
ELSE
BEGIN
	IF (@AuthorFirst = '' AND @AuthorLast <> '') SET @Author = @AuthorLast + '%'
	IF (@AuthorFirst <> '' AND @AuthorLast = '') SET @Author = @AuthorFirst + '%'
	IF (@AuthorFirst <> '' AND @AuthorLast <> '') 
	BEGIN
		SET @Author = @AuthorLast + ', ' + @AuthorFirst + '%'
		SET @AuthorAlt = @AuthorFirst + ' ' + @AuthorLast + '%'
	END
END
IF @AuthorAlt = '' SET @AuthorAlt = @Author

CREATE TABLE #tmpOpenUrlCitation
	(
	PageID int NULL,
	ItemID int NULL,
	TitleID int NULL,
	FullTitle nvarchar(2000) NOT NULL DEFAULT(''),
	PublisherPlace nvarchar(150) NOT NULL DEFAULT(''),
	PublisherName nvarchar(255) NOT NULL DEFAULT(''),
	Date nvarchar(20) NOT NULL DEFAULT(''),
	LanguageName nvarchar(20) NOT NULL DEFAULT(''),
	Volume nvarchar(100) NOT NULL DEFAULT(''),
	EditionStatement nvarchar(450) NOT NULL DEFAULT(''),
	CurrentPublicationFrequency nvarchar(100) NOT NULL DEFAULT(''),
	Genre nvarchar(20) NOT NULL DEFAULT(''),
	Authors nvarchar(2000) NOT NULL DEFAULT(''),
	Subjects nvarchar(1000) NOT NULL DEFAULT(''),
	StartPage nvarchar(40) NOT NULL DEFAULT(''),
	EndPage nvarchar(40) NOT NULL DEFAULT(''),
	Pages nvarchar(40) NOT NULL DEFAULT(''),
	ISSN nvarchar(125) NOT NULL DEFAULT(''),
	ISBN nvarchar(125) NOT NULL DEFAULT(''),
	LCCN nvarchar(125) NOT NULL DEFAULT(''),
	OCLC nvarchar(125) NOT NULL DEFAULT(''),
	Abbreviation nvarchar(125) NOT NULL DEFAULT('')
	)

-- Make sure that search criteria were specified
IF (@Title <> '' OR
	@AuthorLast <> '' OR
	@AuthorFirst <> '' OR
	@AuthorCorporation <> '' OR
	@PublisherName <> '' OR
	@PublisherPlace <> '')
BEGIN
	IF @Title <> '' SET @Title = @Title + '%'
	IF @PublisherName <> '' SET @PublisherName = @PublisherName + '%'
	IF @PublisherPlace <> '' SET @PublisherPlace = @PublisherPlace + '%'
	IF @Publisher <> '' SET @Publisher = @Publisher + '%'

	-- Get the basic title/item/page information

	-- First check using the specified author information
	INSERT INTO #tmpOpenUrlCitation	(
		PageID, ItemID, TitleID, FullTitle, PublisherPlace, PublisherName, Date, LanguageName,
		Volume, EditionStatement, CurrentPublicationFrequency, Genre, Authors, Subjects,
		StartPage
		)
	SELECT	0,
			0,
			t.TitleID,
			ISNULL(t.FullTitle, ''),
			ISNULL(t.Datafield_260_a, '') AS PublisherPlace,
			ISNULL(t.Datafield_260_b, '') AS PublisherName,
			'' AS [Date],
			'' AS LanguageName,
			'' AS Volume,
			ISNULL(t.EditionStatement, ''),
			ISNULL(t.CurrentPublicationFrequency, ''),
			CASE WHEN SUBSTRING(t.MarcBibID, 8, 1) IN ('m', 'a') THEN 'Book' ELSE 'Journal' END AS Genre,
			dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
			dbo.fnTagTextStringForTitle(t.TitleID) AS Subjects,
			'' AS StartPage
	FROM	dbo.Title t LEFT JOIN dbo.Title_Creator tc
				ON t.TitleID = tc.TitleID
			LEFT JOIN dbo.Creator c
				ON tc.CreatorID = c.CreatorID
	WHERE	t.PublishReady = 1
	AND		(t.FullTitle LIKE @Title OR @Title = '')
	AND		(ISNULL(c.CreatorName, '&&&&&') LIKE @Author OR 
				ISNULL(c.CreatorName, '&&&&&') LIKE @AuthorAlt OR
				(@Author = '' AND @AuthorAlt = ''))

	DECLARE @NumFound int
	SELECT @NumFound = COUNT(*) FROM #tmpOpenUrlCitation

	IF (@NumFound = 0)
	BEGIN
		-- Nothing found using author; try publisher instead
		INSERT INTO #tmpOpenUrlCitation	(
			PageID, ItemID, TitleID, FullTitle, PublisherPlace, PublisherName, Date, LanguageName,
			Volume, EditionStatement, CurrentPublicationFrequency, Genre, Authors, Subjects,
			StartPage
			)
		SELECT	0,
				0,
				t.TitleID,
				ISNULL(t.FullTitle, ''),
				ISNULL(t.Datafield_260_a, '') AS PublisherPlace,
				ISNULL(t.Datafield_260_b, '') AS PublisherName,
				'' AS [Date],
				'' AS LanguageName,
				'' AS Volume,
				ISNULL(t.EditionStatement, ''),
				ISNULL(t.CurrentPublicationFrequency, ''),
				CASE WHEN SUBSTRING(t.MarcBibID, 8, 1) IN ('m', 'a') THEN 'Book' ELSE 'Journal' END AS Genre,
				dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
				dbo.fnTagTextStringForTitle(t.TitleID) AS Subjects,
				'' AS StartPage
		FROM	dbo.Title t LEFT JOIN dbo.Title_Creator tc
					ON t.TitleID = tc.TitleID
				LEFT JOIN dbo.Creator c
					ON tc.CreatorID = c.CreatorID
		WHERE	t.PublishReady = 1
		AND		(t.FullTitle LIKE @Title OR @Title = '')
		AND		(t.Datafield_260_b LIKE @PublisherName OR @PublisherName = '')
		AND		(t.Datafield_260_a LIKE @PublisherPlace OR @PublisherPlace = '')
		AND		(t.PublicationDetails LIKE @Publisher OR @Publisher = '')
	END

	IF (@NumFound > 1)
	BEGIN
		-- More than one found using author, try to limit by publisher
		IF EXISTS(	SELECT	tmp.TitleID
					FROM	#tmpOpenUrlCitation tmp INNER JOIN dbo.Title t
							ON tmp.TitleID = t.TitleID
					WHERE	(t.Datafield_260_b LIKE @PublisherName AND @PublisherName <> '')
					OR		(t.Datafield_260_a LIKE @PublisherPlace AND @PublisherPlace <> '')
					OR		(t.PublicationDetails LIKE @Publisher AND @Publisher <> '')
				)
		BEGIN
			-- If anything DOES match on publisher, then delete anything 
			-- that DOESN'T.  Otherwise, just leave alone what we've got.
			DELETE	#tmpOpenUrlCitation
			FROM	#tmpOpenUrlCitation tmp INNER JOIN dbo.Title t
					ON tmp.TitleID = t.TitleID
			WHERE	t.Datafield_260_b NOT LIKE @PublisherName
			AND		t.Datafield_260_a NOT LIKE @PublisherPlace
			AND		t.PublicationDetails NOT LIKE @Publisher
		END		
	END

	/*
	-- Get the title identifiers
	UPDATE	#tmpOpenUrlCitation
	SET		ISSN = tti.IdentifierValue
	FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
				ON t.TitleID = tti.TitleID
				AND tti.TitleIdentifierID = 2

	UPDATE	#tmpOpenUrlCitation
	SET		ISBN = tti.IdentifierValue
	FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
				ON t.TitleID = tti.TitleID
				AND tti.TitleIdentifierID = 3

	UPDATE	#tmpOpenUrlCitation
	SET		LCCN = tti.IdentifierValue
	FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
				ON t.TitleID = tti.TitleID
				AND tti.TitleIdentifierID = 5

	UPDATE	#tmpOpenUrlCitation
	SET		OCLC = REPLACE(tti.IdentifierValue, 'ocm', '')
	FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
				ON t.TitleID = tti.TitleID
				AND tti.TitleIdentifierID = 1

	UPDATE	#tmpOpenUrlCitation
	SET		Abbreviation = tti.IdentifierValue
	FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
				ON t.TitleID = tti.TitleID
				AND tti.TitleIdentifierID = 6
	*/
END

-- Return the final result set
SELECT DISTINCT * FROM #tmpOpenUrlCitation ORDER BY FullTitle, Volume, Date, StartPage

-- Clean up
DROP TABLE #tmpOpenUrlCitation

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OpenUrlCitationSelectByTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[OpenUrlCitationSelectByTitleID]
GO


/****** Object:  StoredProcedure [dbo].[OpenUrlCitationSelectByTitleID]    Script Date: 10/16/2009 16:27:53 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OpenUrlCitationSelectByTitleID]

@TitleID int

AS

BEGIN

SET NOCOUNT ON

CREATE TABLE #tmpOpenUrlCitation
	(
	PageID int NULL,
	ItemID int NULL,
	TitleID int NULL,
	FullTitle nvarchar(2000) NOT NULL DEFAULT(''),
	PublisherPlace nvarchar(150) NOT NULL DEFAULT(''),
	PublisherName nvarchar(255) NOT NULL DEFAULT(''),
	Date nvarchar(20) NOT NULL DEFAULT(''),
	LanguageName nvarchar(20) NOT NULL DEFAULT(''),
	Volume nvarchar(100) NOT NULL DEFAULT(''),
	EditionStatement nvarchar(450) NOT NULL DEFAULT(''),
	CurrentPublicationFrequency nvarchar(100) NOT NULL DEFAULT(''),
	Genre nvarchar(20) NOT NULL DEFAULT(''),
	Authors nvarchar(2000) NOT NULL DEFAULT(''),
	Subjects nvarchar(1000) NOT NULL DEFAULT(''),
	StartPage nvarchar(40) NOT NULL DEFAULT(''),
	EndPage nvarchar(40) NOT NULL DEFAULT(''),
	Pages nvarchar(40) NOT NULL DEFAULT(''),
	ISSN nvarchar(125) NOT NULL DEFAULT(''),
	ISBN nvarchar(125) NOT NULL DEFAULT(''),
	LCCN nvarchar(125) NOT NULL DEFAULT(''),
	OCLC nvarchar(125) NOT NULL DEFAULT(''),
	Abbreviation nvarchar(125) NOT NULL DEFAULT('')
	)

-- Get the basic title/item/page information
INSERT INTO #tmpOpenUrlCitation	(
	PageID, ItemID, TitleID, FullTitle, PublisherPlace, PublisherName, Date, LanguageName,
	Volume, EditionStatement, CurrentPublicationFrequency, Genre, Authors, Subjects,
	StartPage
	)
SELECT	0,
		0,
		t.TitleID,
		ISNULL(t.FullTitle, ''),
		ISNULL(t.Datafield_260_a, '') AS PublisherPlace,
		ISNULL(t.Datafield_260_b, '') AS PublisherName,
		'' AS [Date],
		'' AS LanguageName,
		'' AS Volume,
		ISNULL(t.EditionStatement, ''),
		ISNULL(t.CurrentPublicationFrequency, ''),
		CASE WHEN SUBSTRING(t.MarcBibID, 8, 1) IN ('m', 'a') THEN 'Book' ELSE 'Journal' END AS Genre,
		dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
		dbo.fnTagTextStringForTitle(t.TitleID) AS Subjects,
		'' AS StartPage
FROM	dbo.Title t
WHERE	t.PublishReady = 1
AND		t.TitleID = @TitleID

/*
-- Get the title identifiers
UPDATE	#tmpOpenUrlCitation
SET		ISSN = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 2

UPDATE	#tmpOpenUrlCitation
SET		ISBN = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 3

UPDATE	#tmpOpenUrlCitation
SET		LCCN = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 5

UPDATE	#tmpOpenUrlCitation
SET		OCLC = REPLACE(tti.IdentifierValue, 'ocm', '')
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 1

UPDATE	#tmpOpenUrlCitation
SET		Abbreviation = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 6
*/

-- Return the final result set
SELECT * FROM #tmpOpenUrlCitation ORDER BY FullTitle, Volume, Date, StartPage

-- Clean up
DROP TABLE #tmpOpenUrlCitation

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[OpenUrlCitationSelectByTitleIdentifier]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[OpenUrlCitationSelectByTitleIdentifier]
GO


/****** Object:  StoredProcedure [dbo].[OpenUrlCitationSelectByTitleIdentifier]    Script Date: 10/16/2009 16:27:54 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[OpenUrlCitationSelectByTitleIdentifier]

@IdentifierName nvarchar(40),
@IdentifierValue nvarchar(125)

AS

BEGIN

SET NOCOUNT ON

CREATE TABLE #tmpOpenUrlCitation
	(
	PageID int NULL,
	ItemID int NULL,
	TitleID int NULL,
	FullTitle nvarchar(2000) NOT NULL DEFAULT(''),
	PublisherPlace nvarchar(150) NOT NULL DEFAULT(''),
	PublisherName nvarchar(255) NOT NULL DEFAULT(''),
	Date nvarchar(20) NOT NULL DEFAULT(''),
	LanguageName nvarchar(20) NOT NULL DEFAULT(''),
	Volume nvarchar(100) NOT NULL DEFAULT(''),
	EditionStatement nvarchar(450) NOT NULL DEFAULT(''),
	CurrentPublicationFrequency nvarchar(100) NOT NULL DEFAULT(''),
	Genre nvarchar(20) NOT NULL DEFAULT(''),
	Authors nvarchar(1000) NOT NULL DEFAULT(''),
	Subjects nvarchar(1000) NOT NULL DEFAULT(''),
	StartPage nvarchar(40) NOT NULL DEFAULT(''),
	EndPage nvarchar(40) NOT NULL DEFAULT(''),
	Pages nvarchar(40) NOT NULL DEFAULT(''),
	ISSN nvarchar(125) NOT NULL DEFAULT(''),
	ISBN nvarchar(125) NOT NULL DEFAULT(''),
	LCCN nvarchar(125) NOT NULL DEFAULT(''),
	OCLC nvarchar(125) NOT NULL DEFAULT(''),
	Abbreviation nvarchar(125) NOT NULL DEFAULT('')
	)

-- Get the basic title/item/page information
INSERT INTO #tmpOpenUrlCitation	(
	PageID, ItemID, TitleID, FullTitle, PublisherPlace, PublisherName, Date, LanguageName,
	Volume, EditionStatement, CurrentPublicationFrequency, Genre, Authors, Subjects,
	StartPage
	)
SELECT	0,
		0,
		t.TitleID,
		ISNULL(t.FullTitle, ''),
		ISNULL(t.Datafield_260_a, '') AS PublisherPlace,
		ISNULL(t.Datafield_260_b, '') AS PublisherName,
		'' AS [Date],
		'' AS LanguageName,
		'' AS Volume,
		ISNULL(t.EditionStatement, ''),
		ISNULL(t.CurrentPublicationFrequency, ''),
		CASE WHEN SUBSTRING(t.MarcBibID, 8, 1) IN ('m', 'a') THEN 'Book' ELSE 'Journal' END AS Genre,
		dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
		dbo.fnTagTextStringForTitle(t.TitleID) AS Subjects,
		'' AS StartPage
FROM	dbo.Title t INNER JOIN dbo.Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND (tti.IdentifierValue = @IdentifierValue
			OR tti.IdentifierValue = 'ocm' + @IdentifierValue)
		INNER JOIN dbo.TitleIdentifier ti
			ON tti.TitleIdentifierID = ti.TitleIdentifierID
			AND ti.IdentifierName = @IdentifierName
WHERE	t.PublishReady = 1

/*
-- Get the title identifiers
UPDATE	#tmpOpenUrlCitation
SET		ISSN = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 2

UPDATE	#tmpOpenUrlCitation
SET		ISBN = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 3

UPDATE	#tmpOpenUrlCitation
SET		LCCN = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 5

UPDATE	#tmpOpenUrlCitation
SET		OCLC = REPLACE(tti.IdentifierValue, 'ocm', '')
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 1

UPDATE	#tmpOpenUrlCitation
SET		Abbreviation = tti.IdentifierValue
FROM	#tmpOpenUrlCitation t INNER JOIN Title_TitleIdentifier tti
			ON t.TitleID = tti.TitleID
			AND tti.TitleIdentifierID = 6
*/

-- Return the final result set
SELECT * FROM #tmpOpenUrlCitation ORDER BY FullTitle, Volume, Date, StartPage

-- Clean up
DROP TABLE #tmpOpenUrlCitation

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTypeDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTypeDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleTypeDeleteAuto]    Script Date: 10/16/2009 16:27:54 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleTypeDeleteAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for TitleType

CREATE PROCEDURE TitleTypeDeleteAuto

@TitleTypeID INT /* Unique identifier for each Title Type record. */

AS 

DELETE FROM [dbo].[TitleType]

WHERE

	[TitleTypeID] = @TitleTypeID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleTypeDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Page_PageTypeDeleteAllForPage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Page_PageTypeDeleteAllForPage]
GO


/****** Object:  StoredProcedure [dbo].[Page_PageTypeDeleteAllForPage]    Script Date: 10/16/2009 16:27:55 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[Page_PageTypeDeleteAllForPage]

@PageID INT /* Unique identifier for each Page record. */
AS 

DELETE FROM [dbo].[Page_PageType]

WHERE

	[PageID] = @PageID 

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Page_PageTypeDeleteAllForPage. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Page_PageTypeDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Page_PageTypeDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[Page_PageTypeDeleteAuto]    Script Date: 10/16/2009 16:27:55 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Page_PageTypeDeleteAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Page_PageType

CREATE PROCEDURE Page_PageTypeDeleteAuto

@PageID INT /* Unique identifier for each Page record. */,
@PageTypeID INT /* Unique identifier for each Page Type record. */

AS 

DELETE FROM [dbo].[Page_PageType]

WHERE

	[PageID] = @PageID AND
	[PageTypeID] = @PageTypeID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Page_PageTypeDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Page_PageTypeInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Page_PageTypeInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[Page_PageTypeInsertAuto]    Script Date: 10/16/2009 16:27:55 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Page_PageTypeInsertAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Page_PageType

CREATE PROCEDURE Page_PageTypeInsertAuto

@PageID INT /* Unique identifier for each Page record. */,
@PageTypeID INT /* Unique identifier for each Page Type record. */,
@Verified BIT,
@CreationUserID INT = null,
@LastModifiedUserID INT = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Page_PageType]
(
	[PageID],
	[PageTypeID],
	[Verified],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID]
)
VALUES
(
	@PageID,
	@PageTypeID,
	@Verified,
	getdate(),
	getdate(),
	@CreationUserID,
	@LastModifiedUserID
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Page_PageTypeInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PageID],
		[PageTypeID],
		[Verified],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID]	

	FROM [dbo].[Page_PageType]
	
	WHERE
		[PageID] = @PageID AND
		[PageTypeID] = @PageTypeID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Page_PageTypeSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Page_PageTypeSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[Page_PageTypeSelectAuto]    Script Date: 10/16/2009 16:27:56 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Page_PageTypeSelectAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for Page_PageType

CREATE PROCEDURE Page_PageTypeSelectAuto

@PageID INT /* Unique identifier for each Page record. */,
@PageTypeID INT /* Unique identifier for each Page Type record. */

AS 

SET NOCOUNT ON

SELECT 

	[PageID],
	[PageTypeID],
	[Verified],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID]

FROM [dbo].[Page_PageType]

WHERE
	[PageID] = @PageID AND
	[PageTypeID] = @PageTypeID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Page_PageTypeSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Page_PageTypeUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Page_PageTypeUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[Page_PageTypeUpdateAuto]    Script Date: 10/16/2009 16:27:56 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Page_PageTypeUpdateAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for Page_PageType

CREATE PROCEDURE Page_PageTypeUpdateAuto

@PageID INT /* Unique identifier for each Page record. */,
@PageTypeID INT /* Unique identifier for each Page Type record. */,
@Verified BIT,
@LastModifiedUserID INT

AS 

SET NOCOUNT ON

UPDATE [dbo].[Page_PageType]

SET

	[PageID] = @PageID,
	[PageTypeID] = @PageTypeID,
	[Verified] = @Verified,
	[LastModifiedDate] = getdate(),
	[LastModifiedUserID] = @LastModifiedUserID

WHERE
	[PageID] = @PageID AND
	[PageTypeID] = @PageTypeID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Page_PageTypeUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PageID],
		[PageTypeID],
		[Verified],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID]

	FROM [dbo].[Page_PageType]
	
	WHERE
		[PageID] = @PageID AND 
		[PageTypeID] = @PageTypeID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[PageDeleteAuto]    Script Date: 10/16/2009 16:27:56 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PageDeleteAuto PROCEDURE
-- Generated 2/26/2008 2:23:06 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Page

CREATE PROCEDURE PageDeleteAuto

@PageID INT

AS 

DELETE FROM [dbo].[Page]

WHERE

	[PageID] = @PageID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaultSelectMaxID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[VaultSelectMaxID]
GO


/****** Object:  StoredProcedure [dbo].[VaultSelectMaxID]    Script Date: 10/16/2009 16:27:57 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
create PROCEDURE [dbo].[VaultSelectMaxID]
AS 

SET NOCOUNT ON

SELECT 
MAX(	[VaultID] )
FROM [dbo].[Vault]

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[PageInsertAuto]    Script Date: 10/16/2009 16:27:57 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PageInsertAuto PROCEDURE
-- Generated 2/26/2008 2:23:06 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Page

CREATE PROCEDURE PageInsertAuto

@PageID INT OUTPUT,
@ItemID INT,
@FileNamePrefix NVARCHAR(50),
@SequenceOrder INT = null,
@PageDescription NVARCHAR(255) = null,
@Illustration BIT,
@Note NVARCHAR(255) = null,
@FileSize_Temp INT = null,
@FileExtension NVARCHAR(5) = null,
@Active BIT,
@Year NVARCHAR(20) = null,
@Series NVARCHAR(20) = null,
@Volume NVARCHAR(20) = null,
@Issue NVARCHAR(20) = null,
@ExternalURL NVARCHAR(500) = null,
@AltExternalURL NVARCHAR(500) = null,
@IssuePrefix NVARCHAR(20) = null,
@LastPageNameLookupDate DATETIME = null,
@PaginationUserID INT = null,
@PaginationDate DATETIME = null,
@CreationUserID INT = null,
@LastModifiedUserID INT = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Page]
(
	[ItemID],
	[FileNamePrefix],
	[SequenceOrder],
	[PageDescription],
	[Illustration],
	[Note],
	[FileSize_Temp],
	[FileExtension],
	[Active],
	[Year],
	[Series],
	[Volume],
	[Issue],
	[ExternalURL],
	[AltExternalURL],
	[IssuePrefix],
	[LastPageNameLookupDate],
	[PaginationUserID],
	[PaginationDate],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID]
)
VALUES
(
	@ItemID,
	@FileNamePrefix,
	@SequenceOrder,
	@PageDescription,
	@Illustration,
	@Note,
	@FileSize_Temp,
	@FileExtension,
	@Active,
	@Year,
	@Series,
	@Volume,
	@Issue,
	@ExternalURL,
	@AltExternalURL,
	@IssuePrefix,
	@LastPageNameLookupDate,
	@PaginationUserID,
	@PaginationDate,
	getdate(),
	getdate(),
	@CreationUserID,
	@LastModifiedUserID
)

SET @PageID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PageID],
		[ItemID],
		[FileNamePrefix],
		[SequenceOrder],
		[PageDescription],
		[Illustration],
		[Note],
		[FileSize_Temp],
		[FileExtension],
		[Active],
		[Year],
		[Series],
		[Volume],
		[Issue],
		[ExternalURL],
		[AltExternalURL],
		[IssuePrefix],
		[LastPageNameLookupDate],
		[PaginationUserID],
		[PaginationDate],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID]	

	FROM [dbo].[Page]
	
	WHERE
		[PageID] = @PageID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageMetadataSelectByItemID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageMetadataSelectByItemID]
GO


/****** Object:  StoredProcedure [dbo].[PageMetadataSelectByItemID]    Script Date: 10/16/2009 16:27:57 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageMetadataSelectByItemID]

@ItemID INT

AS 

SET NOCOUNT ON

SELECT 

	p.PageID,
	p.SequenceOrder,
	p.Year,
	p.Series,
	p.Volume,
	p.Issue,
	dbo.fnIndicatedPageStringForPage(p.PageID) AS IndicatedPages,
	dbo.fnPageTypeStringForPage(p.PageID) AS PageTypes,
	p.FileNamePrefix,
	v.FolderShare,
	v.WebVirtualDirectory,
	i.BarCode,
	t.MARCBibID,
	t.RareBooks,
	p.Illustration,
	p.ExternalURL,
	p.IssuePrefix

FROM dbo.Page p

INNER JOIN dbo.Item i ON (p.ItemID = i.ItemID)
INNER JOIN dbo.Title t ON (i.PrimaryTitleID = t.TitleID)
LEFT OUTER JOIN dbo.Vault v ON (i.VaultID = v.VaultID)

WHERE
	p.[ItemID] = @ItemID
AND
	Active = 1

ORDER BY
	p.[SequenceOrder] ASC

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageMetadataSelectByItemID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageMetadataSelectByPageID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageMetadataSelectByPageID]
GO


/****** Object:  StoredProcedure [dbo].[PageMetadataSelectByPageID]    Script Date: 10/16/2009 16:27:58 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageMetadataSelectByPageID]

@PageID INT

AS 

SET NOCOUNT ON

SELECT	p.PageID,
		p.SequenceOrder,
		ISNULL(p.Year, i.Year) AS [Year],
		p.Series,
		ISNULL(CONVERT(nvarchar(100), p.Volume), i.Volume) AS Volume,
		p.IssuePrefix,
		p.Issue,
		dbo.fnIndicatedPageStringForPage(p.PageID) AS IndicatedPages,
		dbo.fnPageTypeStringForPage(p.PageID) AS PageTypes,
		p.FileNamePrefix,
		i.BarCode,
		t.MARCBibID,
		t.ShortTitle
FROM	dbo.Page p INNER JOIN dbo.Item i 
			ON p.ItemID = i.ItemID
		INNER JOIN dbo.Title t 
			ON i.PrimaryTitleID = t.TitleID
WHERE	p.[PageID] = @PageID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageMetadataSelectByPageID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTagSelectWithSuspectCharacters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTagSelectWithSuspectCharacters]
GO


/****** Object:  StoredProcedure [dbo].[TitleTagSelectWithSuspectCharacters]    Script Date: 10/16/2009 16:27:58 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleTagSelectWithSuspectCharacters]

@InstitutionCode NVARCHAR(10) = '',
@MaxAge INT = 30

AS
BEGIN

SET NOCOUNT ON

SELECT	tt.TitleID, 
		t.InstitutionCode,
		inst.InstitutionName,
		tt.CreationDate,
		CHAR(dbo.fnContainsSuspectCharacter(tt.TagText)) AS TagTextSuspect, 
		tt.TagText,
		oclc.IdentifierValue as OCLC,
		MIN(i.ZQuery) AS ZQuery
FROM	dbo.TitleTag tt INNER JOIN dbo.Title t
			ON tt.TitleID = t.TitleID
		LEFT JOIN (SELECT * FROM dbo.Title_TitleIdentifier WHERE TitleIdentifierID = 1) as oclc
			ON t.TitleID = oclc.TitleID
		INNER JOIN dbo.TitleItem ti
			ON t.TitleID = ti.TitleID
		INNER JOIN dbo.Item i
			ON ti.ItemID = i.ItemID
		INNER JOIN dbo.Institution inst
			ON t.InstitutionCode = inst.InstitutionCode
WHERE	dbo.fnContainsSuspectCharacter(tt.TagText) > 0
AND		(t.InstitutionCode = @InstitutionCode OR @InstitutionCode = '')
AND		tt.CreationDate > DATEADD(dd, (@MaxAge * -1), GETDATE())
GROUP BY
		CHAR(dbo.fnContainsSuspectCharacter(tt.TagText)), 
		tt.TitleID, 
		tt.TagText,
		t.InstitutionCode,
		inst.InstitutionName,
		tt.CreationDate,
		oclc.IdentifierValue
ORDER BY
		inst.InstitutionName, tt.CreationDate DESC
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameCountUniqueConfirmed]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameCountUniqueConfirmed]
GO


/****** Object:  StoredProcedure [dbo].[PageNameCountUniqueConfirmed]    Script Date: 10/16/2009 16:27:58 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageNameCountUniqueConfirmed]

AS 

SET NOCOUNT ON

-- Count total names
SELECT	COUNT(DISTINCT NameConfirmed)
FROM	PageName
WHERE	Active = 1
AND		NameBankID IS NOT NULL

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameCountUniqueConfirmed. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameCountUniqueConfirmedBetweenDates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameCountUniqueConfirmedBetweenDates]
GO


/****** Object:  StoredProcedure [dbo].[PageNameCountUniqueConfirmedBetweenDates]    Script Date: 10/16/2009 16:27:59 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PageNameCountUniqueConfirmedBetweenDates]

@StartDate DateTime,
@EndDate DateTime

AS 

SET NOCOUNT ON

-- Count total names
SELECT	COUNT(DISTINCT NameConfirmed)
FROM	PageName
WHERE	Active = 1
AND		(CreateDate BETWEEN @StartDate AND @EndDate OR
		LastUpdateDate BETWEEN @StartDate AND @EndDate)
AND		NameBankID IS NOT NULL

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameCountUniqueConfirmed. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameCountUpdate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameCountUpdate]
GO


/****** Object:  StoredProcedure [dbo].[PageNameCountUpdate]    Script Date: 10/16/2009 16:27:59 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageNameCountUpdate] 
AS

SELECT DISTINCT P.PageID
INTO #TmpPage
FROM Title T 
	INNER JOIN Item I ON I.PrimaryTitleID = T.TitleID
	INNER JOIN Page P ON P.ItemID = I.ItemID
WHERE T.PublishReady = 1 AND
	P.Active = 1 AND
	I.ItemStatusID = 40

DELETE FROM PageNameCount

INSERT INTO PageNameCount
( NameConfirmed, Qty, RefreshDate )
	SELECT TOP 500 NameConfirmed, 
		COUNT(*) AS Qty,
		GetDate()
	FROM PageName PN
		INNER JOIN #TmpPage TP ON TP.PageID = PN.PageID
	WHERE PN.Active = 1 AND
		PN.NameConfirmed IS NOT NULL AND
		PN.NameBankID IS NOT NULL
	GROUP BY NameConfirmed
	ORDER BY Qty DESC

DROP TABLE #TmpPage

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[PageNameDeleteAuto]    Script Date: 10/16/2009 16:27:59 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PageNameDeleteAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for PageName

CREATE PROCEDURE PageNameDeleteAuto

@PageNameID INT

AS 

DELETE FROM [dbo].[PageName]

WHERE

	[PageNameID] = @PageNameID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameDeleteForInactivePages]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameDeleteForInactivePages]
GO


/****** Object:  StoredProcedure [dbo].[PageNameDeleteForInactivePages]    Script Date: 10/16/2009 16:28:00 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE PageNameDeleteForInactivePages

AS

BEGIN

/*
 This procedure should be run on a nightly basis to assure that
 names associated with inactive items/pages do not appear in 
 search results.  

 Simply removing the names from the names table (as we do here)
 allows us to create a more efficient search query (no need to join
 to the Page and Item tables to determine if they are active).

 An alternate solution to this procedure would be to modify the
 administration site to update the name data as item and page
 statuses are edited.
 */

SET NOCOUNT ON

-- Get the inactive pages with names
SELECT DISTINCT	i.ItemID, p.PageID
INTO	#tmpPage
FROM	dbo.Item i INNER JOIN dbo.Page p
			ON i.ItemID = p.ItemID
		INNER JOIN dbo.PageName n
			ON p.PageID = n.PageID
WHERE	ItemStatusID = 5
OR		p.Active = 0

-- Delete the names
DELETE	dbo.PageName
FROM	dbo.PageName n INNER JOIN #tmpPage p
			ON n.PageID = p.PageID

-- Set the LastPageNameUpdateDates to NULL for inactive pages and items.
-- (This assures that the names will be re-retrieved from UBIO if the 
-- items/pages become active in the future.)
UPDATE	dbo.Page
SET		LastPageNameLookupDate = NULL
FROM	#tmpPage t INNER JOIN dbo.Page p
			ON t.PageID = p.PageID
WHERE	p.LastPageNameLookupDate IS NOT NULL

UPDATE	dbo.Item
SET		LastPageNameLookupDate = NULL
FROM	#tmpPage t INNER JOIN dbo.Item i
			ON t.ItemID = i.ItemID
WHERE	i.ItemStatusID = 5
AND		i.LastPageNameLookupDate IS NOT NULL

-- Clean up
DROP TABLE #tmpPage

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[PageNameInsertAuto]    Script Date: 10/16/2009 16:28:00 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PageNameInsertAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for PageName

CREATE PROCEDURE PageNameInsertAuto

@PageNameID INT OUTPUT,
@PageID INT,
@Source NVARCHAR(50) = null,
@NameFound NVARCHAR(100),
@NameConfirmed NVARCHAR(100) = null,
@NameBankID INT = null,
@Active BIT,
@IsCommonName BIT = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[PageName]
(
	[PageID],
	[Source],
	[NameFound],
	[NameConfirmed],
	[NameBankID],
	[Active],
	[CreateDate],
	[LastUpdateDate],
	[IsCommonName]
)
VALUES
(
	@PageID,
	@Source,
	@NameFound,
	@NameConfirmed,
	@NameBankID,
	@Active,
	getdate(),
	getdate(),
	@IsCommonName
)

SET @PageNameID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PageNameID],
		[PageID],
		[Source],
		[NameFound],
		[NameConfirmed],
		[NameBankID],
		[Active],
		[CreateDate],
		[LastUpdateDate],
		[IsCommonName]	

	FROM [dbo].[PageName]
	
	WHERE
		[PageNameID] = @PageNameID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameListActive]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameListActive]
GO


/****** Object:  StoredProcedure [dbo].[PageNameListActive]    Script Date: 10/16/2009 16:28:01 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageNameListActive]

@StartRow INT,
@BatchSize INT

AS 

SET NOCOUNT ON

-- Get the specified names
DECLARE @EndRow int
SET @EndRow = @StartRow + @BatchSize - 1;

WITH PageNames AS
(
SELECT	NameConfirmed, NameBankID,
		ROW_NUMBER() OVER(ORDER BY NameConfirmed, NameBankID) AS RowNumber
FROM	PageName
WHERE	Active = 1
AND		NameBankID IS NOT NULL
GROUP BY 
		NameConfirmed, NameBankID
)
SELECT	NameConfirmed, NameBankID
FROM	PageNames
WHERE	RowNumber BETWEEN @StartRow AND @EndRow

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameListActive. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameListActiveBetweenDates]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameListActiveBetweenDates]
GO


/****** Object:  StoredProcedure [dbo].[PageNameListActiveBetweenDates]    Script Date: 10/16/2009 16:28:02 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PageNameListActiveBetweenDates]

@StartRow INT,
@BatchSize INT,
@StartDate DATETIME,
@EndDate DATETIME

AS 

SET NOCOUNT ON

-- Get the specified names
DECLARE @EndRow int
SET @EndRow = @StartRow + @BatchSize - 1;

WITH PageNames AS
(
SELECT	NameConfirmed, NameBankID,
		ROW_NUMBER() OVER(ORDER BY NameConfirmed, NameBankID) AS RowNumber
FROM	PageName
WHERE	Active = 1
AND		(CreateDate BETWEEN @StartDate AND @EndDate OR
		LastUpdateDate BETWEEN @StartDate AND @EndDate)
AND		NameBankID IS NOT NULL
GROUP BY 
		NameConfirmed, NameBankID
)
SELECT	NameConfirmed, NameBankID
FROM	PageNames
WHERE	RowNumber BETWEEN @StartRow AND @EndRow

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameListActive. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSearch]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSearch]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSearch]    Script Date: 10/16/2009 16:28:02 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageNameSearch]
@NameConfirmed NVarchar(100),
@TitleID INT = 0,
@LanguageCode NVARCHAR(10) = ''
AS 

SET NOCOUNT ON

-- Get the initial data set
SELECT DISTINCT t.TitleID,
  t.MarcBibID,
  t.ShortTitle,
  t.SortTitle,
	i.ItemID,
	ti.ItemSequence,
  i.Volume AS ItemVolume,
  p.PageID,
	p.SequenceOrder--,
  --dbo.fnIndicatedPageStringForPage(p.PageID) AS IndicatedPages
INTO #tmpPageName
FROM PageName pn
	INNER JOIN Page p ON pn.pageid = p.pageid
	INNER JOIN Item i ON p.itemid = i.itemid
	INNER JOIN TitleItem ti ON i.ItemID = ti.ItemID
	INNER JOIN Title t ON ti.titleid = t.titleid
	LEFT JOIN dbo.TitleLanguage tl ON t.TitleID = tl.TitleID
	LEFT JOIN dbo.ItemLanguage il ON i.ItemID = il.ItemID
WHERE pn.NameConfirmed = @NameConfirmed
  AND NameBankID is not null
  AND p.Active = 1
  AND i.ItemStatusID = 40
AND	(t.LanguageCode = @LanguageCode OR
	i.LanguageCode = @LanguageCode OR
	ISNULL(tl.LanguageCode, '') = @LanguageCode OR
	ISNULL(il.LanguageCode, '') = @LanguageCode OR
	@LanguageCode = '')
AND ((t.TitleID = @TitleID AND @TitleID > 0) OR (t.TitleID = i.PrimaryTitleID AND @TitleID = 0))
ORDER BY t.SortTitle ASC, i.Volume, ti.ItemSequence ASC, p.SequenceOrder ASC

-- Add the indicated pages
SELECT	TitleID,
		MarcBibID,
		ShortTitle,
		SortTitle,
		ItemID,
		ItemSequence,
		ItemVolume,
		PageID,
		SequenceOrder,
		dbo.fnIndicatedPageStringForPage(PageID) AS IndicatedPages
FROM	#tmpPageName

-- Clean up
DROP TABLE #tmpPageName

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameSearch. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSearchByPageType]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSearchByPageType]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSearchByPageType]    Script Date: 10/16/2009 16:28:02 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageNameSearchByPageType]
@NameConfirmed NVarchar(100),
@PageTypeID int,
@LanguageCode NVARCHAR(10) = ''

AS 

SET NOCOUNT ON

SELECT DISTINCT t.TitleID,
  t.MarcBibID,
  t.ShortTitle,
  t.SortTitle,
	i.ItemID,
	ti.ItemSequence,
  i.Volume AS ItemVolume,
  p.PageID,
	p.SequenceOrder,
  dbo.fnIndicatedPageStringForPage(p.PageID) AS IndicatedPages
FROM PageName pn
	INNER JOIN Page p ON pn.pageid = p.pageid
	LEFT OUTER JOIN Page_PageType PT ON PT.PageID = p.PageID
	INNER JOIN Item i ON p.itemid = i.itemid
	INNER JOIN TitleItem ti ON i.ItemID = ti.ItemID AND i.PrimaryTitleID = ti.TitleID
	INNER JOIN Title t ON i.primarytitleid = t.titleid
	LEFT JOIN dbo.TitleLanguage tl ON t.TitleID = tl.TitleID
	LEFT JOIN dbo.ItemLanguage il ON i.ItemID = il.ItemID
WHERE pn.NameConfirmed = @NameConfirmed
  AND NameBankID is not null
  AND p.Active = 1
  AND i.ItemStatusID = 40
	AND PT.PageTypeID = @PageTypeID
	AND (t.LanguageCode = @LanguageCode OR
		i.LanguageCode = @LanguageCode OR
		ISNULL(tl.LanguageCode, '') = @LanguageCode OR
		ISNULL(il.LanguageCode, '') = @LanguageCode OR
		@LanguageCode = '')
ORDER BY t.SortTitle ASC, ti.ItemSequence ASC, p.SequenceOrder ASC

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameSearchByPageType. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSearchByPageTypeAndTitle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSearchByPageTypeAndTitle]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSearchByPageTypeAndTitle]    Script Date: 10/16/2009 16:28:03 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageNameSearchByPageTypeAndTitle]
@NameConfirmed NVarchar(100),
@PageTypeID int,
@TitleID int,
@LanguageCode NVARCHAR(10) = ''

AS 

SET NOCOUNT ON

SELECT DISTINCT t.TitleID,
  t.MarcBibID,
  t.ShortTitle,
  t.SortTitle,
	i.ItemID,
	ti.ItemSequence,
  i.Volume AS ItemVolume,
  p.PageID,
	p.SequenceOrder,
  dbo.fnIndicatedPageStringForPage(p.PageID) AS IndicatedPages
FROM dbo.PageName pn
	INNER JOIN dbo.Page p ON pn.pageid = p.pageid
	LEFT OUTER JOIN dbo.Page_PageType PT ON PT.PageID = p.PageID
	INNER JOIN dbo.Item i ON p.itemid = i.itemid
	INNER JOIN dbo.TitleItem ti ON i.ItemID = ti.ItemID
	INNER JOIN dbo.Title t ON ti.titleid = t.titleid
	LEFT JOIN dbo.TitleLanguage tl ON t.TitleID = tl.TitleID
	LEFT JOIN dbo.ItemLanguage il ON i.ItemID = il.ItemID
WHERE pn.NameConfirmed = @NameConfirmed
  AND NameBankID is not null
  AND p.Active = 1
  AND i.ItemStatusID = 40
  AND t.TitleID = @TitleID
	AND PT.PageTypeID = @PageTypeID
	AND (t.LanguageCode = @LanguageCode OR
		i.LanguageCode = @LanguageCode OR
		 ISNULL(tl.LanguageCode, '') = @LanguageCode OR
		 ISNULL(il.LanguageCode, '') = @LanguageCode OR
		@LanguageCode = '')
ORDER BY t.SortTitle ASC, ti.ItemSequence ASC, p.SequenceOrder ASC

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameSearchByPageTypeAndTitle. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSearchForTitles]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSearchForTitles]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSearchForTitles]    Script Date: 10/16/2009 16:28:03 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageNameSearchForTitles]
@NameConfirmed NVarchar(100),
@LanguageCode NVARCHAR(10) = ''
AS 

SET NOCOUNT ON

-- Use the indexed view (PageDetailView)
SELECT  p.TitleID,
  p.MarcBibID,
  p.ShortTitle,
  ISNULL(t.PartNumber, '') AS PartNumber,
  ISNULL(t.PartName, '') AS PartName,
  p.SortTitle,
  SUM(CONVERT(int, p.NumPages)) AS [TotalPageCount]
FROM dbo.PageDetailView p
	INNER JOIN dbo.PageName pn ON p.PageID = pn.PageID
	INNER JOIN dbo.Item i ON p.itemid = i.itemid
	INNER JOIN dbo.Title t ON p.titleid = t.titleid
	LEFT JOIN dbo.TitleLanguage tl ON p.TitleID = tl.TitleID AND tl.LanguageCode = @LanguageCode
	LEFT JOIN dbo.ItemLanguage il ON p.ItemID = il.ItemID AND il.LanguageCode = @LanguageCode
WHERE pn.NameConfirmed = @NameConfirmed
  AND pn.NameBankID is not null
  AND p.Active = 1
  AND p.ItemStatusID = 40
AND	(t.LanguageCode = @LanguageCode OR
	i.LanguageCode = @LanguageCode OR
	ISNULL(tl.LanguageCode, '') = @LanguageCode OR
	ISNULL(il.LanguageCode, '') = @LanguageCode OR
	@LanguageCode = '')
GROUP BY p.TitleID, p.MarcBibID, p.ShortTitle, ISNULL(t.PartNumber, ''), ISNULL(t.PartName, ''), p.SortTitle
ORDER BY p.SortTitle ASC

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameSearchForTitles. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSelectAuto]    Script Date: 10/16/2009 16:28:03 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PageNameSelectAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for PageName

CREATE PROCEDURE PageNameSelectAuto

@PageNameID INT

AS 

SET NOCOUNT ON

SELECT 

	[PageNameID],
	[PageID],
	[Source],
	[NameFound],
	[NameConfirmed],
	[NameBankID],
	[Active],
	[CreateDate],
	[LastUpdateDate],
	[IsCommonName]

FROM [dbo].[PageName]

WHERE
	[PageNameID] = @PageNameID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSelectByConfirmedName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSelectByConfirmedName]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSelectByConfirmedName]    Script Date: 10/16/2009 16:28:04 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageNameSelectByConfirmedName]

@NameConfirmed NVARCHAR(100),
@LanguageCode NVARCHAR(10) = ''

AS 

BEGIN

SET NOCOUNT ON

IF @LanguageCode = ''
BEGIN
	SELECT TOP 1
		[NameFound],
		[Active],
		[NameConfirmed],
		[NameBankID]
	FROM [dbo].[PageName]
	WHERE
		[Active] = 1 AND
		[NameBankID] IS NOT NULL AND
		[NameConfirmed] = LTRIM(RTRIM(@NameConfirmed)) 
	ORDER BY [NameConfirmed] ASC
END
ELSE
BEGIN
	-- For performance reasons, only do the extra joins if we have a
	-- LanguageCode to evaluate
	SELECT TOP 1
		pn.[NameFound],
		pn.[Active],
		pn.[NameConfirmed],
		pn.[NameBankID]
	FROM [dbo].[PageName] pn
		INNER JOIN dbo.Page p ON pn.PageID = p.PageID
		INNER JOIN dbo.Item i ON p.ItemID = i.ItemID
		INNER JOIN dbo.Title t ON i.PrimaryTitleID = t.TitleID
		LEFT JOIN dbo.TitleLanguage tl ON t.TitleID = tl.TitleID
		LEFT JOIN dbo.ItemLanguage il ON i.ItemID = il.ItemID
	WHERE
		pn.[Active] = 1 AND
		pn.[NameBankID] IS NOT NULL AND
		pn.[NameConfirmed] = LTRIM(RTRIM(@NameConfirmed)) AND
		(t.LanguageCode = @LanguageCode OR 
		 i.LanguageCode = @LanguageCode OR
		 ISNULL(tl.LanguageCode, '') = @LanguageCode OR
		 ISNULL(il.LanguageCode, '') = @LanguageCode)
	ORDER BY pn.[NameConfirmed] ASC
END

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSelectByItemIDAndSequence]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSelectByItemIDAndSequence]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSelectByItemIDAndSequence]    Script Date: 10/16/2009 16:28:05 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PageNameSelectByItemIDAndSequence]

@ItemID INT,
@SequenceOrder INT

AS 

SET NOCOUNT ON

SELECT 

	pn.[PageNameID],
	pn.[PageID],
	pn.[Source],
	pn.[NameFound],
	pn.[NameConfirmed],
	pn.[NameBankID],
	pn.[CreateDate],
	pn.[LastUpdateDate]

FROM [dbo].[PageName] pn
JOIN [dbo].[Page] p ON pn.PageID = p.PageID

WHERE
	p.ItemID = @ItemID
	AND p.SequenceOrder = @SequenceOrder

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameSelectByItemIDAndSequence. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSelectByNameBankID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSelectByNameBankID]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSelectByNameBankID]    Script Date: 10/16/2009 16:28:06 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageNameSelectByNameBankID]
@NameBankID int
AS 

SET NOCOUNT ON

SELECT DISTINCT 
		NameConfirmed,
		NameBankID
FROM	PageName
WHERE	NameBankID = @NameBankID
AND		Active = 1

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameSearchByNameBankID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTagSelectNewLocations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTagSelectNewLocations]
GO


/****** Object:  StoredProcedure [dbo].[TitleTagSelectNewLocations]    Script Date: 10/16/2009 16:28:06 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[TitleTagSelectNewLocations]
AS
BEGIN
	SET NOCOUNT ON;

	SELECT DISTINCT [TagText]
	FROM [dbo].[TitleTag] 
	JOIN [dbo].[Title] ON [Title].[TitleID] = [TitleTag].[TitleID]
	WHERE [MarcSubFieldCode] = 'z'
	AND [PublishReady] = 1
	AND NOT EXISTS (SELECT * FROM Location WHERE LocationName = TagText)
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSelectByPageID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSelectByPageID]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSelectByPageID]    Script Date: 10/16/2009 16:28:06 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PageNameSelectByPageID]

@PageID INT

AS 

SET NOCOUNT ON

SELECT 

	pn.[PageNameID],
	pn.[PageID],
	pn.[Source],
	pn.[NameFound],
	pn.[NameConfirmed],
	pn.[NameBankID],
	pn.[Active],
	pn.[CreateDate],
	pn.[LastUpdateDate],
	pn.[IsCommonName]

FROM [dbo].[PageName] pn
JOIN [dbo].[Page] p ON pn.PageID = p.PageID

WHERE
	p.PageID = @PageID

ORDER BY pn.[NameFound] ASC

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameSelectByPageID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END







GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSelectByPageIDAndNameFound]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSelectByPageIDAndNameFound]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSelectByPageIDAndNameFound]    Script Date: 10/16/2009 16:28:07 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO



CREATE PROCEDURE [dbo].[PageNameSelectByPageIDAndNameFound]

@PageID INT,
@NameFound NVARCHAR(100)

AS 

SET NOCOUNT ON

SELECT 

	[PageNameID],
	[PageID],
	[Source],
	[NameFound],
	[NameConfirmed],
	[NameBankID],
	[Active],
	[CreateDate],
	[LastUpdateDate]

FROM [dbo].[PageName]

WHERE
	[PageID] = @PageID AND
	[NameFound] = @NameFound

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameSelectByPageIDAndNameFound. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameSelectCountByInstitution]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameSelectCountByInstitution]
GO


/****** Object:  StoredProcedure [dbo].[PageNameSelectCountByInstitution]    Script Date: 10/16/2009 16:28:07 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageNameSelectCountByInstitution] 

@Number INT = 100,
@InstitutionCode nvarchar(10) = ''

AS
BEGIN
	SET NOCOUNT ON

	SELECT DISTINCT	t.TitleID
	INTO #tmpTitle
	FROM dbo.Title t 
		INNER JOIN dbo.Item i	ON t.TitleID = i.PrimaryTitleID
	WHERE	
		t.PublishReady = 1 AND
		(t.InstitutionCode = @InstitutionCode OR
			i.InstitutionCode = @InstitutionCode OR
			@InstitutionCode = '')

	-- Make the total number of titles for the specified institution be
	-- the first item in the result set
	SELECT 
		NULL AS [NameConfirmed], 
		COUNT(DISTINCT t.TitleID) AS [Count]
	FROM dbo.Title t 
		INNER JOIN dbo.Item i ON t.TitleID = i.PrimaryTitleID
		INNER JOIN dbo.Page P ON P.ItemID = i.ItemID
		INNER JOIN dbo.PageName PN ON PN.PageID = P.PageID
	WHERE t.PublishReady = 1
	AND (t.InstitutionCode = @InstitutionCode OR 
		i.InstitutionCode = @InstitutionCode OR 
		@InstitutionCode = '')
	UNION
	SELECT 
		NameConfirmed, 
		[Count]
	FROM 
	(
		SELECT 
			TOP (@Number) PN.NameConfirmed, 
			COUNT(*) AS [Count] 
		FROM dbo.PageName PN 
			INNER JOIN dbo.Page P ON P.PageID = PN.PageID
			INNER JOIN dbo.Item I ON I.ItemID = P.ItemID
			INNER JOIN #tmpTitle t ON I.PrimaryTitleID = t.TitleID
		GROUP BY PN.NameConfirmed
		ORDER BY [Count] DESC
	) X
	ORDER BY [Count] DESC

	DROP TABLE #tmpTitle
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaultSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[VaultSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[VaultSelectAuto]    Script Date: 10/16/2009 16:28:07 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- VaultSelectAuto PROCEDURE
-- Generated 1/24/2008 10:03:58 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for Vault

CREATE PROCEDURE VaultSelectAuto

@VaultID INT /* Unique identifier for each Vault entry. */

AS 

SET NOCOUNT ON

SELECT 

	[VaultID],
	[Server],
	[FolderShare],
	[WebVirtualDirectory],
	[OCRFolderShare]

FROM [dbo].[Vault]

WHERE
	[VaultID] = @VaultID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure VaultSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageNameUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[PageNameUpdateAuto]    Script Date: 10/16/2009 16:28:08 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PageNameUpdateAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for PageName

CREATE PROCEDURE PageNameUpdateAuto

@PageNameID INT,
@PageID INT,
@Source NVARCHAR(50),
@NameFound NVARCHAR(100),
@NameConfirmed NVARCHAR(100),
@NameBankID INT,
@Active BIT,
@IsCommonName BIT

AS 

SET NOCOUNT ON

UPDATE [dbo].[PageName]

SET

	[PageID] = @PageID,
	[Source] = @Source,
	[NameFound] = @NameFound,
	[NameConfirmed] = @NameConfirmed,
	[NameBankID] = @NameBankID,
	[Active] = @Active,
	[LastUpdateDate] = getdate(),
	[IsCommonName] = @IsCommonName

WHERE
	[PageNameID] = @PageNameID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageNameUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PageNameID],
		[PageID],
		[Source],
		[NameFound],
		[NameConfirmed],
		[NameBankID],
		[Active],
		[CreateDate],
		[LastUpdateDate],
		[IsCommonName]

	FROM [dbo].[PageName]
	
	WHERE
		[PageNameID] = @PageNameID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageResolve]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageResolve]
GO


/****** Object:  StoredProcedure [dbo].[PageResolve]    Script Date: 10/16/2009 16:28:08 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageResolve] 
	@TitleID	int,
	@Volume	nvarchar(20),
	@Issue	nvarchar(20),
	@Year	nvarchar(20),
	@StartPage	nvarchar(20)
AS

SET NOCOUNT ON

IF (@Volume = '') SELECT @Volume = NULL
IF (@Issue = '') SELECT @Issue = NULL
IF (@Year = '') SELECT @Year = NULL



create table #items
(
	ItemID int
)

declare @ItemID int, @ItemCount int
select @ItemCount = 0
--see if we can narrow it down to an item
if @Volume is not null
begin
	insert into #items 
	select distinct p.ItemID
	from Page p
	join Item i on p.ItemID = i.ItemID
	join TitleItem ti on i.ItemID = ti.ItemID
	join Title t on ti.TitleID = t.TitleID
	where t.TitleID = @TitleID and
		t.PublishReady = 1 and
		p.Volume = @Volume

	select @ItemCount = count(*) from #items
	if @ItemCount = 0
	begin
		insert into #items 
		select distinct p.ItemID
		from Page p
		join Item i on p.ItemID = i.ItemID
		join TitleItem ti on i.ItemID = ti.ItemID
		join Title t on ti.TitleID = t.TitleID
		where t.TitleID = @TitleID and
			t.PublishReady = 1 and
			(
				i.Volume like '%v. ' + @Volume + '%' or
				i.Volume like '%v.' + @Volume + '%' or
				i.Volume like '%v ' + @Volume + '%' or
				i.Volume like '%v' + @Volume + '%' or
				i.Volume like '%vol. ' + @Volume + '%' or
				i.Volume like '%vol.' + @Volume + '%' or
				i.Volume like '%vol ' + @Volume + '%' or
				i.Volume like '%vol' + @Volume + '%'
			)
		select @ItemCount = count(*) from #items
	end
end

CREATE TABLE #pages
(
	PageID INT,
	ItemID INT,
	ItemSequence INT,
	SequenceOrder INT,
	Issue nvarchar(20),
	Year nvarchar(20),
	PagePrefix nvarchar(20),
	PageNumber nvarchar(20),
	Volume nvarchar(20),
	FullTitle ntext,
	ItemVolume nvarchar(100)
)

--if a volume was provided and we have no item matches then we need to drop out because
--we have no way to determine the correct volume
if @Volume is not null and @ItemCount = 0
begin
	select * from #pages
	drop table #items
	drop table #pages
	return
end

--do our initial population of the #pages table
if @StartPage is not null and @StartPage <> ''
begin
	if @ItemCount > 0
	begin
		insert into #pages
		select p.PageID, it.ItemID, ti.ItemSequence, p.SequenceOrder, p.Issue, 
			p.Year, ip.PagePrefix, ip.PageNumber, p.Volume, t.FullTitle, i.Volume
		from #items it
		join Item i on it.ItemID = i.ItemID
		join Page p on i.ItemID = p.ItemID
		join IndicatedPage ip on p.PageID = ip.PageID
		join TitleItem ti ON i.ItemID = ti.ItemID
		join Title t on ti.TitleID = t.TitleID
		where ip.PageNumber = @StartPage and
			p.Active = 1
	end
	else
	begin
		insert into #pages
		select p.PageID, i.ItemID, ti.ItemSequence, p.SequenceOrder, p.Issue, 
			p.Year, ip.PagePrefix, ip.PageNumber, p.Volume, t.FullTitle, i.Volume
		from Item i
		join Page p on i.ItemID = p.ItemID
		join IndicatedPage ip on p.PageID = ip.PageID
		join TitleItem ti on i.ItemID = ti.ItemID
		join Title t on ti.TitleID = t.TitleID
		where t.TitleID = @TitleID and
			ip.PageNumber = @StartPage and
			p.Active = 1
	end

	--if no pages were inserted based on start page, then look for a title page
	if (select count(*) from #pages) = 0
	begin
		if @ItemCount > 0
		begin
			insert into #pages
			select p.PageID, it.ItemID, ti.ItemSequence, p.SequenceOrder, p.Issue, 
				p.Year, ip.PagePrefix, ip.PageNumber, p.Volume, t.FullTitle, i.Volume
			from #items it
			join Item i on it.ItemID = i.ItemID
			join Page p on i.ItemID = p.ItemID
			left join IndicatedPage ip on p.PageID = ip.PageID
			join Page_PageType ppt on p.PageID = ppt.PageID
			join PageType pt on ppt.PageTypeID = pt.PageTypeID
			join TitleItem ti on i.ItemID = ti.ItemID
			join Title t on ti.TitleID = t.TitleID
			where pt.PageTypeID = 1 and
				p.Active = 1
		end
		else
		begin
			insert into #pages
			select p.PageID, i.ItemID, ti.ItemSequence, p.SequenceOrder, p.Issue, 
				p.Year, ip.PagePrefix, ip.PageNumber, p.Volume, t.FullTitle, i.Volume
			from Item i
			join Page p on i.ItemID = p.ItemID
			left join IndicatedPage ip on p.PageID = ip.PageID
			join Page_PageType ppt on p.PageID = ppt.PageID
			join PageType pt on ppt.PageTypeID = pt.PageTypeID
			join TitleItem ti on i.ItemID = ti.ItemID
			join Title t on ti.TitleID = t.TitleID
			where t.TitleID = @TitleID and
				pt.PageTypeID = 1 and
				p.Active = 1
		end
	end
end
else
begin
	--if we weren't given a start page, look for title pages
	if @ItemCount > 0
	begin
		insert into #pages
		select p.PageID, it.ItemID, ti.ItemSequence, p.SequenceOrder, p.Issue, 
			p.Year, ip.PagePrefix, ip.PageNumber, p.Volume, t.FullTitle, i.Volume
		from #items it
		join Item i on it.ItemID = i.ItemID
		join Page p on i.ItemID = p.ItemID
		left join IndicatedPage ip on p.PageID = ip.PageID
		join Page_PageType ppt on p.PageID = ppt.PageID
		join PageType pt on ppt.PageTypeID = pt.PageTypeID
		join TitleItem ti on i.ItemID = ti.ItemID
		join Title t on ti.TitleID = t.TitleID
		where pt.PageTypeID = 1 and
			p.Active = 1
	end
	else
	begin
		insert into #pages
		select p.PageID, i.ItemID, ti.ItemSequence, p.SequenceOrder, p.Issue, 
			p.Year, ip.PagePrefix, ip.PageNumber, p.Volume, t.FullTitle, i.Volume
		from Item i
		join Page p on i.ItemID = p.ItemID
		left join IndicatedPage ip on p.PageID = ip.PageID
		join Page_PageType ppt on p.PageID = ppt.PageID
		join PageType pt on ppt.PageTypeID = pt.PageTypeID
		join TitleItem ti on i.ItemID = ti.ItemID
		join Title t on ti.TitleID = t.TitleID
		where t.TitleID = @TitleID and
			pt.PageTypeID = 1 and
			p.Active = 1
	end
end

if (select count(*) from #pages) = 0 and (select count(*) from #items) > 0
begin
	insert into #pages
	select null, it.ItemID, null, null, null, null, null, null, null, t.FullTitle, i.Volume
	from #items it
	join Title t on t.TitleID = @TitleID
	join Item i on it.ItemID = i.ItemID
end
--if we got an issue, drop any rows from our #pages table that don't match
if @Issue is not null
begin
	delete from #pages where Issue <> @Issue
end

--if we got a year, drop any rows from our #pages table that don't match
if @Year is not null
begin
	--if deleting based on year would wipe out all of our results, then don't filter on year
	if (select count(*) from #pages where Year = @Year) > 0
		delete from #pages where Year <> @Year
end

select * from #pages


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[PageSelectAuto]    Script Date: 10/16/2009 16:28:09 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PageSelectAuto PROCEDURE
-- Generated 2/26/2008 2:23:06 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for Page

CREATE PROCEDURE PageSelectAuto

@PageID INT

AS 

SET NOCOUNT ON

SELECT 

	[PageID],
	[ItemID],
	[FileNamePrefix],
	[SequenceOrder],
	[PageDescription],
	[Illustration],
	[Note],
	[FileSize_Temp],
	[FileExtension],
	[Active],
	[Year],
	[Series],
	[Volume],
	[Issue],
	[ExternalURL],
	[AltExternalURL],
	[IssuePrefix],
	[LastPageNameLookupDate],
	[PaginationUserID],
	[PaginationDate],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID]

FROM [dbo].[Page]

WHERE
	[PageID] = @PageID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_CreatorUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_CreatorUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[Title_CreatorUpdateAuto]    Script Date: 10/16/2009 16:28:10 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Title_CreatorUpdateAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for Title_Creator

CREATE PROCEDURE Title_CreatorUpdateAuto

@Title_CreatorID INT,
@TitleID INT /* Unique identifier for each Title record. */,
@CreatorID INT /* Unique identifier for each Creator record. */,
@CreatorRoleTypeID INT /* Unique identifier for each Creator Role Type. */,
@LastModifiedUserID INT

AS 

SET NOCOUNT ON

UPDATE [dbo].[Title_Creator]

SET

	[TitleID] = @TitleID,
	[CreatorID] = @CreatorID,
	[CreatorRoleTypeID] = @CreatorRoleTypeID,
	[LastModifiedDate] = getdate(),
	[LastModifiedUserID] = @LastModifiedUserID

WHERE
	[Title_CreatorID] = @Title_CreatorID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_CreatorUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[Title_CreatorID],
		[TitleID],
		[CreatorID],
		[CreatorRoleTypeID],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID]

	FROM [dbo].[Title_Creator]
	
	WHERE
		[Title_CreatorID] = @Title_CreatorID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSelectByItemAndSequence]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSelectByItemAndSequence]
GO


/****** Object:  StoredProcedure [dbo].[PageSelectByItemAndSequence]    Script Date: 10/16/2009 16:28:10 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSelectByItemAndSequence]

@ItemID INT,
@SequenceOrder INT

AS 

SET NOCOUNT ON

SELECT 

	[PageID],
	[ItemID],
	[FileNamePrefix],
	[SequenceOrder],
	[PageDescription],
	[Illustration],
	[Note],
	[FileSize_Temp],
	[FileExtension],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID],
	[Active],
	[Year],
	[Series],
	[Volume],
	[Issue],
	[ExternalURL],
	[AltExternalURL],
	[IssuePrefix],
	[LastPageNameLookupDate]

FROM [dbo].[Page]

WHERE
	[ItemID] = @ItemID AND
	[SequenceOrder] = @SequenceOrder

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSelectByItemAndSequence. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSelectByItemID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSelectByItemID]
GO


/****** Object:  StoredProcedure [dbo].[PageSelectByItemID]    Script Date: 10/16/2009 16:28:11 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSelectByItemID]

@ItemID INT

AS 

SET NOCOUNT ON

SELECT 
	[PageID],
	[ItemID],
	[FileNamePrefix],
	[SequenceOrder],
	[PageDescription],
	[Illustration],
	[Note],
	[FileSize_Temp],
	[FileExtension],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID],
	[Active],
	[Year],
	[Series],
	[Volume],
	[Issue],
	[ExternalURL],
	[AltExternalURL],
	[IssuePrefix],
	[LastPageNameLookupDate],
	[PaginationUserID],
	[PaginationDate]
FROM [dbo].[Page]
WHERE
	[ItemID] = @ItemID
ORDER BY
	[SequenceOrder] ASC

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSelectByItemID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END




GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifierSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_TitleIdentifierSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[Title_TitleIdentifierSelectAuto]    Script Date: 10/16/2009 16:28:11 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Title_TitleIdentifierSelectAuto PROCEDURE
-- Generated 7/30/2008 3:15:22 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for Title_TitleIdentifier

CREATE PROCEDURE Title_TitleIdentifierSelectAuto

@Title_TitleIdentifierID INT

AS 

SET NOCOUNT ON

SELECT 

	[Title_TitleIdentifierID],
	[TitleID],
	[TitleIdentifierID],
	[IdentifierValue],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[Title_TitleIdentifier]

WHERE
	[Title_TitleIdentifierID] = @Title_TitleIdentifierID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_TitleIdentifierSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSelectCountByItemID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSelectCountByItemID]
GO


/****** Object:  StoredProcedure [dbo].[PageSelectCountByItemID]    Script Date: 10/16/2009 16:28:11 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSelectCountByItemID]

@ItemID INT

AS 

SET NOCOUNT ON

SELECT COUNT(*)
FROM [dbo].[Page]
WHERE
	[ItemID] = @ItemID
AND	[Active] = 1

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSelectCountByItemID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSelectFileNameByItemID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSelectFileNameByItemID]
GO


/****** Object:  StoredProcedure [dbo].[PageSelectFileNameByItemID]    Script Date: 10/16/2009 16:28:12 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSelectFileNameByItemID]

@ItemID INT

AS 

SET NOCOUNT ON

SELECT 
	[PageID],
	[FileNamePrefix]
FROM [dbo].[Page]
WHERE
	[ItemID] = @ItemID
ORDER BY
	[SequenceOrder] ASC

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSelectByItemID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSelectWithExpiredPageNamesByItemID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSelectWithExpiredPageNamesByItemID]
GO


/****** Object:  StoredProcedure [dbo].[PageSelectWithExpiredPageNamesByItemID]    Script Date: 10/16/2009 16:28:12 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSelectWithExpiredPageNamesByItemID]

@ItemID INT,
@MaxAge INT  -- Maximum allowed age of pages (in days)

AS 

SET NOCOUNT ON

SELECT 
	[PageID],
	[FileNamePrefix]
FROM [dbo].[Page]
WHERE
	[ItemID] = @ItemID
AND	[Active] = 1
AND	DATEDIFF(day, [LastPageNameLookupDate], GETDATE()) > @MaxAge
ORDER BY
	[SequenceOrder] ASC

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSelectWithExpiredPageNamesByItemID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSelectWithoutPageNames]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSelectWithoutPageNames]
GO


/****** Object:  StoredProcedure [dbo].[PageSelectWithoutPageNames]    Script Date: 10/16/2009 16:28:13 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSelectWithoutPageNames]

AS 

-- Select pages with NULL [LastPageNameLookupDate] values that are related
-- to items with NON-NULL [LastPageNameLookupDate] values.  The data set
-- returned will include individual pages added to items after the initial
-- page processing was completed for the items.

SET NOCOUNT ON

SELECT 
	p.[PageID],
	p.[FileNamePrefix]
FROM [dbo].[Page] p -- WITH (INDEX(IX_Page_LastPageNameLookupDate)) 
	INNER JOIN [dbo].[Item] i
		ON p.[ItemID] = i.[ItemID]
WHERE p.[LastPageNameLookupDate] IS NULL
AND	i.[LastPageNameLookupDate] IS NOT NULL
AND	p.Active = 1
AND	i.ItemStatusID = 40
ORDER BY
	p.ItemID ASC,
	p.[SequenceOrder] ASC

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSelectWithoutPageNames. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifierSelectByTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_TitleIdentifierSelectByTitleID]
GO


/****** Object:  StoredProcedure [dbo].[Title_TitleIdentifierSelectByTitleID]    Script Date: 10/16/2009 16:28:13 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Title_TitleIdentifierSelectByTitleID]
@TitleID INT
AS 

SET NOCOUNT ON

SELECT 
	tti.Title_TitleIdentifierID,
	tti.TitleID,
	tti.TitleIdentifierID,
	ti.[IdentifierName],
	ti.[MarcDataFieldTag],
	ti.[MarcSubFieldCode],
	tti.[IdentifierValue]
FROM [dbo].[Title_TitleIdentifier] tti INNER JOIN [dbo].[TitleIdentifier] ti
		ON tti.TitleIdentifierID = ti.TitleIdentifierID
WHERE tti.TitleID = @TitleID
ORDER BY ti.IdentifierName, tti.IdentifierValue

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_TitleIdentifierSelectByTitleID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleUpdateAuto]    Script Date: 10/16/2009 16:28:14 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleUpdateAuto PROCEDURE
-- Generated 5/19/2009 11:15:05 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for Title

CREATE PROCEDURE TitleUpdateAuto

@TitleID INT,
@MARCBibID NVARCHAR(50),
@MARCLeader NVARCHAR(24),
@TropicosTitleID INT,
@RedirectTitleID INT,
@FullTitle NVARCHAR(2000),
@ShortTitle NVARCHAR(255),
@UniformTitle NVARCHAR(255),
@SortTitle NVARCHAR(60),
@PartNumber NVARCHAR(255),
@PartName NVARCHAR(255),
@CallNumber NVARCHAR(100),
@PublicationDetails NVARCHAR(255),
@StartYear SMALLINT,
@EndYear SMALLINT,
@Datafield_260_a NVARCHAR(150),
@Datafield_260_b NVARCHAR(255),
@Datafield_260_c NVARCHAR(100),
@InstitutionCode NVARCHAR(10),
@LanguageCode NVARCHAR(10),
@TitleDescription NTEXT,
@TL2Author NVARCHAR(100),
@PublishReady BIT,
@RareBooks BIT,
@Note NVARCHAR(255),
@LastModifiedUserID INT,
@OriginalCatalogingSource NVARCHAR(100),
@EditionStatement NVARCHAR(450),
@CurrentPublicationFrequency NVARCHAR(100)

AS 

SET NOCOUNT ON

UPDATE [dbo].[Title]

SET

	[MARCBibID] = @MARCBibID,
	[MARCLeader] = @MARCLeader,
	[TropicosTitleID] = @TropicosTitleID,
	[RedirectTitleID] = @RedirectTitleID,
	[FullTitle] = @FullTitle,
	[ShortTitle] = @ShortTitle,
	[UniformTitle] = @UniformTitle,
	[SortTitle] = @SortTitle,
	[PartNumber] = @PartNumber,
	[PartName] = @PartName,
	[CallNumber] = @CallNumber,
	[PublicationDetails] = @PublicationDetails,
	[StartYear] = @StartYear,
	[EndYear] = @EndYear,
	[Datafield_260_a] = @Datafield_260_a,
	[Datafield_260_b] = @Datafield_260_b,
	[Datafield_260_c] = @Datafield_260_c,
	[InstitutionCode] = @InstitutionCode,
	[LanguageCode] = @LanguageCode,
	[TitleDescription] = @TitleDescription,
	[TL2Author] = @TL2Author,
	[PublishReady] = @PublishReady,
	[RareBooks] = @RareBooks,
	[Note] = @Note,
	[LastModifiedDate] = getdate(),
	[LastModifiedUserID] = @LastModifiedUserID,
	[OriginalCatalogingSource] = @OriginalCatalogingSource,
	[EditionStatement] = @EditionStatement,
	[CurrentPublicationFrequency] = @CurrentPublicationFrequency

WHERE
	[TitleID] = @TitleID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleID],
		[MARCBibID],
		[MARCLeader],
		[TropicosTitleID],
		[RedirectTitleID],
		[FullTitle],
		[ShortTitle],
		[UniformTitle],
		[SortTitle],
		[PartNumber],
		[PartName],
		[CallNumber],
		[PublicationDetails],
		[StartYear],
		[EndYear],
		[Datafield_260_a],
		[Datafield_260_b],
		[Datafield_260_c],
		[InstitutionCode],
		[LanguageCode],
		[TitleDescription],
		[TL2Author],
		[PublishReady],
		[RareBooks],
		[Note],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID],
		[OriginalCatalogingSource],
		[EditionStatement],
		[CurrentPublicationFrequency]

	FROM [dbo].[Title]
	
	WHERE
		[TitleID] = @TitleID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTagSelectCountByInstitution]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTagSelectCountByInstitution]
GO


/****** Object:  StoredProcedure [dbo].[TitleTagSelectCountByInstitution]    Script Date: 10/16/2009 16:28:14 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleTagSelectCountByInstitution] 

@Number INT = 100,
@InstitutionCode nvarchar(10) = '',
@LanguageCode nvarchar(10) = ''

AS
BEGIN
	SET NOCOUNT ON

	SELECT DISTINCT	t.TitleID
	INTO #tmpTitle
	FROM dbo.Title t INNER JOIN dbo.Item i 
			ON t.TitleID = i.PrimaryTitleID
		LEFT JOIN dbo.TitleLanguage tl
			ON t.TitleID = tl.TitleID
		LEFT JOIN dbo.ItemLanguage il
			ON i.ItemID = il.ItemID
	WHERE	
		t.PublishReady = 1 AND
		(t.InstitutionCode = @InstitutionCode OR
			i.InstitutionCode = @InstitutionCode OR
			@InstitutionCode = '') AND
		(t.LanguageCode = @LanguageCode OR
			i.LanguageCode = @LanguageCode OR
			ISNULL(tl.LanguageCode, '') = @LanguageCode OR
			ISNULL(il.LanguageCode, '') = @LanguageCode OR
			@LanguageCode = '')

	-- Make the total number of titles for the specified institution and language be
	-- the first item in the result set
	SELECT
		NULL AS [TagText],
		COUNT(TitleID) AS [Count]
	FROM #tmpTitle
	UNION
	SELECT 
		TagText, 
		[Count] * 2
	FROM 
	(
		SELECT	TOP(@Number) v.TagText,
				COUNT(*) AS [Count]
		FROM	(SELECT DISTINCT PrimaryTitleID, TagText 
				 FROM dbo.PrimaryTitleTagView) v INNER JOIN #tmpTitle t
					ON v.PrimaryTitleID = t.TitleID
		GROUP BY v.TagText
		ORDER BY [Count] DESC, v.TagText
	) X
	ORDER BY TagText

	DROP TABLE #tmpTitle
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSummarySelectByItemAndSequence]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSummarySelectByItemAndSequence]
GO


/****** Object:  StoredProcedure [dbo].[PageSummarySelectByItemAndSequence]    Script Date: 10/16/2009 16:28:15 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSummarySelectByItemAndSequence]
@ItemID	int,
@Sequence int
AS 

SET NOCOUNT ON

	SELECT MARCBibID, TitleID, FullTitle, RareBooks, ItemStatusID, ItemID, BarCode, 
		PageID, FileNamePrefix, PageDescription, SequenceOrder, 
		Illustration, PDFSize, ShortTitle, Volume, WebVirtualDirectory,
		OCRFolderShare, ExternalURL, AltExternalURL, DownloadUrl, FileRootFolder
	FROM PageSummaryView
	WHERE ItemID = @ItemID AND SequenceOrder = @Sequence

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSummarySelectByItemAndSequence. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSummarySelectByItemID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSummarySelectByItemID]
GO


/****** Object:  StoredProcedure [dbo].[PageSummarySelectByItemID]    Script Date: 10/16/2009 16:28:15 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSummarySelectByItemID]
@ItemID int
AS 

SET NOCOUNT ON

	SELECT MARCBibID, TitleID, FullTitle, PartNumber, PartName, RareBooks, 
		ItemStatusID, ItemID, BarCode, 
		PageID, FileNamePrefix, PageDescription, SequenceOrder, 
		Illustration, PDFSize, ShortTitle, Volume, WebVirtualDirectory,
		OCRFolderShare, ExternalURL, AltExternalURL, DownloadUrl, FileRootFolder
	FROM PageSummaryView
	WHERE ItemID = @ItemID AND SequenceOrder=1 AND Active=1
	ORDER BY SortTitle

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSummarySelectByItemID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSummarySelectByPageId]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSummarySelectByPageId]
GO


/****** Object:  StoredProcedure [dbo].[PageSummarySelectByPageId]    Script Date: 10/16/2009 16:28:15 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSummarySelectByPageId]
@PageId	int
AS 

SET NOCOUNT ON

SELECT MARCBibID, TitleID, FullTitle, PartNumber, PartName, RareBooks, ItemStatusID, 
	ItemID, BarCode, v.PageID, FileNamePrefix, PageDescription, 
	CONVERT(int, x.SequenceOrder) AS SequenceOrder, 
	Illustration, PDFSize, ShortTitle, Volume, WebVirtualDirectory,
	OCRFolderShare, ExternalURL, AltExternalURL, DownloadUrl, ImageServerUrlFormat,
	FileRootFolder
FROM PageSummaryView v INNER JOIN (
				-- Computing alternate sequence order which is ensured to be exactly sequential (no gaps)
				SELECT	PageID, 
						ROW_NUMBER() OVER (PARTITION BY ItemID ORDER BY SequenceOrder) AS SequenceOrder
				FROM	Page
				WHERE	ItemID IN (SELECT ItemID FROM Page WHERE PageID = @PageID)
				AND		Active = 1
				) x
		ON v.PageID = x.PageID
WHERE v.PageId = @PageId

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSummarySelectByPageId. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleTypeDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_TitleTypeDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[Title_TitleTypeDeleteAuto]    Script Date: 10/16/2009 16:28:16 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Title_TitleTypeDeleteAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Title_TitleType

CREATE PROCEDURE Title_TitleTypeDeleteAuto

@Title_TitleTypeID INT

AS 

DELETE FROM [dbo].[Title_TitleType]

WHERE

	[Title_TitleTypeID] = @Title_TitleTypeID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_TitleTypeDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSummarySelectByPrefixes]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSummarySelectByPrefixes]
GO


/****** Object:  StoredProcedure [dbo].[PageSummarySelectByPrefixes]    Script Date: 10/16/2009 16:28:16 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSummarySelectByPrefixes]
@Prefixes	varchar(max)
AS 

SET NOCOUNT ON

	SELECT MARCBibID, TitleID, FullTitle, RareBooks, ItemStatusID, ItemID, BarCode, 
		PageID, FileNamePrefix, PageDescription, SequenceOrder, 
		Illustration, PDFSize, ShortTitle, Volume, WebVirtualDirectory,
		OCRFolderShare, ExternalURL, AltExternalURL, DownloadUrl, FileRootFolder
	FROM PageSummaryView
	WHERE FileNamePrefix IN (select [Value] from dbo.fn_Split(@Prefixes,','))

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageSummarySelectByPrefixes. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSummarySelectFoldersForTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSummarySelectFoldersForTitleID]
GO


/****** Object:  StoredProcedure [dbo].[PageSummarySelectFoldersForTitleID]    Script Date: 10/16/2009 16:28:17 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSummarySelectFoldersForTitleID]

@TitleID int

AS 
BEGIN

SET NOCOUNT ON

SELECT DISTINCT 
		OCRFolderShare, 
		FileRootFolder 
FROM	PageSummaryView 
WHERE	TitleID = @TitleID

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageSummarySelectForViewerByItemID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageSummarySelectForViewerByItemID]
GO


/****** Object:  StoredProcedure [dbo].[PageSummarySelectForViewerByItemID]    Script Date: 10/16/2009 16:28:17 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageSummarySelectForViewerByItemID]

@ItemID int

AS 

BEGIN

SELECT	ISNULL(REPLACE(RIGHT(AltExternalUrl, 9), '.jp2', '.jpg'), '') AS AltExternalURL,
        CASE WHEN AltExternalUrl IS NULL THEN WebVirtualDirectory ELSE '' END AS WebVirtualDirectory,
        CASE WHEN AltExternalUrl IS NULL THEN FileRootFolder ELSE '' END AS FileRootFolder,
        BarCode,
        CASE WHEN AltExternalUrl IS NULL THEN FileNamePrefix ELSE '' END AS FileNamePrefix,
        RareBooks,
        Illustration
FROM	dbo.PageSummaryView
WHERE	ItemID = @ItemID
AND		Active = 1
ORDER BY
        SequenceOrder

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleTypeSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_TitleTypeSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[Title_TitleTypeSelectAuto]    Script Date: 10/16/2009 16:28:18 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Title_TitleTypeSelectAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for Title_TitleType

CREATE PROCEDURE Title_TitleTypeSelectAuto

@Title_TitleTypeID INT

AS 

SET NOCOUNT ON

SELECT 

	[Title_TitleTypeID],
	[TitleID],
	[TitleTypeID]

FROM [dbo].[Title_TitleType]

WHERE
	[Title_TitleTypeID] = @Title_TitleTypeID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_TitleTypeSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageTitleSummarySelectByBibID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageTitleSummarySelectByBibID]
GO


/****** Object:  StoredProcedure [dbo].[PageTitleSummarySelectByBibID]    Script Date: 10/16/2009 16:28:18 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageTitleSummarySelectByBibID]
@BibID	nvarchar(50)
AS 

SET NOCOUNT ON

	SELECT TOP 1 MARCBibID, TitleID, FullTitle,  PartNumber, PartName, RareBooks, 
		ItemStatusID, ItemID, BarCode, PageID, FileNamePrefix, PageDescription, SequenceOrder, 
		Illustration, PDFSize, ShortTitle, Volume, WebVirtualDirectory,
		OCRFolderShare, ExternalURL, AltExternalURL, DownloadUrl, FileRootFolder
	FROM PageTitleSummaryView
	WHERE MARCBibID = @BibID AND SequenceOrder=1 AND Active=1 AND ItemStatusID=40
	ORDER BY ItemSequence

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageTitleSummarySelectByBibID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageTitleSummarySelectByTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageTitleSummarySelectByTitleID]
GO


/****** Object:  StoredProcedure [dbo].[PageTitleSummarySelectByTitleID]    Script Date: 10/16/2009 16:28:18 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageTitleSummarySelectByTitleID]
@TitleID int
AS 

SET NOCOUNT ON

	SELECT TOP 1 MARCBibID, TitleID, FullTitle, PartNumber, PartName, RareBooks, 
		ItemStatusID, ItemID, BarCode, PageID, FileNamePrefix, PageDescription, SequenceOrder, 
		Illustration, PDFSize, ShortTitle, Volume, WebVirtualDirectory,
		OCRFolderShare, ExternalURL, AltExternalURL, DownloadUrl, FileRootFolder
	FROM PageTitleSummaryView
	WHERE TitleID= @TitleID AND SequenceOrder=1 AND Active=1 AND ItemStatusID=40
	ORDER BY ItemSequence

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure [PageTitleSummarySelectByTitleID]. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleTypeUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_TitleTypeUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[Title_TitleTypeUpdateAuto]    Script Date: 10/16/2009 16:28:19 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Title_TitleTypeUpdateAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for Title_TitleType

CREATE PROCEDURE Title_TitleTypeUpdateAuto

@Title_TitleTypeID INT,
@TitleID INT /* Unique identifier for each Title record. */,
@TitleTypeID INT /* Unique identifier for each Title Type record. */

AS 

SET NOCOUNT ON

UPDATE [dbo].[Title_TitleType]

SET

	[TitleID] = @TitleID,
	[TitleTypeID] = @TitleTypeID

WHERE
	[Title_TitleTypeID] = @Title_TitleTypeID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_TitleTypeUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[Title_TitleTypeID],
		[TitleID],
		[TitleTypeID]

	FROM [dbo].[Title_TitleType]
	
	WHERE
		[Title_TitleTypeID] = @Title_TitleTypeID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTagSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTagSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleTagSelectAuto]    Script Date: 10/16/2009 16:28:19 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleTagSelectAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for TitleTag

CREATE PROCEDURE TitleTagSelectAuto

@TitleID INT,
@TagText NVARCHAR(50)

AS 

SET NOCOUNT ON

SELECT 

	[TitleID],
	[TagText],
	[MarcDataFieldTag],
	[MarcSubFieldCode],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[TitleTag]

WHERE
	[TitleID] = @TitleID AND
	[TagText] = @TagText

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleTagSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageTypeDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageTypeDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[PageTypeDeleteAuto]    Script Date: 10/16/2009 16:28:20 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PageTypeDeleteAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for PageType

CREATE PROCEDURE PageTypeDeleteAuto

@PageTypeID INT /* Unique identifier for each Page Type record. */

AS 

DELETE FROM [dbo].[PageType]

WHERE

	[PageTypeID] = @PageTypeID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageTypeDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageTypeInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageTypeInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[PageTypeInsertAuto]    Script Date: 10/16/2009 16:28:20 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PageTypeInsertAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for PageType

CREATE PROCEDURE PageTypeInsertAuto

@PageTypeID INT OUTPUT /* Unique identifier for each Page Type record. */,
@PageTypeName NVARCHAR(30) /* Name of a Page Type. */,
@PageTypeDescription NVARCHAR(255) = null /* Description of the Page Type. */

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[PageType]
(
	[PageTypeName],
	[PageTypeDescription]
)
VALUES
(
	@PageTypeName,
	@PageTypeDescription
)

SET @PageTypeID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageTypeInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PageTypeID],
		[PageTypeName],
		[PageTypeDescription]	

	FROM [dbo].[PageType]
	
	WHERE
		[PageTypeID] = @PageTypeID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageTypeSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageTypeSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[PageTypeSelectAll]    Script Date: 10/16/2009 16:28:20 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO


CREATE PROCEDURE [dbo].[PageTypeSelectAll]
AS 

SET NOCOUNT ON

SELECT 
	[PageTypeID],
	[PageTypeName],
	[PageTypeDescription]
FROM [dbo].[PageType]
ORDER BY PageTypeName

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageTypeSelectAll. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageTypeSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageTypeSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[PageTypeSelectAuto]    Script Date: 10/16/2009 16:28:21 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PageTypeSelectAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for PageType

CREATE PROCEDURE PageTypeSelectAuto

@PageTypeID INT /* Unique identifier for each Page Type record. */

AS 

SET NOCOUNT ON

SELECT 

	[PageTypeID],
	[PageTypeName],
	[PageTypeDescription]

FROM [dbo].[PageType]

WHERE
	[PageTypeID] = @PageTypeID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageTypeSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageTypeUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageTypeUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[PageTypeUpdateAuto]    Script Date: 10/16/2009 16:28:21 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PageTypeUpdateAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for PageType

CREATE PROCEDURE PageTypeUpdateAuto

@PageTypeID INT /* Unique identifier for each Page Type record. */,
@PageTypeName NVARCHAR(30) /* Name of a Page Type. */,
@PageTypeDescription NVARCHAR(255) /* Description of the Page Type. */

AS 

SET NOCOUNT ON

UPDATE [dbo].[PageType]

SET

	[PageTypeName] = @PageTypeName,
	[PageTypeDescription] = @PageTypeDescription

WHERE
	[PageTypeID] = @PageTypeID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageTypeUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PageTypeID],
		[PageTypeName],
		[PageTypeDescription]

	FROM [dbo].[PageType]
	
	WHERE
		[PageTypeID] = @PageTypeID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[PageUpdateAuto]    Script Date: 10/16/2009 16:28:21 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PageUpdateAuto PROCEDURE
-- Generated 2/26/2008 2:23:06 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for Page

CREATE PROCEDURE PageUpdateAuto

@PageID INT,
@ItemID INT,
@FileNamePrefix NVARCHAR(50),
@SequenceOrder INT,
@PageDescription NVARCHAR(255),
@Illustration BIT,
@Note NVARCHAR(255),
@FileSize_Temp INT,
@FileExtension NVARCHAR(5),
@Active BIT,
@Year NVARCHAR(20),
@Series NVARCHAR(20),
@Volume NVARCHAR(20),
@Issue NVARCHAR(20),
@ExternalURL NVARCHAR(500),
@AltExternalURL NVARCHAR(500),
@IssuePrefix NVARCHAR(20),
@LastPageNameLookupDate DATETIME,
@PaginationUserID INT,
@PaginationDate DATETIME,
@LastModifiedUserID INT

AS 

SET NOCOUNT ON

UPDATE [dbo].[Page]

SET

	[ItemID] = @ItemID,
	[FileNamePrefix] = @FileNamePrefix,
	[SequenceOrder] = @SequenceOrder,
	[PageDescription] = @PageDescription,
	[Illustration] = @Illustration,
	[Note] = @Note,
	[FileSize_Temp] = @FileSize_Temp,
	[FileExtension] = @FileExtension,
	[Active] = @Active,
	[Year] = @Year,
	[Series] = @Series,
	[Volume] = @Volume,
	[Issue] = @Issue,
	[ExternalURL] = @ExternalURL,
	[AltExternalURL] = @AltExternalURL,
	[IssuePrefix] = @IssuePrefix,
	[LastPageNameLookupDate] = @LastPageNameLookupDate,
	[PaginationUserID] = @PaginationUserID,
	[PaginationDate] = @PaginationDate,
	[LastModifiedDate] = getdate(),
	[LastModifiedUserID] = @LastModifiedUserID

WHERE
	[PageID] = @PageID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PageID],
		[ItemID],
		[FileNamePrefix],
		[SequenceOrder],
		[PageDescription],
		[Illustration],
		[Note],
		[FileSize_Temp],
		[FileExtension],
		[Active],
		[Year],
		[Series],
		[Volume],
		[Issue],
		[ExternalURL],
		[AltExternalURL],
		[IssuePrefix],
		[LastPageNameLookupDate],
		[PaginationUserID],
		[PaginationDate],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID]

	FROM [dbo].[Page]
	
	WHERE
		[PageID] = @PageID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageUpdateLastPageNameLookupDate]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PageUpdateLastPageNameLookupDate]
GO


/****** Object:  StoredProcedure [dbo].[PageUpdateLastPageNameLookupDate]    Script Date: 10/16/2009 16:28:22 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PageUpdateLastPageNameLookupDate]

@PageID INT

AS 

SET NOCOUNT ON

UPDATE [dbo].[Page]

SET
	[LastPageNameLookupDate] = GETDATE(),
	[LastModifiedDate] = GETDATE()

WHERE
	[PageID] = @PageID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PageUpdateLastPageNameLookupDate. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PageID],
		[ItemID],
		[SequenceOrder],
		[Active]

	FROM [dbo].[Page]
	
	WHERE
		[PageID] = @PageID
	
	RETURN -- update successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTagDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTagDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleTagDeleteAuto]    Script Date: 10/16/2009 16:28:22 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleTagDeleteAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for TitleTag

CREATE PROCEDURE TitleTagDeleteAuto

@TitleID INT,
@TagText NVARCHAR(50)

AS 

DELETE FROM [dbo].[TitleTag]

WHERE

	[TitleID] = @TitleID AND
	[TagText] = @TagText

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleTagDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociation_TitleIdentifierInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociation_TitleIdentifierInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociation_TitleIdentifierInsertAuto]    Script Date: 10/16/2009 16:28:22 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleAssociation_TitleIdentifierInsertAuto PROCEDURE
-- Generated 7/30/2008 3:15:22 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for TitleAssociation_TitleIdentifier

CREATE PROCEDURE TitleAssociation_TitleIdentifierInsertAuto

@TitleAssociation_TitleIdentifierID INT OUTPUT,
@TitleAssociationID INT,
@TitleIdentifierID INT,
@IdentifierValue VARCHAR(125)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[TitleAssociation_TitleIdentifier]
(
	[TitleAssociationID],
	[TitleIdentifierID],
	[IdentifierValue],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@TitleAssociationID,
	@TitleIdentifierID,
	@IdentifierValue,
	getdate(),
	getdate()
)

SET @TitleAssociation_TitleIdentifierID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociation_TitleIdentifierInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleAssociation_TitleIdentifierID],
		[TitleAssociationID],
		[TitleIdentifierID],
		[IdentifierValue],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[TitleAssociation_TitleIdentifier]
	
	WHERE
		[TitleAssociation_TitleIdentifierID] = @TitleAssociation_TitleIdentifierID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaginationStatusInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PaginationStatusInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[PaginationStatusInsertAuto]    Script Date: 10/16/2009 16:28:23 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PaginationStatusInsertAuto PROCEDURE
-- Generated 6/28/2007 2:15:43 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for PaginationStatus

CREATE PROCEDURE [dbo].[PaginationStatusInsertAuto]

@PaginationStatusID INT,
@PaginationStatusName NVARCHAR(50)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[PaginationStatus]
(
	[PaginationStatusID],
	[PaginationStatusName]
)
VALUES
(
	@PaginationStatusID,
	@PaginationStatusName
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PaginationStatusInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PaginationStatusID],
		[PaginationStatusName]	

	FROM [dbo].[PaginationStatus]
	
	WHERE
		[PaginationStatusID] = @PaginationStatusID
	
	RETURN -- insert successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaginationStatusSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PaginationStatusSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[PaginationStatusSelectAll]    Script Date: 10/16/2009 16:28:23 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[PaginationStatusSelectAll]

AS 

SET NOCOUNT ON

SELECT 

	[PaginationStatusID],
	[PaginationStatusName]

FROM [dbo].[PaginationStatus]


IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PaginationStatusSelectAll. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaginationStatusSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PaginationStatusSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[PaginationStatusSelectAuto]    Script Date: 10/16/2009 16:28:23 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PaginationStatusSelectAuto PROCEDURE
-- Generated 6/28/2007 2:15:43 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for PaginationStatus

CREATE PROCEDURE [dbo].[PaginationStatusSelectAuto]

@PaginationStatusID INT

AS 

SET NOCOUNT ON

SELECT 

	[PaginationStatusID],
	[PaginationStatusName]

FROM [dbo].[PaginationStatus]

WHERE
	[PaginationStatusID] = @PaginationStatusID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PaginationStatusSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociation_TitleIdentifierDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociation_TitleIdentifierDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociation_TitleIdentifierDeleteAuto]    Script Date: 10/16/2009 16:28:24 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleAssociation_TitleIdentifierDeleteAuto PROCEDURE
-- Generated 7/30/2008 3:15:22 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for TitleAssociation_TitleIdentifier

CREATE PROCEDURE TitleAssociation_TitleIdentifierDeleteAuto

@TitleAssociation_TitleIdentifierID INT

AS 

DELETE FROM [dbo].[TitleAssociation_TitleIdentifier]

WHERE

	[TitleAssociation_TitleIdentifierID] = @TitleAssociation_TitleIdentifierID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociation_TitleIdentifierDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociation_TitleIdentifierSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociation_TitleIdentifierSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociation_TitleIdentifierSelectAuto]    Script Date: 10/16/2009 16:28:24 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleAssociation_TitleIdentifierSelectAuto PROCEDURE
-- Generated 7/30/2008 3:15:22 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for TitleAssociation_TitleIdentifier

CREATE PROCEDURE TitleAssociation_TitleIdentifierSelectAuto

@TitleAssociation_TitleIdentifierID INT

AS 

SET NOCOUNT ON

SELECT 

	[TitleAssociation_TitleIdentifierID],
	[TitleAssociationID],
	[TitleIdentifierID],
	[IdentifierValue],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[TitleAssociation_TitleIdentifier]

WHERE
	[TitleAssociation_TitleIdentifierID] = @TitleAssociation_TitleIdentifierID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociation_TitleIdentifierSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[PDFDeleteAuto]    Script Date: 10/16/2009 16:28:24 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PDFDeleteAuto PROCEDURE
-- Generated 1/21/2009 11:41:21 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for PDF

CREATE PROCEDURE PDFDeleteAuto

@PdfID INT

AS 

DELETE FROM [dbo].[PDF]

WHERE

	[PdfID] = @PdfID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PDFDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectWithSuspectCharacters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectWithSuspectCharacters]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectWithSuspectCharacters]    Script Date: 10/16/2009 16:28:25 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleSelectWithSuspectCharacters]

@InstitutionCode NVARCHAR(10) = '',
@MaxAge INT = 30

AS
BEGIN

SET NOCOUNT ON

-- Title
SELECT	t.TitleID, 
		t.InstitutionCode,
		inst.InstitutionName,
		t.CreationDate,
		CHAR(dbo.fnContainsSuspectCharacter(FullTitle)) as FullTitleSuspect, FullTitle,
		CHAR(dbo.fnContainsSuspectCharacter(ShortTitle)) as ShortTitleSuspect, ShortTitle,
		CHAR(dbo.fnContainsSuspectCharacter(SortTitle)) as SortTitleSuspect, SortTitle,
		CHAR(dbo.fnContainsSuspectCharacter(DataField_260_a)) as DataField260aSuspect, DataField_260_a,
		CHAR(dbo.fnContainsSuspectCharacter(DataField_260_b)) as DataField260bSuspect, DataField_260_b,
		CHAR(dbo.fnContainsSuspectCharacter(PublicationDetails)) as PubDetailsSuspect, PublicationDetails,
		oclc.IdentifierValue as OCLC,
		MIN(i.ZQuery) AS ZQuery
FROM	dbo.Title t LEFT JOIN (SELECT * FROM dbo.Title_TitleIdentifier WHERE TitleIdentifierID = 1) AS oclc
			ON t.TitleID = oclc.TitleID
		INNER JOIN dbo.TitleItem ti
			ON t.TitleID = ti.TitleID
		INNER JOIN dbo.Item i
			ON ti.ItemID = i.ItemID
		INNER JOIN dbo.Institution inst
			ON t.InstitutionCode = inst.InstitutionCode
WHERE	(dbo.fnContainsSuspectCharacter(FullTitle) > 0
OR		dbo.fnContainsSuspectCharacter(ShortTitle) > 0
OR		dbo.fnContainsSuspectCharacter(SortTitle) > 0
OR		dbo.fnContainsSuspectCharacter(Datafield_260_a) > 0
OR		dbo.fnContainsSuspectCharacter(Datafield_260_b) > 0
OR		dbo.fnContainsSuspectCharacter(PublicationDetails) > 0)
AND		(t.InstitutionCode = @InstitutionCode
OR		@InstitutionCode = '')
AND		t.CreationDate > DATEADD(dd, (@MaxAge * -1), GETDATE())
GROUP BY 
		t.TitleID, 
		t.InstitutionCode,
		inst.InstitutionName,
		t.CreationDate,
		CHAR(dbo.fnContainsSuspectCharacter(FullTitle)), FullTitle,
		CHAR(dbo.fnContainsSuspectCharacter(ShortTitle)), ShortTitle,
		CHAR(dbo.fnContainsSuspectCharacter(SortTitle)),  SortTitle,
		CHAR(dbo.fnContainsSuspectCharacter(DataField_260_a)), DataField_260_a,
		CHAR(dbo.fnContainsSuspectCharacter(DataField_260_b)), DataField_260_b, 
		CHAR(dbo.fnContainsSuspectCharacter(PublicationDetails)), PublicationDetails,
		oclc.IdentifierValue
ORDER BY
		inst.InstitutionName, t.CreationDate DESC

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTypeSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTypeSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleTypeSelectAuto]    Script Date: 10/16/2009 16:28:25 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleTypeSelectAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for TitleType

CREATE PROCEDURE TitleTypeSelectAuto

@TitleTypeID INT /* Unique identifier for each Title Type record. */

AS 

SET NOCOUNT ON

SELECT 

	[TitleTypeID],
	[TitleType],
	[TitleTypeDescription]

FROM [dbo].[TitleType]

WHERE
	[TitleTypeID] = @TitleTypeID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleTypeSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFPageDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFPageDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[PDFPageDeleteAuto]    Script Date: 10/16/2009 16:28:26 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PDFPageDeleteAuto PROCEDURE
-- Generated 11/24/2008 4:39:21 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for PDFPage

CREATE PROCEDURE PDFPageDeleteAuto

@PdfPageID INT

AS 

DELETE FROM [dbo].[PDFPage]

WHERE

	[PdfPageID] = @PdfPageID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PDFPageDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFPageInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFPageInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[PDFPageInsertAuto]    Script Date: 10/16/2009 16:28:26 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PDFPageInsertAuto PROCEDURE
-- Generated 11/24/2008 4:39:21 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for PDFPage

CREATE PROCEDURE PDFPageInsertAuto

@PdfPageID INT OUTPUT,
@PdfID INT,
@PageID INT

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[PDFPage]
(
	[PdfID],
	[PageID]
)
VALUES
(
	@PdfID,
	@PageID
)

SET @PdfPageID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PDFPageInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PdfPageID],
		[PdfID],
		[PageID]	

	FROM [dbo].[PDFPage]
	
	WHERE
		[PdfPageID] = @PdfPageID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociation_TitleIdentifierUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociation_TitleIdentifierUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociation_TitleIdentifierUpdateAuto]    Script Date: 10/16/2009 16:28:26 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleAssociation_TitleIdentifierUpdateAuto PROCEDURE
-- Generated 7/30/2008 3:15:22 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for TitleAssociation_TitleIdentifier

CREATE PROCEDURE TitleAssociation_TitleIdentifierUpdateAuto

@TitleAssociation_TitleIdentifierID INT,
@TitleAssociationID INT,
@TitleIdentifierID INT,
@IdentifierValue VARCHAR(125)

AS 

SET NOCOUNT ON

UPDATE [dbo].[TitleAssociation_TitleIdentifier]

SET

	[TitleAssociationID] = @TitleAssociationID,
	[TitleIdentifierID] = @TitleIdentifierID,
	[IdentifierValue] = @IdentifierValue,
	[LastModifiedDate] = getdate()

WHERE
	[TitleAssociation_TitleIdentifierID] = @TitleAssociation_TitleIdentifierID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociation_TitleIdentifierUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleAssociation_TitleIdentifierID],
		[TitleAssociationID],
		[TitleIdentifierID],
		[IdentifierValue],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[TitleAssociation_TitleIdentifier]
	
	WHERE
		[TitleAssociation_TitleIdentifierID] = @TitleAssociation_TitleIdentifierID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFPageSelectForPdfID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFPageSelectForPdfID]
GO


/****** Object:  StoredProcedure [dbo].[PDFPageSelectForPdfID]    Script Date: 10/16/2009 16:28:27 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE dbo.PDFPageSelectForPdfID
@PdfID INT
AS
BEGIN

SET NOCOUNT ON

SELECT	pp.PdfPageID,
		pp.PageID, 
		p.FileNamePrefix, 
		ip.PagePrefix, 
		ip.PageNumber, 
		pt.PageTypeName
FROM	dbo.PDFPage pp INNER JOIN dbo.Page p
			ON pp.PageID = p.PageID
		LEFT JOIN dbo.IndicatedPage ip
			ON p.PageID = ip.pageID
		LEFT JOIN dbo.Page_PageType ppt
			ON p.PageID = ppt.PageID
		LEFT JOIN dbo.PageType pt
			ON ppt.PageTypeID = pt.PageTypeID
WHERE	pp.PdfID = @PdfID
ORDER BY
		pp.PdfID, p.SequenceOrder

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFPageSummaryViewSelectByPdfID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFPageSummaryViewSelectByPdfID]
GO


/****** Object:  StoredProcedure [dbo].[PDFPageSummaryViewSelectByPdfID]    Script Date: 10/16/2009 16:28:27 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PDFPageSummaryViewSelectByPdfID]

@PdfID int

AS
BEGIN

SET NOCOUNT ON

SELECT	psv.MARCBibID,
		psv.FullTitle,
		psv.TitleID,
		psv.ItemID,
		psv.Volume,
		psv.PageID,
		psv.BarCode,
		psv.FileNamePrefix,
		psv.OCRFolderShare,
		psv.WebVirtualDirectory,
		psv.ExternalURL,
		psv.AltExternalURL,
		psv.FileRootFolder,
		psv.RareBooks,
		psv.Illustration
FROM	PDFPage ppg	INNER JOIN PageSummaryView psv
			ON ppg.PageID = psv.PageID
WHERE	ppg.PdfID = @PdfID
ORDER BY
		psv.SequenceOrder

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociationInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociationInsertAuto]    Script Date: 10/16/2009 16:28:27 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleAssociationInsertAuto PROCEDURE
-- Generated 8/22/2008 9:43:29 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for TitleAssociation

CREATE PROCEDURE TitleAssociationInsertAuto

@TitleAssociationID INT OUTPUT,
@TitleID INT,
@TitleAssociationTypeID INT,
@Title NVARCHAR(500),
@Section NVARCHAR(500),
@Volume NVARCHAR(500),
@Heading NVARCHAR(500),
@Publication NVARCHAR(500),
@Relationship NVARCHAR(500),
@Active BIT,
@AssociatedTitleID INT = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[TitleAssociation]
(
	[TitleID],
	[TitleAssociationTypeID],
	[Title],
	[Section],
	[Volume],
	[Heading],
	[Publication],
	[Relationship],
	[Active],
	[AssociatedTitleID],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@TitleID,
	@TitleAssociationTypeID,
	@Title,
	@Section,
	@Volume,
	@Heading,
	@Publication,
	@Relationship,
	@Active,
	@AssociatedTitleID,
	getdate(),
	getdate()
)

SET @TitleAssociationID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociationInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleAssociationID],
		[TitleID],
		[TitleAssociationTypeID],
		[Title],
		[Section],
		[Volume],
		[Heading],
		[Publication],
		[Relationship],
		[Active],
		[AssociatedTitleID],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[TitleAssociation]
	
	WHERE
		[TitleAssociationID] = @TitleAssociationID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[PDFSelectAuto]    Script Date: 10/16/2009 16:28:27 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PDFSelectAuto PROCEDURE
-- Generated 1/21/2009 11:41:21 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for PDF

CREATE PROCEDURE PDFSelectAuto

@PdfID INT

AS 

SET NOCOUNT ON

SELECT 

	[PdfID],
	[ItemID],
	[EmailAddress],
	[ShareWithEmailAddresses],
	[ImagesOnly],
	[ArticleTitle],
	[ArticleCreators],
	[ArticleTags],
	[FileLocation],
	[FileUrl],
	[FileGenerationDate],
	[FileDeletionDate],
	[PdfStatusID],
	[NumberImagesMissing],
	[NumberOcrMissing],
	[Comment],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[PDF]

WHERE
	[PdfID] = @PdfID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PDFSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFSelectDuplicateForPdfID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFSelectDuplicateForPdfID]
GO


/****** Object:  StoredProcedure [dbo].[PDFSelectDuplicateForPdfID]    Script Date: 10/16/2009 16:28:28 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PDFSelectDuplicateForPdfID]

@PdfID INT

AS

BEGIN
/***********************************************************
 *
 * Get identifiers and file locations for existing (generated)
 * PDFs that contain exactly the same pages as the specified
 * PDF.
 *
 ***********************************************************/

SET NOCOUNT ON

-- Get set of pages for the PDF we're about to generate
SELECT	PdfID, 
		PageID, 
		ROW_NUMBER() OVER (PARTITION BY PdfID ORDER BY PageID) AS RowNum
INTO	#tmpControl 
FROM	PDFPage 
WHERE	PdfID = @PdfID

-- Get the number of pages in the PDF we're about to generate
DECLARE @NumPages INT
SELECT @NumPages = COUNT(*) FROM #tmpControl WHERE PdfID = @PdfID

-- Get the ImageOnly flag for the PDF we're about to generate
DECLARE @ImagesOnly BIT
SELECT @ImagesOnly = ImagesOnly FROM PDF WHERE PdfID = @PdfID

-- Find all generated pdfs that have the same number of pages as the
-- PDF we're about the generate
SELECT	pp.PdfID
INTO	#tmpPdf
FROM	PDFPage pp INNER JOIN PDF p
			ON pp.PdfID = p.PdfID
WHERE	pp.PdfID <> @PdfID
AND		p.ImagesOnly = @ImagesOnly
-- find generated, not deleted pdfs with article info (won't be deleted)
AND		p.FileGenerationDate IS NOT NULL
AND		p.FileDeletionDate IS NULL
AND		(p.ArticleTitle <> '' OR
		 p.ArticleCreators <> '' OR
		 p.ArticleTags <> '')
GROUP BY pp.PdfID HAVING COUNT(*) = @NumPages

-- Get the PDF and page identifiers for the generated pdfs that have the
-- same number of pages as the PDF we're about to generate
SELECT	t.PdfID, 
		pp.PageID, 
		ROW_NUMBER() OVER (PARTITION BY t.PdfID ORDER BY pp.PageID) AS RowNum
INTO	#tmpCompare
FROM	#tmpPdf t INNER JOIN PDF p
			ON t.PdfID = p.PdfID
		INNER JOIN PDFPage pp
			ON t.PdfID = pp.PdfID

-- Get the identifers and file locations for generated pdfs that match
-- exactly the pages in the PDF we're about to generate
SELECT	PdfID, 
		FileLocation,
		FileUrl
FROM	PDF 
WHERE	PdfID IN (
			SELECT	com.PdfID
			FROM	#tmpControl con INNER JOIN #tmpCompare com
						ON con.PageID = com.PageID
						AND con.RowNum = com.RowNum
			GROUP BY com.PdfID HAVING COUNT(*) = @NumPages
			)

DROP TABLE #tmpCompare
DROP TABLE #tmpPdf
DROP TABLE #tmpControl

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociationSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociationSelectAuto]    Script Date: 10/16/2009 16:28:28 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleAssociationSelectAuto PROCEDURE
-- Generated 8/22/2008 9:43:29 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for TitleAssociation

CREATE PROCEDURE TitleAssociationSelectAuto

@TitleAssociationID INT

AS 

SET NOCOUNT ON

SELECT 

	[TitleAssociationID],
	[TitleID],
	[TitleAssociationTypeID],
	[Title],
	[Section],
	[Volume],
	[Heading],
	[Publication],
	[Relationship],
	[Active],
	[AssociatedTitleID],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[TitleAssociation]

WHERE
	[TitleAssociationID] = @TitleAssociationID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociationSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFSelectForFileCreation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFSelectForFileCreation]
GO


/****** Object:  StoredProcedure [dbo].[PDFSelectForFileCreation]    Script Date: 10/16/2009 16:28:28 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[PDFSelectForFileCreation]
AS
BEGIN

SET NOCOUNT ON

SELECT	PdfID,
		ItemID,
		EmailAddress,
		ShareWithEmailAddresses,
		ImagesOnly,
		ArticleTitle,
		ArticleCreators,
		ArticleTags
FROM	PDF
WHERE	PdfStatusID = 10

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationSelectWithSuspectCharacters]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociationSelectWithSuspectCharacters]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociationSelectWithSuspectCharacters]    Script Date: 10/16/2009 16:28:29 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleAssociationSelectWithSuspectCharacters]

@InstitutionCode NVARCHAR(10) = '',
@MaxAge INT = 30

AS
BEGIN

SET NOCOUNT ON

SELECT	ta.TitleID,
		t.InstitutionCode,
		inst.InstitutionName,
		ta.CreationDate,
		ta.TitleAssociationID,
		CHAR(dbo.fnContainsSuspectCharacter(ta.Title)) AS TitleSuspect, ta.Title,
		CHAR(dbo.fnContainsSuspectCharacter(ta.Section)) AS SectionSuspect, ta.Section,
		CHAR(dbo.fnContainsSuspectCharacter(ta.Volume)) AS VolumeSuspect, ta.Volume,
		CHAR(dbo.fnContainsSuspectCharacter(ta.Heading)) AS HeadingSuspect, ta.Heading,
		CHAR(dbo.fnContainsSuspectCharacter(ta.Publication)) AS PublicationSuspect, ta.Publication,
		CHAR(dbo.fnContainsSuspectCharacter(ta.Relationship)) AS RelationshipSuspect, ta.Relationship,
		oclc.IdentifierValue AS OCLC,
		i.ZQuery AS ZQuery
FROM	dbo.TitleAssociation ta INNER JOIN dbo.Title t
			ON ta.TitleID = t.TitleID
		LEFT JOIN (SELECT * FROM dbo.Title_TitleIdentifier WHERE TitleIdentifierID = 1) AS oclc
			ON t.TitleID = oclc.TitleID
		INNER JOIN (SELECT DISTINCT ti.TitleID, i.InstitutionCode, i.ZQuery 
					FROM TitleItem ti INNER JOIN Item i ON ti.ItemID = i.ItemID) AS i
			ON t.TitleID = i.TitleID
		INNER JOIN dbo.Institution inst
			ON t.InstitutionCode = inst.InstitutionCode
WHERE	(dbo.fnContainsSuspectCharacter(ta.Title) > 0
OR		dbo.fnContainsSuspectCharacter(ta.Section) > 0
OR		dbo.fnContainsSuspectCharacter(ta.Volume) > 0
OR		dbo.fnContainsSuspectCharacter(ta.Heading) > 0
OR		dbo.fnContainsSuspectCharacter(ta.Publication) > 0
OR		dbo.fnContainsSuspectCharacter(ta.Relationship) > 0)
AND		(t.InstitutionCode = @InstitutionCode OR @InstitutionCode = '')
AND		ta.CreationDate > DATEADD(dd, (@MaxAge * -1), GETDATE())
ORDER BY
		inst.InstitutionName, ta.CreationDate DESC
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTypeInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTypeInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleTypeInsertAuto]    Script Date: 10/16/2009 16:28:29 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleTypeInsertAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for TitleType

CREATE PROCEDURE TitleTypeInsertAuto

@TitleTypeID INT /* Unique identifier for each Title Type record. */,
@TitleType NVARCHAR(25) /* A Type to be associated with a Title. */,
@TitleTypeDescription NVARCHAR(80) = null /* Description of a Title Type. */

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[TitleType]
(
	[TitleTypeID],
	[TitleType],
	[TitleTypeDescription]
)
VALUES
(
	@TitleTypeID,
	@TitleType,
	@TitleTypeDescription
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleTypeInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleTypeID],
		[TitleType],
		[TitleTypeDescription]	

	FROM [dbo].[TitleType]
	
	WHERE
		[TitleTypeID] = @TitleTypeID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PdfStatsSelectOverview]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PdfStatsSelectOverview]
GO


/****** Object:  StoredProcedure [dbo].[PdfStatsSelectOverview]    Script Date: 10/16/2009 16:28:29 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.PdfStatsSelectOverview
AS
BEGIN

SET NOCOUNT ON

-- Overall stats (grouped by status)
SELECT	s.PdfStatusID,
		s.PdfStatusName, 
		COUNT(*) as [NumberOfPDFs],
		SUM(CASE WHEN ImagesOnly = 1 THEN 0 ELSE 1 END) AS [PDFsWithOCR],
		SUM(CASE WHEN ArticleTitle <> '' OR ArticleCreators <> '' OR ArticleTags <> '' THEN 1 ELSE 0 END) AS [PDFsWithArticleMetadata],
		SUM(CASE WHEN NumberImagesMissing > 0 THEN 1 ELSE 0 END) AS [PDFsWithMissingImages],
		SUM(CASE WHEN NumberOCRMissing > 0 THEN 1 ELSE 0 END) AS [PDFsWithMissingOCR]
FROM	dbo.PDF p INNER JOIN dbo.PDFStatus s
			ON p.PdfStatusID = s.PdfStatusID
GROUP BY
		s.PdfStatusId,
		s.PdfStatusName
ORDER BY
		s.PdfStatusID
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectPublishedByInstitution]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectPublishedByInstitution]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectPublishedByInstitution]    Script Date: 10/16/2009 16:28:30 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleSelectPublishedByInstitution]
@IsPublished	bit = null,
@InstitutionCode nvarchar(10) = null
AS 

SET NOCOUNT ON

-- Select titles that are associated with the specified institution,
-- or that have related items which are associated with the 
-- specified institution
SELECT DISTINCT

	t.[TitleID],
	t.[MARCBibID],
	t.[MARCLeader],
	t.[TropicosTitleID],
	t.[FullTitle],
	t.[ShortTitle],
	t.[UniformTitle],
	t.[SortTitle],
	t.[PartNumber],
	t.[PartName],
	t.[CallNumber],
	t.[PublicationDetails],
	t.[StartYear],
	t.[EndYear],
	t.[Datafield_260_a],
	t.[Datafield_260_b],
	t.[Datafield_260_c],
	t.[InstitutionCode],
	ins.InstitutionName,
	t.[LanguageCode],
	CONVERT(nvarchar(4000), t.[TitleDescription]) AS [TitleDescription],
	t.[TL2Author],
	t.[PublishReady],
	t.[RareBooks],
	t.[OriginalCatalogingSource],
	t.[EditionStatement],
	t.[CurrentPublicationFrequency],
	t.[Note],
	t.[CreationDate],
	t.[LastModifiedDate],
	t.[CreationUserID],
	t.[LastModifiedUserID]

FROM [dbo].[Title] t INNER JOIN  [dbo].[TitleItem] ti
		ON t.TitleID = ti.TitleID
	INNER JOIN [dbo].[Item] i
		ON ti.ItemID = i.ItemID
	LEFT OUTER JOIN Institution ins
		ON ins.InstitutionCode = t.InstitutionCode
WHERE t.PublishReady = ISNULL(@IsPublished, t.PublishReady)
AND (t.InstitutionCode = ISNULL(@InstitutionCode, t.InstitutionCode) OR
	 i.InstitutionCode = ISNULL(@InstitutionCode, i.InstitutionCode) )
ORDER BY t.SortTitle

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleSelectPublishedByInstitution. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFStatusDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFStatusDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[PDFStatusDeleteAuto]    Script Date: 10/16/2009 16:28:30 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PDFStatusDeleteAuto PROCEDURE
-- Generated 1/23/2009 8:46:39 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for PDFStatus

CREATE PROCEDURE PDFStatusDeleteAuto

@PdfStatusID INT

AS 

DELETE FROM [dbo].[PDFStatus]

WHERE

	[PdfStatusID] = @PdfStatusID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PDFStatusDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFStatusInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFStatusInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[PDFStatusInsertAuto]    Script Date: 10/16/2009 16:28:31 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PDFStatusInsertAuto PROCEDURE
-- Generated 1/23/2009 8:46:39 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for PDFStatus

CREATE PROCEDURE PDFStatusInsertAuto

@PdfStatusID INT,
@PdfStatusName NCHAR(10)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[PDFStatus]
(
	[PdfStatusID],
	[PdfStatusName]
)
VALUES
(
	@PdfStatusID,
	@PdfStatusName
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PDFStatusInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PdfStatusID],
		[PdfStatusName]	

	FROM [dbo].[PDFStatus]
	
	WHERE
		[PdfStatusID] = @PdfStatusID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFStatusSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFStatusSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[PDFStatusSelectAll]    Script Date: 10/16/2009 16:28:31 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE PDFStatusSelectAll

AS 

SET NOCOUNT ON

SELECT 	PdfStatusID,
		PdfStatusName
FROM	dbo.PDFStatus
ORDER BY 
		PdfStatusID


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFStatusSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFStatusSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[PDFStatusSelectAuto]    Script Date: 10/16/2009 16:28:32 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PDFStatusSelectAuto PROCEDURE
-- Generated 1/23/2009 8:46:39 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for PDFStatus

CREATE PROCEDURE PDFStatusSelectAuto

@PdfStatusID INT

AS 

SET NOCOUNT ON

SELECT 

	[PdfStatusID],
	[PdfStatusName]

FROM [dbo].[PDFStatus]

WHERE
	[PdfStatusID] = @PdfStatusID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PDFStatusSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectSearchName]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectSearchName]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectSearchName]    Script Date: 10/16/2009 16:28:32 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleSelectSearchName]
@Name			varchar(1000),
@PublishReady	bit,
@LanguageCode	nvarchar(10) = '',
@IncludeSecondaryTitles char(1) = '',
@ReturnCount	int = 100
AS 

SET NOCOUNT ON

SELECT DISTINCT TOP (@ReturnCount)
	t.[TitleID],
	t.[FullTitle],
	t.[SortTitle],
	ISNULL(t.[PartNumber], '') AS PartNumber,
	ISNULL(t.[PartName], '') AS PartName,
	t.[PublicationDetails],
	I.InstitutionName
FROM [dbo].[Title] t
	LEFT OUTER JOIN Institution I ON I.InstitutionCode = t.InstitutionCode
	INNER JOIN TitleItem TI ON t.TitleID = TI.TitleID
	INNER JOIN Item IT ON TI.ItemID = IT.ItemID
	LEFT JOIN dbo.TitleLanguage tl ON t.TitleID = tl.TitleID
	LEFT JOIN dbo.ItemLanguage il ON it.ItemID = il.ItemID
WHERE t.FullTitle LIKE '%' + @Name + '%'
AND t.PublishReady = @PublishReady
AND (t.LanguageCode = @LanguageCode OR
		IT.LanguageCode = @LanguageCode OR
		ISNULL(tl.LanguageCode, '') = @LanguageCode OR
		ISNULL(il.LanguageCode, '') = @LanguageCode OR
		@LanguageCode = '')
-- Only consider Primary titles unless @IncludeSecondaryTitles = '1'
AND	(t.[TitleID] IN (SELECT DISTINCT PrimaryTitleID FROM dbo.Item) OR @IncludeSecondaryTitles = '1')
ORDER BY t.SortTitle

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleSelectSearchName. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[PDFUpdateAuto]    Script Date: 10/16/2009 16:28:33 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- PDFUpdateAuto PROCEDURE
-- Generated 1/21/2009 11:41:21 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for PDF

CREATE PROCEDURE PDFUpdateAuto

@PdfID INT,
@ItemID INT,
@EmailAddress NVARCHAR(200),
@ShareWithEmailAddresses NVARCHAR(MAX),
@ImagesOnly BIT,
@ArticleTitle NVARCHAR(MAX),
@ArticleCreators NVARCHAR(MAX),
@ArticleTags NVARCHAR(MAX),
@FileLocation NVARCHAR(200),
@FileUrl NVARCHAR(200),
@FileGenerationDate DATETIME,
@FileDeletionDate DATETIME,
@PdfStatusID INT,
@NumberImagesMissing INT,
@NumberOcrMissing INT,
@Comment NVARCHAR(MAX)

AS 

SET NOCOUNT ON

UPDATE [dbo].[PDF]

SET

	[ItemID] = @ItemID,
	[EmailAddress] = @EmailAddress,
	[ShareWithEmailAddresses] = @ShareWithEmailAddresses,
	[ImagesOnly] = @ImagesOnly,
	[ArticleTitle] = @ArticleTitle,
	[ArticleCreators] = @ArticleCreators,
	[ArticleTags] = @ArticleTags,
	[FileLocation] = @FileLocation,
	[FileUrl] = @FileUrl,
	[FileGenerationDate] = @FileGenerationDate,
	[FileDeletionDate] = @FileDeletionDate,
	[PdfStatusID] = @PdfStatusID,
	[NumberImagesMissing] = @NumberImagesMissing,
	[NumberOcrMissing] = @NumberOcrMissing,
	[Comment] = @Comment,
	[LastModifiedDate] = getdate()

WHERE
	[PdfID] = @PdfID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure PDFUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[PdfID],
		[ItemID],
		[EmailAddress],
		[ShareWithEmailAddresses],
		[ImagesOnly],
		[ArticleTitle],
		[ArticleCreators],
		[ArticleTags],
		[FileLocation],
		[FileUrl],
		[FileGenerationDate],
		[FileDeletionDate],
		[PdfStatusID],
		[NumberImagesMissing],
		[NumberOcrMissing],
		[Comment],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[PDF]
	
	WHERE
		[PdfID] = @PdfID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFUpdatePdfStatus]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[PDFUpdatePdfStatus]
GO


/****** Object:  StoredProcedure [dbo].[PDFUpdatePdfStatus]    Script Date: 10/16/2009 16:28:33 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE dbo.PDFUpdatePdfStatus
@PdfID int,
@PdfStatusID int,
@RowsUpdated int OUTPUT
AS
BEGIN

UPDATE	dbo.PDF
SET		PdfStatusID = @PdfStatusID
WHERE	PdfID = @PdfID
AND		PdfStatusID <> @PdfStatusID

SELECT	@RowsUpdated = @@ROWCOUNT

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[VaultDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[VaultDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[VaultDeleteAuto]    Script Date: 10/16/2009 16:28:34 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- VaultDeleteAuto PROCEDURE
-- Generated 1/24/2008 10:03:58 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Vault

CREATE PROCEDURE VaultDeleteAuto

@VaultID INT /* Unique identifier for each Vault entry. */

AS 

DELETE FROM [dbo].[Vault]

WHERE

	[VaultID] = @VaultID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure VaultDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationTypeSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociationTypeSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociationTypeSelectAll]    Script Date: 10/16/2009 16:28:34 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleAssociationTypeSelectAll]

AS 

SELECT 
	[TitleAssociationTypeID],
	[TitleAssociationName],
	[TitleAssociationLabel],
	[MARCTag],
	[MARCIndicator2]
FROM [dbo].[TitleAssociationType]
ORDER BY TitleAssociationName


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationTypeUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociationTypeUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociationTypeUpdateAuto]    Script Date: 10/16/2009 16:28:34 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleAssociationTypeUpdateAuto PROCEDURE
-- Generated 5/6/2009 2:57:04 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for TitleAssociationType

CREATE PROCEDURE TitleAssociationTypeUpdateAuto

@TitleAssociationTypeID INT,
@TitleAssociationName NVARCHAR(60),
@MARCTag NVARCHAR(20),
@MARCIndicator2 NCHAR(1),
@TitleAssociationLabel NVARCHAR(30)

AS 

SET NOCOUNT ON

UPDATE [dbo].[TitleAssociationType]

SET

	[TitleAssociationName] = @TitleAssociationName,
	[MARCTag] = @MARCTag,
	[MARCIndicator2] = @MARCIndicator2,
	[TitleAssociationLabel] = @TitleAssociationLabel

WHERE
	[TitleAssociationTypeID] = @TitleAssociationTypeID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociationTypeUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleAssociationTypeID],
		[TitleAssociationName],
		[MARCTag],
		[MARCIndicator2],
		[TitleAssociationLabel]

	FROM [dbo].[TitleAssociationType]
	
	WHERE
		[TitleAssociationTypeID] = @TitleAssociationTypeID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTagUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTagUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleTagUpdateAuto]    Script Date: 10/16/2009 16:28:35 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleTagUpdateAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for TitleTag

CREATE PROCEDURE TitleTagUpdateAuto

@TitleID INT,
@TagText NVARCHAR(50),
@MarcDataFieldTag NVARCHAR(50),
@MarcSubFieldCode NVARCHAR(50)

AS 

SET NOCOUNT ON

UPDATE [dbo].[TitleTag]

SET

	[TitleID] = @TitleID,
	[TagText] = @TagText,
	[MarcDataFieldTag] = @MarcDataFieldTag,
	[MarcSubFieldCode] = @MarcSubFieldCode,
	[LastModifiedDate] = getdate()

WHERE
	[TitleID] = @TitleID AND
	[TagText] = @TagText
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleTagUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleID],
		[TagText],
		[MarcDataFieldTag],
		[MarcSubFieldCode],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[TitleTag]
	
	WHERE
		[TitleID] = @TitleID AND 
		[TagText] = @TagText
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[StatsSelect]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[StatsSelect]
GO


/****** Object:  StoredProcedure [dbo].[StatsSelect]    Script Date: 10/16/2009 16:28:35 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[StatsSelect]

@Expanded bit = 0,
@Names bit = 0

AS 
BEGIN
SET NOCOUNT ON

DECLARE @TitleCount int,
	@VolumeCount int,
	@PageCount int,
	@TitleTotal int,
	@VolumeTotal int,
	@PageTotal int,
	@UniqueCount int,
	@UniqueTotal int

-- Make sure each title is the primary title for at least one item
SELECT @TitleCount = count(*) FROM Title WHERE (Title.PublishReady=1) AND Title.TitleID IN (SELECT DISTINCT PrimaryTitleID FROM dbo.Item)
SELECT @VolumeCount = count(*) FROM Item WHERE (Item.ItemStatusID=40)
SELECT @PageCount = count(*) FROM Page WHERE (Page.Active=1)

IF (@Expanded = 1)
BEGIN
	SELECT @TitleTotal = count(*) FROM Title
	SELECT @VolumeTotal = count(*) FROM Item
	SELECT @PageTotal = count(*) FROM Page
END

IF (@Names = 1)
BEGIN
	SELECT @UniqueCount = COUNT(DISTINCT NameBankID) FROM PageName WHERE Active = 1
	IF (@Expanded = 1) SELECT @UniqueTotal = COUNT(DISTINCT NameBankID) FROM PageName
END

SELECT @TitleCount AS TitleCount,
	@VolumeCount AS VolumeCount,
	@PageCount AS PageCount,
	ISNULL(@TitleTotal, 0) AS TitleTotal,
	ISNULL(@VolumeTotal, 0) AS VolumeTotal,
	ISNULL(@PageTotal, 0) AS PageTotal,
	ISNULL(@UniqueCount, 0) AS UniqueCount,
	ISNULL(@UniqueTotal, 0) AS UniqueTotal
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleBibTeXSelectAllTitleCitations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleBibTeXSelectAllTitleCitations]
GO


/****** Object:  StoredProcedure [dbo].[TitleBibTeXSelectAllTitleCitations]    Script Date: 10/16/2009 16:28:35 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleBibTeXSelectAllTitleCitations]
AS
BEGIN

SET NOCOUNT ON

SELECT	'bhltitle' + CONVERT(NVARCHAR(10), t.TitleID) AS CitationKey,
		'http://www.biodiversitylibrary.org/bibliography/' + CONVERT(NVARCHAR(10), t.TitleID) AS Url,
		t.ShortTitle AS Title, ISNULL(t.Datafield_260_a, '') + ISNULL(t.Datafield_260_b, '') AS Publisher,
		CASE WHEN ISNULL(t.Datafield_260_c, '') = '' THEN ISNULL(CONVERT(NVARCHAR(20), StartYear), '') ELSE ISNULL(t.Datafield_260_c, '') END [Year],
		dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
		dbo.fnTagTextStringForTitle(t.TitleID) AS Keywords
FROM	dbo.Title t
WHERE	t.PublishReady = 1

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleDeleteAuto]    Script Date: 10/16/2009 16:28:36 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleDeleteAuto PROCEDURE
-- Generated 5/19/2009 11:15:05 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Title

CREATE PROCEDURE TitleDeleteAuto

@TitleID INT

AS 

DELETE FROM [dbo].[Title]

WHERE

	[TitleID] = @TitleID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTagSelectTagTextByTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTagSelectTagTextByTitleID]
GO


/****** Object:  StoredProcedure [dbo].[TitleTagSelectTagTextByTitleID]    Script Date: 10/16/2009 16:28:36 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleTagSelectTagTextByTitleID]
	@TitleID int
AS 

SET NOCOUNT ON

SELECT DISTINCT	
		TagText
FROM	dbo.PrimaryTitleTagView
WHERE	PrimaryTitleID = @TitleID
UNION
SELECT DISTINCT
		TagText
FROM	dbo.PrimaryTitleTagView
WHERE	TitleID = @TitleID
ORDER BY TagText

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleBibTeXSelectForTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleBibTeXSelectForTitleID]
GO


/****** Object:  StoredProcedure [dbo].[TitleBibTeXSelectForTitleID]    Script Date: 10/16/2009 16:28:37 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleBibTeXSelectForTitleID]

@TitleID INT

AS
BEGIN

SET NOCOUNT ON

SELECT	'bhl' + CONVERT(NVARCHAR(10), i.ItemID) AS CitationKey,
		'http://www.biodiversitylibrary.org/item/' + CONVERT(NVARCHAR(10), i.ItemID) AS Url,
		'http://www.biodiversitylibrary.org/bibliography/' + CONVERT(NVARCHAR(10), t.TitleID) AS Note,
		t.ShortTitle AS Title, ISNULL(t.Datafield_260_a, '') + ISNULL(t.Datafield_260_b, '') AS Publisher,
		CASE WHEN i.Year IS NULL THEN ISNULL(t.Datafield_260_c, '') ELSE i.Year END AS [Year],
		ISNULL(i.Volume, '') AS Volume , ISNULL(i.CopyrightStatus, '') AS CopyrightStatus,
		dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
		dbo.fnCOinSGetPageCountForItem(i.ItemID) AS Pages,
		dbo.fnTagTextStringForTitle(t.TitleID) AS Keywords
FROM	dbo.Title t INNER JOIN dbo.Item i
			ON t.TitleID = i.PrimaryTitleID
		INNER JOIN dbo.TitleItem ti
			ON i.ItemID = ti.ItemID
			AND t.TitleID = ti.TitleID
WHERE	t.PublishReady = 1
AND		i.ItemStatusID = 40
AND		t.TitleID = @TitleID
ORDER BY ti.ItemSequence
		
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_CreatorDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_CreatorDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[Title_CreatorDeleteAuto]    Script Date: 10/16/2009 16:28:37 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Title_CreatorDeleteAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Title_Creator

CREATE PROCEDURE Title_CreatorDeleteAuto

@Title_CreatorID INT

AS 

DELETE FROM [dbo].[Title_Creator]

WHERE

	[Title_CreatorID] = @Title_CreatorID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_CreatorDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_CreatorInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_CreatorInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[Title_CreatorInsertAuto]    Script Date: 10/16/2009 16:28:38 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Title_CreatorInsertAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Title_Creator

CREATE PROCEDURE Title_CreatorInsertAuto

@Title_CreatorID INT OUTPUT,
@TitleID INT /* Unique identifier for each Title record. */,
@CreatorID INT /* Unique identifier for each Creator record. */,
@CreatorRoleTypeID INT /* Unique identifier for each Creator Role Type. */,
@CreationUserID INT = null,
@LastModifiedUserID INT = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Title_Creator]
(
	[TitleID],
	[CreatorID],
	[CreatorRoleTypeID],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID]
)
VALUES
(
	@TitleID,
	@CreatorID,
	@CreatorRoleTypeID,
	getdate(),
	getdate(),
	@CreationUserID,
	@LastModifiedUserID
)

SET @Title_CreatorID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_CreatorInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[Title_CreatorID],
		[TitleID],
		[CreatorID],
		[CreatorRoleTypeID],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID]	

	FROM [dbo].[Title_Creator]
	
	WHERE
		[Title_CreatorID] = @Title_CreatorID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_CreatorSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_CreatorSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[Title_CreatorSelectAuto]    Script Date: 10/16/2009 16:28:38 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Title_CreatorSelectAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for Title_Creator

CREATE PROCEDURE Title_CreatorSelectAuto

@Title_CreatorID INT

AS 

SET NOCOUNT ON

SELECT 

	[Title_CreatorID],
	[TitleID],
	[CreatorID],
	[CreatorRoleTypeID],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID]

FROM [dbo].[Title_Creator]

WHERE
	[Title_CreatorID] = @Title_CreatorID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_CreatorSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_CreatorSelectByTitle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_CreatorSelectByTitle]
GO


/****** Object:  StoredProcedure [dbo].[Title_CreatorSelectByTitle]    Script Date: 10/16/2009 16:28:38 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Title_CreatorSelectByTitle]

@TitleID INT /* Unique identifier for each Title record. */

AS 

SET NOCOUNT ON

SELECT 

	TC.[Title_CreatorID],
	TC.[TitleID],
	TC.[CreatorID],
	TC.[CreatorRoleTypeID],
	CRT.CreatorRoleTypeDescription 

FROM [dbo].[Title_Creator] TC
INNER JOIN CreatorRoleType CRT ON TC.CreatorRoleTypeID = CRT.CreatorRoleTypeID
INNER JOIN Creator C ON C.CreatorID = TC.CreatorID

WHERE
	[TitleID] = @TitleID
ORDER BY C.CreatorName

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_CreatorSelectByTitleID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_CreatorSelectByTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_CreatorSelectByTitleID]
GO


/****** Object:  StoredProcedure [dbo].[Title_CreatorSelectByTitleID]    Script Date: 10/16/2009 16:28:38 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Title_CreatorSelectByTitleID]

@TitleID INT /* Unique identifier for each Title record. */

AS 

SET NOCOUNT ON

SELECT 

	TC.[TitleID],
	TC.[CreatorID],
	TC.[CreatorRoleTypeID],
	CRT.CreatorRoleTypeDescription 

FROM [dbo].[Title_Creator] TC
INNER JOIN CreatorRoleType CRT ON TC.CreatorRoleTypeID = CRT.CreatorRoleTypeID

WHERE
	[TitleID] = @TitleID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_CreatorSelectByTitleID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectByTagTextInstitutionAndLanguage]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectByTagTextInstitutionAndLanguage]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectByTagTextInstitutionAndLanguage]    Script Date: 10/16/2009 16:28:39 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleSelectByTagTextInstitutionAndLanguage]
@TagText nvarchar(50),
@InstitutionCode nvarchar(10),
@LanguageCode nvarchar(10) = '',
@IncludeSecondaryTitles char(1) = ''

AS
SET NOCOUNT ON

-- Get titles tied directly to the specified TagText
SELECT DISTINCT 
		v.TitleID,
		t.FullTitle,
		t.ShortTitle,
		t.SortTitle,
		t.PartNumber,
		t.PartName,
		t.PublicationDetails,
		i.InstitutionName--,
		--dbo.fnTagTextStringForTitle(v.TitleID) AS TagTextString
INTO	#tmpTitle
FROM	dbo.PrimaryTitleTagView v INNER JOIN dbo.Title t
			ON v.TitleID = t.TitleID
		INNER JOIN dbo.Institution i
			ON v.ItemInstitutionCode = i.InstitutionCode
		LEFT JOIN dbo.TitleLanguage tl
			ON v.TitleID = tl.TitleID
		LEFT JOIN dbo.ItemLanguage il
			ON v.ItemID = il.ItemID
WHERE	v.TagText = @TagText
-- Only consider Primary titles unless @IncludeSecondaryTitles = '1'
AND		(v.TitleID IN (SELECT DISTINCT PrimaryTitleID FROM dbo.Item) OR @IncludeSecondaryTitles = 1)
AND		t.PublishReady=1
AND		(v.TitleInstitutionCode = @InstitutionCode OR 
		 v.ItemInstitutionCode = @InstitutionCode OR 
		 @InstitutionCode = '')
AND		(v.TitleLanguageCode = @LanguageCode OR
		 v.ItemLanguageCode = @LanguageCode OR
		 ISNULL(tl.LanguageCode, '') = @LanguageCode OR
		 ISNULL(il.LanguageCode, '') = @LanguageCode OR
		 @LanguageCode = '')
UNION
-- Get primary titles indirectly tied to TagText
SELECT DISTINCT 
		v.PrimaryTitleID AS TitleID,
		t.FullTitle,
		t.ShortTitle,
		t.SortTitle,
		t.PartNumber,
		t.PartName,
		t.PublicationDetails,
		i.InstitutionName--,
		--dbo.fnTagTextStringForTitle(v.PrimaryTitleID) AS TagTextString
FROM	dbo.PrimaryTitleTagView v INNER JOIN dbo.Title t
			ON v.PrimaryTitleID = t.TitleID
		INNER JOIN dbo.Institution i
			ON v.ItemInstitutionCode = i.InstitutionCode
		LEFT JOIN dbo.TitleLanguage tl
			ON v.TitleID = tl.TitleID
		LEFT JOIN dbo.ItemLanguage il
			ON v.ItemID = il.ItemID
WHERE	TagText = @TagText
AND		t.PublishReady=1
AND		(v.TitleInstitutionCode = @InstitutionCode OR 
		 v.ItemInstitutionCode = @InstitutionCode OR 
		 @InstitutionCode = '')
AND		(v.TitleLanguageCode = @LanguageCode OR
		 v.ItemLanguageCode = @LanguageCode OR
		 ISNULL(tl.LanguageCode, '') = @LanguageCode OR
		 ISNULL(il.LanguageCode, '') = @LanguageCode OR
		 @LanguageCode = '')
ORDER BY SortTitle

-- Add the tags for each title to the result set
SELECT	TitleID,
		FullTitle,
		ShortTitle,
		SortTitle,
		PartNumber,
		PartName,
		PublicationDetails,
		InstitutionName,
		dbo.fnTagTextStringForTitle(TitleID) AS TagTextString
FROM	#tmpTitle

-- Clean up
DROP TABLE #tmpTitle

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleSelectByTagTextInstitutionAndLanguage. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTagSelectLikeTag]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTagSelectLikeTag]
GO


/****** Object:  StoredProcedure [dbo].[TitleTagSelectLikeTag]    Script Date: 10/16/2009 16:28:39 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleTagSelectLikeTag]
@TagText NVARCHAR(50),
@LanguageCode NVARCHAR(10) = '',
@IncludeSecondaryTitles CHAR(1) = '',
@ReturnCount INT = 100

AS 

SET NOCOUNT ON

SELECT DISTINCT TOP (@ReturnCount) TagText
FROM [dbo].[TitleTag] TT
	INNER JOIN dbo.Title T ON TT.TitleID = T.TitleID
	INNER JOIN dbo.TitleItem TI ON T.TitleID = TI.TitleID
	INNER JOIN dbo.Item I ON TI.ItemID = I.ItemID
	LEFT JOIN dbo.TitleLanguage tl ON T.TitleID = tl.TitleID
	LEFT JOIN dbo.ItemLanguage il ON I.ItemID = il.ItemID
WHERE
	TT.[TagText] LIKE @TagText + '%' AND
	T.PublishReady = 1 AND
	(T.LanguageCode = @LanguageCode OR
		I.LanguageCode = @LanguageCode OR
		ISNULL(TL.LanguageCode, '') = @LanguageCode OR
		ISNULL(IL.LanguageCode, '') = @LanguageCode OR
		@LanguageCode = '')
-- Only consider Primary titles unless @IncludeSecondaryTitles = '1'
--AND	([T].[TitleID] IN (SELECT DISTINCT PrimaryTitleID FROM dbo.Item) OR @IncludeSecondaryTitles = '1')
ORDER BY
	TagText

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifierDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_TitleIdentifierDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[Title_TitleIdentifierDeleteAuto]    Script Date: 10/16/2009 16:28:39 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Title_TitleIdentifierDeleteAuto PROCEDURE
-- Generated 7/30/2008 3:15:22 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for Title_TitleIdentifier

CREATE PROCEDURE Title_TitleIdentifierDeleteAuto

@Title_TitleIdentifierID INT

AS 

DELETE FROM [dbo].[Title_TitleIdentifier]

WHERE

	[Title_TitleIdentifierID] = @Title_TitleIdentifierID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_TitleIdentifierDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifierInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_TitleIdentifierInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[Title_TitleIdentifierInsertAuto]    Script Date: 10/16/2009 16:28:40 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Title_TitleIdentifierInsertAuto PROCEDURE
-- Generated 7/30/2008 3:15:22 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Title_TitleIdentifier

CREATE PROCEDURE Title_TitleIdentifierInsertAuto

@Title_TitleIdentifierID INT OUTPUT,
@TitleID INT,
@TitleIdentifierID INT,
@IdentifierValue NVARCHAR(125)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Title_TitleIdentifier]
(
	[TitleID],
	[TitleIdentifierID],
	[IdentifierValue],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@TitleID,
	@TitleIdentifierID,
	@IdentifierValue,
	getdate(),
	getdate()
)

SET @Title_TitleIdentifierID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_TitleIdentifierInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[Title_TitleIdentifierID],
		[TitleID],
		[TitleIdentifierID],
		[IdentifierValue],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[Title_TitleIdentifier]
	
	WHERE
		[Title_TitleIdentifierID] = @Title_TitleIdentifierID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleEndNoteSelectForTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleEndNoteSelectForTitleID]
GO


/****** Object:  StoredProcedure [dbo].[TitleEndNoteSelectForTitleID]    Script Date: 10/16/2009 16:28:40 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleEndNoteSelectForTitleID]

@TitleID INT

AS
BEGIN

SET NOCOUNT ON

SELECT 	t.TitleID,
		i.ItemID,
		CASE SUBSTRING(t.MarcLeader, 8, 1)
			WHEN 'm' THEN 'Book'	-- monograph
			WHEN 'a' THEN 'Book'	-- monographic part
			WHEN 's' THEN 'Serial'	-- serial
			WHEN 'b' THEN 'Serial'	-- serial part
			WHEN 'c' THEN 'Serial'	-- collection
			ELSE 'Book'
		END AS PublicationType,
		dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
		CASE 
			WHEN ISNULL(i.Year, '') <> '' THEN i.Year
			WHEN ISNULL(CONVERT(NVARCHAR(20), t.StartYear), '') <> '' THEN CONVERT(NVARCHAR(20), t.StartYear)
			ELSE ISNULL(t.Datafield_260_c, '')
		END AS Year,
		t.FullTitle,
		LTRIM(ISNULL(t.PartNumber, '') + ' ' + ISNULL(PartName, '')) AS SecondaryTitle,
		ISNULL(t.Datafield_260_a, '') AS PublisherPlace,
		ISNULL(t.Datafield_260_b, '') AS PublisherName,
		i.Volume,
		t.ShortTitle,
		abbrev.IdentifierValue AS Abbreviation,
		isbn.IdentifierValue AS ISBN,
		CASE WHEN ISNULL(i.CallNumber, '') = '' THEN t.CallNumber ELSE i.CallNumber END AS CallNumber,
		dbo.fnTagTextStringForTitle(t.TitleID) AS Keywords,
		l.LanguageName,
		i.Note
FROM	dbo.Title t LEFT JOIN dbo.Title_TitleIdentifier isbn
			ON t.TitleID = isbn.TitleID
			AND isbn.TitleIdentifierID = 3 -- isbn
		LEFT JOIN dbo.Title_TitleIdentifier abbrev
			ON t.TitleID = abbrev.TitleID
			AND abbrev.TitleIdentifierID = 6 -- abbrev
		INNER JOIN dbo.TitleItem ti
			ON t.TitleID = ti.TitleID
		INNER JOIN dbo.Item i
			ON ti.ItemID  = i.ItemID
			AND i.ItemStatusID = 40
		LEFT JOIN dbo.Language l
			ON i.LanguageCode = l.LanguageCode
WHERE	t.PublishReady = 1
AND		t.TitleID = @TitleID
ORDER BY ti.ItemSequence

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifierSelectByIdentifierValue]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_TitleIdentifierSelectByIdentifierValue]
GO


/****** Object:  StoredProcedure [dbo].[Title_TitleIdentifierSelectByIdentifierValue]    Script Date: 10/16/2009 16:28:40 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[Title_TitleIdentifierSelectByIdentifierValue]
@IdentifierValue NVARCHAR(125)
AS 

SET NOCOUNT ON

SELECT	@IdentifierValue = CASE WHEN SUBSTRING(@IdentifierValue, 1, 3) IN ('ocm', 'ocn')
							THEN SUBSTRING(@IdentifierValue, 4, LEN(@IdentifierValue))
							ELSE @IdentifierValue
							END

SELECT	tti.Title_TitleIdentifierID,
		tti.TitleID,
		tti.TitleIdentifierID,
		ti.IdentifierName,
		tti.IdentifierValue
FROM	[dbo].[Title_TitleIdentifier] tti INNER JOIN [dbo].[TitleIdentifier] ti
			ON tti.TitleIdentifierID = ti.TitleIdentifierID
		INNER JOIN [dbo].Title t
			ON tti.TitleID = t.TitleID
WHERE	t.PublishReady = 1
AND		(IdentifierValue = @IdentifierValue
OR		IdentifierValue = 'ocm' + @IdentifierValue
OR		IdentifierValue = 'ocn' + @IdentifierValue)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_TitleIdentifierSelectByIdentifierValue. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleIdentifierDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleIdentifierDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleIdentifierDeleteAuto]    Script Date: 10/16/2009 16:28:41 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleIdentifierDeleteAuto PROCEDURE
-- Generated 5/6/2009 3:30:24 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for TitleIdentifier

CREATE PROCEDURE TitleIdentifierDeleteAuto

@TitleIdentifierID INT

AS 

DELETE FROM [dbo].[TitleIdentifier]

WHERE

	[TitleIdentifierID] = @TitleIdentifierID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleIdentifierDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifierUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_TitleIdentifierUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[Title_TitleIdentifierUpdateAuto]    Script Date: 10/16/2009 16:28:41 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Title_TitleIdentifierUpdateAuto PROCEDURE
-- Generated 7/30/2008 3:15:22 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for Title_TitleIdentifier

CREATE PROCEDURE Title_TitleIdentifierUpdateAuto

@Title_TitleIdentifierID INT,
@TitleID INT,
@TitleIdentifierID INT,
@IdentifierValue NVARCHAR(125)

AS 

SET NOCOUNT ON

UPDATE [dbo].[Title_TitleIdentifier]

SET

	[TitleID] = @TitleID,
	[TitleIdentifierID] = @TitleIdentifierID,
	[IdentifierValue] = @IdentifierValue,
	[LastModifiedDate] = getdate()

WHERE
	[Title_TitleIdentifierID] = @Title_TitleIdentifierID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_TitleIdentifierUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[Title_TitleIdentifierID],
		[TitleID],
		[TitleIdentifierID],
		[IdentifierValue],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[Title_TitleIdentifier]
	
	WHERE
		[Title_TitleIdentifierID] = @Title_TitleIdentifierID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleIdentifierInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleIdentifierInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleIdentifierInsertAuto]    Script Date: 10/16/2009 16:28:42 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleIdentifierInsertAuto PROCEDURE
-- Generated 5/6/2009 3:30:24 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for TitleIdentifier

CREATE PROCEDURE TitleIdentifierInsertAuto

@TitleIdentifierID INT OUTPUT,
@IdentifierName NVARCHAR(40),
@MarcDataFieldTag NVARCHAR(50),
@MarcSubFieldCode NVARCHAR(50)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[TitleIdentifier]
(
	[IdentifierName],
	[MarcDataFieldTag],
	[MarcSubFieldCode]
)
VALUES
(
	@IdentifierName,
	@MarcDataFieldTag,
	@MarcSubFieldCode
)

SET @TitleIdentifierID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleIdentifierInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleIdentifierID],
		[IdentifierName],
		[MarcDataFieldTag],
		[MarcSubFieldCode]	

	FROM [dbo].[TitleIdentifier]
	
	WHERE
		[TitleIdentifierID] = @TitleIdentifierID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleIdentifierSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleIdentifierSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[TitleIdentifierSelectAll]    Script Date: 10/16/2009 16:28:43 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleIdentifierSelectAll]

AS 

SET NOCOUNT ON

SELECT 
	[TitleIdentifierID],
	[IdentifierName],
	[MarcDataFieldTag],
	[MarcSubFieldCode]
FROM [dbo].[TitleIdentifier]
ORDER BY
	[IdentifierName]

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleIdentifierSelectAll. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleTypeInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_TitleTypeInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[Title_TitleTypeInsertAuto]    Script Date: 10/16/2009 16:28:43 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- Title_TitleTypeInsertAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Title_TitleType

CREATE PROCEDURE Title_TitleTypeInsertAuto

@Title_TitleTypeID INT OUTPUT,
@TitleID INT /* Unique identifier for each Title record. */,
@TitleTypeID INT /* Unique identifier for each Title Type record. */

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Title_TitleType]
(
	[TitleID],
	[TitleTypeID]
)
VALUES
(
	@TitleID,
	@TitleTypeID
)

SET @Title_TitleTypeID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure Title_TitleTypeInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[Title_TitleTypeID],
		[TitleID],
		[TitleTypeID]	

	FROM [dbo].[Title_TitleType]
	
	WHERE
		[Title_TitleTypeID] = @Title_TitleTypeID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectByNameLike]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectByNameLike]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectByNameLike]    Script Date: 10/16/2009 16:28:43 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleSelectByNameLike]
@Name varchar(1000),
@InstitutionCode nvarchar(10) = '',
@LanguageCode nvarchar(10) = ''
AS
SET NOCOUNT ON

SELECT DISTINCT
	t.[TitleID],
	t.[FullTitle],
	t.[SortTitle],
	ISNULL(t.[PartNumber], '') AS PartNumber,
	ISNULL(t.[PartName], '') AS PartName,
	t.[PublicationDetails],
	I.InstitutionName
FROM [dbo].[Title] t
LEFT OUTER JOIN dbo.Institution I ON I.InstitutionCode = t.InstitutionCode
LEFT OUTER JOIN dbo.TitleLanguage tl ON t.TitleID = tl.TitleID
WHERE	t.PublishReady=1 AND t.SortTitle LIKE @Name + '%'
AND		(t.InstitutionCode = @InstitutionCode OR I.InstitutionCode = @InstitutionCode OR @InstitutionCode = '')
AND		(t.LanguageCode = @LanguageCode OR ISNULL(tl.LanguageCode, '') = @LanguageCode OR @LanguageCode = '')
-- Make sure each title is the primary title for at least one item
AND		t.TitleID IN (SELECT DISTINCT PrimaryTitleID FROM dbo.Item)
ORDER BY t.SortTitle

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleSelectByNameLike. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleTypeSelectByTitle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[Title_TitleTypeSelectByTitle]
GO


/****** Object:  StoredProcedure [dbo].[Title_TitleTypeSelectByTitle]    Script Date: 10/16/2009 16:28:44 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[Title_TitleTypeSelectByTitle]

@TitleID INT 

AS 

SET NOCOUNT ON

SELECT 
	TTT.Title_TitleTypeID,
	TTT.[TitleID],
	TTT.[TitleTypeID],
	TT.TitleType,
	TT.TitleTypeDescription

FROM [dbo].[Title_TitleType] TTT
INNER JOIN dbo.TitleType TT ON TTT.TitleTypeID = TT.TitleTypeID

WHERE
	TTT.[TitleID] = @TitleID 
ORDER BY TT.TitleType

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleIdentifierUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleIdentifierUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleIdentifierUpdateAuto]    Script Date: 10/16/2009 16:28:44 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleIdentifierUpdateAuto PROCEDURE
-- Generated 5/6/2009 3:30:24 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for TitleIdentifier

CREATE PROCEDURE TitleIdentifierUpdateAuto

@TitleIdentifierID INT,
@IdentifierName NVARCHAR(40),
@MarcDataFieldTag NVARCHAR(50),
@MarcSubFieldCode NVARCHAR(50)

AS 

SET NOCOUNT ON

UPDATE [dbo].[TitleIdentifier]

SET

	[IdentifierName] = @IdentifierName,
	[MarcDataFieldTag] = @MarcDataFieldTag,
	[MarcSubFieldCode] = @MarcSubFieldCode

WHERE
	[TitleIdentifierID] = @TitleIdentifierID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleIdentifierUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleIdentifierID],
		[IdentifierName],
		[MarcDataFieldTag],
		[MarcSubFieldCode]

	FROM [dbo].[TitleIdentifier]
	
	WHERE
		[TitleIdentifierID] = @TitleIdentifierID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTagInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTagInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleTagInsertAuto]    Script Date: 10/16/2009 16:28:44 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleTagInsertAuto PROCEDURE
-- Generated 1/18/2008 11:10:47 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for TitleTag

CREATE PROCEDURE TitleTagInsertAuto

@TitleID INT,
@TagText NVARCHAR(50),
@MarcDataFieldTag NVARCHAR(50) = null,
@MarcSubFieldCode NVARCHAR(50) = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[TitleTag]
(
	[TitleID],
	[TagText],
	[MarcDataFieldTag],
	[MarcSubFieldCode],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@TitleID,
	@TagText,
	@MarcDataFieldTag,
	@MarcSubFieldCode,
	getdate(),
	getdate()
)

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleTagInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleID],
		[TagText],
		[MarcDataFieldTag],
		[MarcSubFieldCode],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[TitleTag]
	
	WHERE
		[TitleID] = @TitleID AND
		[TagText] = @TagText
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTagSelectByTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleTagSelectByTitleID]
GO


/****** Object:  StoredProcedure [dbo].[TitleTagSelectByTitleID]    Script Date: 10/16/2009 16:28:45 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleTagSelectByTitleID]
	@TitleID int
AS 

SET NOCOUNT ON

SELECT	TitleID,
		TagText,
		MarcDataFieldTag,
		MarcSubFieldCode,
		CreationDate,
		LastModifiedDate
FROM	dbo.TitleTag
WHERE	TitleID = @TitleID
ORDER BY
		TagText,
		MarcDatafieldTag,
		MarcSubFieldCode

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleInsertAuto]    Script Date: 10/16/2009 16:28:45 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleInsertAuto PROCEDURE
-- Generated 5/19/2009 11:15:05 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for Title

CREATE PROCEDURE TitleInsertAuto

@TitleID INT OUTPUT,
@MARCBibID NVARCHAR(50),
@MARCLeader NVARCHAR(24) = null,
@TropicosTitleID INT = null,
@RedirectTitleID INT = null,
@FullTitle NVARCHAR(2000),
@ShortTitle NVARCHAR(255) = null,
@UniformTitle NVARCHAR(255) = null,
@SortTitle NVARCHAR(60) = null,
@PartNumber NVARCHAR(255) = null,
@PartName NVARCHAR(255) = null,
@CallNumber NVARCHAR(100) = null,
@PublicationDetails NVARCHAR(255) = null,
@StartYear SMALLINT = null,
@EndYear SMALLINT = null,
@Datafield_260_a NVARCHAR(150) = null,
@Datafield_260_b NVARCHAR(255) = null,
@Datafield_260_c NVARCHAR(100) = null,
@InstitutionCode NVARCHAR(10) = null,
@LanguageCode NVARCHAR(10) = null,
@TitleDescription NTEXT = null,
@TL2Author NVARCHAR(100) = null,
@PublishReady BIT,
@RareBooks BIT,
@Note NVARCHAR(255) = null,
@CreationUserID INT = null,
@LastModifiedUserID INT = null,
@OriginalCatalogingSource NVARCHAR(100) = null,
@EditionStatement NVARCHAR(450) = null,
@CurrentPublicationFrequency NVARCHAR(100) = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[Title]
(
	[MARCBibID],
	[MARCLeader],
	[TropicosTitleID],
	[RedirectTitleID],
	[FullTitle],
	[ShortTitle],
	[UniformTitle],
	[SortTitle],
	[PartNumber],
	[PartName],
	[CallNumber],
	[PublicationDetails],
	[StartYear],
	[EndYear],
	[Datafield_260_a],
	[Datafield_260_b],
	[Datafield_260_c],
	[InstitutionCode],
	[LanguageCode],
	[TitleDescription],
	[TL2Author],
	[PublishReady],
	[RareBooks],
	[Note],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID],
	[OriginalCatalogingSource],
	[EditionStatement],
	[CurrentPublicationFrequency]
)
VALUES
(
	@MARCBibID,
	@MARCLeader,
	@TropicosTitleID,
	@RedirectTitleID,
	@FullTitle,
	@ShortTitle,
	@UniformTitle,
	@SortTitle,
	@PartNumber,
	@PartName,
	@CallNumber,
	@PublicationDetails,
	@StartYear,
	@EndYear,
	@Datafield_260_a,
	@Datafield_260_b,
	@Datafield_260_c,
	@InstitutionCode,
	@LanguageCode,
	@TitleDescription,
	@TL2Author,
	@PublishReady,
	@RareBooks,
	@Note,
	getdate(),
	getdate(),
	@CreationUserID,
	@LastModifiedUserID,
	@OriginalCatalogingSource,
	@EditionStatement,
	@CurrentPublicationFrequency
)

SET @TitleID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleID],
		[MARCBibID],
		[MARCLeader],
		[TropicosTitleID],
		[RedirectTitleID],
		[FullTitle],
		[ShortTitle],
		[UniformTitle],
		[SortTitle],
		[PartNumber],
		[PartName],
		[CallNumber],
		[PublicationDetails],
		[StartYear],
		[EndYear],
		[Datafield_260_a],
		[Datafield_260_b],
		[Datafield_260_c],
		[InstitutionCode],
		[LanguageCode],
		[TitleDescription],
		[TL2Author],
		[PublishReady],
		[RareBooks],
		[Note],
		[CreationDate],
		[LastModifiedDate],
		[CreationUserID],
		[LastModifiedUserID],
		[OriginalCatalogingSource],
		[EditionStatement],
		[CurrentPublicationFrequency]	

	FROM [dbo].[Title]
	
	WHERE
		[TitleID] = @TitleID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSimpleSelectByCreator]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSimpleSelectByCreator]
GO


/****** Object:  StoredProcedure [dbo].[TitleSimpleSelectByCreator]    Script Date: 10/16/2009 16:28:45 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleSimpleSelectByCreator]
	@CreatorId	int
AS
SET NOCOUNT ON

SELECT DISTINCT T.TitleID
INTO #tmp_title
FROM dbo.Title T
	INNER JOIN dbo.Title_Creator TC on T.TitleID = TC.TitleID
WHERE 
	PublishReady = 1 AND 
	TC.CreatorID = @CreatorId

SELECT
	T.[TitleID],
	T.[FullTitle],
	CRT.CreatorRoleTypeDescription 
FROM [dbo].[Title_Creator] TC
	INNER JOIN dbo.Title T ON TC.TitleID = T.TitleID
	INNER JOIN dbo.CreatorRoleType CRT ON TC.CreatorRoleTypeID = CRT.CreatorRoleTypeID
WHERE 
	TC.TitleID IN (SELECT TitleID FROM #tmp_title) AND 
	T.PublishReady = 1 AND
	TC.CreatorID = @CreatorID
ORDER BY T.SortTitle

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectByFullTitle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectByFullTitle]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectByFullTitle]    Script Date: 10/16/2009 16:28:45 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleSelectByFullTitle]
@FullTitle NVARCHAR(2000)
AS 

SET NOCOUNT ON

SELECT 
	[TitleID]
FROM [dbo].[Title]
WHERE Title.PublishReady = 1 AND Title.FullTitle = @FullTitle
ORDER BY SortTitle

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleSelectByFullTitle. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociation_TitleIdentifierSelectByTitleAssociationID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociation_TitleIdentifierSelectByTitleAssociationID]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociation_TitleIdentifierSelectByTitleAssociationID]    Script Date: 10/16/2009 16:28:46 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleAssociation_TitleIdentifierSelectByTitleAssociationID]

@TitleAssociationID INT

AS 

SET NOCOUNT ON

SELECT 

	tati.[TitleAssociation_TitleIdentifierID],
	tati.[TitleAssociationID],
	tati.[TitleIdentifierID],
	ti.[IdentifierName],
	tati.[IdentifierValue],
	tati.[CreationDate],
	tati.[LastModifiedDate]

FROM [dbo].[TitleAssociation_TitleIdentifier] tati INNER JOIN [dbo].[TitleIdentifier] ti
		ON tati.TitleIdentifierID = ti.TitleIdentifierID

WHERE
	tati.[TitleAssociationID] = @TitleAssociationID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociation_TitleIdentifierSelectByTitleAssociationID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectByItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectByItem]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectByItem]    Script Date: 10/16/2009 16:28:46 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleSelectByItem]
@ItemID INT
AS
BEGIN

SET NOCOUNT ON;

SELECT	t.MARCBibID, 
		t.TitleID, 
		t.ShortTitle
FROM    Title t INNER JOIN TitleItem ti
			ON t.TitleID = ti.TitleID 
		INNER JOIN Item i
			ON ti.ItemID = i.ItemID
WHERE	i.ItemID = @ItemID

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociationDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociationDeleteAuto]    Script Date: 10/16/2009 16:28:47 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleAssociationDeleteAuto PROCEDURE
-- Generated 8/22/2008 9:43:29 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for TitleAssociation

CREATE PROCEDURE TitleAssociationDeleteAuto

@TitleAssociationID INT

AS 

DELETE FROM [dbo].[TitleAssociation]

WHERE

	[TitleAssociationID] = @TitleAssociationID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociationDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleItemDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleItemDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleItemDeleteAuto]    Script Date: 10/16/2009 16:28:47 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleItemDeleteAuto PROCEDURE
-- Generated 7/10/2008 10:47:22 AM
-- Do not modify the contents of this procedure.
-- Delete Procedure for TitleItem

CREATE PROCEDURE TitleItemDeleteAuto

@TitleItemID INT

AS 

DELETE FROM [dbo].[TitleItem]

WHERE

	[TitleItemID] = @TitleItemID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleItemDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleItemInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleItemInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleItemInsertAuto]    Script Date: 10/16/2009 16:28:47 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleItemInsertAuto PROCEDURE
-- Generated 7/10/2008 10:47:22 AM
-- Do not modify the contents of this procedure.
-- Insert Procedure for TitleItem

CREATE PROCEDURE TitleItemInsertAuto

@TitleItemID INT OUTPUT,
@TitleID INT,
@ItemID INT,
@ItemSequence SMALLINT = null

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[TitleItem]
(
	[TitleID],
	[ItemID],
	[ItemSequence],
	[CreationDate],
	[LastModifiedDate]
)
VALUES
(
	@TitleID,
	@ItemID,
	@ItemSequence,
	getdate(),
	getdate()
)

SET @TitleItemID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleItemInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleItemID],
		[TitleID],
		[ItemID],
		[ItemSequence],
		[CreationDate],
		[LastModifiedDate]	

	FROM [dbo].[TitleItem]
	
	WHERE
		[TitleItemID] = @TitleItemID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationSelectByTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociationSelectByTitleID]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociationSelectByTitleID]    Script Date: 10/16/2009 16:28:48 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleAssociationSelectByTitleID]

@TitleID INT,
@Active BIT = NULL

AS
BEGIN

SET NOCOUNT ON

SELECT	ta.TitleAssociationID,
		ta.TitleID,
		ta.TitleAssociationTypeID,
		tat.TitleAssociationLabel, 
		tat.TitleAssociationName,
		ta.Title,
		ta.Section,
		ta.Volume,
		ta.Heading,
		ta.Publication,
		ta.Relationship,
		ta.AssociatedTitleID,
		ta.Active,
		ta.CreationDate,
		ta.LastModifiedDate
FROM	dbo.TitleAssociation ta INNER JOIN dbo.TitleAssociationType tat
			ON ta.TitleAssociationTypeID = tat.TitleAssociationTypeID
WHERE	ta.TitleID = @TitleID
AND		(ta.Active = @Active OR @Active IS NULL)
ORDER BY
		tat.TitleAssociationLabel, tat.MarcIndicator2, ta.Title, ta.Section, ta.Volume

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectByCreator]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectByCreator]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectByCreator]    Script Date: 10/16/2009 16:28:48 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleSelectByCreator]
@CreatorId	int,
@IncludeSecondaryTitles char(1) = ''
AS
SET NOCOUNT ON

-- Get titles directly associated with the specified creator
SELECT DISTINCT 
		v.TitleID,
		t.FullTitle,
		t.SortTitle,
		ISNULL(t.PartNumber, '') AS PartNumber,
		ISNULL(t.PartName, '') AS PartName,
		t.PublicationDetails,
		i.InstitutionName
FROM	dbo.PrimaryTitleCreatorView v INNER JOIN dbo.Title t
			ON v.TitleID = t.TitleID
		LEFT JOIN dbo.Institution i
			ON t.InstitutionCode = i.InstitutionCode
WHERE	v.CreatorID = @CreatorID
-- Only consider Primary titles unless @IncludeSecondaryTitles = '1'
AND		(v.TitleID IN (SELECT DISTINCT PrimaryTitleID FROM dbo.Item) OR @IncludeSecondaryTitles = 1)
UNION
-- Get primary titles indirectly associated with the specified creator
SELECT DISTINCT
		v.PrimaryTitleID,
		t.FullTitle,
		t.SortTitle,
		ISNULL(t.PartNumber, '') AS PartNumber,
		ISNULL(t.PartName, '') AS PartName,
		t.PublicationDetails,
		i.InstitutionName
FROM	dbo.PrimaryTitleCreatorView v INNER JOIN dbo.Title t
			ON v.PrimaryTitleID = t.TitleID
		LEFT JOIN dbo.Institution i
			ON t.InstitutionCode = i.InstitutionCode
WHERE	CreatorID = @CreatorID
ORDER BY
		t.SortTitle


IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleSelectByCreator. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleItemSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleItemSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleItemSelectAuto]    Script Date: 10/16/2009 16:28:48 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleItemSelectAuto PROCEDURE
-- Generated 7/10/2008 10:47:22 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for TitleItem

CREATE PROCEDURE TitleItemSelectAuto

@TitleItemID INT

AS 

SET NOCOUNT ON

SELECT 

	[TitleItemID],
	[TitleID],
	[ItemID],
	[ItemSequence],
	[CreationDate],
	[LastModifiedDate]

FROM [dbo].[TitleItem]

WHERE
	[TitleItemID] = @TitleItemID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleItemSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationTypeDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociationTypeDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociationTypeDeleteAuto]    Script Date: 10/16/2009 16:28:49 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleAssociationTypeDeleteAuto PROCEDURE
-- Generated 5/6/2009 2:57:04 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for TitleAssociationType

CREATE PROCEDURE TitleAssociationTypeDeleteAuto

@TitleAssociationTypeID INT

AS 

DELETE FROM [dbo].[TitleAssociationType]

WHERE

	[TitleAssociationTypeID] = @TitleAssociationTypeID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociationTypeDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationTypeInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociationTypeInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociationTypeInsertAuto]    Script Date: 10/16/2009 16:28:49 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleAssociationTypeInsertAuto PROCEDURE
-- Generated 5/6/2009 2:57:04 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for TitleAssociationType

CREATE PROCEDURE TitleAssociationTypeInsertAuto

@TitleAssociationTypeID INT OUTPUT,
@TitleAssociationName NVARCHAR(60),
@MARCTag NVARCHAR(20),
@MARCIndicator2 NCHAR(1),
@TitleAssociationLabel NVARCHAR(30)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[TitleAssociationType]
(
	[TitleAssociationName],
	[MARCTag],
	[MARCIndicator2],
	[TitleAssociationLabel]
)
VALUES
(
	@TitleAssociationName,
	@MARCTag,
	@MARCIndicator2,
	@TitleAssociationLabel
)

SET @TitleAssociationTypeID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociationTypeInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleAssociationTypeID],
		[TitleAssociationName],
		[MARCTag],
		[MARCIndicator2],
		[TitleAssociationLabel]	

	FROM [dbo].[TitleAssociationType]
	
	WHERE
		[TitleAssociationTypeID] = @TitleAssociationTypeID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectByDateRangeAndInstitution]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectByDateRangeAndInstitution]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectByDateRangeAndInstitution]    Script Date: 10/16/2009 16:28:49 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleSelectByDateRangeAndInstitution]

@StartDate	int,
@EndDate int,
@InstitutionCode nvarchar(10) = '',
@LanguageCode nvarchar(10) = ''

AS
SET NOCOUNT ON
SELECT DISTINCT 
	T.[TitleID],
	T.[FullTitle],
	T.[PartNumber],
	T.[PartName],
	T.[PublicationDetails],
	T.[StartYear],
	I.InstitutionName
FROM [dbo].[Title] T
	LEFT OUTER JOIN Institution I ON I.InstitutionCode = T.InstitutionCode
	INNER JOIN [dbo].[Item] IT ON [T].[TitleID] = [IT].[PrimaryTitleID]
	LEFT JOIN dbo.TitleLanguage tl ON T.TitleID = tl.TitleID
	LEFT JOIN dbo.ItemLanguage il ON IT.ItemID = il.ItemID
WHERE	T.StartYear BETWEEN @StartDate AND @EndDate 
AND		T.PublishReady=1
AND		(T.InstitutionCode = @InstitutionCode OR 
		IT.InstitutionCode = @InstitutionCode OR 
		@InstitutionCode = '')
AND		(T.LanguageCode = @LanguageCode OR
		IT.LanguageCode = @LanguageCode OR
		 ISNULL(tl.LanguageCode, '') = @LanguageCode OR
		 ISNULL(il.LanguageCode, '') = @LanguageCode OR
		@LanguageCode = '')
ORDER BY T.StartYear

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleSelectByDateRangeAndInstitution. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationTypeSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociationTypeSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociationTypeSelectAuto]    Script Date: 10/16/2009 16:28:50 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleAssociationTypeSelectAuto PROCEDURE
-- Generated 5/6/2009 2:57:04 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for TitleAssociationType

CREATE PROCEDURE TitleAssociationTypeSelectAuto

@TitleAssociationTypeID INT

AS 

SET NOCOUNT ON

SELECT 

	[TitleAssociationTypeID],
	[TitleAssociationName],
	[MARCTag],
	[MARCIndicator2],
	[TitleAssociationLabel]

FROM [dbo].[TitleAssociationType]

WHERE
	[TitleAssociationTypeID] = @TitleAssociationTypeID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociationTypeSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleItemSelectByItem]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleItemSelectByItem]
GO


/****** Object:  StoredProcedure [dbo].[TitleItemSelectByItem]    Script Date: 10/16/2009 16:28:50 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleItemSelectByItem]
@ItemID INT
AS
BEGIN

SET NOCOUNT ON;

SELECT	ti.TitleItemID,
		t.MARCBibID, 
		t.TitleID, 
		t.ShortTitle,
		i.ItemID,
		ti.ItemSequence
FROM    Title t INNER JOIN TitleItem ti
			ON t.TitleID = ti.TitleID 
		INNER JOIN Item i
			ON ti.ItemID = i.ItemID
WHERE	i.ItemID = @ItemID

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleAssociationUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleAssociationUpdateAuto]    Script Date: 10/16/2009 16:28:50 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleAssociationUpdateAuto PROCEDURE
-- Generated 8/22/2008 9:43:29 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for TitleAssociation

CREATE PROCEDURE TitleAssociationUpdateAuto

@TitleAssociationID INT,
@TitleID INT,
@TitleAssociationTypeID INT,
@Title NVARCHAR(500),
@Section NVARCHAR(500),
@Volume NVARCHAR(500),
@Heading NVARCHAR(500),
@Publication NVARCHAR(500),
@Relationship NVARCHAR(500),
@Active BIT,
@AssociatedTitleID INT

AS 

SET NOCOUNT ON

UPDATE [dbo].[TitleAssociation]

SET

	[TitleID] = @TitleID,
	[TitleAssociationTypeID] = @TitleAssociationTypeID,
	[Title] = @Title,
	[Section] = @Section,
	[Volume] = @Volume,
	[Heading] = @Heading,
	[Publication] = @Publication,
	[Relationship] = @Relationship,
	[Active] = @Active,
	[AssociatedTitleID] = @AssociatedTitleID,
	[LastModifiedDate] = getdate()

WHERE
	[TitleAssociationID] = @TitleAssociationID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleAssociationUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleAssociationID],
		[TitleID],
		[TitleAssociationTypeID],
		[Title],
		[Section],
		[Volume],
		[Heading],
		[Publication],
		[Relationship],
		[Active],
		[AssociatedTitleID],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[TitleAssociation]
	
	WHERE
		[TitleAssociationID] = @TitleAssociationID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleBibTeXSelectAllItemCitations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleBibTeXSelectAllItemCitations]
GO


/****** Object:  StoredProcedure [dbo].[TitleBibTeXSelectAllItemCitations]    Script Date: 10/16/2009 16:28:51 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleBibTeXSelectAllItemCitations]
AS
BEGIN

SET NOCOUNT ON

SELECT	'bhlitem' + CONVERT(NVARCHAR(10), i.ItemID) AS CitationKey,
		'http://www.biodiversitylibrary.org/item/' + CONVERT(NVARCHAR(10), i.ItemID) AS Url,
		'http://www.biodiversitylibrary.org/bibliography/' + CONVERT(NVARCHAR(10), t.TitleID) AS Note,
		t.ShortTitle AS Title, ISNULL(t.Datafield_260_a, '') + ISNULL(t.Datafield_260_b, '') AS Publisher,
		CASE WHEN i.Year IS NULL THEN ISNULL(t.Datafield_260_c, '') ELSE i.Year END AS [Year],
		ISNULL(i.Volume, '') AS Volume , ISNULL(i.CopyrightStatus, '') AS CopyrightStatus,
		dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
		dbo.fnCOinSGetPageCountForItem(i.ItemID) AS Pages,
		dbo.fnTagTextStringForTitle(t.TitleID) AS Keywords
FROM	dbo.Title t INNER JOIN dbo.Item i
			ON t.TitleID = i.PrimaryTitleID
WHERE	t.PublishReady = 1
AND		i.ItemStatusID = 40
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleItemSelectByTitle]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleItemSelectByTitle]
GO


/****** Object:  StoredProcedure [dbo].[TitleItemSelectByTitle]    Script Date: 10/16/2009 16:28:51 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleItemSelectByTitle]
@TitleID INT
AS
BEGIN

SET NOCOUNT ON

SELECT	ti.TitleItemID,
		ti.ItemSequence,
		ti.TitleID,
		ti.ItemID,
		i.BarCode,
		i.Volume,
		i.ItemStatusID,
		i.PrimaryTitleID
FROM    dbo.TitleItem ti INNER JOIN dbo.Item i
			ON ti.ItemID = i.ItemID
WHERE	ti.TitleID = @TitleID
ORDER BY
		ti.ItemSequence

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleItemUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleItemUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleItemUpdateAuto]    Script Date: 10/16/2009 16:28:52 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleItemUpdateAuto PROCEDURE
-- Generated 7/10/2008 10:47:22 AM
-- Do not modify the contents of this procedure.
-- Update Procedure for TitleItem

CREATE PROCEDURE TitleItemUpdateAuto

@TitleItemID INT,
@TitleID INT,
@ItemID INT,
@ItemSequence SMALLINT

AS 

SET NOCOUNT ON

UPDATE [dbo].[TitleItem]

SET

	[TitleID] = @TitleID,
	[ItemID] = @ItemID,
	[ItemSequence] = @ItemSequence,
	[LastModifiedDate] = getdate()

WHERE
	[TitleItemID] = @TitleItemID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleItemUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleItemID],
		[TitleID],
		[ItemID],
		[ItemSequence],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[TitleItem]
	
	WHERE
		[TitleItemID] = @TitleItemID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectByAbbreviation]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectByAbbreviation]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectByAbbreviation]    Script Date: 10/16/2009 16:28:52 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleSelectByAbbreviation]
@Abbreviation NVARCHAR(125)
AS 

SET NOCOUNT ON

SELECT 
	[Title].[TitleID]
FROM [dbo].[Title] INNER JOIN [dbo].[Title_TitleIdentifier]
		ON Title.TitleID = Title_TitleIdentifier.TitleID
	INNER JOIN TitleIdentifier
		ON Title_TitleIdentifier.TitleIdentifierID = TitleIdentifier.TitleIdentifierID
WHERE Title.PublishReady = 1 
AND Title_TitleIdentifier.IdentifierValue = @Abbreviation
AND TitleIdentifier.IdentifierName = 'Abbreviation'
ORDER BY SortTitle

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleSelectByAbbreviation. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleEndNoteSelectAllItemCitations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleEndNoteSelectAllItemCitations]
GO


/****** Object:  StoredProcedure [dbo].[TitleEndNoteSelectAllItemCitations]    Script Date: 10/16/2009 16:28:52 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleEndNoteSelectAllItemCitations]
AS
BEGIN

SET NOCOUNT ON

SELECT 	t.TitleID,
		i.ItemID,
		CASE SUBSTRING(t.MarcLeader, 8, 1)
			WHEN 'm' THEN 'Book'	-- monograph
			WHEN 'a' THEN 'Book'	-- monographic part
			WHEN 's' THEN 'Serial'	-- serial
			WHEN 'b' THEN 'Serial'	-- serial part
			WHEN 'c' THEN 'Serial'	-- collection
			ELSE 'Book'
		END AS PublicationType,
		dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
		CASE 
			WHEN ISNULL(i.Year, '') <> '' THEN i.Year
			WHEN ISNULL(CONVERT(NVARCHAR(20), t.StartYear), '') <> '' THEN CONVERT(NVARCHAR(20), t.StartYear)
			ELSE ISNULL(t.Datafield_260_c, '')
		END AS Year,
		t.FullTitle,
		LTRIM(ISNULL(t.PartNumber, '') + ' ' + ISNULL(PartName, '')) AS SecondaryTitle,
		ISNULL(t.Datafield_260_a, '') AS PublisherPlace,
		ISNULL(t.Datafield_260_b, '') AS PublisherName,
		i.Volume,
		t.ShortTitle,
		abbrev.IdentifierValue AS Abbreviation,
		isbn.IdentifierValue AS ISBN,
		CASE WHEN ISNULL(i.CallNumber, '') = '' THEN t.CallNumber ELSE i.CallNumber END AS CallNumber,
		dbo.fnTagTextStringForTitle(t.TitleID) AS Keywords,
		l.LanguageName,
		i.Note
FROM	dbo.Title t LEFT JOIN dbo.Title_TitleIdentifier isbn
			ON t.TitleID = isbn.TitleID
			AND isbn.TitleIdentifierID = 3 -- isbn
		LEFT JOIN dbo.Title_TitleIdentifier abbrev
			ON t.TitleID = abbrev.TitleID
			AND abbrev.TitleIdentifierID = 6 -- abbrev
		INNER JOIN dbo.Item i
			ON t.TitleID = i.PrimaryTitleID
			AND i.ItemStatusID = 40
		LEFT JOIN dbo.Language l
			ON i.LanguageCode = l.LanguageCode
WHERE	PublishReady = 1

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleEndNoteSelectAllTitleCitations]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleEndNoteSelectAllTitleCitations]
GO


/****** Object:  StoredProcedure [dbo].[TitleEndNoteSelectAllTitleCitations]    Script Date: 10/16/2009 16:28:53 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleEndNoteSelectAllTitleCitations]
AS
BEGIN

SET NOCOUNT ON

SELECT 	t.TitleID,
		CASE SUBSTRING(t.MarcLeader, 8, 1)
			WHEN 'm' THEN 'Book'	-- monograph
			WHEN 'a' THEN 'Book'	-- monographic part
			WHEN 's' THEN 'Serial'	-- serial
			WHEN 'b' THEN 'Serial'	-- serial part
			WHEN 'c' THEN 'Serial'	-- collection
			ELSE 'Book'
		END AS PublicationType,
		dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS Authors,
		CASE 
			WHEN ISNULL(t.Datafield_260_c, '') = '' 
			THEN ISNULL(CONVERT(NVARCHAR(20), t.StartYear), '') 
			ELSE ISNULL(t.DataField_260_c, '') 
		END AS Year,
		t.FullTitle,
		ISNULL(t.Datafield_260_a, '') AS PublisherPlace,
		ISNULL(t.Datafield_260_b, '') AS PublisherName,
		t.ShortTitle,
		abbrev.IdentifierValue AS Abbreviation,
		isbn.IdentifierValue AS ISBN,
		t.CallNumber,
		dbo.fnTagTextStringForTitle(t.TitleID) AS Keywords,
		l.LanguageName,
		t.Note,
		t.EditionStatement
FROM	dbo.Title t LEFT JOIN dbo.Title_TitleIdentifier isbn
			ON t.TitleID = isbn.TitleID
			AND isbn.TitleIdentifierID = 3 -- isbn
		LEFT JOIN dbo.Title_TitleIdentifier abbrev
			ON t.TitleID = abbrev.TitleID
			AND abbrev.TitleIdentifierID = 6 -- abbrev
		LEFT JOIN dbo.Language l
			ON t.LanguageCode = l.LanguageCode
WHERE	PublishReady = 1

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleItemUpdateItemSequence]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleItemUpdateItemSequence]
GO


/****** Object:  StoredProcedure [dbo].[TitleItemUpdateItemSequence]    Script Date: 10/16/2009 16:28:53 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleItemUpdateItemSequence]

@TitleID INT,
@ItemID INT,
@ItemSequence SMALLINT

AS 

SET NOCOUNT ON

UPDATE	[dbo].[TitleItem]
SET		[ItemSequence] = @ItemSequence,
		[LastModifiedDate] = GETDATE()
WHERE	[TitleID] = @TitleID
AND		[ItemID] = @ItemID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleItemUpdateItemSequence. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT 

		[TitleItemID],
		[TitleID],
		[ItemID],
		[ItemSequence],
		[CreationDate],
		[LastModifiedDate]

	FROM [dbo].[TitleItem]

	WHERE
		[TitleID] = @TitleID
	AND [ItemID] = @ItemID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleLanguageDeleteAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleLanguageDeleteAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleLanguageDeleteAuto]    Script Date: 10/16/2009 16:28:54 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleLanguageDeleteAuto PROCEDURE
-- Generated 1/7/2009 2:04:17 PM
-- Do not modify the contents of this procedure.
-- Delete Procedure for TitleLanguage

CREATE PROCEDURE TitleLanguageDeleteAuto

@TitleLanguageID INT

AS 

DELETE FROM [dbo].[TitleLanguage]

WHERE

	[TitleLanguageID] = @TitleLanguageID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleLanguageDeleteAuto. No information was deleted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred 
END
ELSE BEGIN
	RETURN 0 -- delete successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectAllWithCreator]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectAllWithCreator]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectAllWithCreator]    Script Date: 10/16/2009 16:28:54 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleSelectAllWithCreator]
@IsPublished	bit = null
AS 

SET NOCOUNT ON
SELECT 

	[TitleID],
	[MARCBibID],
	[MARCLeader],
	[TropicosTitleID],
	[FullTitle],
	[ShortTitle],
	[UniformTitle],
	[SortTitle],
	[PartNumber],
	[PartName],
	[CallNumber],
	[PublicationDetails],
	[StartYear],
	[EndYear],
	[Datafield_260_a],
	[Datafield_260_b],
	[Datafield_260_c],
	[InstitutionCode],
	[LanguageCode],
	[TitleDescription],
	[TL2Author],
	[PublishReady],
	[RareBooks],
	[OriginalCatalogingSource],
	[EditionStatement],
	[CurrentPublicationFrequency],
	[Note],
[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID],
	dbo.fnAuthorStringForTitle(TitleID) as Creators
FROM [dbo].[Title]
WHERE Title.PublishReady = ISNULL(@IsPublished,Title.PublishReady)
ORDER BY SortTitle
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleSelectAllWithCreator. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectAuto]    Script Date: 10/16/2009 16:28:54 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleSelectAuto PROCEDURE
-- Generated 5/19/2009 11:15:05 AM
-- Do not modify the contents of this procedure.
-- Select Procedure for Title

CREATE PROCEDURE TitleSelectAuto

@TitleID INT

AS 

SET NOCOUNT ON

SELECT 

	[TitleID],
	[MARCBibID],
	[MARCLeader],
	[TropicosTitleID],
	[RedirectTitleID],
	[FullTitle],
	[ShortTitle],
	[UniformTitle],
	[SortTitle],
	[PartNumber],
	[PartName],
	[CallNumber],
	[PublicationDetails],
	[StartYear],
	[EndYear],
	[Datafield_260_a],
	[Datafield_260_b],
	[Datafield_260_c],
	[InstitutionCode],
	[LanguageCode],
	[TitleDescription],
	[TL2Author],
	[PublishReady],
	[RareBooks],
	[Note],
	[CreationDate],
	[LastModifiedDate],
	[CreationUserID],
	[LastModifiedUserID],
	[OriginalCatalogingSource],
	[EditionStatement],
	[CurrentPublicationFrequency]

FROM [dbo].[Title]

WHERE
	[TitleID] = @TitleID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleIdentifierSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleIdentifierSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleIdentifierSelectAuto]    Script Date: 10/16/2009 16:28:55 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleIdentifierSelectAuto PROCEDURE
-- Generated 5/6/2009 3:30:24 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for TitleIdentifier

CREATE PROCEDURE TitleIdentifierSelectAuto

@TitleIdentifierID INT

AS 

SET NOCOUNT ON

SELECT 

	[TitleIdentifierID],
	[IdentifierName],
	[MarcDataFieldTag],
	[MarcSubFieldCode]

FROM [dbo].[TitleIdentifier]

WHERE
	[TitleIdentifierID] = @TitleIdentifierID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleIdentifierSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectAll]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectAll]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectAll]    Script Date: 10/16/2009 16:28:55 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[TitleSelectAll]
@IsPublished	bit = null
AS 

SET NOCOUNT ON

SELECT 

	Title.[TitleID],
	Title.[FullTitle]
FROM [dbo].[Title]
WHERE Title.PublishReady = ISNULL(@IsPublished,Title.PublishReady)
ORDER BY SortTitle

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleSelectAll. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleLanguageInsertAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleLanguageInsertAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleLanguageInsertAuto]    Script Date: 10/16/2009 16:28:55 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleLanguageInsertAuto PROCEDURE
-- Generated 1/7/2009 2:04:17 PM
-- Do not modify the contents of this procedure.
-- Insert Procedure for TitleLanguage

CREATE PROCEDURE TitleLanguageInsertAuto

@TitleLanguageID INT OUTPUT,
@TitleID INT,
@LanguageCode NVARCHAR(10)

AS 

SET NOCOUNT ON

INSERT INTO [dbo].[TitleLanguage]
(
	[TitleID],
	[LanguageCode],
	[CreationDate]
)
VALUES
(
	@TitleID,
	@LanguageCode,
	getdate()
)

SET @TitleLanguageID = Scope_Identity()

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleLanguageInsertAuto. No information was inserted as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleLanguageID],
		[TitleID],
		[LanguageCode],
		[CreationDate]	

	FROM [dbo].[TitleLanguage]
	
	WHERE
		[TitleLanguageID] = @TitleLanguageID
	
	RETURN -- insert successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSelectByBarcode]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSelectByBarcode]
GO


/****** Object:  StoredProcedure [dbo].[TitleSelectByBarcode]    Script Date: 10/16/2009 16:28:56 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleSelectByBarcode]
(@Barcode	varchar(50))
AS
BEGIN
	SET NOCOUNT ON;
	SELECT     Title.MARCBibID, Title.TitleID, Title.RareBooks, Item.ItemID, Item.BarCode, Page.PageID, Page.FileNamePrefix, Page.PageDescription, 
                      Page.SequenceOrder, Item.PDFSize, Title.ShortTitle, Item.Volume
	FROM         Title INNER JOIN
                      Item ON Title.TitleID = Item.PrimaryTitleID INNER JOIN
                      Page ON Item.ItemID = Page.ItemID
	WHERE     (Page.SequenceOrder = 1) AND (Item.BarCode = @Barcode)
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleLanguageSelectAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleLanguageSelectAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleLanguageSelectAuto]    Script Date: 10/16/2009 16:28:56 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleLanguageSelectAuto PROCEDURE
-- Generated 1/7/2009 2:04:17 PM
-- Do not modify the contents of this procedure.
-- Select Procedure for TitleLanguage

CREATE PROCEDURE TitleLanguageSelectAuto

@TitleLanguageID INT

AS 

SET NOCOUNT ON

SELECT 

	[TitleLanguageID],
	[TitleID],
	[LanguageCode],
	[CreationDate]

FROM [dbo].[TitleLanguage]

WHERE
	[TitleLanguageID] = @TitleLanguageID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleLanguageSelectAuto. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSearchPaging]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSearchPaging]
GO


/****** Object:  StoredProcedure [dbo].[TitleSearchPaging]    Script Date: 10/16/2009 16:28:57 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[TitleSearchPaging]
	@MARCBibID nvarchar(50),
	@TitleID int,
	@Title nvarchar(60),
	@StartRow int,
	@PageSize int,
	@OrderBy int
AS

SET NOCOUNT ON

DECLARE @SortDirection varchar(4)
IF (@OrderBy >= 0) 
BEGIN
	SET @SortDirection = 'ASC'
END
ELSE 
BEGIN
	SET @SortDirection = 'DESC'
	SELECT @OrderBy = 0 - @OrderBy
END

BEGIN
	--Print 'Building Stored Procedure ' + @spName

	DECLARE @SQL varchar(4000)
	DECLARE @OrderByClause varchar(1000)
	DECLARE @WhereClause varchar(2500)
	DECLARE @WhereItem int

	IF (@OrderBy = 1)
	BEGIN
		SELECT @OrderByClause = ' ORDER BY T.TitleID ' + @SortDirection
	END
	ELSE IF (@OrderBy = 2)
	BEGIN
		SELECT @OrderByClause = ' ORDER BY T.MarcBibID ' + @SortDirection
	END
	ELSE IF (@OrderBy = 3)
	BEGIN
		SELECT @OrderByClause = ' ORDER BY T.SortTitle ' + @SortDirection
	END
	ELSE
	BEGIN
		SELECT @OrderByClause = ' ORDER BY T.SortTitle ' + @SortDirection
	END

	SELECT @OrderByClause = @OrderByClause + ' '

	SET @WhereItem = 0
	SET @WhereClause = 'WHERE '		

-- Build Where clause


	IF @MarcBibID IS NOT NULL 
	BEGIN
		SET @WhereClause = @WhereClause + 'T.MarcBibID COLLATE latin1_general_ci_ai LIKE ''' + @MarcBibID + ''' AND '
	END

	IF @TitleID IS NOT NULL
	BEGIN
		SET @WhereClause = @WhereClause + 'T.TitleID = ' + CONVERT(varchar(10), @TitleID) + ' AND '
	END
	IF @Title IS NOT NULL
	BEGIN
		SET @WhereClause = @WhereClause + 'T.SortTitle COLLATE latin1_general_ci_ai LIKE ''' + @Title + ''' AND '
	END

SET @SQL = 
	' SELECT * FROM
		(
SELECT
	ROW_NUMBER() OVER(' + @OrderByClause + ') AS RowNum,
	T.MARCBibID,
	T.TitleID,
	T.SortTitle
FROM dbo.Title T
'

	SET @Sql = @Sql + @WhereClause
	IF LEN(@WhereClause) > 6 
	BEGIN
		SET @Sql = LEFT(@Sql, LEN(@SQL) - 4 )
	END
	ELSE
	BEGIN
		SET @Sql = LEFT( @Sql, LEN(@Sql) - 6 )
	END

	SET @Sql = @Sql + ') AS TT 
		WHERE TT.RowNum BETWEEN ' + convert(varchar(10), @StartRow) + ' AND ' + convert(varchar(10), @StartRow + @PageSize - 1)

--	Print 'SQL for Stored Procedure: ' + @SQL

	EXEC(@Sql)

END

executeProcedure:

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleSearchCount]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleSearchCount]
GO


/****** Object:  StoredProcedure [dbo].[TitleSearchCount]    Script Date: 10/16/2009 16:28:57 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE Procedure [dbo].[TitleSearchCount]
	@MARCBibID nvarchar(50),
	@TitleID int,
	@Title nvarchar(60)
AS

DECLARE @spName varchar(300) 

SET @spName = 'TitleSearchPaging_AutoGen_'
SET @spName = @spName + CASE COALESCE(@MARCBibID, '0') WHEN '0' THEN '0' ELSE '1' END
SET @spName = @spName + CASE COALESCE(@TitleID, '0') WHEN '0' THEN '0' ELSE '1' END
SET @spName = @spName + CASE COALESCE(@Title, '0') WHEN '0' THEN '0' ELSE '1' END

IF EXISTS (SELECT * from dbo.sysobjects where id = object_id(N'[dbo].' + @spName) and OBJECTPROPERTY(id, N'IsProcedure') = 1)
BEGIN
	--Print 'Skipping to execution of ' + @spName
	GOTO executeProcedure
END
ELSE
BEGIN
	--Print 'Building Stored Procedure ' + @spName
	BEGIN TRAN

	DECLARE @SQL varchar(4000)
	DECLARE @WhereClause varchar(2500)
	DECLARE @WhereItem int

	SET @WhereItem = 0
	SET @WhereClause = 'WHERE '		

	SET @SQL = 'CREATE PROCEDURE [dbo].' + @spName + '
	@MarcBIBID nvarchar(50),
	@TitleID int,
	@Title nvarchar(60)
AS
/******************************************************************************
**		Name: ' + @spName + '
**		Desc: This is an auto generated stored procedure. DO NOT CHANGE
**          Auto generated by TitleSearchCount stored procedure.
**		Date: ' + CONVERT(varchar(30), GetDate()) + '
*******************************************************************************/

SELECT COUNT(*) FROM dbo.Title T '

	IF @MarcBibID IS NOT NULL 
	BEGIN
		SET @WhereClause = @WhereClause + 'T.MarcBibID COLLATE latin1_general_ci_ai LIKE @MarcBibID AND '
	END

	IF @TitleID IS NOT NULL
	BEGIN
		SET @WhereClause = @WhereClause + 'T.TitleID = @TitleID AND '
	END
	IF @Title IS NOT NULL
	BEGIN
		SET @WhereClause = @WhereClause + 'T.SortTitle COLLATE latin1_general_ci_ai LIKE @Title AND '
	END

	SET @Sql = @Sql + @WhereClause
	IF LEN(@WhereClause) > 6 
	BEGIN
		SET @Sql = LEFT(@Sql, LEN(@SQL) - 4 )
	END
	ELSE
	BEGIN
		SET @Sql = LEFT( @Sql, LEN(@Sql) - 6 )
	END

	Print 'SQL for Stored Procedure: ' + @SQL

	EXEC(@Sql)

	SET @Sql = ' GRANT EXEC ON [dbo].' + @spName + ' TO PUBLIC ' + 
	'	GRANT EXEC ON [dbo].' + @spName + ' TO BHLWebUser ' 

	EXEC(@Sql)

	COMMIT

	END

executeProcedure:
	EXEC @spName @MarcBibID, @TitleID, @Title



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleLanguageUpdateAuto]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleLanguageUpdateAuto]
GO


/****** Object:  StoredProcedure [dbo].[TitleLanguageUpdateAuto]    Script Date: 10/16/2009 16:28:57 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

-- TitleLanguageUpdateAuto PROCEDURE
-- Generated 1/7/2009 2:04:17 PM
-- Do not modify the contents of this procedure.
-- Update Procedure for TitleLanguage

CREATE PROCEDURE TitleLanguageUpdateAuto

@TitleLanguageID INT,
@TitleID INT,
@LanguageCode NVARCHAR(10)

AS 

SET NOCOUNT ON

UPDATE [dbo].[TitleLanguage]

SET

	[TitleID] = @TitleID,
	[LanguageCode] = @LanguageCode

WHERE
	[TitleLanguageID] = @TitleLanguageID
		
IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleLanguageUpdateAuto. No information was updated as a result of this request.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	SELECT
	
		[TitleLanguageID],
		[TitleID],
		[LanguageCode],
		[CreationDate]

	FROM [dbo].[TitleLanguage]
	
	WHERE
		[TitleLanguageID] = @TitleLanguageID
	
	RETURN -- update successful
END


GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleLanguageSelectByTitleID]') AND type in (N'P', N'PC'))
DROP PROCEDURE [dbo].[TitleLanguageSelectByTitleID]
GO


/****** Object:  StoredProcedure [dbo].[TitleLanguageSelectByTitleID]    Script Date: 10/16/2009 16:28:58 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[TitleLanguageSelectByTitleID]

@TitleID INT

AS 

SET NOCOUNT ON

SELECT	tl.TitleLanguageID,
		tl.TitleID,
		tl.LanguageCode,
		l.LanguageName,
		tl.CreationDate
FROM	dbo.TitleLanguage tl INNER JOIN dbo.Language l
			ON tl.LanguageCode = l.LanguageCode
WHERE	tl.TitleID = @TitleID

IF @@ERROR <> 0
BEGIN
	-- raiserror will throw a SqlException
	RAISERROR('An error occurred in procedure TitleLanguageSelectByTitleID. No information was selected.', 16, 1)
	RETURN 9 -- error occurred
END
ELSE BEGIN
	RETURN -- select successful
END

GO

