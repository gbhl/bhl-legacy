using System;
using System.Data;
using System.Web;
using System.Collections;
using System.Web.Services;
using System.Web.Services.Protocols;
using System.Web.Script;
using System.Net;
using System.IO;
using CustomDataAccess;
using MOBOT.Services.NameServiceDataObjects;

namespace MOBOT.BHL.Web.Services
{
    /// <summary>
    /// Summary description for NameServiceJsonXml
    /// </summary>
    [WebService(Namespace = "http://mobot.org/")]
    [WebServiceBinding(ConformsTo = WsiProfiles.BasicProfile1_1)]
    public class NameServiceJsonXml : IHttpHandler
    {

        public void ProcessRequest(HttpContext context)
        {
            String response = String.Empty;

            String operation = context.Request.QueryString["op"];
            String startRow = context.Request.QueryString["startRow"];
            String batchSize = context.Request.QueryString["batchSize"];
            String nameBankID = context.Request.QueryString["nameBankID"];
            String name = context.Request.QueryString["name"];
            String startDate = context.Request.QueryString["startDate"];
            String endDate = context.Request.QueryString["endDate"];
            String callback = context.Request.QueryString["callback"];
            String format = context.Request.QueryString["format"];

            OutputType outputType = OutputType.Xml;
            if (format == "json") outputType = OutputType.Json;

            try
            {
                if (String.Compare(operation, "NameCount", true) == 0)
                {
                    ServiceResponse<int> serviceResponse = new ServiceResponse<int>();
                    serviceResponse.NameResult = this.NameCount(startDate, endDate);
                    response = serviceResponse.Serialize(outputType);
                }
                else if (String.Compare(operation, "NameList", true) == 0)
                {
                    ServiceResponse<CustomGenericList<Name>> serviceResponse = new ServiceResponse<CustomGenericList<Name>>();
                    serviceResponse.NameResult = this.NameList(startRow, batchSize, startDate, endDate);
                    response = serviceResponse.Serialize(outputType);
                }
                else if (String.Compare(operation, "NameGetDetail", true) == 0)
                {
                    ServiceResponse<Name> serviceResponse = new ServiceResponse<Name>();
                    serviceResponse.NameResult = this.NameGetDetail(nameBankID);
                    response = serviceResponse.Serialize(outputType);
                }
                else if (String.Compare(operation, "NameSearch", true) == 0)
                {
                    ServiceResponse<CustomGenericList<Name>> serviceResponse = new ServiceResponse<CustomGenericList<Name>>();
                    serviceResponse.NameResult = this.NameSearch(name);
                    response = serviceResponse.Serialize(outputType);
                }
            }
            catch (Exception ex)
            {
                ServiceResponse<string> serviceResponse = new ServiceResponse<string>();
                serviceResponse.Status = "error";
                serviceResponse.ErrorMessage = ex.Message;
                serviceResponse.NameResult = ex.Message;
                response = serviceResponse.Serialize(outputType);
            }

            // Include any specified callback function in JSON responses
            if ((callback != null) && (callback != String.Empty) && outputType == OutputType.Json)
            {
                response = callback + "(" + response + ");";
            }

            context.Response.ContentType = "text/plain";
            context.Response.Write(response);
        }

        public bool IsReusable
        {
            get
            {
                return false;
            }
        }

        private int NameCount(string startDate, string endDate)
        {
            NameService nameService = new NameService();
            if ((startDate != null) || (endDate != null))
                return nameService.NameCountBetweenDates(startDate, endDate);
            else
                return nameService.NameCount();
        }

        private CustomGenericList<Name> NameList(string startRow, string batchSize, string startDate, string endDate)
        {
            NameService nameService = new NameService();
            if ((startDate != null) || (endDate != null))
                return nameService.NameListBetweenDates(startRow, batchSize, startDate, endDate);
            else
                return nameService.NameList(startRow, batchSize);
        }

        private Name NameGetDetail(string nameBankID)
        {
            NameService nameService = new NameService();
            return nameService.NameGetDetail(nameBankID);
        }

        private CustomGenericList<Name> NameSearch(string name)
        {
            NameService nameService = new NameService();
            return nameService.NameSearch(name);
        }
    }
}
