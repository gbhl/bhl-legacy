/****** Object:  ForeignKey [IndicatedPage_FK00]    Script Date: 09/29/2009 09:01:38 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[IndicatedPage_FK00]') AND parent_object_id = OBJECT_ID(N'[dbo].[IndicatedPage]'))
ALTER TABLE [dbo].[IndicatedPage] DROP CONSTRAINT [IndicatedPage_FK00]
GO
/****** Object:  ForeignKey [FK_Item_Institution]    Script Date: 09/29/2009 09:02:02 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_Institution]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item] DROP CONSTRAINT [FK_Item_Institution]
GO
/****** Object:  ForeignKey [FK_Item_ItemSource]    Script Date: 09/29/2009 09:02:02 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_ItemSource]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item] DROP CONSTRAINT [FK_Item_ItemSource]
GO
/****** Object:  ForeignKey [FK_Item_ItemStatus]    Script Date: 09/29/2009 09:02:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_ItemStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item] DROP CONSTRAINT [FK_Item_ItemStatus]
GO
/****** Object:  ForeignKey [FK_Item_Language]    Script Date: 09/29/2009 09:02:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_Language]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item] DROP CONSTRAINT [FK_Item_Language]
GO
/****** Object:  ForeignKey [FK_Item_PaginationStatus]    Script Date: 09/29/2009 09:02:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_PaginationStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item] DROP CONSTRAINT [FK_Item_PaginationStatus]
GO
/****** Object:  ForeignKey [FK_Item_Title]    Script Date: 09/29/2009 09:02:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item] DROP CONSTRAINT [FK_Item_Title]
GO
/****** Object:  ForeignKey [FK_Item_Vault]    Script Date: 09/29/2009 09:02:03 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_Vault]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item] DROP CONSTRAINT [FK_Item_Vault]
GO
/****** Object:  ForeignKey [FK_ItemLanguage_Item]    Script Date: 09/29/2009 09:02:05 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemLanguage_Item]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemLanguage]'))
ALTER TABLE [dbo].[ItemLanguage] DROP CONSTRAINT [FK_ItemLanguage_Item]
GO
/****** Object:  ForeignKey [FK_ItemLanguage_Language]    Script Date: 09/29/2009 09:02:05 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemLanguage_Language]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemLanguage]'))
ALTER TABLE [dbo].[ItemLanguage] DROP CONSTRAINT [FK_ItemLanguage_Language]
GO
/****** Object:  ForeignKey [Page_FK00]    Script Date: 09/29/2009 09:02:56 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Page_FK00]') AND parent_object_id = OBJECT_ID(N'[dbo].[Page]'))
ALTER TABLE [dbo].[Page] DROP CONSTRAINT [Page_FK00]
GO
/****** Object:  ForeignKey [Page_FK02]    Script Date: 09/29/2009 09:02:56 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Page_FK02]') AND parent_object_id = OBJECT_ID(N'[dbo].[Page]'))
ALTER TABLE [dbo].[Page] DROP CONSTRAINT [Page_FK02]
GO
/****** Object:  ForeignKey [Page_PageType_FK00]    Script Date: 09/29/2009 09:03:01 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Page_PageType_FK00]') AND parent_object_id = OBJECT_ID(N'[dbo].[Page_PageType]'))
ALTER TABLE [dbo].[Page_PageType] DROP CONSTRAINT [Page_PageType_FK00]
GO
/****** Object:  ForeignKey [Page_PageType_FK01]    Script Date: 09/29/2009 09:03:02 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Page_PageType_FK01]') AND parent_object_id = OBJECT_ID(N'[dbo].[Page_PageType]'))
ALTER TABLE [dbo].[Page_PageType] DROP CONSTRAINT [Page_PageType_FK01]
GO
/****** Object:  ForeignKey [FK_PageName_Page]    Script Date: 09/29/2009 09:03:09 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PageName_Page]') AND parent_object_id = OBJECT_ID(N'[dbo].[PageName]'))
ALTER TABLE [dbo].[PageName] DROP CONSTRAINT [FK_PageName_Page]
GO
/****** Object:  ForeignKey [FK_PDF_Item]    Script Date: 09/29/2009 09:03:26 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PDF_Item]') AND parent_object_id = OBJECT_ID(N'[dbo].[PDF]'))
ALTER TABLE [dbo].[PDF] DROP CONSTRAINT [FK_PDF_Item]
GO
/****** Object:  ForeignKey [FK_PDF_PDFStatus]    Script Date: 09/29/2009 09:03:26 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PDF_PDFStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[PDF]'))
ALTER TABLE [dbo].[PDF] DROP CONSTRAINT [FK_PDF_PDFStatus]
GO
/****** Object:  ForeignKey [FK_PDFPage_PDF]    Script Date: 09/29/2009 09:03:28 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PDFPage_PDF]') AND parent_object_id = OBJECT_ID(N'[dbo].[PDFPage]'))
ALTER TABLE [dbo].[PDFPage] DROP CONSTRAINT [FK_PDFPage_PDF]
GO
/****** Object:  ForeignKey [FK_Title_Title]    Script Date: 09/29/2009 09:03:44 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Title_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title]'))
ALTER TABLE [dbo].[Title] DROP CONSTRAINT [FK_Title_Title]
GO
/****** Object:  ForeignKey [Title_FK00]    Script Date: 09/29/2009 09:03:44 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_FK00]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title]'))
ALTER TABLE [dbo].[Title] DROP CONSTRAINT [Title_FK00]
GO
/****** Object:  ForeignKey [Title_FK01]    Script Date: 09/29/2009 09:03:44 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_FK01]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title]'))
ALTER TABLE [dbo].[Title] DROP CONSTRAINT [Title_FK01]
GO
/****** Object:  ForeignKey [Title_FK02]    Script Date: 09/29/2009 09:03:44 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_FK02]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title]'))
ALTER TABLE [dbo].[Title] DROP CONSTRAINT [Title_FK02]
GO
/****** Object:  ForeignKey [FK_Title_Creator_Creator]    Script Date: 09/29/2009 09:03:50 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Title_Creator_Creator]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_Creator]'))
ALTER TABLE [dbo].[Title_Creator] DROP CONSTRAINT [FK_Title_Creator_Creator]
GO
/****** Object:  ForeignKey [Title_Creator_FK00]    Script Date: 09/29/2009 09:03:50 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_Creator_FK00]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_Creator]'))
ALTER TABLE [dbo].[Title_Creator] DROP CONSTRAINT [Title_Creator_FK00]
GO
/****** Object:  ForeignKey [Title_Creator_FK02]    Script Date: 09/29/2009 09:03:50 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_Creator_FK02]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_Creator]'))
ALTER TABLE [dbo].[Title_Creator] DROP CONSTRAINT [Title_Creator_FK02]
GO
/****** Object:  ForeignKey [FK_Title_TitleIdentifier_Title]    Script Date: 09/29/2009 09:03:55 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Title_TitleIdentifier_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifier]'))
ALTER TABLE [dbo].[Title_TitleIdentifier] DROP CONSTRAINT [FK_Title_TitleIdentifier_Title]
GO
/****** Object:  ForeignKey [FK_Title_TitleIdentifier_TitleIdentifier]    Script Date: 09/29/2009 09:03:55 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Title_TitleIdentifier_TitleIdentifier]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifier]'))
ALTER TABLE [dbo].[Title_TitleIdentifier] DROP CONSTRAINT [FK_Title_TitleIdentifier_TitleIdentifier]
GO
/****** Object:  ForeignKey [Title_TitleType_FK00]    Script Date: 09/29/2009 09:03:58 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleType_FK00]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_TitleType]'))
ALTER TABLE [dbo].[Title_TitleType] DROP CONSTRAINT [Title_TitleType_FK00]
GO
/****** Object:  ForeignKey [Title_TitleType_FK01]    Script Date: 09/29/2009 09:03:58 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleType_FK01]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_TitleType]'))
ALTER TABLE [dbo].[Title_TitleType] DROP CONSTRAINT [Title_TitleType_FK01]
GO
/****** Object:  ForeignKey [FK_TitleAssociation_Title]    Script Date: 09/29/2009 09:04:04 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleAssociation_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleAssociation]'))
ALTER TABLE [dbo].[TitleAssociation] DROP CONSTRAINT [FK_TitleAssociation_Title]
GO
/****** Object:  ForeignKey [FK_TitleAssociation_Title1]    Script Date: 09/29/2009 09:04:04 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleAssociation_Title1]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleAssociation]'))
ALTER TABLE [dbo].[TitleAssociation] DROP CONSTRAINT [FK_TitleAssociation_Title1]
GO
/****** Object:  ForeignKey [FK_TitleAssociation_TitleAssociationType]    Script Date: 09/29/2009 09:04:04 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleAssociation_TitleAssociationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleAssociation]'))
ALTER TABLE [dbo].[TitleAssociation] DROP CONSTRAINT [FK_TitleAssociation_TitleAssociationType]
GO
/****** Object:  ForeignKey [FK_TitleAssociation_TitleIdentifier_TitleAssociation]    Script Date: 09/29/2009 09:04:07 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleAssociation_TitleIdentifier_TitleAssociation]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleAssociation_TitleIdentifier]'))
ALTER TABLE [dbo].[TitleAssociation_TitleIdentifier] DROP CONSTRAINT [FK_TitleAssociation_TitleIdentifier_TitleAssociation]
GO
/****** Object:  ForeignKey [FK_TitleAssociation_TitleIdentifier_TitleIdentifier]    Script Date: 09/29/2009 09:04:07 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleAssociation_TitleIdentifier_TitleIdentifier]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleAssociation_TitleIdentifier]'))
ALTER TABLE [dbo].[TitleAssociation_TitleIdentifier] DROP CONSTRAINT [FK_TitleAssociation_TitleIdentifier_TitleIdentifier]
GO
/****** Object:  ForeignKey [FK_TitleItem_Item]    Script Date: 09/29/2009 09:04:20 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleItem_Item]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleItem]'))
ALTER TABLE [dbo].[TitleItem] DROP CONSTRAINT [FK_TitleItem_Item]
GO
/****** Object:  ForeignKey [FK_TitleItem_Title]    Script Date: 09/29/2009 09:04:21 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleItem_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleItem]'))
ALTER TABLE [dbo].[TitleItem] DROP CONSTRAINT [FK_TitleItem_Title]
GO
/****** Object:  ForeignKey [FK_TitleLanguage_Language]    Script Date: 09/29/2009 09:04:23 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleLanguage_Language]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleLanguage]'))
ALTER TABLE [dbo].[TitleLanguage] DROP CONSTRAINT [FK_TitleLanguage_Language]
GO
/****** Object:  ForeignKey [FK_TitleLanguage_Title]    Script Date: 09/29/2009 09:04:23 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleLanguage_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleLanguage]'))
ALTER TABLE [dbo].[TitleLanguage] DROP CONSTRAINT [FK_TitleLanguage_Title]
GO
/****** Object:  ForeignKey [FK_TitleTag_Title]    Script Date: 09/29/2009 09:04:27 ******/
IF  EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleTag_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleTag]'))
ALTER TABLE [dbo].[TitleTag] DROP CONSTRAINT [FK_TitleTag_Title]
GO
/****** Object:  Check [CK IndicatedPage Sequence]    Script Date: 09/29/2009 09:01:38 ******/
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK IndicatedPage Sequence]') AND parent_object_id = OBJECT_ID(N'[dbo].[IndicatedPage]'))
ALTER TABLE [dbo].[IndicatedPage] DROP CONSTRAINT [CK IndicatedPage Sequence]
GO
/****** Object:  Check [CK Title EndYear]    Script Date: 09/29/2009 09:03:44 ******/
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK Title EndYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title]'))
ALTER TABLE [dbo].[Title] DROP CONSTRAINT [CK Title EndYear]
GO
/****** Object:  Check [CK Title StartYear]    Script Date: 09/29/2009 09:03:44 ******/
IF  EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK Title StartYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title]'))
ALTER TABLE [dbo].[Title] DROP CONSTRAINT [CK Title StartYear]
GO
/****** Object:  Table [dbo].[User]    Script Date: 09/29/2009 09:04:42 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND type in (N'U'))
DROP TABLE [dbo].[User]
GO
/****** Object:  Table [dbo].[TitleAssociation]    Script Date: 09/29/2009 09:04:04 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociation]') AND type in (N'U'))
DROP TABLE [dbo].[TitleAssociation]
GO
/****** Object:  Table [dbo].[PaginationStatus]    Script Date: 09/29/2009 09:03:17 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaginationStatus]') AND type in (N'U'))
DROP TABLE [dbo].[PaginationStatus]
GO
/****** Object:  Table [dbo].[Institution]    Script Date: 09/29/2009 09:01:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Institution]') AND type in (N'U'))
DROP TABLE [dbo].[Institution]
GO
/****** Object:  Table [dbo].[TitleAssociationType]    Script Date: 09/29/2009 09:04:12 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationType]') AND type in (N'U'))
DROP TABLE [dbo].[TitleAssociationType]
GO
/****** Object:  Table [dbo].[MonthlyStats]    Script Date: 09/29/2009 09:02:43 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonthlyStats]') AND type in (N'U'))
DROP TABLE [dbo].[MonthlyStats]
GO
/****** Object:  Table [dbo].[Location]    Script Date: 09/29/2009 09:02:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Location]') AND type in (N'U'))
DROP TABLE [dbo].[Location]
GO
/****** Object:  Table [dbo].[TitleTag]    Script Date: 09/29/2009 09:04:27 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTag]') AND type in (N'U'))
DROP TABLE [dbo].[TitleTag]
GO
/****** Object:  Table [dbo].[PDF]    Script Date: 09/29/2009 09:03:26 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDF]') AND type in (N'U'))
DROP TABLE [dbo].[PDF]
GO
/****** Object:  Table [dbo].[PDFPage]    Script Date: 09/29/2009 09:03:28 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFPage]') AND type in (N'U'))
DROP TABLE [dbo].[PDFPage]
GO
/****** Object:  Table [dbo].[PDFStatus]    Script Date: 09/29/2009 09:03:29 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFStatus]') AND type in (N'U'))
DROP TABLE [dbo].[PDFStatus]
GO
/****** Object:  Table [dbo].[PageName]    Script Date: 09/29/2009 09:03:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageName]') AND type in (N'U'))
DROP TABLE [dbo].[PageName]
GO
/****** Object:  Table [dbo].[PageNameCount]    Script Date: 09/29/2009 09:03:11 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameCount]') AND type in (N'U'))
DROP TABLE [dbo].[PageNameCount]
GO
/****** Object:  Table [dbo].[TitleLanguage]    Script Date: 09/29/2009 09:04:23 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleLanguage]') AND type in (N'U'))
DROP TABLE [dbo].[TitleLanguage]
GO
/****** Object:  Table [dbo].[ItemLanguage]    Script Date: 09/29/2009 09:02:05 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemLanguage]') AND type in (N'U'))
DROP TABLE [dbo].[ItemLanguage]
GO
/****** Object:  Table [dbo].[Language]    Script Date: 09/29/2009 09:02:13 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Language]') AND type in (N'U'))
DROP TABLE [dbo].[Language]
GO
/****** Object:  Table [dbo].[Configuration]    Script Date: 09/29/2009 09:01:00 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Configuration]') AND type in (N'U'))
DROP TABLE [dbo].[Configuration]
GO
/****** Object:  Table [dbo].[Title_TitleType]    Script Date: 09/29/2009 09:03:58 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleType]') AND type in (N'U'))
DROP TABLE [dbo].[Title_TitleType]
GO
/****** Object:  Table [dbo].[ItemStatus]    Script Date: 09/29/2009 09:02:09 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemStatus]') AND type in (N'U'))
DROP TABLE [dbo].[ItemStatus]
GO
/****** Object:  Table [dbo].[TitleType]    Script Date: 09/29/2009 09:04:31 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleType]') AND type in (N'U'))
DROP TABLE [dbo].[TitleType]
GO
/****** Object:  Table [dbo].[TitleAssociation_TitleIdentifier]    Script Date: 09/29/2009 09:04:07 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociation_TitleIdentifier]') AND type in (N'U'))
DROP TABLE [dbo].[TitleAssociation_TitleIdentifier]
GO
/****** Object:  Table [dbo].[Creator]    Script Date: 09/29/2009 09:01:24 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Creator]') AND type in (N'U'))
DROP TABLE [dbo].[Creator]
GO
/****** Object:  Table [dbo].[Title_Creator]    Script Date: 09/29/2009 09:03:50 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_Creator]') AND type in (N'U'))
DROP TABLE [dbo].[Title_Creator]
GO
/****** Object:  Table [dbo].[TitleIdentifier]    Script Date: 09/29/2009 09:04:15 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleIdentifier]') AND type in (N'U'))
DROP TABLE [dbo].[TitleIdentifier]
GO
/****** Object:  Table [dbo].[Vault]    Script Date: 09/29/2009 09:04:49 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vault]') AND type in (N'U'))
DROP TABLE [dbo].[Vault]
GO
/****** Object:  Table [dbo].[Item]    Script Date: 09/29/2009 09:02:02 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Item]') AND type in (N'U'))
DROP TABLE [dbo].[Item]
GO
/****** Object:  Table [dbo].[Page]    Script Date: 09/29/2009 09:02:56 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Page]') AND type in (N'U'))
DROP TABLE [dbo].[Page]
GO
/****** Object:  Table [dbo].[Title]    Script Date: 09/29/2009 09:03:44 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title]') AND type in (N'U'))
DROP TABLE [dbo].[Title]
GO
/****** Object:  Table [dbo].[CreatorRoleType]    Script Date: 09/29/2009 09:01:30 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorRoleType]') AND type in (N'U'))
DROP TABLE [dbo].[CreatorRoleType]
GO
/****** Object:  Table [dbo].[ItemSource]    Script Date: 09/29/2009 09:02:08 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSource]') AND type in (N'U'))
DROP TABLE [dbo].[ItemSource]
GO
/****** Object:  Table [dbo].[TitleItem]    Script Date: 09/29/2009 09:04:20 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleItem]') AND type in (N'U'))
DROP TABLE [dbo].[TitleItem]
GO
/****** Object:  Table [dbo].[PageType]    Script Date: 09/29/2009 09:03:16 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageType]') AND type in (N'U'))
DROP TABLE [dbo].[PageType]
GO
/****** Object:  Table [dbo].[Page_PageType]    Script Date: 09/29/2009 09:03:01 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Page_PageType]') AND type in (N'U'))
DROP TABLE [dbo].[Page_PageType]
GO
/****** Object:  Table [dbo].[IndicatedPage]    Script Date: 09/29/2009 09:01:38 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IndicatedPage]') AND type in (N'U'))
DROP TABLE [dbo].[IndicatedPage]
GO
/****** Object:  Table [dbo].[Title_TitleIdentifier]    Script Date: 09/29/2009 09:03:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifier]') AND type in (N'U'))
DROP TABLE [dbo].[Title_TitleIdentifier]
GO
/****** Object:  Table [dbo].[Marc]    Script Date: 09/29/2009 09:03:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Marc]') AND type in (N'U'))
DROP TABLE [dbo].[Marc]
GO
/****** Object:  Table [dbo].[MarcControl]    Script Date: 09/29/2009 09:03:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcControl]') AND type in (N'U'))
DROP TABLE [dbo].[MarcControl]
GO
/****** Object:  Table [dbo].[MarcDataField]    Script Date: 09/29/2009 09:03:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcDataField]') AND type in (N'U'))
DROP TABLE [dbo].[MarcDataField]
GO
/****** Object:  Table [dbo].[MarcImportBatch]    Script Date: 09/29/2009 09:03:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcImportBatch]') AND type in (N'U'))
DROP TABLE [dbo].[MarcImportBatch]
GO
/****** Object:  Table [dbo].[MarcImportError]    Script Date: 09/29/2009 09:03:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcImportError]') AND type in (N'U'))
DROP TABLE [dbo].[MarcImportError]
GO
/****** Object:  Table [dbo].[MarcImportStatus]    Script Date: 09/29/2009 09:03:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcImportStatus]') AND type in (N'U'))
DROP TABLE [dbo].[MarcImportStatus]
GO
/****** Object:  Table [dbo].[MarcSubField]    Script Date: 09/29/2009 09:03:55 ******/
IF  EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MarcSubField]') AND type in (N'U'))
DROP TABLE [dbo].[MarcSubField]
GO
/****** Object:  Table [dbo].[ItemStatus]    Script Date: 09/29/2009 09:02:09 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ItemStatus](
	[ItemStatusID] [int] NOT NULL,
	[ItemStatusName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_ItemStatus] PRIMARY KEY CLUSTERED 
(
	[ItemStatusID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[MonthlyStats]    Script Date: 09/29/2009 09:02:43 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[MonthlyStats]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[MonthlyStats](
	[Year] [int] NOT NULL,
	[Month] [int] NOT NULL,
	[InstitutionName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StatType] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[StatValue] [int] NOT NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_MonthlyStats_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_MonthlyStats_LastModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_MonthlyStats] PRIMARY KEY CLUSTERED 
(
	[Year] ASC,
	[Month] ASC,
	[InstitutionName] ASC,
	[StatType] ASC
)
)
END
GO
/****** Object:  Table [dbo].[Location]    Script Date: 09/29/2009 09:02:16 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Location]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Location](
	[LocationName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
	[Latitude] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Longitude] [varchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NextAttemptDate] [datetime] NULL,
	[IncludeInUI] [bit] NOT NULL CONSTRAINT [DF_Location_IncludeInUI]  DEFAULT ((1)),
	[CreationDate] [datetime] NULL CONSTRAINT [DF_Location_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_Location_LastModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Location] PRIMARY KEY CLUSTERED 
(
	[LocationName] ASC
)
)
END
GO
/****** Object:  Table [dbo].[TitleType]    Script Date: 09/29/2009 09:04:31 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TitleType](
	[TitleTypeID] [int] NOT NULL,
	[TitleType] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[TitleTypeDescription] [nvarchar](80) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [aaaaaTitleType_PK] PRIMARY KEY NONCLUSTERED 
(
	[TitleTypeID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[Configuration]    Script Date: 09/29/2009 09:01:00 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Configuration]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Configuration](
	[ConfigurationID] [int] NOT NULL,
	[ConfigurationName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[ConfigurationValue] [nvarchar](1000) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_Configuration] PRIMARY KEY CLUSTERED 
(
	[ConfigurationID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[Vault]    Script Date: 09/29/2009 09:04:49 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Vault]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Vault](
	[VaultID] [int] NOT NULL,
	[Server] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FolderShare] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[WebVirtualDirectory] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OCRFolderShare] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [aaaaaVault_PK] PRIMARY KEY NONCLUSTERED 
(
	[VaultID] ASC
)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Vault]') AND name = N'CatalogID')
CREATE UNIQUE NONCLUSTERED INDEX [CatalogID] ON [dbo].[Vault] 
(
	[VaultID] ASC
)
GO
/****** Object:  Table [dbo].[ItemSource]    Script Date: 09/29/2009 09:02:08 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemSource]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ItemSource](
	[ItemSourceID] [int] IDENTITY(1,1) NOT NULL,
	[SourceName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ItemSource_SourceName]  DEFAULT (''),
	[DownloadUrl] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ItemSource_DownloadUrl]  DEFAULT (''),
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_ItemSource_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_ItemSource_LastModifiedDate]  DEFAULT (getdate()),
	[ImageServerUrlFormat] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_ItemSource_ImageServerUrl]  DEFAULT (''),
 CONSTRAINT [PK_ItemSource] PRIMARY KEY CLUSTERED 
(
	[ItemSourceID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[PaginationStatus]    Script Date: 09/29/2009 09:03:17 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PaginationStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PaginationStatus](
	[PaginationStatusID] [int] NOT NULL,
	[PaginationStatusName] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
 CONSTRAINT [PK_PaginationStatus] PRIMARY KEY CLUSTERED 
(
	[PaginationStatusID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[PageNameCount]    Script Date: 09/29/2009 09:03:11 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageNameCount]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PageNameCount](
	[NameConfirmed] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Qty] [int] NOT NULL,
	[RefreshDate] [datetime] NOT NULL
)
END
GO
/****** Object:  Table [dbo].[User]    Script Date: 09/29/2009 09:04:42 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[User]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[User](
	[UserID] [int] NOT NULL,
	[FirstName] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastName] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastNameFirst] [nvarchar](62) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Email] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Password] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[UserNote] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [aaaaaUser_PK] PRIMARY KEY NONCLUSTERED 
(
	[UserID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[Language]    Script Date: 09/29/2009 09:02:13 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Language]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Language](
	[LanguageCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[LanguageName] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Note] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [aaaaaLanguage_PK] PRIMARY KEY NONCLUSTERED 
(
	[LanguageCode] ASC
)
)
END
GO
/****** Object:  Table [dbo].[Institution]    Script Date: 09/29/2009 09:01:44 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Institution]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Institution](
	[InstitutionCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[InstitutionName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[Note] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InstitutionUrl] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[BHLMemberLibrary] [bit] NOT NULL CONSTRAINT [DF_Institution_BHLMemberLibrary]  DEFAULT ((0)),
 CONSTRAINT [aaaaaInstitution_PK] PRIMARY KEY NONCLUSTERED 
(
	[InstitutionCode] ASC
)
)
END
GO
/****** Object:  Table [dbo].[Creator]    Script Date: 09/29/2009 09:01:24 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Creator]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Creator](
	[CreatorID] [int] IDENTITY(1,1) NOT NULL,
	[CreatorName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
	[FirstNameFirst] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SimpleName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DOB] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[DOD] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Biography] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreatorNote] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MARCDataFieldTag] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MARCCreator_a] [nvarchar](450) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MARCCreator_b] [nvarchar](450) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MARCCreator_c] [nvarchar](450) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MARCCreator_d] [nvarchar](450) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[MARCCreator_Full] [nvarchar](450) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[CreationDate] [datetime] NULL CONSTRAINT [DF_Creator_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_Creator_LastModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Creator] PRIMARY KEY CLUSTERED 
(
	[CreatorID] ASC
)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Creator]') AND name = N'CreatorName')
CREATE NONCLUSTERED INDEX [CreatorName] ON [dbo].[Creator] 
(
	[CreatorName] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Creator]') AND name = N'IX_Creator_MarcCreator')
CREATE NONCLUSTERED INDEX [IX_Creator_MarcCreator] ON [dbo].[Creator] 
(
	[MARCCreator_a] ASC
)
INCLUDE ( [MARCCreator_b],
[MARCCreator_c],
[MARCCreator_d]) 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Creator]') AND name = N'IX_Creator_MARCCreator_Full')
CREATE UNIQUE NONCLUSTERED INDEX [IX_Creator_MARCCreator_Full] ON [dbo].[Creator] 
(
	[MARCCreator_Full] ASC
)
GO
/****** Object:  Table [dbo].[CreatorRoleType]    Script Date: 09/29/2009 09:01:30 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[CreatorRoleType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[CreatorRoleType](
	[CreatorRoleTypeID] [int] NOT NULL,
	[CreatorRoleType] [nvarchar](25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreatorRoleTypeDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MARCDataFieldTag] [nvarchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [aaaaaCreatorRoleType_PK] PRIMARY KEY NONCLUSTERED 
(
	[CreatorRoleTypeID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[TitleAssociationType]    Script Date: 09/29/2009 09:04:12 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociationType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TitleAssociationType](
	[TitleAssociationTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TitleAssociationName] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Table_1_AssociationName]  DEFAULT (''),
	[MARCTag] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TitleAssociationType_MARCTag]  DEFAULT (''),
	[MARCIndicator2] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TitleAssociationType_MARCIndicator2]  DEFAULT (''),
	[TitleAssociationLabel] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TitleAssociationType_TitleAssociationLabel]  DEFAULT (''),
 CONSTRAINT [PK_TitleAssociationType] PRIMARY KEY CLUSTERED 
(
	[TitleAssociationTypeID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[TitleIdentifier]    Script Date: 09/29/2009 09:04:15 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleIdentifier]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TitleIdentifier](
	[TitleIdentifierID] [int] IDENTITY(1,1) NOT NULL,
	[IdentifierName] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TitleIdentifier_IdentifierName]  DEFAULT (''),
	[MarcDataFieldTag] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TitleIdentifier_MarcDataFieldTag]  DEFAULT (''),
	[MarcSubFieldCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TitleIdentifier_MarcSubFieldCode]  DEFAULT (''),
 CONSTRAINT [PK_TitleIdentifier] PRIMARY KEY CLUSTERED 
(
	[TitleIdentifierID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[PDFStatus]    Script Date: 09/29/2009 09:03:29 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFStatus]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PDFStatus](
	[PdfStatusID] [int] NOT NULL,
	[PdfStatusName] [nchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PDFStatus_PDFStatusName]  DEFAULT (''),
 CONSTRAINT [PK_PDFStatus] PRIMARY KEY CLUSTERED 
(
	[PdfStatusID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[PageType]    Script Date: 09/29/2009 09:03:16 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PageType](
	[PageTypeID] [int] IDENTITY(1,1) NOT NULL,
	[PageTypeName] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[PageTypeDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [aaaaaPageType_PK] PRIMARY KEY NONCLUSTERED 
(
	[PageTypeID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[Page]    Script Date: 09/29/2009 09:02:56 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Page]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Page](
	[PageID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[FileNamePrefix] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SequenceOrder] [int] NULL,
	[PageDescription] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Illustration] [bit] NOT NULL CONSTRAINT [DF_Page_Illustration]  DEFAULT ((0)),
	[Note] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FileSize_Temp] [int] NULL,
	[FileExtension] [nvarchar](5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreationDate] [datetime] NULL CONSTRAINT [DF__Page__Created__2610A626]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF__Page__Changed__2704CA5F]  DEFAULT (getdate()),
	[CreationUserID] [int] NULL CONSTRAINT [DF_Page_CreationUserID]  DEFAULT ((1)),
	[LastModifiedUserID] [int] NULL CONSTRAINT [DF_Page_LastModifiedUserID]  DEFAULT ((1)),
	[Active] [bit] NOT NULL CONSTRAINT [DF_Item_Active]  DEFAULT ((1)),
	[Year] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Series] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Volume] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Issue] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ExternalURL] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IssuePrefix] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LastPageNameLookupDate] [datetime] NULL,
	[PaginationUserID] [int] NULL,
	[PaginationDate] [datetime] NULL,
	[AltExternalURL] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
 CONSTRAINT [aaaaaPage_PK] PRIMARY KEY NONCLUSTERED 
(
	[PageID] ASC
)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Page]') AND name = N'ItemPage')
CREATE NONCLUSTERED INDEX [ItemPage] ON [dbo].[Page] 
(
	[ItemID] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Page]') AND name = N'IX_Page_Active')
CREATE NONCLUSTERED INDEX [IX_Page_Active] ON [dbo].[Page] 
(
	[Active] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Page]') AND name = N'IX_Page_ActiveItemID')
CREATE NONCLUSTERED INDEX [IX_Page_ActiveItemID] ON [dbo].[Page] 
(
	[Active] ASC,
	[ItemID] ASC
)
INCLUDE ( [PageID],
[CreationDate]) 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Page]') AND name = N'IX_Page_ItemIDActiveSeqOrder')
CREATE NONCLUSTERED INDEX [IX_Page_ItemIDActiveSeqOrder] ON [dbo].[Page] 
(
	[ItemID] ASC,
	[Active] ASC,
	[SequenceOrder] ASC
)
INCLUDE ( [PageID],
[FileNamePrefix],
[Illustration],
[Year],
[Series],
[Volume],
[Issue],
[ExternalURL],
[IssuePrefix]) 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Page]') AND name = N'IX_Page_LastPageNameLookupDate')
CREATE NONCLUSTERED INDEX [IX_Page_LastPageNameLookupDate] ON [dbo].[Page] 
(
	[LastPageNameLookupDate] ASC
)
INCLUDE ( [PageID],
[ItemID],
[FileNamePrefix],
[SequenceOrder]) 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Page]') AND name = N'IX_Page_PageIDActiveItem')
CREATE NONCLUSTERED INDEX [IX_Page_PageIDActiveItem] ON [dbo].[Page] 
(
	[PageID] ASC,
	[Active] ASC,
	[ItemID] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Page]') AND name = N'IX_Page_PageIDActiveSequence')
CREATE NONCLUSTERED INDEX [IX_Page_PageIDActiveSequence] ON [dbo].[Page] 
(
	[PageID] ASC,
	[Active] ASC,
	[SequenceOrder] ASC
)
INCLUDE ( [ItemID]) 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Page]') AND name = N'Sequence')
CREATE NONCLUSTERED INDEX [Sequence] ON [dbo].[Page] 
(
	[FileNamePrefix] ASC
)
GO
/****** Object:  Table [dbo].[Title]    Script Date: 09/29/2009 09:03:44 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Title](
	[TitleID] [int] IDENTITY(1,1) NOT NULL,
	[MARCBibID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MARCLeader] [nvarchar](24) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TropicosTitleID] [int] NULL,
	[RedirectTitleID] [int] NULL,
	[FullTitle] [nvarchar](2000) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL CONSTRAINT [DF_Title_FullTitle]  DEFAULT (''),
	[ShortTitle] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[UniformTitle] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[SortTitle] [nvarchar](60) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[CallNumber] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PublicationDetails] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[StartYear] [smallint] NULL,
	[EndYear] [smallint] NULL,
	[Datafield_260_a] [nvarchar](150) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[Datafield_260_b] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[Datafield_260_c] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[InstitutionCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Title__Instituti__7167D3BD]  DEFAULT ('MO'),
	[LanguageCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TitleDescription] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[TL2Author] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PublishReady] [bit] NOT NULL CONSTRAINT [DF__Title__PublishRe__725BF7F6]  DEFAULT ((0)),
	[RareBooks] [bit] NOT NULL CONSTRAINT [DF_Title_RareBooks]  DEFAULT ((0)),
	[Note] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[OriginalCatalogingSource] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[EditionStatement] [nvarchar](450) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CurrentPublicationFrequency] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PartNumber] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[PartName] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[CreationDate] [datetime] NULL CONSTRAINT [DF__Title__Created__74444068]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF__Title__Changed__753864A1]  DEFAULT (getdate()),
	[CreationUserID] [int] NULL CONSTRAINT [DF_Title_CreationUserID]  DEFAULT ((1)),
	[LastModifiedUserID] [int] NULL CONSTRAINT [DF_Title_LastModifiedUserID]  DEFAULT ((1)),
 CONSTRAINT [aaaaaTitle_PK] PRIMARY KEY NONCLUSTERED 
(
	[TitleID] ASC
)
) TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Title]') AND name = N'IX_Title_BibIDShortTitle')
CREATE UNIQUE NONCLUSTERED INDEX [IX_Title_BibIDShortTitle] ON [dbo].[Title] 
(
	[MARCBibID] ASC,
	[ShortTitle] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Title]') AND name = N'IX_Title_PublishReadySortTitle')
CREATE NONCLUSTERED INDEX [IX_Title_PublishReadySortTitle] ON [dbo].[Title] 
(
	[PublishReady] ASC,
	[SortTitle] ASC
)
INCLUDE ( [TitleID],
[FullTitle],
[ShortTitle],
[PublicationDetails],
[InstitutionCode],
[LanguageCode]) 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Title]') AND name = N'IX_Title_PublishReadyStartYear')
CREATE NONCLUSTERED INDEX [IX_Title_PublishReadyStartYear] ON [dbo].[Title] 
(
	[PublishReady] ASC,
	[StartYear] ASC
)
INCLUDE ( [PublicationDetails],
[TitleID],
[FullTitle],
[LanguageCode],
[InstitutionCode]) 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Title]') AND name = N'IX_Title_TitleIDSortTitle')
CREATE NONCLUSTERED INDEX [IX_Title_TitleIDSortTitle] ON [dbo].[Title] 
(
	[TitleID] ASC,
	[SortTitle] ASC
)
INCLUDE ( [ShortTitle],
[MARCBibID]) 
GO
/****** Object:  Table [dbo].[Item]    Script Date: 09/29/2009 09:02:02 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Item]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Item](
	[ItemID] [int] IDENTITY(1,1) NOT NULL,
	[PrimaryTitleID] [int] NOT NULL,
	[BarCode] [nvarchar](40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[MARCItemID] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CallNumber] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Volume] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AI NULL,
	[InstitutionCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF__Item__Institutio__68D28DBC]  DEFAULT ('MO'),
	[LanguageCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ItemDescription] [ntext] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScannedBy] [int] NULL,
	[PDFSize] [int] NULL,
	[VaultID] [int] NULL,
	[NumberOfFiles] [smallint] NULL,
	[Note] [nvarchar](255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreationDate] [datetime] NULL CONSTRAINT [DF__Item__Created__6BAEFA67]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF__Item__Changed__6CA31EA0]  DEFAULT (getdate()),
	[CreationUserID] [int] NULL CONSTRAINT [DF_Item_CreationUserID]  DEFAULT ((1)),
	[LastModifiedUserID] [int] NULL CONSTRAINT [DF_Item_LastModifiedUserID]  DEFAULT ((1)),
	[ItemStatusID] [int] NOT NULL CONSTRAINT [DF_Item_ItemStatusID]  DEFAULT ((10)),
	[ScanningUser] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[ScanningDate] [datetime] NULL,
	[PaginationCompleteUserID] [int] NULL,
	[PaginationCompleteDate] [datetime] NULL,
	[PaginationStatusID] [int] NULL,
	[PaginationStatusUserID] [int] NULL,
	[PaginationStatusDate] [datetime] NULL,
	[LastPageNameLookupDate] [datetime] NULL,
	[ItemSourceID] [int] NULL,
	[Year] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[IdentifierBib] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[FileRootFolder] [nvarchar](250) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Item_FileRootFolder]  DEFAULT (''),
	[ZQuery] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Sponsor] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[LicenseUrl] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Item_LicenseUrl]  DEFAULT (''),
	[Rights] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Item_Rights]  DEFAULT (''),
	[DueDiligence] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Item_DueDiligence]  DEFAULT (''),
	[CopyrightStatus] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Item_CopyrightStatus]  DEFAULT (''),
	[CopyrightRegion] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Item_CopyrightRegion]  DEFAULT (''),
	[CopyrightComment] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Item_CopyrightComment]  DEFAULT (''),
	[CopyrightEvidence] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Item_CopyrightEvidence]  DEFAULT (''),
	[CopyrightEvidenceOperator] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Item_CopyrightEvidenceOperator]  DEFAULT (''),
	[CopyrightEvidenceDate] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_Item_CopyrightEvidenceDate]  DEFAULT (''),
 CONSTRAINT [aaaaaItem_PK] PRIMARY KEY NONCLUSTERED 
(
	[ItemID] ASC
)
) TEXTIMAGE_ON [PRIMARY]
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Item]') AND name = N'IX_Item_ItemStatusID')
CREATE CLUSTERED INDEX [IX_Item_ItemStatusID] ON [dbo].[Item] 
(
	[ItemStatusID] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Item]') AND name = N'BarCode')
CREATE UNIQUE NONCLUSTERED INDEX [BarCode] ON [dbo].[Item] 
(
	[BarCode] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Item]') AND name = N'IX_Item_StatusItemTitle')
CREATE NONCLUSTERED INDEX [IX_Item_StatusItemTitle] ON [dbo].[Item] 
(
	[ItemStatusID] ASC,
	[ItemID] ASC,
	[PrimaryTitleID] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Item]') AND name = N'IX_Item_StatusItemVolume')
CREATE NONCLUSTERED INDEX [IX_Item_StatusItemVolume] ON [dbo].[Item] 
(
	[ItemStatusID] ASC,
	[ItemID] ASC,
	[Volume] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Item]') AND name = N'IX_Item_TitleID')
CREATE NONCLUSTERED INDEX [IX_Item_TitleID] ON [dbo].[Item] 
(
	[PrimaryTitleID] ASC
)
INCLUDE ( [InstitutionCode],
[LanguageCode]) 
GO
/****** Object:  Table [dbo].[Title_TitleType]    Script Date: 09/29/2009 09:03:58 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Title_TitleType](
	[Title_TitleTypeID] [int] IDENTITY(1,1) NOT NULL,
	[TitleID] [int] NOT NULL,
	[TitleTypeID] [int] NOT NULL,
 CONSTRAINT [PK_Title_TitleType] PRIMARY KEY CLUSTERED 
(
	[Title_TitleTypeID] ASC
)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleType]') AND name = N'IX_Title_TitleType_TitleType_Title')
CREATE UNIQUE NONCLUSTERED INDEX [IX_Title_TitleType_TitleType_Title] ON [dbo].[Title_TitleType] 
(
	[TitleID] ASC,
	[TitleTypeID] ASC
)
GO
/****** Object:  Table [dbo].[PDFPage]    Script Date: 09/29/2009 09:03:28 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDFPage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PDFPage](
	[PdfPageID] [int] IDENTITY(1,1) NOT NULL,
	[PdfID] [int] NOT NULL,
	[PageID] [int] NOT NULL,
 CONSTRAINT [PK_PDFPage] PRIMARY KEY CLUSTERED 
(
	[PdfPageID] ASC
)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PDFPage]') AND name = N'IX_PdfPage_PdfID')
CREATE NONCLUSTERED INDEX [IX_PdfPage_PdfID] ON [dbo].[PDFPage] 
(
	[PdfID] ASC
)
INCLUDE ( [PageID]) 
GO
/****** Object:  Table [dbo].[TitleLanguage]    Script Date: 09/29/2009 09:04:23 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleLanguage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TitleLanguage](
	[TitleLanguageID] [int] IDENTITY(1,1) NOT NULL,
	[TitleID] [int] NOT NULL,
	[LanguageCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__TitleLang__Creat__3A0D7D32]  DEFAULT (getdate()),
 CONSTRAINT [PK_TitleLanguage] PRIMARY KEY CLUSTERED 
(
	[TitleLanguageID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[ItemLanguage]    Script Date: 09/29/2009 09:02:05 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[ItemLanguage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[ItemLanguage](
	[ItemLanguageID] [int] IDENTITY(1,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[LanguageCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF__ItemLangu__Creat__3BF5C5A4]  DEFAULT (getdate()),
 CONSTRAINT [PK_ItemLanguage] PRIMARY KEY CLUSTERED 
(
	[ItemLanguageID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[Title_Creator]    Script Date: 09/29/2009 09:03:50 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_Creator]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Title_Creator](
	[Title_CreatorID] [int] IDENTITY(1,1) NOT NULL,
	[TitleID] [int] NOT NULL,
	[CreatorID] [int] NOT NULL,
	[CreatorRoleTypeID] [int] NOT NULL,
	[CreationDate] [datetime] NULL CONSTRAINT [DF_Title_Creator_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_Title_Creator_LastModifiedDate]  DEFAULT (getdate()),
	[CreationUserID] [int] NULL CONSTRAINT [DF_Title_Creator_CreationUserID]  DEFAULT ((1)),
	[LastModifiedUserID] [int] NULL CONSTRAINT [DF_Title_Creator_LastModifiedUserID]  DEFAULT ((1)),
 CONSTRAINT [PK_Title_Creator_1] PRIMARY KEY CLUSTERED 
(
	[Title_CreatorID] ASC
)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Title_Creator]') AND name = N'IX_Title_Creator_Title_Creator_CreatorRoleType')
CREATE UNIQUE NONCLUSTERED INDEX [IX_Title_Creator_Title_Creator_CreatorRoleType] ON [dbo].[Title_Creator] 
(
	[TitleID] ASC,
	[CreatorID] ASC,
	[CreatorRoleTypeID] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Title_Creator]') AND name = N'IX_TitleCreator_CreatorID')
CREATE NONCLUSTERED INDEX [IX_TitleCreator_CreatorID] ON [dbo].[Title_Creator] 
(
	[CreatorID] ASC
)
GO
/****** Object:  Table [dbo].[TitleAssociation_TitleIdentifier]    Script Date: 09/29/2009 09:04:07 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociation_TitleIdentifier]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TitleAssociation_TitleIdentifier](
	[TitleAssociation_TitleIdentifierID] [int] IDENTITY(1,1) NOT NULL,
	[TitleAssociationID] [int] NOT NULL,
	[TitleIdentifierID] [int] NOT NULL,
	[IdentifierValue] [varchar](125) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_TitleAssociation_TitleIdentifier_IdentifierValue]  DEFAULT (''),
	[CreationDate] [datetime] NULL CONSTRAINT [DF_TitleAssociation_TitleIdentifier_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_TitleAssociation_TitleIdentifier_LastModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_TitleAssociation_TitleIdentifier] PRIMARY KEY CLUSTERED 
(
	[TitleAssociation_TitleIdentifierID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[TitleAssociation]    Script Date: 09/29/2009 09:04:04 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociation]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TitleAssociation](
	[TitleAssociationID] [int] IDENTITY(1,1) NOT NULL,
	[TitleID] [int] NOT NULL,
	[TitleAssociationTypeID] [int] NOT NULL,
	[Title] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL CONSTRAINT [DF_TitleAssociation_Title]  DEFAULT (''),
	[Section] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL CONSTRAINT [DF_TitleAssociation_Section]  DEFAULT (''),
	[Volume] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL CONSTRAINT [DF_TitleAssociation_Volume]  DEFAULT (''),
	[Active] [bit] NOT NULL CONSTRAINT [DF_TitleAssociation_Active]  DEFAULT ((1)),
	[AssociatedTitleID] [int] NULL,
	[CreationDate] [datetime] NULL CONSTRAINT [DF_TitleAssociation_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_TitleAssociation_LastModifiedDate]  DEFAULT (getdate()),
	[Heading] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL CONSTRAINT [DF_TitleAssociation_Heading]  DEFAULT (''),
	[Publication] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL CONSTRAINT [DF_TitleAssociation_PublicationInfo]  DEFAULT (''),
	[Relationship] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL CONSTRAINT [DF_TitleAssociation_Relationship]  DEFAULT (''),
 CONSTRAINT [PK_TitleAssociation] PRIMARY KEY CLUSTERED 
(
	[TitleAssociationID] ASC
)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TitleAssociation]') AND name = N'IX_TitleAssociation')
CREATE NONCLUSTERED INDEX [IX_TitleAssociation] ON [dbo].[TitleAssociation] 
(
	[TitleID] ASC,
	[Active] ASC
)
GO
/****** Object:  Table [dbo].[Title_TitleIdentifier]    Script Date: 09/29/2009 09:03:55 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifier]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Title_TitleIdentifier](
	[Title_TitleIdentifierID] [int] IDENTITY(1,1) NOT NULL,
	[TitleID] [int] NOT NULL,
	[TitleIdentifierID] [int] NOT NULL,
	[IdentifierValue] [nvarchar](125) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Title_TitleIdentifier_IdentifierValue]  DEFAULT (''),
	[CreationDate] [datetime] NULL CONSTRAINT [DF_Title_TitleIdentifier_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_Title_TitleIdentifier_LastModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Title_TitleIdentifier] PRIMARY KEY CLUSTERED 
(
	[Title_TitleIdentifierID] ASC
)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifier]') AND name = N'IX_Title_TitleIdentifier_TitleID')
CREATE NONCLUSTERED INDEX [IX_Title_TitleIdentifier_TitleID] ON [dbo].[Title_TitleIdentifier] 
(
	[TitleID] ASC
)
INCLUDE ( [TitleIdentifierID],
[IdentifierValue]) 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifier]') AND name = N'IX_TitleTitleIdentifier_IdentifierValue')
CREATE NONCLUSTERED INDEX [IX_TitleTitleIdentifier_IdentifierValue] ON [dbo].[Title_TitleIdentifier] 
(
	[IdentifierValue] ASC
)
INCLUDE ( [TitleID],
[TitleIdentifierID]) 
GO
/****** Object:  Table [dbo].[PDF]    Script Date: 09/29/2009 09:03:26 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PDF]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PDF](
	[PdfID] [int] IDENTITY(1000,1) NOT NULL,
	[ItemID] [int] NOT NULL,
	[FileLocation] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PDF_FileLocation]  DEFAULT (''),
	[EmailAddress] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PDF_EmailAddress]  DEFAULT (''),
	[ShareWithEmailAddresses] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PDF_ShareWithEmailAddresses]  DEFAULT (''),
	[ArticleTitle] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PDF_ArticleTitle]  DEFAULT (''),
	[ArticleCreators] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PDF_ArticleCreators]  DEFAULT (''),
	[ArticleTags] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PDF_ArticleTags]  DEFAULT (''),
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_PDF_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_PDF_LastModifiedDate]  DEFAULT (getdate()),
	[ImagesOnly] [bit] NOT NULL CONSTRAINT [DF_PDF_ImagesOnly]  DEFAULT ((1)),
	[FileUrl] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PDF_FileUrl]  DEFAULT (''),
	[FileGenerationDate] [datetime] NULL,
	[FileDeletionDate] [datetime] NULL,
	[PdfStatusID] [int] NOT NULL CONSTRAINT [DF_PDF_PdfStatusID]  DEFAULT ((10)),
	[NumberImagesMissing] [int] NOT NULL CONSTRAINT [DF_PDF_NumberImagesMissing]  DEFAULT ((0)),
	[NumberOcrMissing] [int] NOT NULL CONSTRAINT [DF_PDF_NumberOcrMissing]  DEFAULT ((0)),
	[Comment] [nvarchar](max) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_PDF_Comment]  DEFAULT (''),
 CONSTRAINT [PK_PDF] PRIMARY KEY CLUSTERED 
(
	[PdfID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[TitleItem]    Script Date: 09/29/2009 09:04:20 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleItem]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TitleItem](
	[TitleItemID] [int] IDENTITY(1,1) NOT NULL,
	[TitleID] [int] NOT NULL,
	[ItemID] [int] NOT NULL,
	[ItemSequence] [smallint] NULL,
	[CreationDate] [datetime] NULL CONSTRAINT [DF_TitleItem_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_TitleItem_LastModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_TitleItem] PRIMARY KEY CLUSTERED 
(
	[TitleItemID] ASC
)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TitleItem]') AND name = N'IX_TitleItem')
CREATE UNIQUE NONCLUSTERED INDEX [IX_TitleItem] ON [dbo].[TitleItem] 
(
	[TitleID] ASC,
	[ItemID] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TitleItem]') AND name = N'IX_TitleItemItemID')
CREATE NONCLUSTERED INDEX [IX_TitleItemItemID] ON [dbo].[TitleItem] 
(
	[ItemID] ASC
)
INCLUDE ( [TitleID],
[ItemSequence]) 
GO
/****** Object:  Table [dbo].[Page_PageType]    Script Date: 09/29/2009 09:03:01 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[Page_PageType]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[Page_PageType](
	[PageID] [int] NOT NULL,
	[PageTypeID] [int] NOT NULL,
	[Verified] [bit] NOT NULL CONSTRAINT [DF_Page_PageType_Verified]  DEFAULT ((0)),
	[CreationDate] [datetime] NULL CONSTRAINT [DF_Page_PageType_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_Page_PageType_LastModifiedDate]  DEFAULT (getdate()),
	[CreationUserID] [int] NULL CONSTRAINT [DF_Page_PageType_CreationUserID]  DEFAULT ((1)),
	[LastModifiedUserID] [int] NULL CONSTRAINT [DF_Page_PageType_LastModifiedUserID]  DEFAULT ((1)),
 CONSTRAINT [PK_Page_PageType] PRIMARY KEY CLUSTERED 
(
	[PageID] ASC,
	[PageTypeID] ASC
)
)
END
GO
/****** Object:  Table [dbo].[IndicatedPage]    Script Date: 09/29/2009 09:01:38 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[IndicatedPage]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[IndicatedPage](
	[PageID] [int] NOT NULL,
	[Sequence] [smallint] NOT NULL,
	[PagePrefix] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[PageNumber] [nvarchar](20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Implied] [bit] NOT NULL,
	[CreationDate] [datetime] NULL CONSTRAINT [DF_IndicatedPage_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_IndicatedPage_LastModifiedDate]  DEFAULT (getdate()),
	[CreationUserID] [int] NULL CONSTRAINT [DF_IndicatedPage_CreationUserID]  DEFAULT ((1)),
	[LastModifiedUserID] [int] NULL CONSTRAINT [DF_IndicatedPage_LastModifiedUserID]  DEFAULT ((1)),
 CONSTRAINT [PK_IndicatedPage] PRIMARY KEY CLUSTERED 
(
	[PageID] ASC,
	[Sequence] ASC
)
)
END
GO
/****** Object:  Table [dbo].[PageName]    Script Date: 09/29/2009 09:03:09 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[PageName]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[PageName](
	[PageNameID] [int] IDENTITY(1,1) NOT NULL,
	[PageID] [int] NOT NULL,
	[Source] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NameFound] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
	[NameConfirmed] [nvarchar](100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[NameBankID] [int] NULL,
	[Active] [bit] NOT NULL,
	[CreateDate] [datetime] NOT NULL,
	[LastUpdateDate] [datetime] NOT NULL,
	[IsCommonName] [bit] NULL,
 CONSTRAINT [PK_PageName] PRIMARY KEY CLUSTERED 
(
	[PageNameID] ASC
)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PageName]') AND name = N'IDX_PageName_NameBankID')
CREATE NONCLUSTERED INDEX [IDX_PageName_NameBankID] ON [dbo].[PageName] 
(
	[NameBankID] ASC
)
INCLUDE ( [Active],
[NameConfirmed],
[PageID]) 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PageName]') AND name = N'IDX_PageName_NameConfirmedNameBankID')
CREATE NONCLUSTERED INDEX [IDX_PageName_NameConfirmedNameBankID] ON [dbo].[PageName] 
(
	[NameConfirmed] ASC,
	[NameBankID] ASC
)
INCLUDE ( [Active]) 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PageName]') AND name = N'IX_PageName_NameConfirmedNameBankIDDates')
CREATE NONCLUSTERED INDEX [IX_PageName_NameConfirmedNameBankIDDates] ON [dbo].[PageName] 
(
	[NameConfirmed] ASC,
	[NameBankID] ASC,
	[LastUpdateDate] ASC,
	[CreateDate] ASC
)
INCLUDE ( [PageNameID],
[Active]) 
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PageName]') AND name = N'IX_PageName_NameConfirmedPageID')
CREATE NONCLUSTERED INDEX [IX_PageName_NameConfirmedPageID] ON [dbo].[PageName] 
(
	[NameConfirmed] ASC,
	[PageID] ASC,
	[PageNameID] ASC
)
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PageName]') AND name = N'IX_PageName_PageID')
CREATE NONCLUSTERED INDEX [IX_PageName_PageID] ON [dbo].[PageName] 
(
	[PageID] ASC
)
GO
/****** Object:  Table [dbo].[TitleTag]    Script Date: 09/29/2009 09:04:27 ******/
IF NOT EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[TitleTag]') AND type in (N'U'))
BEGIN
CREATE TABLE [dbo].[TitleTag](
	[TitleID] [int] NOT NULL,
	[TagText] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AI NOT NULL,
	[MarcDataFieldTag] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[MarcSubFieldCode] [nvarchar](50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreationDate] [datetime] NULL CONSTRAINT [DF_TitleTag_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NULL CONSTRAINT [DF_TitleTag_LastModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_TitleTag] PRIMARY KEY CLUSTERED 
(
	[TitleID] ASC,
	[TagText] ASC
)
)
END
GO
IF NOT EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[TitleTag]') AND name = N'IX_TitleTag_TagText')
CREATE NONCLUSTERED INDEX [IX_TitleTag_TagText] ON [dbo].[TitleTag] 
(
	[TagText] ASC
)
GO

/****** Object:  Table [dbo].[Marc]    Script Date: 10/19/2009 11:38:27 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Marc](
	[MarcID] [int] IDENTITY(1,1) NOT NULL,
	[MarcImportStatusID] [int] NOT NULL,
	[MarcImportBatchID] [int] NOT NULL,
	[MarcFileLocation] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Marc_MarcFileLocation]  DEFAULT (''),
	[InstitutionCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[Leader] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_Marc_Leader]  DEFAULT (''),
	[TitleID] [int] NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_Marc_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_Marc_LastModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Marc] PRIMARY KEY CLUSTERED 
(
	[MarcID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[MarcControl]    Script Date: 10/19/2009 11:38:29 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarcControl](
	[MarcControlID] [int] IDENTITY(1,1) NOT NULL,
	[MarcID] [int] NOT NULL,
	[Tag] [nchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MarcControl_Tag]  DEFAULT (''),
	[Value] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MarcControl_Value]  DEFAULT (''),
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_MarcControl_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_MarcControl_LastModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_MarcControl] PRIMARY KEY CLUSTERED 
(
	[MarcControlID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Table [dbo].[MarcDataField]    Script Date: 10/19/2009 11:38:30 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarcDataField](
	[MarcDataFieldID] [int] IDENTITY(1,1) NOT NULL,
	[MarcID] [int] NOT NULL,
	[Tag] [nchar](3) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MarcDataField_Tag]  DEFAULT (''),
	[Indicator1] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MarcDataField_Indicator1]  DEFAULT (''),
	[Indicator2] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MarcDataField_Indicator2]  DEFAULT (''),
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_MarcDataField_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_MarcDataField_LastModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_MarcDataField] PRIMARY KEY CLUSTERED 
(
	[MarcDataFieldID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Index [IX_MarcDataField_MarcIDTag]    Script Date: 10/19/2009 11:38:30 ******/
CREATE NONCLUSTERED INDEX [IX_MarcDataField_MarcIDTag] ON [dbo].[MarcDataField] 
(
	[MarcID] ASC,
	[Tag] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

/****** Object:  Table [dbo].[MarcImportBatch]    Script Date: 10/19/2009 11:38:32 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarcImportBatch](
	[MarcImportBatchID] [int] IDENTITY(1,1) NOT NULL,
	[FileName] [nvarchar](500) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MarcImportBatch_FileName]  DEFAULT (''),
	[InstitutionCode] [nvarchar](10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_MarcImportBatch_CreationDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_MarcImportBatch] PRIMARY KEY CLUSTERED 
(
	[MarcImportBatchID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[MarcImportError]    Script Date: 10/19/2009 11:38:36 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarcImportError](
	[MarcImportErrorID] [int] IDENTITY(1,1) NOT NULL,
	[MarcImportBatchID] [int] NULL,
	[ItemID] [int] NULL,
	[ErrorDate] [datetime] NOT NULL CONSTRAINT [DF_MarcImportError_ErrorDate]  DEFAULT (getdate()),
	[Number] [int] NULL,
	[Severity] [int] NULL,
	[State] [int] NULL,
	[Procedure] [nvarchar](126) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MarcImportError_Procedure]  DEFAULT (''),
	[Line] [int] NULL,
	[Message] [nvarchar](4000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL CONSTRAINT [DF_MarcImportError_Message]  DEFAULT (''),
 CONSTRAINT [PK_MarcImportError] PRIMARY KEY CLUSTERED 
(
	[MarcImportErrorID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[MarcImportStatus]    Script Date: 10/19/2009 11:38:39 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarcImportStatus](
	[MarcImportStatusID] [int] NOT NULL,
	[StatusDescription] [nvarchar](30) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MarcImportStatus_StatusDescription]  DEFAULT (''),
 CONSTRAINT [PK_MarcImportStatus] PRIMARY KEY CLUSTERED 
(
	[MarcImportStatusID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

/****** Object:  Table [dbo].[MarcSubField]    Script Date: 10/19/2009 11:38:42 ******/
SET ANSI_NULLS ON
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[MarcSubField](
	[MarcSubFieldID] [int] IDENTITY(1,1) NOT NULL,
	[MarcDataFieldID] [int] NOT NULL,
	[Code] [nchar](1) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MarcSubField_Code]  DEFAULT (''),
	[Value] [nvarchar](200) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF_MarcSubField_Value]  DEFAULT (''),
	[CreationDate] [datetime] NOT NULL CONSTRAINT [DF_MarcSubField_CreationDate]  DEFAULT (getdate()),
	[LastModifiedDate] [datetime] NOT NULL CONSTRAINT [DF_MarcSubField_LastModifiedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_MarcSubField] PRIMARY KEY CLUSTERED 
(
	[MarcSubFieldID] ASC
)WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]
) ON [PRIMARY]

/****** Object:  Index [IX_MarcSubField_CodeValue]    Script Date: 10/19/2009 11:38:42 ******/
CREATE NONCLUSTERED INDEX [IX_MarcSubField_CodeValue] ON [dbo].[MarcSubField] 
(
	[Code] ASC,
	[Value] ASC
)
INCLUDE ( [MarcSubFieldID],
[MarcDataFieldID]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

/****** Object:  Index [IX_MarcSubField_MarcDataFieldIDCode]    Script Date: 10/19/2009 11:38:42 ******/
CREATE NONCLUSTERED INDEX [IX_MarcSubField_MarcDataFieldIDCode] ON [dbo].[MarcSubField] 
(
	[MarcDataFieldID] ASC,
	[Code] ASC
)
INCLUDE ( [Value]) WITH (PAD_INDEX  = OFF, STATISTICS_NORECOMPUTE  = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS  = ON, ALLOW_PAGE_LOCKS  = ON) ON [PRIMARY]

/****** Object:  Check [CK IndicatedPage Sequence]    Script Date: 09/29/2009 09:01:38 ******/
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK IndicatedPage Sequence]') AND parent_object_id = OBJECT_ID(N'[dbo].[IndicatedPage]'))
ALTER TABLE [dbo].[IndicatedPage]  WITH CHECK ADD  CONSTRAINT [CK IndicatedPage Sequence] CHECK  (([Sequence]>=(1) AND [Sequence]<=(4)))
GO
ALTER TABLE [dbo].[IndicatedPage] CHECK CONSTRAINT [CK IndicatedPage Sequence]
GO
/****** Object:  Check [CK Title EndYear]    Script Date: 09/29/2009 09:03:44 ******/
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK Title EndYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title]'))
ALTER TABLE [dbo].[Title]  WITH CHECK ADD  CONSTRAINT [CK Title EndYear] CHECK  (([EndYear]>=(1400) AND [EndYear]<=(2025) OR [EndYear] IS NULL))
GO
ALTER TABLE [dbo].[Title] CHECK CONSTRAINT [CK Title EndYear]
GO
/****** Object:  Check [CK Title StartYear]    Script Date: 09/29/2009 09:03:44 ******/
IF NOT EXISTS (SELECT * FROM sys.check_constraints WHERE object_id = OBJECT_ID(N'[dbo].[CK Title StartYear]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title]'))
ALTER TABLE [dbo].[Title]  WITH CHECK ADD  CONSTRAINT [CK Title StartYear] CHECK  (([StartYear]>=(1400) AND [StartYear]<=(2025) OR [StartYear] IS NULL))
GO
ALTER TABLE [dbo].[Title] CHECK CONSTRAINT [CK Title StartYear]
GO
/****** Object:  ForeignKey [IndicatedPage_FK00]    Script Date: 09/29/2009 09:01:38 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[IndicatedPage_FK00]') AND parent_object_id = OBJECT_ID(N'[dbo].[IndicatedPage]'))
ALTER TABLE [dbo].[IndicatedPage]  WITH CHECK ADD  CONSTRAINT [IndicatedPage_FK00] FOREIGN KEY([PageID])
REFERENCES [dbo].[Page] ([PageID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[IndicatedPage] CHECK CONSTRAINT [IndicatedPage_FK00]
GO
/****** Object:  ForeignKey [FK_Item_Institution]    Script Date: 09/29/2009 09:02:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_Institution]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_Institution] FOREIGN KEY([InstitutionCode])
REFERENCES [dbo].[Institution] ([InstitutionCode])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_Institution]
GO
/****** Object:  ForeignKey [FK_Item_ItemSource]    Script Date: 09/29/2009 09:02:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_ItemSource]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_ItemSource] FOREIGN KEY([ItemSourceID])
REFERENCES [dbo].[ItemSource] ([ItemSourceID])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_ItemSource]
GO
/****** Object:  ForeignKey [FK_Item_ItemStatus]    Script Date: 09/29/2009 09:02:03 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_ItemStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_ItemStatus] FOREIGN KEY([ItemStatusID])
REFERENCES [dbo].[ItemStatus] ([ItemStatusID])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_ItemStatus]
GO
/****** Object:  ForeignKey [FK_Item_Language]    Script Date: 09/29/2009 09:02:03 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_Language]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_Language] FOREIGN KEY([LanguageCode])
REFERENCES [dbo].[Language] ([LanguageCode])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_Language]
GO
/****** Object:  ForeignKey [FK_Item_PaginationStatus]    Script Date: 09/29/2009 09:02:03 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_PaginationStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_PaginationStatus] FOREIGN KEY([PaginationStatusID])
REFERENCES [dbo].[PaginationStatus] ([PaginationStatusID])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_PaginationStatus]
GO
/****** Object:  ForeignKey [FK_Item_Title]    Script Date: 09/29/2009 09:02:03 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_Title] FOREIGN KEY([PrimaryTitleID])
REFERENCES [dbo].[Title] ([TitleID])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_Title]
GO
/****** Object:  ForeignKey [FK_Item_Vault]    Script Date: 09/29/2009 09:02:03 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Item_Vault]') AND parent_object_id = OBJECT_ID(N'[dbo].[Item]'))
ALTER TABLE [dbo].[Item]  WITH CHECK ADD  CONSTRAINT [FK_Item_Vault] FOREIGN KEY([VaultID])
REFERENCES [dbo].[Vault] ([VaultID])
GO
ALTER TABLE [dbo].[Item] CHECK CONSTRAINT [FK_Item_Vault]
GO
/****** Object:  ForeignKey [FK_ItemLanguage_Item]    Script Date: 09/29/2009 09:02:05 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemLanguage_Item]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemLanguage]'))
ALTER TABLE [dbo].[ItemLanguage]  WITH CHECK ADD  CONSTRAINT [FK_ItemLanguage_Item] FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])
GO
ALTER TABLE [dbo].[ItemLanguage] CHECK CONSTRAINT [FK_ItemLanguage_Item]
GO
/****** Object:  ForeignKey [FK_ItemLanguage_Language]    Script Date: 09/29/2009 09:02:05 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_ItemLanguage_Language]') AND parent_object_id = OBJECT_ID(N'[dbo].[ItemLanguage]'))
ALTER TABLE [dbo].[ItemLanguage]  WITH CHECK ADD  CONSTRAINT [FK_ItemLanguage_Language] FOREIGN KEY([LanguageCode])
REFERENCES [dbo].[Language] ([LanguageCode])
GO
ALTER TABLE [dbo].[ItemLanguage] CHECK CONSTRAINT [FK_ItemLanguage_Language]
GO
/****** Object:  ForeignKey [Page_FK00]    Script Date: 09/29/2009 09:02:56 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Page_FK00]') AND parent_object_id = OBJECT_ID(N'[dbo].[Page]'))
ALTER TABLE [dbo].[Page]  WITH CHECK ADD  CONSTRAINT [Page_FK00] FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Page] CHECK CONSTRAINT [Page_FK00]
GO
/****** Object:  ForeignKey [Page_FK02]    Script Date: 09/29/2009 09:02:56 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Page_FK02]') AND parent_object_id = OBJECT_ID(N'[dbo].[Page]'))
ALTER TABLE [dbo].[Page]  WITH CHECK ADD  CONSTRAINT [Page_FK02] FOREIGN KEY([LastModifiedUserID])
REFERENCES [dbo].[User] ([UserID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Page] CHECK CONSTRAINT [Page_FK02]
GO
/****** Object:  ForeignKey [Page_PageType_FK00]    Script Date: 09/29/2009 09:03:01 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Page_PageType_FK00]') AND parent_object_id = OBJECT_ID(N'[dbo].[Page_PageType]'))
ALTER TABLE [dbo].[Page_PageType]  WITH CHECK ADD  CONSTRAINT [Page_PageType_FK00] FOREIGN KEY([PageID])
REFERENCES [dbo].[Page] ([PageID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Page_PageType] CHECK CONSTRAINT [Page_PageType_FK00]
GO
/****** Object:  ForeignKey [Page_PageType_FK01]    Script Date: 09/29/2009 09:03:02 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Page_PageType_FK01]') AND parent_object_id = OBJECT_ID(N'[dbo].[Page_PageType]'))
ALTER TABLE [dbo].[Page_PageType]  WITH CHECK ADD  CONSTRAINT [Page_PageType_FK01] FOREIGN KEY([PageTypeID])
REFERENCES [dbo].[PageType] ([PageTypeID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Page_PageType] CHECK CONSTRAINT [Page_PageType_FK01]
GO
/****** Object:  ForeignKey [FK_PageName_Page]    Script Date: 09/29/2009 09:03:09 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PageName_Page]') AND parent_object_id = OBJECT_ID(N'[dbo].[PageName]'))
ALTER TABLE [dbo].[PageName]  WITH CHECK ADD  CONSTRAINT [FK_PageName_Page] FOREIGN KEY([PageID])
REFERENCES [dbo].[Page] ([PageID])
GO
ALTER TABLE [dbo].[PageName] CHECK CONSTRAINT [FK_PageName_Page]
GO
/****** Object:  ForeignKey [FK_PDF_Item]    Script Date: 09/29/2009 09:03:26 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PDF_Item]') AND parent_object_id = OBJECT_ID(N'[dbo].[PDF]'))
ALTER TABLE [dbo].[PDF]  WITH CHECK ADD  CONSTRAINT [FK_PDF_Item] FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])
GO
ALTER TABLE [dbo].[PDF] CHECK CONSTRAINT [FK_PDF_Item]
GO
/****** Object:  ForeignKey [FK_PDF_PDFStatus]    Script Date: 09/29/2009 09:03:26 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PDF_PDFStatus]') AND parent_object_id = OBJECT_ID(N'[dbo].[PDF]'))
ALTER TABLE [dbo].[PDF]  WITH CHECK ADD  CONSTRAINT [FK_PDF_PDFStatus] FOREIGN KEY([PdfStatusID])
REFERENCES [dbo].[PDFStatus] ([PdfStatusID])
GO
ALTER TABLE [dbo].[PDF] CHECK CONSTRAINT [FK_PDF_PDFStatus]
GO
/****** Object:  ForeignKey [FK_PDFPage_PDF]    Script Date: 09/29/2009 09:03:28 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_PDFPage_PDF]') AND parent_object_id = OBJECT_ID(N'[dbo].[PDFPage]'))
ALTER TABLE [dbo].[PDFPage]  WITH CHECK ADD  CONSTRAINT [FK_PDFPage_PDF] FOREIGN KEY([PdfID])
REFERENCES [dbo].[PDF] ([PdfID])
GO
ALTER TABLE [dbo].[PDFPage] CHECK CONSTRAINT [FK_PDFPage_PDF]
GO
/****** Object:  ForeignKey [FK_Title_Title]    Script Date: 09/29/2009 09:03:44 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Title_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title]'))
ALTER TABLE [dbo].[Title]  WITH CHECK ADD  CONSTRAINT [FK_Title_Title] FOREIGN KEY([RedirectTitleID])
REFERENCES [dbo].[Title] ([TitleID])
GO
ALTER TABLE [dbo].[Title] CHECK CONSTRAINT [FK_Title_Title]
GO
/****** Object:  ForeignKey [Title_FK00]    Script Date: 09/29/2009 09:03:44 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_FK00]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title]'))
ALTER TABLE [dbo].[Title]  WITH CHECK ADD  CONSTRAINT [Title_FK00] FOREIGN KEY([InstitutionCode])
REFERENCES [dbo].[Institution] ([InstitutionCode])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Title] CHECK CONSTRAINT [Title_FK00]
GO
/****** Object:  ForeignKey [Title_FK01]    Script Date: 09/29/2009 09:03:44 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_FK01]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title]'))
ALTER TABLE [dbo].[Title]  WITH CHECK ADD  CONSTRAINT [Title_FK01] FOREIGN KEY([LanguageCode])
REFERENCES [dbo].[Language] ([LanguageCode])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Title] CHECK CONSTRAINT [Title_FK01]
GO
/****** Object:  ForeignKey [Title_FK02]    Script Date: 09/29/2009 09:03:44 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_FK02]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title]'))
ALTER TABLE [dbo].[Title]  WITH CHECK ADD  CONSTRAINT [Title_FK02] FOREIGN KEY([LastModifiedUserID])
REFERENCES [dbo].[User] ([UserID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Title] CHECK CONSTRAINT [Title_FK02]
GO
/****** Object:  ForeignKey [FK_Title_Creator_Creator]    Script Date: 09/29/2009 09:03:50 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Title_Creator_Creator]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_Creator]'))
ALTER TABLE [dbo].[Title_Creator]  WITH CHECK ADD  CONSTRAINT [FK_Title_Creator_Creator] FOREIGN KEY([CreatorID])
REFERENCES [dbo].[Creator] ([CreatorID])
GO
ALTER TABLE [dbo].[Title_Creator] CHECK CONSTRAINT [FK_Title_Creator_Creator]
GO
/****** Object:  ForeignKey [Title_Creator_FK00]    Script Date: 09/29/2009 09:03:50 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_Creator_FK00]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_Creator]'))
ALTER TABLE [dbo].[Title_Creator]  WITH CHECK ADD  CONSTRAINT [Title_Creator_FK00] FOREIGN KEY([CreatorRoleTypeID])
REFERENCES [dbo].[CreatorRoleType] ([CreatorRoleTypeID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Title_Creator] CHECK CONSTRAINT [Title_Creator_FK00]
GO
/****** Object:  ForeignKey [Title_Creator_FK02]    Script Date: 09/29/2009 09:03:50 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_Creator_FK02]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_Creator]'))
ALTER TABLE [dbo].[Title_Creator]  WITH CHECK ADD  CONSTRAINT [Title_Creator_FK02] FOREIGN KEY([TitleID])
REFERENCES [dbo].[Title] ([TitleID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Title_Creator] CHECK CONSTRAINT [Title_Creator_FK02]
GO
/****** Object:  ForeignKey [FK_Title_TitleIdentifier_Title]    Script Date: 09/29/2009 09:03:55 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Title_TitleIdentifier_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifier]'))
ALTER TABLE [dbo].[Title_TitleIdentifier]  WITH CHECK ADD  CONSTRAINT [FK_Title_TitleIdentifier_Title] FOREIGN KEY([TitleID])
REFERENCES [dbo].[Title] ([TitleID])
GO
ALTER TABLE [dbo].[Title_TitleIdentifier] CHECK CONSTRAINT [FK_Title_TitleIdentifier_Title]
GO
/****** Object:  ForeignKey [FK_Title_TitleIdentifier_TitleIdentifier]    Script Date: 09/29/2009 09:03:55 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_Title_TitleIdentifier_TitleIdentifier]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_TitleIdentifier]'))
ALTER TABLE [dbo].[Title_TitleIdentifier]  WITH CHECK ADD  CONSTRAINT [FK_Title_TitleIdentifier_TitleIdentifier] FOREIGN KEY([TitleIdentifierID])
REFERENCES [dbo].[TitleIdentifier] ([TitleIdentifierID])
GO
ALTER TABLE [dbo].[Title_TitleIdentifier] CHECK CONSTRAINT [FK_Title_TitleIdentifier_TitleIdentifier]
GO
/****** Object:  ForeignKey [Title_TitleType_FK00]    Script Date: 09/29/2009 09:03:58 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleType_FK00]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_TitleType]'))
ALTER TABLE [dbo].[Title_TitleType]  WITH CHECK ADD  CONSTRAINT [Title_TitleType_FK00] FOREIGN KEY([TitleID])
REFERENCES [dbo].[Title] ([TitleID])
ON UPDATE CASCADE
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[Title_TitleType] CHECK CONSTRAINT [Title_TitleType_FK00]
GO
/****** Object:  ForeignKey [Title_TitleType_FK01]    Script Date: 09/29/2009 09:03:58 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[Title_TitleType_FK01]') AND parent_object_id = OBJECT_ID(N'[dbo].[Title_TitleType]'))
ALTER TABLE [dbo].[Title_TitleType]  WITH CHECK ADD  CONSTRAINT [Title_TitleType_FK01] FOREIGN KEY([TitleTypeID])
REFERENCES [dbo].[TitleType] ([TitleTypeID])
ON UPDATE CASCADE
GO
ALTER TABLE [dbo].[Title_TitleType] CHECK CONSTRAINT [Title_TitleType_FK01]
GO
/****** Object:  ForeignKey [FK_TitleAssociation_Title]    Script Date: 09/29/2009 09:04:04 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleAssociation_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleAssociation]'))
ALTER TABLE [dbo].[TitleAssociation]  WITH CHECK ADD  CONSTRAINT [FK_TitleAssociation_Title] FOREIGN KEY([TitleID])
REFERENCES [dbo].[Title] ([TitleID])
GO
ALTER TABLE [dbo].[TitleAssociation] CHECK CONSTRAINT [FK_TitleAssociation_Title]
GO
/****** Object:  ForeignKey [FK_TitleAssociation_Title1]    Script Date: 09/29/2009 09:04:04 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleAssociation_Title1]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleAssociation]'))
ALTER TABLE [dbo].[TitleAssociation]  WITH CHECK ADD  CONSTRAINT [FK_TitleAssociation_Title1] FOREIGN KEY([AssociatedTitleID])
REFERENCES [dbo].[Title] ([TitleID])
GO
ALTER TABLE [dbo].[TitleAssociation] CHECK CONSTRAINT [FK_TitleAssociation_Title1]
GO
/****** Object:  ForeignKey [FK_TitleAssociation_TitleAssociationType]    Script Date: 09/29/2009 09:04:04 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleAssociation_TitleAssociationType]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleAssociation]'))
ALTER TABLE [dbo].[TitleAssociation]  WITH CHECK ADD  CONSTRAINT [FK_TitleAssociation_TitleAssociationType] FOREIGN KEY([TitleAssociationTypeID])
REFERENCES [dbo].[TitleAssociationType] ([TitleAssociationTypeID])
GO
ALTER TABLE [dbo].[TitleAssociation] CHECK CONSTRAINT [FK_TitleAssociation_TitleAssociationType]
GO
/****** Object:  ForeignKey [FK_TitleAssociation_TitleIdentifier_TitleAssociation]    Script Date: 09/29/2009 09:04:07 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleAssociation_TitleIdentifier_TitleAssociation]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleAssociation_TitleIdentifier]'))
ALTER TABLE [dbo].[TitleAssociation_TitleIdentifier]  WITH CHECK ADD  CONSTRAINT [FK_TitleAssociation_TitleIdentifier_TitleAssociation] FOREIGN KEY([TitleAssociationID])
REFERENCES [dbo].[TitleAssociation] ([TitleAssociationID])
ON DELETE CASCADE
GO
ALTER TABLE [dbo].[TitleAssociation_TitleIdentifier] CHECK CONSTRAINT [FK_TitleAssociation_TitleIdentifier_TitleAssociation]
GO
/****** Object:  ForeignKey [FK_TitleAssociation_TitleIdentifier_TitleIdentifier]    Script Date: 09/29/2009 09:04:07 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleAssociation_TitleIdentifier_TitleIdentifier]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleAssociation_TitleIdentifier]'))
ALTER TABLE [dbo].[TitleAssociation_TitleIdentifier]  WITH CHECK ADD  CONSTRAINT [FK_TitleAssociation_TitleIdentifier_TitleIdentifier] FOREIGN KEY([TitleIdentifierID])
REFERENCES [dbo].[TitleIdentifier] ([TitleIdentifierID])
GO
ALTER TABLE [dbo].[TitleAssociation_TitleIdentifier] CHECK CONSTRAINT [FK_TitleAssociation_TitleIdentifier_TitleIdentifier]
GO
/****** Object:  ForeignKey [FK_TitleItem_Item]    Script Date: 09/29/2009 09:04:20 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleItem_Item]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleItem]'))
ALTER TABLE [dbo].[TitleItem]  WITH CHECK ADD  CONSTRAINT [FK_TitleItem_Item] FOREIGN KEY([ItemID])
REFERENCES [dbo].[Item] ([ItemID])
GO
ALTER TABLE [dbo].[TitleItem] CHECK CONSTRAINT [FK_TitleItem_Item]
GO
/****** Object:  ForeignKey [FK_TitleItem_Title]    Script Date: 09/29/2009 09:04:21 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleItem_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleItem]'))
ALTER TABLE [dbo].[TitleItem]  WITH CHECK ADD  CONSTRAINT [FK_TitleItem_Title] FOREIGN KEY([TitleID])
REFERENCES [dbo].[Title] ([TitleID])
GO
ALTER TABLE [dbo].[TitleItem] CHECK CONSTRAINT [FK_TitleItem_Title]
GO
/****** Object:  ForeignKey [FK_TitleLanguage_Language]    Script Date: 09/29/2009 09:04:23 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleLanguage_Language]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleLanguage]'))
ALTER TABLE [dbo].[TitleLanguage]  WITH CHECK ADD  CONSTRAINT [FK_TitleLanguage_Language] FOREIGN KEY([LanguageCode])
REFERENCES [dbo].[Language] ([LanguageCode])
GO
ALTER TABLE [dbo].[TitleLanguage] CHECK CONSTRAINT [FK_TitleLanguage_Language]
GO
/****** Object:  ForeignKey [FK_TitleLanguage_Title]    Script Date: 09/29/2009 09:04:23 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleLanguage_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleLanguage]'))
ALTER TABLE [dbo].[TitleLanguage]  WITH CHECK ADD  CONSTRAINT [FK_TitleLanguage_Title] FOREIGN KEY([TitleID])
REFERENCES [dbo].[Title] ([TitleID])
GO
ALTER TABLE [dbo].[TitleLanguage] CHECK CONSTRAINT [FK_TitleLanguage_Title]
GO
/****** Object:  ForeignKey [FK_TitleTag_Title]    Script Date: 09/29/2009 09:04:27 ******/
IF NOT EXISTS (SELECT * FROM sys.foreign_keys WHERE object_id = OBJECT_ID(N'[dbo].[FK_TitleTag_Title]') AND parent_object_id = OBJECT_ID(N'[dbo].[TitleTag]'))
ALTER TABLE [dbo].[TitleTag]  WITH CHECK ADD  CONSTRAINT [FK_TitleTag_Title] FOREIGN KEY([TitleID])
REFERENCES [dbo].[Title] ([TitleID])
GO
ALTER TABLE [dbo].[TitleTag] CHECK CONSTRAINT [FK_TitleTag_Title]
GO
/****** Object:  ForeignKey [dbo].[Marc]    Script Date: 10/19/2009 11:38:27 ******/
ALTER TABLE [dbo].[Marc]  WITH CHECK ADD  CONSTRAINT [FK_Marc_MarcImportBatch] FOREIGN KEY([MarcImportBatchID])
REFERENCES [dbo].[MarcImportBatch] ([MarcImportBatchID])
ON DELETE CASCADE
ALTER TABLE [dbo].[Marc] CHECK CONSTRAINT [FK_Marc_MarcImportBatch]
ALTER TABLE [dbo].[Marc]  WITH CHECK ADD  CONSTRAINT [FK_Marc_MarcImportStatus] FOREIGN KEY([MarcImportStatusID])
REFERENCES [dbo].[MarcImportStatus] ([MarcImportStatusID])
ALTER TABLE [dbo].[Marc] CHECK CONSTRAINT [FK_Marc_MarcImportStatus]
GO
/****** Object:  ForeignKey [dbo].[MarcControl]    Script Date: 10/19/2009 11:38:29 ******/
ALTER TABLE [dbo].[MarcControl]  WITH CHECK ADD  CONSTRAINT [FK_MarcControl_Marc] FOREIGN KEY([MarcID])
REFERENCES [dbo].[Marc] ([MarcID])
ON DELETE CASCADE
ALTER TABLE [dbo].[MarcControl] CHECK CONSTRAINT [FK_MarcControl_Marc]
GO
/****** Object:  ForeignKey [dbo].[MarcDataField]    Script Date: 10/19/2009 11:38:30 ******/
ALTER TABLE [dbo].[MarcDataField]  WITH CHECK ADD  CONSTRAINT [FK_MarcDataField_Marc] FOREIGN KEY([MarcID])
REFERENCES [dbo].[Marc] ([MarcID])
ON DELETE CASCADE
ALTER TABLE [dbo].[MarcDataField] CHECK CONSTRAINT [FK_MarcDataField_Marc]
GO
/****** Object:  ForeignKey [dbo].[MarcSubField]    Script Date: 10/19/2009 11:38:30 ******/
ALTER TABLE [dbo].[MarcSubField]  WITH CHECK ADD  CONSTRAINT [FK_MarcSubField_MarcDataField] FOREIGN KEY([MarcDataFieldID])
REFERENCES [dbo].[MarcDataField] ([MarcDataFieldID])
ON DELETE CASCADE
ALTER TABLE [dbo].[MarcSubField] CHECK CONSTRAINT [FK_MarcSubField_MarcDataField]
GO
