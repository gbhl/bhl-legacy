
#region Using

using System;
using System.Configuration;

#endregion Using

namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class PageSummaryView : __PageSummaryView
    {
        #region Properties

        public string OcrTextLocation
        {
            get 
            {
                return String.Format(ConfigurationManager.AppSettings["OCRTextLocation"], this.OCRFolderShare, this.FileRootFolder, this.BarCode, this.FileNamePrefix);
            }
        }

        public string MarcXmlLocation
        {
            get 
            {
                return String.Format(ConfigurationManager.AppSettings["MARCXmlLocation"], this.OCRFolderShare, this.FileRootFolder, this.BarCode); 
            }
        }

        public string MarcXmlAltLocation
        {
            get 
            {
                return String.Format(ConfigurationManager.AppSettings["MARCXmlAltLocation"], this.MARCBibID); 
            }
        }

        public string PdfLocation
        {
            get 
            {
                return String.Format(ConfigurationManager.AppSettings["PdfLocation"], this.WebVirtualDirectory, this.FileRootFolder, this.BarCode, this.BarCode);
            }
        }

        public string PdfUrl
        {
            get 
            {
                return String.Format(ConfigurationManager.AppSettings["PdfUrl"], this.WebVirtualDirectory, this.FileRootFolder, this.BarCode, this.BarCode);
            }
        }

        public string PdfAuthUrl
        {
            get
            {
                return String.Format(ConfigurationManager.AppSettings["PdfAuthUrl"], this.BarCode);
            }
        }

        #endregion Properties
    }
}
