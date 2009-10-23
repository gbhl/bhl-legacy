
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnGetIdentifierForTitle]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnGetIdentifierForTitle]
GO


/****** Object:  UserDefinedFunction [dbo].[fnGetIdentifierForTitle]    Script Date: 10/16/2009 16:23:54 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnGetIdentifierForTitle] 
(
	@TitleID int,
	@IdentifierName nvarchar(40)
)
RETURNS nvarchar(125)
AS 

BEGIN
	DECLARE @IdentifierValue nvarchar(125)
	SET @IdentifierValue = NULL

	SELECT	@IdentifierValue = MIN(tti.IdentifierValue)
	FROM	dbo.Title_TitleIdentifier tti INNER JOIN dbo.TitleIdentifier ti
				ON tti.TitleIdentifierID = ti.TitleIdentifierID
				AND ti.IdentifierName = @IdentifierName
	WHERE	tti.TitleID = @TitleID

	RETURN LTRIM(RTRIM(COALESCE(@IdentifierValue, '')))
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnFilterString]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnFilterString]
GO


/****** Object:  UserDefinedFunction [dbo].[fnFilterString]    Script Date: 10/16/2009 16:23:54 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnFilterString]
(
	@Source VARCHAR(8000),
	@Filter VARCHAR(8000),
	@Replacement CHAR(1)
)
RETURNS VARCHAR(8000)
AS
BEGIN
	/*
	@Source is the string to be filtered
	@Filter is a regular expression identifying the 'valid' characters in the returned string
	@Replacement identifies the character to use to replace 'invalid' characters
	*/
	DECLARE	@Index SMALLINT

	SET	@Index = DATALENGTH(@Source)

	WHILE @Index > 0
		IF SUBSTRING(@Source, @Index, 1) LIKE @Filter
			SET	@Index = @Index - 1
		ELSE
			SELECT	@Source = STUFF(@Source, @Index, 1, @Replacement),
				@Index =  @Index - 1

	RETURN REPLACE(@Source, ' ', '')
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnVolumeStringForTitle]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnVolumeStringForTitle]
GO


/****** Object:  UserDefinedFunction [dbo].[fnVolumeStringForTitle]    Script Date: 10/16/2009 16:23:54 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnVolumeStringForTitle] 
(
	@TitleID int
)
RETURNS nvarchar(1024)
AS 

BEGIN
	
	DECLARE @VolumeString nvarchar(1024)

	DECLARE @CurrentRecord int
	SELECT @CurrentRecord = 1

	SELECT 
		@VolumeString= COALESCE(@VolumeString, '') +
					(CASE WHEN @CurrentRecord = 1 THEN '' ELSE '|' END) +  
						i.Volume,
		@CurrentRecord = @CurrentRecord + 1
	FROM	dbo.Title t INNER JOIN dbo.TitleItem ti
				ON t.TitleID = ti.TitleID
			INNER JOIN dbo.Item i
				ON ti.ItemID = i.ItemID
	WHERE	t.TitleID = @TitleID
	AND		i.ItemStatusID = 40
	ORDER BY
			ti.ItemSequence

	RETURN LTRIM(RTRIM(COALESCE(@VolumeString, '')))
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnTropicosCheckVolumeExists]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnTropicosCheckVolumeExists]
GO


/****** Object:  UserDefinedFunction [dbo].[fnTropicosCheckVolumeExists]    Script Date: 10/16/2009 16:23:55 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnTropicosCheckVolumeExists]
(
	@TitleID int, 
	@Volume nvarchar(20)
)
RETURNS INT
AS
BEGIN

--always check if volume exists even when volume is null/empty
--books will not have a volume
IF(@Volume IS NULL OR @Volume = '')
BEGIN
	IF EXISTS
	(	
		SELECT TOP 1 p.ItemID
		FROM Page p WITH (NOLOCK)
		INNER JOIN Item i WITH (NOLOCK) ON p.ItemID = i.ItemID
		INNER JOIN Title t WITH (NOLOCK) ON i.PrimaryTitleID = t.TitleID
		WHERE t.TitleID = @TitleID AND
			t.PublishReady = 1 AND
			i.ItemStatusID = 40 AND
			(p.Volume IS NULL OR p.Volume = '')
	)
	BEGIN
		RETURN 1
	END
END

IF EXISTS
(	
	SELECT TOP 1 p.ItemID
	FROM Page p
	INNER JOIN Item i WITH (NOLOCK) ON p.ItemID = i.ItemID
	INNER JOIN Title t WITH (NOLOCK) ON i.PrimaryTitleID = t.TitleID
	WHERE t.TitleID = @TitleID AND
		t.PublishReady = 1 AND
		i.ItemStatusID = 40 AND
		p.Volume = @Volume
)
BEGIN
	RETURN 1
END

IF EXISTS
(	
	SELECT TOP 1 p.ItemID
	FROM Page p
	JOIN Item i ON p.ItemID = i.ItemID
	JOIN Title t ON i.PrimaryTitleID = t.TitleID
	WHERE t.TitleID = @TitleID AND
		t.PublishReady = 1 AND
		i.ItemStatusID = 40 AND
		i.Volume = @Volume
)
BEGIN
	RETURN 1
END

IF EXISTS
(	
	SELECT TOP 1 p.ItemID
	FROM Page p
	JOIN Item i ON p.ItemID = i.ItemID
	JOIN Title t ON i.PrimaryTitleID = t.TitleID
	WHERE t.TitleID = @TitleID AND
		t.PublishReady = 1 AND
		i.ItemStatusID = 40 AND
		(
			i.Volume LIKE @Volume + '%' OR
			i.Volume LIKE '%[^0-9]' + @Volume + '%'
		)
)
BEGIN
	RETURN 1
END

RETURN 0

END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnTagTextStringForTitle]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnTagTextStringForTitle]
GO


/****** Object:  UserDefinedFunction [dbo].[fnTagTextStringForTitle]    Script Date: 10/16/2009 16:23:55 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnTagTextStringForTitle] 
(
	@TitleID int
)
RETURNS nvarchar(1024)
AS
BEGIN
	DECLARE @TitleTagString nvarchar(1024)

	SELECT	@TitleTagString = COALESCE(@TitleTagString, '') + TagText + '|'
	FROM	(
			-- Get tags tied indirectly to this title (if it's a primary title)
			SELECT DISTINCT 
					TagText 
			FROM	PrimaryTitleTagView 
			WHERE	PrimaryTitleID = @TitleID
			UNION
			-- Get all tags tied directly to this title
			SELECT DISTINCT 
					TagText 
			FROM	PrimaryTitleTagView 
			WHERE	TitleID = @TitleID
			) X
	ORDER BY 
			TagText ASC

	RETURN LTRIM(RTRIM(COALESCE(@TitleTagString, '')))
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnPageTypeStringForPage]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnPageTypeStringForPage]
GO


/****** Object:  UserDefinedFunction [dbo].[fnPageTypeStringForPage]    Script Date: 10/16/2009 16:23:55 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnPageTypeStringForPage] 
(
	@PageID int
)
RETURNS nvarchar(1024)
AS
BEGIN
	
	DECLARE @PageTypeString nvarchar(1024)
/*
	DECLARE @NumRecords int

	SELECT @NumRecords = COUNT(*)
	FROM Page p
	INNER JOIN Page_PageType ppt ON (p.PageID = ppt.PageID)
	INNER JOIN PageType pt ON (ppt.PageTypeID = pt.PageTypeID)
	WHERE p.PageID = @PageID
*/
	DECLARE @CurrentRecord int
	SELECT @CurrentRecord = 1

	SELECT 
		@PageTypeString = COALESCE(@PageTypeString, '') +
					(CASE WHEN @CurrentRecord = 1 THEN ''
						ELSE ', ' END) + pt.PageTypeName,
		@CurrentRecord = @CurrentRecord + 1
	FROM Page p
	INNER JOIN Page_PageType ppt ON (p.PageID = ppt.PageID)
	INNER JOIN PageType pt ON (ppt.PageTypeID = pt.PageTypeID)
	WHERE p.PageID = @PageID
	--ORDER BY ip.Sequence ASC

	RETURN LTRIM(RTRIM(COALESCE(@PageTypeString, '')))
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnIndicatedPageStringForPage]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnIndicatedPageStringForPage]
GO


/****** Object:  UserDefinedFunction [dbo].[fnIndicatedPageStringForPage]    Script Date: 10/16/2009 16:23:56 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnIndicatedPageStringForPage] 
(
	@PageID int
)
RETURNS nvarchar(1024)
AS
BEGIN
	
	DECLARE @IndicatedPageString nvarchar(1024)
/*
	DECLARE @NumRecords int

	SELECT @NumRecords = COUNT(*)
	FROM Page p
	INNER JOIN IndicatedPage ip ON (p.PageID = ip.PageID)
	WHERE p.PageID = @PageID
*/
	DECLARE @CurrentRecord int
	SELECT @CurrentRecord = 1

	SELECT 
		@IndicatedPageString = COALESCE(@IndicatedPageString, '') +
					(CASE WHEN @CurrentRecord = 1 THEN ''
						ELSE ', ' END) + ip.PagePrefix + ' ' + 
						(CASE WHEN ip.Implied = 1 THEN '[' + ip.PageNumber + ']'
							ELSE ip.PageNumber END),
		@CurrentRecord = @CurrentRecord + 1
	FROM Page p
	INNER JOIN IndicatedPage ip ON (p.PageID = ip.PageID)
	WHERE p.PageID = @PageID
	ORDER BY ip.Sequence ASC

	RETURN LTRIM(RTRIM(COALESCE(@IndicatedPageString, '')))
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAuthorStringForTitle]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnAuthorStringForTitle]
GO


/****** Object:  UserDefinedFunction [dbo].[fnAuthorStringForTitle]    Script Date: 10/16/2009 16:23:56 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnAuthorStringForTitle] 
(
	@TitleID int
)
RETURNS nvarchar(1024)
AS 

BEGIN
	
	DECLARE @AuthorString nvarchar(1024)

	DECLARE @NumRecords int

	SELECT @NumRecords = COUNT(*)
	FROM Title t
	INNER JOIN Title_Creator tc ON (t.titleid = tc.titleid)
	INNER JOIN Creator c ON (tc.CreatorID = c.CreatorID)
	WHERE t.TitleID = @TitleID

	DECLARE @CurrentRecord int
	SELECT @CurrentRecord = 1

	SELECT 
		@AuthorString = COALESCE(@AuthorString, '') +
					(CASE WHEN @CurrentRecord = 1 THEN ''
						ELSE '|' END) +  c.MARCCreator_Full,
		@CurrentRecord = @CurrentRecord + 1
	FROM Title t
	INNER JOIN Title_Creator tc ON (t.titleid = tc.titleid)
	INNER JOIN Creator c ON (tc.CreatorID = c.CreatorID)
	WHERE t.TitleID = @TitleID
	ORDER BY c.CreatorName ASC

	RETURN LTRIM(RTRIM(COALESCE(@AuthorString, '')))
END



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnAssociationStringForTitle]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnAssociationStringForTitle]
GO


/****** Object:  UserDefinedFunction [dbo].[fnAssociationStringForTitle]    Script Date: 10/16/2009 16:23:56 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnAssociationStringForTitle] 
(
	@TitleID int
)
RETURNS nvarchar(1024)
AS 

BEGIN
	
	DECLARE @AssocString nvarchar(1024)

	DECLARE @CurrentRecord int
	SELECT @CurrentRecord = 1

	SELECT 
		@AssocString = COALESCE(@AssocString, '') +
					(CASE WHEN @CurrentRecord = 1 THEN '' ELSE '|' END) +  
						LTRIM(RTRIM(tat.TitleAssociationLabel COLLATE SQL_Latin1_General_CP1_CI_AI)) + ': ' +  
						LTRIM(RTRIM(ta.Title)) + ' ' + LTRIM(RTRIM(ta.Section)) + ' ' + 
						LTRIM(RTRIM(ta.Volume)) + ' ' + LTRIM(RTRIM(ta.Heading)) + ' ' + 
						LTRIM(RTRIM(ta.Publication)) + ' ' + LTRIM(RTRIM(ta.Relationship)),
		@CurrentRecord = @CurrentRecord + 1
	FROM	dbo.TitleAssociation ta INNER JOIN dbo.TitleAssociationType tat
				ON ta.TitleAssociationTypeID = tat.TitleAssociationTypeID
	WHERE	ta.TitleID = @TitleID
	AND		ta.Active = 1
	ORDER BY
			tat.TitleAssociationLabel, tat.MarcIndicator2, ta.Title, ta.Section, ta.Volume

	RETURN LTRIM(RTRIM(COALESCE(@AssocString, '')))
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnContainsSuspectCharacter]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnContainsSuspectCharacter]
GO


/****** Object:  UserDefinedFunction [dbo].[fnContainsSuspectCharacter]    Script Date: 10/16/2009 16:23:57 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnContainsSuspectCharacter] 
(

	-- Add the parameters for the function here
	@Title NVARCHAR(2000)
)
RETURNS int
AS
/*
	Test with:
	SELECT	CHAR(dbo.fnContainsSuspectCharacter(FullTitle)) as SuspectCharacter, 
			TitleID, 
			FullTitle
	FROM	Title
	WHERE	dbo.fnContainsSuspectCharacter(FullTitle) > 0
*/
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	DECLARE @TitleLen int
	DECLARE @Count int
	DECLARE	@AsciiValue int
	SET @TitleLen = LEN(@Title)
	SET @Count = 1
	SET @Result = 0

	IF (@TitleLen > 0)
	BEGIN
		-- Add the T-SQL statements to compute the return value here
		WHILE (@Count <= @TitleLen AND @Result = 0)
		BEGIN
			SET @AsciiValue = ASCII(SUBSTRING(@Title, @Count, 1))
			IF (
				@AsciiValue BETWEEN 0 AND 31 OR 
				@AsciiValue BETWEEN 127 AND 167 OR 
				@AsciiValue BETWEEN 169 AND 179 OR 
				@AsciiValue BETWEEN 181 AND 191 OR 
				@AsciiValue > 255
			   ) SET @Result = @AsciiValue
			SET @Count = @Count + 1
		END
	END

	-- Return the result of the function
	RETURN @Result
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnContainsDiacritic]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnContainsDiacritic]
GO


/****** Object:  UserDefinedFunction [dbo].[fnContainsDiacritic]    Script Date: 10/16/2009 16:23:57 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[fnContainsDiacritic] 
(
	-- Add the parameters for the function here
	@Title NVARCHAR(2000)
)
RETURNS int
AS
/*
	Test with:
	SELECT	CHAR(dbo.fnContainsDiacritic(FullTitle)) as DiacriticCharacter, 
			TitleID, 
			FullTitle
	FROM	Title
	WHERE	dbo.fnContainsDiacritic(FullTitle) > 0
*/
BEGIN
	-- Declare the return variable here
	DECLARE @Result int

	DECLARE @TitleLen int
	DECLARE @Count int
	DECLARE	@AsciiValue int
	SET @TitleLen = LEN(@Title)
	SET @Count = 1
	SET @Result = 0

	IF (@TitleLen > 0)
	BEGIN
		-- Add the T-SQL statements to compute the return value here
		WHILE (@Count <= @TitleLen AND @Result = 0)
		BEGIN
			SET @AsciiValue = ASCII(SUBSTRING(@Title, @Count, 1))
			IF @AsciiValue BETWEEN 192 AND 255 SET @Result = @AsciiValue
			SET @Count = @Count + 1
		END
	END

	-- Return the result of the function
	RETURN @Result
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnCOinSGetPageCountForItem]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnCOinSGetPageCountForItem]
GO


/****** Object:  UserDefinedFunction [dbo].[fnCOinSGetPageCountForItem]    Script Date: 10/16/2009 16:23:58 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnCOinSGetPageCountForItem] 
(
	@ItemID int
)
RETURNS int
AS 

BEGIN
	DECLARE @PageCount int
	SET @PageCount = 0

	SELECT	@PageCount = COUNT(p.PageID)
	FROM	dbo.Page p LEFT JOIN dbo.Page_PageType ppt
				ON p.PageID = ppt.PageID
			LEFT JOIN dbo.PageType pt
				ON ppt.PageTypeID = pt.PageTypeID
				AND PageTypeName <> 'Cover'
	WHERE	p.ItemID = @ItemID

	RETURN COALESCE(@PageCount, 0)
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnCOinSGetFirstAuthorNameForTitle]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnCOinSGetFirstAuthorNameForTitle]
GO


/****** Object:  UserDefinedFunction [dbo].[fnCOinSGetFirstAuthorNameForTitle]    Script Date: 10/16/2009 16:23:58 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnCOinSGetFirstAuthorNameForTitle] 
(
	@TitleID int,
	@CreatorRoleType nvarchar(25)
)
RETURNS nvarchar(255)
AS 

BEGIN
	DECLARE @CreatorName nvarchar(255)
	DECLARE @CreatorRole nvarchar(25)
	SET @CreatorName = NULL

	/*
	SELECT	@CreatorName = MIN(c.CreatorName)
	FROM	dbo.Title_Creator tc INNER JOIN dbo.Creator c
				ON tc.CreatorID = c.CreatorID
			INNER JOIN dbo.CreatorRoleType crt
				ON tc.CreatorRoleTypeID = crt.CreatorRoleTypeID
				AND crt.CreatorRoleType = @CreatorRoleType
	WHERE	tc.TitleID = @TitleID
	*/

	SELECT TOP 1 @CreatorName = c.CreatorName, @CreatorRole = crt.CreatorRoleType
	FROM	dbo.Title_Creator tc INNER JOIN dbo.Creator c
				ON tc.CreatorID = c.CreatorID
			INNER JOIN dbo.CreatorRoleType crt
				ON tc.CreatorRoleTypeID = crt.CreatorRoleTypeID
	WHERE	tc.TitleID = @TitleID
	ORDER BY crt.CreatorRoleType, c.CreatorName

	IF (@CreatorRoleType = '100' AND @CreatorRole NOT IN ('100', '700')) SET @CreatorName = ''
	IF (@CreatorRoleType = '110' AND @CreatorRole NOT IN ('110', '710')) SET @CreatorName = ''

	RETURN LTRIM(RTRIM(COALESCE(@CreatorName, '')))
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnCOinSAuthorStringForTitle]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnCOinSAuthorStringForTitle]
GO


/****** Object:  UserDefinedFunction [dbo].[fnCOinSAuthorStringForTitle]    Script Date: 10/16/2009 16:23:58 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnCOinSAuthorStringForTitle] 
(
	@TitleID int,
	@IsDC bit
)
RETURNS nvarchar(MAX)
AS 

BEGIN
	DECLARE @AuthorString nvarchar(MAX)
	DECLARE @CreatorName nvarchar(255)
	DECLARE @CurrentRecord int
	SET @CurrentRecord = 1
	SET @CreatorName = NULL

	/*
	IF @IsDC = 0
	BEGIN
		SET @CreatorName = dbo.fnCOinSGetFirstAuthorNameForTitle(@TitleID, '100')
		IF @CreatorName IS NULL SET @CreatorName = dbo.fnCOinSGetFirstAuthorNameForTitle(@TitleID, '110')
	END
	*/

	SELECT	@AuthorString = COALESCE(@AuthorString, '') +
					(CASE WHEN @CurrentRecord = 1 THEN '' ELSE '|' END) +  c.CreatorName,
			@CurrentRecord = @CurrentRecord + 1
	FROM	Title t INNER JOIN Title_Creator tc 
				ON (t.titleid = tc.titleid)
			INNER JOIN Creator c 
				ON (tc.CreatorID = c.CreatorID)
			INNER JOIN CreatorRoleType crt
				ON tc.CreatorRoleTypeID = crt.CreatorRoleTypeID
	WHERE	t.TitleID = @TitleID
	-- Don't include 'first' creator name if selecting for Dublin Core COinS
	--AND		c.CreatorName <> ISNULL(@CreatorName, '')
	ORDER BY crt.CreatorRoleType, c.CreatorName ASC

	RETURN LTRIM(RTRIM(COALESCE(@AuthorString, '')))
END

GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fn_Split]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fn_Split]
GO


/****** Object:  UserDefinedFunction [dbo].[fn_Split]    Script Date: 10/16/2009 16:23:59 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE function [dbo].[fn_Split](
 @String nvarchar (4000),
 @Delimiter nvarchar (10)
 )
returns @ValueTable table ([Value] nvarchar(4000))
begin
 declare @NextString nvarchar(4000)
 declare @Pos int
 declare @NextPos int
 declare @CommaCheck nvarchar(1)
 
 --Initialize
 set @NextString = ''
 set @CommaCheck = right(@String,1) 
 
 --Check for trailing Comma, if not exists, INSERT
 --if (@CommaCheck <> @Delimiter )
 set @String = @String + @Delimiter
 
 --Get position of first Comma
 set @Pos = charindex(@Delimiter,@String)
 set @NextPos = 1
 
 --Loop while there is still a comma in the String of levels
 while (@pos <>  0)  
 begin
  set @NextString = substring(@String,1,@Pos - 1)
 
  insert into @ValueTable ( [Value]) Values (@NextString)
 
  set @String = substring(@String,@pos +1,len(@String))
  
  set @NextPos = @Pos
  set @pos  = charindex(@Delimiter,@String)
 end
 
 return
end



GO


IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[fnSplitLanguage]') AND type in (N'FN', N'IF', N'TF', N'FS', N'FT'))
DROP FUNCTION [dbo].[fnSplitLanguage]
GO


/****** Object:  UserDefinedFunction [dbo].[fnSplitLanguage]    Script Date: 10/16/2009 16:23:59 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION [dbo].[fnSplitLanguage](@MarcId int)
	RETURNS @languages TABLE (LanguageCode nvarchar(10))
AS
BEGIN
	
DECLARE @langs varchar(50)
SET @langs = ''

-- Get a single string listing all languages for the item
-- i.e. EngGerLatFre
-- This might be the way that languages are stored in the 
-- MARC 41 record, so we just concatenate all MARC 41
-- records for an item to get the full list of languages.
SELECT	@langs = @langs + COALESCE(SubFieldValue, '')
FROM	vwMarcDataField
WHERE	DataFieldTag = '041'
AND		Code IN ('a', 'b')
AND		MarcID = @MarcId

-- Parse each individual language code into the return table.
DECLARE	@pos smallint
SET @pos = 1
WHILE @pos < LEN(@langs) 
BEGIN 
	INSERT	@languages (LanguageCode)
	VALUES	(SUBSTRING(@langs, @pos, 3))

	SET @pos = @pos + 3
END 

RETURN 

END

GO

