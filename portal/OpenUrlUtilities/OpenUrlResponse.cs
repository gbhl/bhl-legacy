using System;
using System.Collections.Generic;
using System.Text;
using System.Web.Script.Serialization;
using System.Xml.Serialization;

namespace MOBOT.OpenUrl.Utilities
{
    [Serializable]
    public class OpenUrlResponse : IOpenUrlResponse
    {
        #region IOpenUrlResponse Methods

        public string ToXml()
        {
            System.Xml.Serialization.XmlSerializer xml = new XmlSerializer(typeof(OpenUrlResponse));
            System.IO.StringWriter text = new System.IO.StringWriter();
            xml.Serialize(text, this);
            return text.ToString();
        }

        public string ToJson()
        {
            JavaScriptSerializer js = new JavaScriptSerializer();
            return js.Serialize(this);
        }

        #endregion

        #region IOpenUrlResponse Attributes

        private ResponseStatus _status = ResponseStatus.Undefined;
        public ResponseStatus Status
        {
            get { return _status; }
            set { _status = value; }
        }

        private String _errorMessage = String.Empty;
        public string Message
        {
            get { return _errorMessage; }
            set { _errorMessage = value; }
        }

        private List<OpenUrlResponseCitation> _citations = new List<OpenUrlResponseCitation>();

        public List<OpenUrlResponseCitation> citations
        {
            get { return _citations; }
            set { _citations = value; }
        }

        #endregion
    }
}
