using System;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;
using CustomDataAccess;

namespace MOBOT.BHL.Server
{
    public partial class BHLProvider
    {
        /// <summary>
        /// Select values from Configuration by configuration name.
        /// </summary>
        /// <param name="configurationName">Unique key for configuration record.</param>
        /// <returns>Object of type Configuration.</returns>
        public Configuration ConfigurationSelectByName(String configurationName)
        {
            return ConfigurationDAL.ConfigurationSelectByName(null, null, configurationName);
        }

    }
}