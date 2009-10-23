using System;
using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;
using CustomDataAccess;

namespace MOBOT.BHL.Server
{
    public partial class BHLProvider
    {
        private LocationDAL locationDal = null;

        public CustomGenericList<Location> LocationSelectAll()
        {
            return GetLocationDalInstance().LocationSelectAll(null, null);
        }

        public Location LocationSelectAuto(string locationName)
        {
            return GetLocationDalInstance().LocationSelectAuto(null, null, locationName);
        }

        public CustomGenericList<Location> LocationSelectAllValid()
        {
            return GetLocationDalInstance().LocationSelectAllValid(null, null);
        }

        public CustomGenericList<Location> LocationSelectAllInvalid()
        {
            return GetLocationDalInstance().LocationSelectAllInvalid(null, null);
        }

        public CustomGenericList<Location> LocationSelectValidByInstitution(string institutionCode, string languageCode)
        {
            return GetLocationDalInstance().LocationSelectValidByInstitution(null, null, institutionCode, languageCode);
        }

        public Location LocationInsertAuto(string locationName, string latitude, string longitude, DateTime? nextAttemptDate, bool includeInUI)
        {
            return GetLocationDalInstance().LocationInsertAuto(null, null, locationName, latitude, longitude, nextAttemptDate, includeInUI);
        }

        public Location LocationUpdateAuto(string locationName, string latitude, string longitude, DateTime? nextAttemptDate, bool includeInUI)
        {
            return GetLocationDalInstance().LocationUpdateAuto(null, null, locationName, latitude, longitude, nextAttemptDate, includeInUI);
        }

        public void SaveLocation(Location location)
        {
            GetLocationDalInstance().Save(null, null, location);
        }

        private LocationDAL GetLocationDalInstance()
        {
            if (locationDal == null)
                locationDal = new LocationDAL();

            return locationDal;
        }
    }
}