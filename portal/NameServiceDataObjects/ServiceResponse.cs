using System;
using System.IO;
using System.Collections.Generic;
using CustomDataAccess;

namespace MOBOT.Services.NameServiceDataObjects
{
    public enum OutputType { Xml, Json }

    [Serializable]
    public class ServiceResponse<T>
    {
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public ServiceResponse()
		{
		}

		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
        ~ServiceResponse()
		{
		}
		
		#endregion Destructor

        #region Properties

        private string _Status = "ok";
        public string Status
        {
            get
            {
                return _Status;
            }
            set
            {
                _Status = value;
            }
        }

        private string _ErrorMessage = null;
        public string ErrorMessage
        {
            get
            {
                return _ErrorMessage;
            }
            set
            {
                _ErrorMessage = value;
            }
        }

        private T _NameResult = default(T);
        public T NameResult
        {
            get
            {
                return _NameResult;
            }
            set
            {
                _NameResult = value;
            }
        }

        #endregion Properties

        #region Methods

        public string Serialize(OutputType output)
        {
            if (output == OutputType.Xml)
                return SerializeAsXml();
            else
                return SerializeAsJson();
        }

        private string SerializeAsJson()
        {
            System.Web.Script.Serialization.JavaScriptSerializer js = new System.Web.Script.Serialization.JavaScriptSerializer();
            return js.Serialize(this);
        }

        private string SerializeAsXml()
        {
            //System.Xml.Serialization.XmlSerializer xml = new System.Xml.Serialization.XmlSerializer(typeof(T));
            System.Xml.Serialization.XmlRootAttribute xmlRoot = new System.Xml.Serialization.XmlRootAttribute("NameResponse");
            System.Xml.Serialization.XmlSerializer xml = new System.Xml.Serialization.XmlSerializer(typeof(ServiceResponse<T>), xmlRoot);
            MemoryStream memoryStream = new MemoryStream();
            System.Xml.XmlTextWriter writer = new System.Xml.XmlTextWriter(memoryStream, System.Text.Encoding.UTF8);
            //xml.Serialize(writer, this.NameResult);
            xml.Serialize(writer, this);
            memoryStream = (MemoryStream)writer.BaseStream;
            System.Text.UTF8Encoding encoding = new System.Text.UTF8Encoding();
            return encoding.GetString(memoryStream.ToArray());
        }

        #endregion Methods

    }
}
