﻿using System;
using System.Collections.Generic;
using System.Configuration;
using System.Web;
using System.Web.UI;
using System.Web.UI.WebControls;
using MOBOT.BHL.Server;
using MOBOT.BHL.DataObjects;
using CustomDataAccess;

namespace MOBOT.BHL.Web.Admin
{
    public partial class TitleImportResults : System.Web.UI.Page
    {
        private int _inserted = 0;
        private int _updated = 0;
        private List<String> _error = new List<string>();

        protected void Page_Load(object sender, EventArgs e)
        {
            if (!IsPostBack)
            {
                // Save the batch id
                String batchID = Request.QueryString["id"] == null ? "" : Request.QueryString["id"].ToString();

                // Get the list of titles in this batch
                int batchInt;
                if (Int32.TryParse(batchID, out batchInt))
                {
                    this.ImportMarcBatch(batchInt);

                    litInserted.Text = _inserted.ToString();
                    litUpdated.Text = _updated.ToString();
                    litErrors.Text = _error.Count.ToString();

                    if (_error.Count > 0)
                    {
                        litErrHeader.Visible = true;
                        dlErrors.DataSource = _error;
                        dlErrors.DataBind();
                    }
                }
                else
                {
                    errorControl.AddErrorText("Invalid batch identifier.");
                    errorControl.Visible = true;
                }
            }
        }

        private void ImportMarcBatch(int batchID)
        {
            BHLProvider provider = new BHLProvider();

            CustomGenericList<Marc> marcs = provider.MarcSelectForImportByBatchID(batchID);

            foreach (Marc marc in marcs)
            {
                Title title = null;

                try
                {
                    title = null;
                    String marcBibId = marc.Leader.Trim().Replace(' ', 'x');

                    if (marc.BhlTitleId == 0)
                    {
                        // Build new title class, populate, and save
                        title = provider.MarcSelectTitleDetailsByMarcID(marc.MarcID);
                        title.IsNew = true;
                        title.InstitutionCode = marc.InstitutionCode;

                        // Grab all of the supporting data (subjects, languages, authors, identifiers, associations)
                        CustomGenericList<TitleTag> titleTags = provider.MarcSelectTitleTagsByMarcID(marc.MarcID);
                        foreach (TitleTag titleTag in titleTags)
                        {
                            titleTag.IsNew = true;
                            title.TitleTags.Add(titleTag);
                        }
                        CustomGenericList<TitleLanguage> titleLanguages = provider.MarcSelectTitleLanguagesByMarcID(marc.MarcID);
                        foreach (TitleLanguage titleLanguage in titleLanguages)
                        {
                            titleLanguage.IsNew = true;
                            title.TitleLanguages.Add(titleLanguage);
                        }
                        CustomGenericList<Title_Creator> titleCreators = provider.MarcSelectCreatorsByMarcID(marc.MarcID);
                        foreach (Title_Creator titleCreator in titleCreators)
                        {
                            titleCreator.IsNew = true;
                            title.TitleCreators.Add(titleCreator);
                        }
                        CustomGenericList<Title_TitleIdentifier> titleIdentifiers = provider.MarcSelectTitleIdentifiersByMarcID(marc.MarcID);
                        foreach (Title_TitleIdentifier titleIdentifier in titleIdentifiers)
                        {
                            titleIdentifier.IsNew = true;
                            title.TitleIdentifiers.Add(titleIdentifier);
                        }
                        CustomGenericList<TitleAssociation> titleAssociations = provider.MarcSelectAssociationsByMarcID(marc.MarcID);
                        foreach (TitleAssociation titleAssociation in titleAssociations)
                        {
                            titleAssociation.IsNew = true;

                            // Get title association title identifiers
                            titleAssociation.TitleAssociationIdentifiers =
                                provider.MarcSelectAssociationIdsByMarcDataFieldID(titleAssociation.MarcDataFieldID);
                            title.TitleAssociations.Add(titleAssociation);
                        }

                        // Save the new title
                        provider.TitleSave(title, 1);

                        // Copy MARC XML file to the appropriate server
                        // - Create new folder in current vault (using MarcBibID as name)
                        // - Copy MARC.XML file to new folder (using MarcBibID as name)
                        MOBOT.BHL.DataObjects.Configuration config = provider.ConfigurationSelectByName(
                            System.Configuration.ConfigurationManager.AppSettings["ConfigNameCurrentIAVault"]);
                        if (config != null)
                        {
                            Vault vault = provider.VaultSelect(Convert.ToInt32(config.ConfigurationValue));
                            if (vault != null)
                            {
                                String destinationFile = vault.OCRFolderShare + "\\" + title.MARCBibID + "\\" + title.MARCBibID + "_marc.xml";
                                provider.GetFileAccessProvider(ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true").MoveFile(marc.MarcFileLocation, destinationFile);
                            }
                        }

                        _inserted++;
                    }
                    else
                    {
                        // Load existing title and new title information
                        title = provider.TitleSelectExtended(marc.BhlTitleId);
                        Title marcTitle = provider.MarcSelectTitleDetailsByMarcID(marc.MarcID);

                        // Update title values
                        title.MARCLeader = marcTitle.MARCLeader;
                        title.FullTitle = marcTitle.FullTitle;
                        title.ShortTitle = marcTitle.ShortTitle;
                        title.UniformTitle = marcTitle.UniformTitle;
                        title.SortTitle = marcTitle.SortTitle;
                        title.CallNumber = marcTitle.CallNumber;
                        title.PublicationDetails = marcTitle.PublicationDetails;
                        title.StartYear = marcTitle.StartYear;
                        title.EndYear = marcTitle.EndYear;
                        title.Datafield_260_a = marcTitle.Datafield_260_a;
                        title.Datafield_260_b = marcTitle.Datafield_260_b;
                        title.Datafield_260_c = marcTitle.Datafield_260_c;
                        title.InstitutionCode = marc.InstitutionCode;
                        title.LanguageCode = marcTitle.LanguageCode;
                        title.OriginalCatalogingSource = marcTitle.OriginalCatalogingSource;
                        title.EditionStatement = marcTitle.EditionStatement;
                        title.CurrentPublicationFrequency = marcTitle.CurrentPublicationFrequency;

                        // Replace all subjects associated with this title
                        foreach (TitleTag titletag in title.TitleTags)
                        {
                            titletag.IsDeleted = true;
                        }

                        CustomGenericList<TitleTag> titleTags = provider.MarcSelectTitleTagsByMarcID(marc.MarcID);
                        foreach (TitleTag titleTag in titleTags)
                        {
                            titleTag.IsNew = true;
                            titleTag.TitleID = title.TitleID;
                            title.TitleTags.Add(titleTag);
                        }

                        // Replace all languages associated with this title
                        foreach (TitleLanguage titlelanguage in title.TitleLanguages)
                        {
                            titlelanguage.IsDeleted = true;
                        }

                        CustomGenericList<TitleLanguage> titleLanguages = provider.MarcSelectTitleLanguagesByMarcID(marc.MarcID);
                        foreach (TitleLanguage titleLanguage in titleLanguages)
                        {
                            titleLanguage.IsNew = true;
                            titleLanguage.TitleID = title.TitleID;
                            title.TitleLanguages.Add(titleLanguage);
                        }

                        // Replace all title creators associated with this title
                        foreach (Title_Creator titleCreator in title.TitleCreators)
                        {
                            titleCreator.IsDeleted = true;
                        }

                        CustomGenericList<Title_Creator> titleCreators = provider.MarcSelectCreatorsByMarcID(marc.MarcID);
                        foreach (Title_Creator titleCreator in titleCreators)
                        {
                            titleCreator.IsNew = true;
                            titleCreator.TitleID = title.TitleID;
                            title.TitleCreators.Add(titleCreator);
                        }

                        // Replace all identifiers associated with this title
                        foreach (Title_TitleIdentifier title_titleidentifier in title.TitleIdentifiers)
                        {
                            title_titleidentifier.IsDeleted = true;
                        }

                        CustomGenericList<Title_TitleIdentifier> titleIdentifiers = provider.MarcSelectTitleIdentifiersByMarcID(marc.MarcID);
                        foreach (Title_TitleIdentifier titleIdentifier in titleIdentifiers)
                        {
                            titleIdentifier.IsNew = true;
                            titleIdentifier.TitleID = title.TitleID;
                            title.TitleIdentifiers.Add(titleIdentifier);
                        }

                        // Replace all associations associated with this title
                        foreach (TitleAssociation titleAssociation in title.TitleAssociations)
                        {
                            titleAssociation.IsDeleted = true;
                        }

                        CustomGenericList<TitleAssociation> titleAssociations = provider.MarcSelectAssociationsByMarcID(marc.MarcID);
                        foreach (TitleAssociation titleAssociation in titleAssociations)
                        {
                            titleAssociation.IsNew = true;
                            titleAssociation.TitleID = title.TitleID;
                            titleAssociation.Active = true;

                            // Get title association title identifiers
                            titleAssociation.TitleAssociationIdentifiers = 
                                provider.MarcSelectAssociationIdsByMarcDataFieldID(titleAssociation.MarcDataFieldID);
                            title.TitleAssociations.Add(titleAssociation);
                        }

                        // Update the title
                        provider.TitleSave(title, 1);

                        // Copy MARC XML file to the appropriate location(s)
                        CustomGenericList<PageSummaryView> folders = provider.PageSummarySelectFoldersForTitleID(title.TitleID);
                        CustomGenericList<PageSummaryView> barcodes = provider.PageSummarySelectBarcodeForTitleID(title.TitleID);

                        // For each folder containing items for this title
                        foreach (PageSummaryView folder in folders)
                        {
                            // Get the files in the folder
                            MOBOT.FileAccess.IFileAccessProvider fileAccess =
                                provider.GetFileAccessProvider(ConfigurationManager.AppSettings["UseRemoteFileAccessProvider"] == "true");
                            String destinationFolder = folder.OCRFolderShare + "\\" + folder.FileRootFolder;
                            String[] marcXmlFiles = fileAccess.GetFiles(destinationFolder);

                            // Check each file
                            foreach (String marcXmlFile in marcXmlFiles)
                            {
                                if (marcXmlFile.EndsWith("_marc.xml"))
                                {
                                    // See if any file is related to this title
                                    foreach (PageSummaryView barcode in barcodes)
                                    {
                                        if (marcXmlFile.EndsWith(barcode.BarCode + "_marc.xml"))
                                        {
                                            // Found a match, so replace the file
                                            fileAccess.MoveFile(marcXmlFile, marcXmlFile + "." + System.DateTime.Now.Ticks.ToString());
                                            fileAccess.CopyFile(marc.MarcFileLocation, marcXmlFile, true);
                                            break;
                                        }
                                    }
                                }
                            }
                        }

                        _updated++;
                    }

                    // Update the record to indicate that the import has completed
                    provider.MarcUpdateStatusImported(marc.MarcID);
                }
                catch (Exception ex)
                {
                    // Update the record to indicate the failed import
                    provider.MarcUpdateStatusError(marc.MarcID);

                    if (title != null)
                    {
                        _error.Add("Error loading '" + title.ShortTitle + "': " + ex.Message);
                    }
                    else
                    {
                        _error.Add("Error loading MARC ID " + marc.MarcID.ToString() + ": " + ex.Message);
                    }
                }
            }
        }
    }
}
