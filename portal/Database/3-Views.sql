IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PrimaryTitleCreatorView]'))
DROP VIEW [dbo].[PrimaryTitleCreatorView]
GO


/****** Object:  View [dbo].[PrimaryTitleCreatorView]    Script Date: 10/16/2009 16:20:34 ******/
CREATE VIEW [dbo].[PrimaryTitleCreatorView]
AS
SELECT	i.PrimaryTitleID, i.ItemID, 
		i.InstitutionCode AS ItemInstitutionCode, 
		i.LanguageCode AS ItemLanguageCode,
		t.TitleID, 
		t.InstitutionCode AS TitleInstitutionCode,
		t.LanguageCode AS TitleLanguageCode,
		t.PublishReady,
		c.CreatorID,
		c.CreatorName, c.DOB, c.DOD, c.MARCDataFieldTag,
		c.MARCCreator_a, c.MARCCreator_b, c.MARCCreator_c,
		c.MARCCreator_d, c.MARCCreator_Full, c.CreationDate,
		c.LastModifiedDate
FROM	dbo.Item i INNER JOIN dbo.TitleItem ti
			ON i.ItemID = ti.ItemID
		INNER JOIN dbo.Title t
			ON ti.TitleID = t.TitleID
		INNER JOIN dbo.Title_Creator tc
			ON t.TitleID = tc.TitleID
		INNER JOIN dbo.Creator c
			ON tc.CreatorID = c.CreatorID

GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PageTitleSummaryView]'))
DROP VIEW [dbo].[PageTitleSummaryView]
GO


/****** Object:  View [dbo].[PageTitleSummaryView]    Script Date: 10/16/2009 16:20:35 ******/
CREATE VIEW [dbo].[PageTitleSummaryView]
AS
/*
 7/8/2008
 This view differs from the PageSummaryView in how titles are joined to items.
 This view shows ALL titles associated with each item.  PageSummaryView shows
 only the "primary" title associated with each item.

 The columns included in each view are the same.
 */
SELECT	-- Title
		dbo.Title.MARCBibID, dbo.Title.TitleID, dbo.Title.FullTitle, dbo.Title.RareBooks, 
		dbo.Title.ShortTitle, dbo.Title.SortTitle, dbo.Title.PartNumber, dbo.Title.PartName,
		-- Item
		dbo.Item.ItemStatusID, dbo.Item.ItemID, dbo.Item.BarCode, 
		dbo.Item.PDFSize, dbo.Item.Volume, dbo.Item.FileRootFolder,
		-- TitleItem
		dbo.TitleItem.ItemSequence,
		-- Page
		dbo.Page.PageID, dbo.Page.FileNamePrefix, dbo.Page.PageDescription, dbo.Page.SequenceOrder, 
		dbo.Page.Illustration, dbo.Page.Active, dbo.Page.ExternalURL, dbo.Page.AltExternalURL, 
		-- Vault
		dbo.Vault.WebVirtualDirectory, dbo.Vault.OCRFolderShare,
		-- ItemSource
		dbo.ItemSource.DownloadUrl,
		dbo.ItemSource.ImageServerUrlFormat
FROM	dbo.Vault 
		INNER JOIN dbo.Item ON dbo.Vault.VaultID = dbo.Item.VaultID 
		INNER JOIN dbo.TitleItem ON dbo.Item.ItemID = dbo.TitleItem.ItemID
		INNER JOIN dbo.Title ON dbo.Title.TitleID = dbo.TitleItem.TitleID 
		INNER JOIN dbo.Page ON dbo.Item.ItemID = dbo.Page.ItemID 
		INNER JOIN dbo.ItemSource ON dbo.Item.ItemSourceID = dbo.ItemSource.ItemSourceID

GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PageSummaryView]'))
DROP VIEW [dbo].[PageSummaryView]
GO


/****** Object:  View [dbo].[PageSummaryView]    Script Date: 10/16/2009 16:20:36 ******/
CREATE VIEW [dbo].[PageSummaryView]
AS
/*
 7/8/2008
 This view differs from the PageTitleSummaryView in how titles are joined to 
 items.  This view shows only the "primary" title associated with each item.
 PageTitleSummaryView shows ALL titles associated with each item.  

 The columns included in each view are the same.
 */
SELECT	-- Title
		dbo.Title.MARCBibID, dbo.Title.TitleID, dbo.Title.FullTitle, dbo.Title.RareBooks, 
		dbo.Title.ShortTitle, dbo.Title.SortTitle, dbo.Title.PartNumber, dbo.Title.PartName,
		-- Item
		dbo.Item.ItemStatusID, dbo.Item.ItemID, dbo.Item.BarCode, 
		dbo.Item.PDFSize, dbo.Item.Volume, dbo.Item.FileRootFolder,
		-- TitleItem
		dbo.TitleItem.ItemSequence,
		-- Page
		dbo.Page.PageID, dbo.Page.FileNamePrefix, dbo.Page.PageDescription, dbo.Page.SequenceOrder, dbo.Page.Illustration, 
		dbo.Page.Active, dbo.Page.ExternalURL, dbo.Page.AltExternalURL, 
		-- Vault
		dbo.Vault.WebVirtualDirectory, dbo.Vault.OCRFolderShare, 
		-- ItemSource
		dbo.ItemSource.DownloadUrl,
		dbo.ItemSource.ImageServerUrlFormat
FROM	dbo.Vault 
		INNER JOIN dbo.Item ON dbo.Vault.VaultID = dbo.Item.VaultID 
		INNER JOIN dbo.Title ON dbo.Title.TitleID = dbo.Item.PrimaryTitleID 
		INNER JOIN dbo.TitleItem ON dbo.Item.ItemID = dbo.TitleItem.ItemID 
					AND dbo.Item.PrimaryTitleID = dbo.TitleItem.TitleID 
		INNER JOIN dbo.Page ON dbo.Item.ItemID = dbo.Page.ItemID 
		INNER JOIN dbo.ItemSource ON dbo.Item.ItemSourceID = dbo.ItemSource.ItemSourceID

GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PrimaryTitleTagView]'))
DROP VIEW [dbo].[PrimaryTitleTagView]
GO


/****** Object:  View [dbo].[PrimaryTitleTagView]    Script Date: 10/16/2009 16:20:36 ******/
CREATE VIEW [dbo].[PrimaryTitleTagView]
AS
SELECT	i.PrimaryTitleID,
		i.ItemID, 
		i.InstitutionCode AS ItemInstitutionCode, 
		i.LanguageCode AS ItemLanguageCode,
		t.TitleID, 
		t.InstitutionCode AS TitleInstitutionCode,
		t.LanguageCode AS TitleLanguageCode,
		t.PublishReady,
		tt.TagText, tt.MarcDataFieldTag, tt.MarcSubFieldCode, 
		tt.CreationDate, tt.LastModifiedDate
FROM	dbo.Item i INNER JOIN dbo.TitleItem ti
			ON i.ItemID = ti.ItemID
		INNER JOIN dbo.Title t
			ON ti.TitleID = t.TitleID
		INNER JOIN dbo.TitleTag tt
			ON t.TitleID = tt.TitleID

GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[PageDetailView]'))
DROP VIEW [dbo].[PageDetailView]
GO


/****** Object:  View [dbo].[PageDetailView]    Script Date: 10/16/2009 16:20:37 ******/
CREATE VIEW [dbo].[PageDetailView]  
 AS 
SELECT  [dbo].[Page].[PageID],  
		[dbo].[Item].[ItemStatusID],  
		[dbo].[Page].[Active],  
		[dbo].[Page].[SequenceOrder],  
		[dbo].[Item].[ItemID],  
		[dbo].[Item].[Volume],
		[dbo].[Title].[TitleID],
		[dbo].[Title].[MARCBibID],
		[dbo].[Title].[ShortTitle],
		[dbo].[Title].[SortTitle],
		count_big(*) AS NumPages
FROM	[dbo].[Title],  
		[dbo].[Item],  
		[dbo].[Page]   
WHERE	[dbo].[Title].[TitleID] = [dbo].[Item].[PrimaryTitleID]  
AND		[dbo].[Item].[ItemID] = [dbo].[Page].[ItemID]  
GROUP BY  
		[dbo].[Page].[PageID],  
		[dbo].[Item].[ItemStatusID],  
		[dbo].[Page].[Active],  
		[dbo].[Page].[SequenceOrder],  
		[dbo].[Item].[ItemID],  
		[dbo].[Item].[Volume],  
		[dbo].[Title].[TitleID],  
		[dbo].[Title].[MARCBibID],  
		[dbo].[Title].[ShortTitle],  
		[dbo].[Title].[SortTitle]

GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[ItemCOinSView]'))
DROP VIEW [dbo].[ItemCOinSView]
GO


/****** Object:  View [dbo].[ItemCOinSView]    Script Date: 10/16/2009 16:20:38 ******/
CREATE VIEW [dbo].[ItemCOinSView]
AS
SELECT DISTINCT 
		t.TitleID
		,i.ItemID
		,dbo.fnGetIdentifierForTitle(t.TitleID, 'DLC') AS 'lccn' -- id for book/journal/dc
		,REPLACE(dbo.fnGetIdentifierForTitle(t.TitleID, 'OCLC'), 'ocm', '') AS 'oclc' -- id for book/journal/dc
		,t.FullTitle AS 'rft_title' -- book (btitle)/journal(jtitle)/dc
		,dbo.fnGetIdentifierForTitle(t.TitleID, 'Abbreviation') AS 'rft_stitle' -- journal
		,ISNULL(i.Volume, '') AS 'rft_volume' -- journal
		,ISNULL(LOWER(t.LanguageCode), '') AS 'rft_language' -- dc
		,dbo.fnGetIdentifierForTitle(t.TitleID, 'ISBN') AS 'rft_isbn' -- book/journal
		,CASE WHEN CHARINDEX(',', dbo.fnCOinSGetFirstAuthorNameForTitle(t.TitleID, '100')) > 0
			THEN LTRIM(SUBSTRING(dbo.fnCOinSGetFirstAuthorNameForTitle(t.TitleID, '100'), 1, CHARINDEX(',', dbo.fnCOinSGetFirstAuthorNameForTitle(t.TitleID, '100')) - 1))
			ELSE ISNULL(dbo.fnCOinSGetFirstAuthorNameForTitle(t.TitleID, '100'), '')
		END AS 'rft_aulast' -- book/journal
		,CASE WHEN CHARINDEX(',', dbo.fnCOinSGetFirstAuthorNameForTitle(t.TitleID, '100')) > 0
			THEN LTRIM(REPLACE(SUBSTRING(dbo.fnCOinSGetFirstAuthorNameForTitle(t.TitleID, '100'), CHARINDEX(',', dbo.fnCOinSGetFirstAuthorNameForTitle(t.TitleID, '100')), LEN(dbo.fnCOinSGetFirstAuthorNameForTitle(t.TitleID, '100')) - CHARINDEX(',', dbo.fnCOinSGetFirstAuthorNameForTitle(t.TitleID, '100')) + 1), ',', ''))
			ELSE ''
		END AS 'rft_aufirst' -- book/journal
		,dbo.fnCOinSAuthorStringForTitle(t.TitleID, 0) AS 'rft_au_BOOK' -- book/journal
		,dbo.fnCOinSAuthorStringForTitle(t.TitleID, 1) AS 'rft_au_DC' -- dc
		,dbo.fnCOinSGetFirstAuthorNameForTitle(t.TitleID, '110') AS 'rft_aucorp' -- book/journal
		,ISNULL(t.Datafield_260_a, '') AS 'rft_place' -- book
		,ISNULL(t.Datafield_260_b, '') AS 'rft_pub' -- book
		,ISNULL(t.Datafield_260_b, '') AS 'rft_publisher' -- dc
		,ISNULL(i.Year, '') AS 'rft_date_ITEM' -- book/journal/dc
		,ISNULL(CONVERT(nvarchar(20), t.StartYear), '') AS 'rft_date_TITLE' -- book/journal/dc
		,ISNULL(t.EditionStatement, '') AS 'rft_edition' -- book
		-- Need to use rft_pages, not rft_tpages???
		-- http://forums.zotero.org/discussion/4292/coins-issues/
		,dbo.fnCOinSGetPageCountForItem (i.ItemID) AS 'rft_tpages' -- book/journal
		,dbo.fnGetIdentifierForTitle(t.TitleID, 'ISSN') AS 'rft_issn' -- book/journal
		,dbo.fnGetIdentifierForTitle(t.TitleID, 'CODEN') AS 'rft_coden' -- journal
		,dbo.fnTagTextStringForTitle(t.TitleID) AS 'rft_subject' -- dc
		,inst.InstitutionName AS 'rft_contributor_ITEM' -- dc
		,inst2.InstitutionName AS 'rft_contributor_TITLE' -- dc
		,CASE WHEN SUBSTRING(t.MARCLeader, 8, 1) IN ('s','b') THEN 'journal'
			WHEN SUBSTRING(t.MARCLeader, 8, 1) IN ('a','m') THEN 'book'
			ELSE 'unknown' END AS 'rft_genre' -- book/journal/dc
FROM	dbo.Title t INNER JOIN dbo.TitleItem ti
			ON t.TitleID = ti.TitleID
		INNER JOIN dbo.Item i
			ON ti.ItemID = i.ItemID
		LEFT JOIN dbo.Institution inst
			ON i.InstitutionCode = inst.InstitutionCode
		LEFT JOIN dbo.Institution inst2
			ON t.InstitutionCode = inst2.InstitutionCode
WHERE	t.PublishReady = 1
AND		i.ItemStatusID = 40


GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vwMarcControl]'))
DROP VIEW [dbo].[vwMarcControl]
GO


/****** Object:  View [dbo].[vwMarcControl]    Script Date: 10/16/2009 16:20:39 ******/
CREATE VIEW [dbo].[vwMarcControl]
AS
SELECT	m.MarcImportBatchID,
		m.MarcFileLocation,
		m.InstitutionCode,
		m.MarcID, 
		m.Leader, 
		c.MarcControlID, 
		c.Tag, 
		c.Value 
FROM	Marc m LEFT JOIN MarcControl c
			ON m.marcid = c.marcid

GO


IF  EXISTS (SELECT * FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vwMarcDataField]'))
DROP VIEW [dbo].[vwMarcDataField]
GO


/****** Object:  View [dbo].[vwMarcDataField]    Script Date: 10/16/2009 16:20:40 ******/
CREATE VIEW [dbo].[vwMarcDataField]
AS
SELECT	m.MarcImportBatchID,
		m.MarcFileLocation,
		m.InstitutionCode,
		m.MarcID,
		d.MarcDataFieldID,
		s.MarcSubFieldID,
		d.Tag AS DataFieldTag,
		d.Indicator1,
		d.Indicator2,
		s.Code,
		s.[Value] AS SubFieldValue
FROM	Marc m LEFT JOIN MarcDataField d
			ON m.marcid = d.marcid
		LEFT JOIN MarcSubField s
			ON d.marcdatafieldid = s.marcdatafieldid

GO

