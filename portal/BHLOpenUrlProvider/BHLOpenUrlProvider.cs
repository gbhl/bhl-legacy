using System;
using System.Collections.Generic;
using System.Configuration;
using System.Text;
using MOBOT.OpenUrl.Utilities;
using MOBOT.BHL.DataObjects;
using MOBOT.BHL.DAL;
using CustomDataAccess;

namespace MOBOT.BHL.OpenUrlProvider
{
    public class BHLOpenUrlProvider : IOpenUrlProvider
    {
        private string _urlFormat = string.Empty;

        public string UrlFormat
        {
            get { return _urlFormat; }
            set { _urlFormat = value; }
        }

        private string _itemUrlFormat = string.Empty;

        public string ItemUrlFormat
        {
            get { return _itemUrlFormat; }
            set { _itemUrlFormat = value; }
        }

        private string _titleUrlFormat = string.Empty;

        public string TitleUrlFormat
        {
            get { return _titleUrlFormat; }
            set { _titleUrlFormat = value; }
        }

        #region IOpenUrlProvider Members

        public IOpenUrlResponse FindCitation(IOpenUrlQuery query)
        {
            IOpenUrlResponse response = new OpenUrlResponse();

            try
            {
                if (query == null) throw new Exception("Query cannot be null.");

                if (query.ValidateQuery())  // Validate the query
                {
                    bool foundCitation = false;
                    OpenUrlCitationDAL ouDAL = new OpenUrlCitationDAL();
                    int pageID = 0;
                    if (query.Version == "1.0")
                    {
                        pageID = this.GetBHLIDFromIdentifierList(query, "page");
                    }
                    else
                    {
                        String pageIDString = this.GetIDFromIdentifierList(query, "page");
                        Int32.TryParse(pageIDString, out pageID);
                    }
                    
                    // If we've got a page id, submit a query to database
                    CustomGenericList<OpenUrlCitation> citations = new CustomGenericList<OpenUrlCitation>();
                    if (pageID > 0) citations = ouDAL.OpenUrlCitationSelectByPageID(null, null, pageID);
                    if (citations.Count > 0) foundCitation = true;

                    // If we haven't found a citation, try finding the title using title and page criteria
                    if (!foundCitation)
                    {
                        // Get the title ID, if one was specified
                        int titleID = 0;
                        if (query.Version == "1.0")
                        {
                            titleID = this.GetBHLIDFromIdentifierList(query, "bibliography");
                        }
                        else
                        {
                            String titleIDString = this.GetIDFromIdentifierList(query, "title");
                            Int32.TryParse(titleIDString, out titleID);
                        }

                        // Get OCLC and LCCN identifiers, if specified
                        string oclc = this.GetIDFromIdentifierList(query, "oclcnum");
                        string lccn = this.GetIDFromIdentifierList(query, "lccn");

                        // Look for citations
                        citations = ouDAL.OpenUrlCitationSelectByCitationDetails(null, null, titleID, oclc, lccn,
                            query.Isbn, query.Issn, query.ShortTitle, query.Coden, 
                            (query.BookTitle != String.Empty ? query.BookTitle : query.JournalTitle),
                            query.AuthorLast, query.AuthorFirst, query.AuthorCorporation,
                            query.PublisherName, query.PublisherPlace, query.Publisher,
                            query.Volume, query.Issue, query.Date.Year(), query.StartPage);

                        if (citations.Count > 0) foundCitation = true;
                    }

                    if (foundCitation)
                    {
                        // For each citation we got back from the database, add a citation to the response
                        foreach (OpenUrlCitation citation in citations)
                        {
                            OpenUrlResponseCitation responseCitation = new OpenUrlResponseCitation();
                            responseCitation.Title = citation.FullTitle;
                            responseCitation.PublisherName = citation.PublisherName;
                            responseCitation.PublisherPlace = citation.PublisherPlace;
                            responseCitation.Date = citation.Date;
                            responseCitation.Language = citation.LanguageName;
                            responseCitation.Volume = citation.Volume;
                            responseCitation.Genre = citation.Genre;
                            if (citation.PageID > 0) responseCitation.Url = String.Format(UrlFormat, citation.PageID.ToString());
                            if (citation.ItemID > 0) responseCitation.ItemUrl = String.Format(ItemUrlFormat, citation.ItemID.ToString());
                            if (citation.TitleID > 0) responseCitation.TitleUrl = String.Format(TitleUrlFormat, citation.TitleID.ToString());
                            responseCitation.Oclc = citation.Oclc;
                            responseCitation.Issn = citation.Issn;
                            responseCitation.Isbn = citation.Isbn;
                            responseCitation.Lccn = citation.Lccn;
                            responseCitation.STitle = citation.Abbreviation;
                            responseCitation.PublicationFrequency = citation.CurrentPublicationFrequency;
                            responseCitation.Edition = citation.EditionStatement;
                            responseCitation.SPage = citation.StartPage;
                            responseCitation.EPage = citation.EndPage;
                            responseCitation.Pages = citation.Pages;

                            if (citation.Authors.Length > 0)
                            {
                                string[] authors = citation.Authors.Split('|');
                                foreach (string author in authors)
                                {
                                    responseCitation.Authors.Add(author);
                                }
                            }

                            if (citation.Subjects.Length > 0)
                            {
                                string[] subjects = citation.Subjects.Split('|');
                                foreach (string subject in subjects)
                                {
                                    responseCitation.Subjects.Add(subject);
                                }
                            }

                            response.citations.Add(responseCitation);
                        }
                    }

                    // Data for testing
                    //this.AddTestData(response);

                    response.Status = ResponseStatus.Success;
                }
                else
                {
                    response.Status = ResponseStatus.Error;
                    response.Message = query.ValidationError;
                }
            }
            catch (Exception ex)
            {
                response.Status = ResponseStatus.Error;
                response.Message = ex.Message;
            }

            // Return the response
            return response;
        }

        #endregion

        /// <summary>
        /// Look for a url identifier of the specified type in the identifiers collection
        /// </summary>
        /// <param name="query"></param>
        /// <param name="idType">"page" or "bibliography"</param>
        /// <returns>The numeric identifier portion of the url</returns>
        private int GetBHLIDFromIdentifierList(IOpenUrlQuery query, string idType)
        {
            int id = 0;

            if (idType == "page" || idType == "bibliography")
            {
                // Check if we have an ID of the specified type
                if (query.Version == "1.0")
                {
                    for (int x = 0; x < query.Identifiers.Length; x++)
                    {
                        // Look for the ID in a url (http://www.biodiversitylibrary.org/page/1234)
                        if ((string)query.Identifiers[x].Key == "url")
                        {
                            string url = (string)query.Identifiers[x].Value;
                            if (url.Contains(idType + "/"))
                            {
                                Int32.TryParse(url.Substring(url.LastIndexOf('/') + 1), out id);
                            }
                        }
                    }
                }
                else
                {
                    for (int x = 0; x < query.Identifiers.Length; x++)
                    {
                        // Look for an identifier key of the appropriate type
                        if ((string)query.Identifiers[x].Key == idType)
                        {
                            Int32.TryParse((string)query.Identifiers[x].Value, out id);
                        }
                    }
                }
            }

            return id;
        }

        /// <summary>
        /// Look for an identifier of the specified type in the identifiers collection
        /// </summary>
        /// <param name="query"></param>
        /// <param name="idType"></param>
        /// <returns></returns>
        private string GetIDFromIdentifierList(IOpenUrlQuery query, string idType)
        {
            string id = string.Empty;

            if (idType == "oclcnum" || idType == "lccn" || idType == "title" || idType == "page")
            {
                // Check if we have an ID of the specified type
                for (int x = 0; x < query.Identifiers.Length; x++)
                {
                    if ((string)query.Identifiers[x].Key == idType)
                    {
                        id = (string)query.Identifiers[x].Value;
                    }
                }
            }

            return id;
        }

        private void AddTestData(IOpenUrlResponse response)
        {
            OpenUrlResponseCitation citation = new OpenUrlResponseCitation();
            citation.Title = "The cannon-ball tree : the monkey-pots";
            citation.PublisherName = "Field Museum of Natural History,";
            citation.PublisherPlace = "Chicago:";
            citation.Date = "1924";
            citation.Language = "English";
            citation.Volume = "Fieldiana, Popular Series, Botany, no. 6";
            citation.Genre = "Book";
            citation.Authors.Add("Dahlgren, B. E.");
            citation.Authors.Add("Lang, H.");
            citation.Subjects.Add("Brazil nut");
            citation.Subjects.Add("Lecythidaceae");
            citation.Subjects.Add("South American");
            citation.Subjects.Add("Trees");
            citation.Url = "http://www.biodiversitylibrary.org/page/4354945";
            citation.TitleUrl = "http://www.biodiversitylibary.org/title/5435";
            citation.Oclc = "179674112";
            response.citations.Add(citation);
            citation = new OpenUrlResponseCitation();
            citation.Title = "The cannon-ball tree : the monkey-pots";
            citation.PublisherName = "Field Museum of Natural History,";
            citation.PublisherPlace = "Chicago:";
            citation.Date = "1924";
            citation.Language = "English";
            citation.Volume = "Fieldiana, Popular Series, Botany, no. 6";
            citation.Genre = "Book";
            citation.Authors.Add("Dahlgren, B. E.");
            citation.Authors.Add("Lang, H.");
            citation.Subjects.Add("Brazil nut");
            citation.Subjects.Add("Lecythidaceae");
            citation.Subjects.Add("South American");
            citation.Subjects.Add("Trees");
            citation.Url = "http://www.biodiversitylibrary.org/page/4354939";
            citation.TitleUrl = "http://www.biodiversitylibary.org/title/5435";
            citation.Oclc = "179674112";
            response.citations.Add(citation);
        }
    }
}
