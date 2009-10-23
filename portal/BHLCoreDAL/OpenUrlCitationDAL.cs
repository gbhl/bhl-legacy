using System;
using System.Data;
using System.Data.SqlClient;
using CustomDataAccess;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.DAL
{
    public class OpenUrlCitationDAL
    {
        public CustomGenericList<OpenUrlCitation> OpenUrlCitationSelectByPageID(
            SqlConnection sqlConnection,
            SqlTransaction sqlTransaction,
            int pageID)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("OpenUrlCitationSelectByPageID", connection, transaction,
    				CustomSqlHelper.CreateInputParameter( "PageID", SqlDbType.Int, null, true, pageID) ))
            {
                CustomGenericList<CustomDataRow> list = CustomSqlHelper.ExecuteReaderAndReturnRows(command);
                return this.GetOpenUrlCitationList(list);
            }
        }

        public CustomGenericList<OpenUrlCitation> OpenUrlCitationSelectByTitleID(
            SqlConnection sqlConnection,
            SqlTransaction sqlTransaction,
            int titleID)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("OpenUrlCitationSelectByTitleID", connection, transaction,
                    CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, true, titleID)))
            {
                CustomGenericList<CustomDataRow> list = CustomSqlHelper.ExecuteReaderAndReturnRows(command);
                return this.GetOpenUrlCitationList(list);
            }
        }

        public CustomGenericList<OpenUrlCitation> OpenUrlCitationSelectByTitleIdentifier(
            SqlConnection sqlConnection,
            SqlTransaction sqlTransaction,
            string identifierName,
            string identifierValue)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("OpenUrlCitationSelectByTitleIdentifier", connection, transaction,
                    CustomSqlHelper.CreateInputParameter("IdentifierName", SqlDbType.NVarChar, 40, true, identifierName),
                    CustomSqlHelper.CreateInputParameter("IdentifierValue", SqlDbType.NVarChar, 125, true, identifierValue)))
            {
                CustomGenericList<CustomDataRow> list = CustomSqlHelper.ExecuteReaderAndReturnRows(command);
                return this.GetOpenUrlCitationList(list);
            }
        }

        public CustomGenericList<OpenUrlCitation> OpenUrlCitationSelectByTitleDetails(
            SqlConnection sqlConnection,
            SqlTransaction sqlTransaction,
            string title,
            string authorLast,
            string authorFirst,
            string authorCorporation,
            string publisherName,
            string publisherPlace,
            string publisher)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("OpenUrlCitationSelectByTitleDetails", connection, transaction,
                    CustomSqlHelper.CreateInputParameter("Title", SqlDbType.NVarChar, 2000, true, title),
                    CustomSqlHelper.CreateInputParameter("AuthorLast", SqlDbType.NVarChar, 150, true, authorLast),
                    CustomSqlHelper.CreateInputParameter("AuthorFirst", SqlDbType.NVarChar, 100, true, authorFirst),
                    CustomSqlHelper.CreateInputParameter("AuthorCorporation", SqlDbType.NVarChar, 255, true, authorCorporation),
                    CustomSqlHelper.CreateInputParameter("PublisherName", SqlDbType.NVarChar, 255, true, publisherName),
                    CustomSqlHelper.CreateInputParameter("PublisherPlace", SqlDbType.NVarChar, 150, true, publisherPlace),
                    CustomSqlHelper.CreateInputParameter("Publisher", SqlDbType.NVarChar, 255, true, publisher)))
            {
                CustomGenericList<CustomDataRow> list = CustomSqlHelper.ExecuteReaderAndReturnRows(command);
                return this.GetOpenUrlCitationList(list);
            }
        }

        public CustomGenericList<OpenUrlCitation> OpenUrlCitationSelectByCitationDetails(
            SqlConnection sqlConnection,
            SqlTransaction sqlTransaction,
            int titleID,
            string oclc,
            string lccn,
            string isbn,
            string issn,
            string abbreviation,
            string coden,
            string title,
            string authorLast,
            string authorFirst,
            string authorCorporation,
            string publisherName,
            string publisherPlace,
            string publisher,
            string volume,
            string issue,
            string year,
            string startPage)
        {
            SqlConnection connection = CustomSqlHelper.CreateConnection(CustomSqlHelper.GetConnectionStringFromConnectionStrings("BHL"), sqlConnection);
            SqlTransaction transaction = sqlTransaction;

            using (SqlCommand command = CustomSqlHelper.CreateCommand("OpenUrlCitationSelectByCitationDetails", connection, transaction,
                    CustomSqlHelper.CreateInputParameter("TitleID", SqlDbType.Int, null, true, titleID),
                    CustomSqlHelper.CreateInputParameter("OCLC", SqlDbType.NVarChar, 125, true, oclc),
                    CustomSqlHelper.CreateInputParameter("LCCN", SqlDbType.NVarChar, 125, true, lccn),
                    CustomSqlHelper.CreateInputParameter("ISBN", SqlDbType.NVarChar, 125, true, isbn),
                    CustomSqlHelper.CreateInputParameter("ISSN", SqlDbType.NVarChar, 125, true, issn),
                    CustomSqlHelper.CreateInputParameter("Abbreviation", SqlDbType.NVarChar, 125, true, abbreviation),
                    CustomSqlHelper.CreateInputParameter("CODEN", SqlDbType.NVarChar, 125, true, coden),
                    CustomSqlHelper.CreateInputParameter("Title", SqlDbType.NVarChar, 2000, true, title),
                    CustomSqlHelper.CreateInputParameter("AuthorLast", SqlDbType.NVarChar, 150, true, authorLast),
                    CustomSqlHelper.CreateInputParameter("AuthorFirst", SqlDbType.NVarChar, 100, true, authorFirst),
                    CustomSqlHelper.CreateInputParameter("AuthorCorporation", SqlDbType.NVarChar, 255, true, authorCorporation),
                    CustomSqlHelper.CreateInputParameter("PublisherName", SqlDbType.NVarChar, 255, true, publisherName),
                    CustomSqlHelper.CreateInputParameter("PublisherPlace", SqlDbType.NVarChar, 150, true, publisherPlace),
                    CustomSqlHelper.CreateInputParameter("Publisher", SqlDbType.NVarChar, 255, true, publisher),
                    CustomSqlHelper.CreateInputParameter("Volume", SqlDbType.NVarChar, 100, true, volume),
                    CustomSqlHelper.CreateInputParameter("Issue", SqlDbType.NVarChar, 20, true, issue),
                    CustomSqlHelper.CreateInputParameter("Year", SqlDbType.NVarChar, 20, true, year),
                    CustomSqlHelper.CreateInputParameter("StartPage", SqlDbType.NVarChar, 20, true, startPage)))
            {
                CustomGenericList<CustomDataRow> list = CustomSqlHelper.ExecuteReaderAndReturnRows(command);
                return this.GetOpenUrlCitationList(list);
            }
        }

        /// <summary>
        /// Reads the specified list of generic data rows into a list of OpenUrlCitations
        /// </summary>
        /// <param name="list"></param>
        /// <returns></returns>
        private CustomGenericList<OpenUrlCitation> GetOpenUrlCitationList(CustomGenericList<CustomDataRow> list)
        {
            CustomGenericList<OpenUrlCitation> citations = new CustomGenericList<OpenUrlCitation>();
            foreach (CustomDataRow row in list)
            {
                OpenUrlCitation citation = new OpenUrlCitation();
                citation.PageID = Utility.ZeroIfNull(row["PageID"].Value);
                citation.ItemID = Utility.ZeroIfNull(row["ItemID"].Value);
                citation.TitleID = Utility.ZeroIfNull(row["TitleID"].Value);
                citation.FullTitle = row["FullTitle"].Value.ToString();
                citation.PublisherPlace = row["PublisherPlace"].Value.ToString();
                citation.PublisherName = row["PublisherName"].Value.ToString();
                citation.Date = row["Date"].Value.ToString();
                citation.LanguageName = row["LanguageName"].Value.ToString();
                citation.Volume = row["Volume"].Value.ToString();
                citation.EditionStatement = row["EditionStatement"].Value.ToString();
                citation.CurrentPublicationFrequency = row["CurrentPublicationFrequency"].Value.ToString();
                citation.Genre = row["Genre"].Value.ToString();
                citation.Authors = row["Authors"].Value.ToString();
                citation.Subjects = row["Subjects"].Value.ToString();
                citation.StartPage = row["StartPage"].Value.ToString();
                citation.EndPage = row["EndPage"].Value.ToString();
                citation.Pages = row["Pages"].Value.ToString();
                citation.Issn = row["ISSN"].Value.ToString();
                citation.Isbn = row["ISBN"].Value.ToString();
                citation.Lccn = row["LCCN"].Value.ToString();
                citation.Oclc = row["OCLC"].Value.ToString();
                citation.Abbreviation = row["Abbreviation"].Value.ToString();
                citations.Add(citation);
            }

            return citations;
        }
    }
}
