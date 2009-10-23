using System;
using System.Collections.Generic;
using System.Text;
using CustomDataAccess;

namespace MOBOT.BHL.DataObjects
{
    public class CreatorSuspectCharacter : ISetValues
    {
        private int _titleID;

        public int TitleID
        {
            get { return _titleID; }
            set { _titleID = value; }
        }

        private String _institutionCode;

        public String InstitutionCode
        {
            get { return _institutionCode; }
            set { _institutionCode = value; }
        }

        private String _institutionName;

        public String InstitutionName
        {
            get { return _institutionName; }
            set { _institutionName = value; }
        }

        private DateTime _creationDate;

        public DateTime CreationDate
        {
            get { return _creationDate; }
            set { _creationDate = value; }
        }

        private String _oclc;

        public String Oclc
        {
            get { return _oclc; }
            set { _oclc = value; }
        }

        private String _zQuery;

        public String ZQuery
        {
            get { return _zQuery; }
            set { _zQuery = value; }
        }

        private int _creatorID;

        public int CreatorID
        {
            get { return _creatorID; }
            set { _creatorID = value; }
        }

        private String _nameSuspect;

        public String NameSuspect
        {
            get { return _nameSuspect; }
            set { _nameSuspect = value; }
        }

        private String _creatorName;

        public String CreatorName
        {
            get { return _creatorName; }
            set { _creatorName = value; }
        }

        private String _marcASuspect;

        public String MarcASuspect
        {
            get { return _marcASuspect; }
            set { _marcASuspect = value; }
        }

        private String _marcCreator_a;

        public String MarcCreator_a
        {
            get { return _marcCreator_a; }
            set { _marcCreator_a = value; }
        }

        private String _marcBSuspect;

        public String MarcBSuspect
        {
            get { return _marcBSuspect; }
            set { _marcBSuspect = value; }
        }

        private String _marcCreator_b;

        public String MarcCreator_b
        {
            get { return _marcCreator_b; }
            set { _marcCreator_b = value; }
        }

        private String _marcCSuspect;

        public String MarcCSuspect
        {
            get { return _marcCSuspect; }
            set { _marcCSuspect = value; }
        }

        private String _marcCreator_c;

        public String MarcCreator_c
        {
            get { return _marcCreator_c; }
            set { _marcCreator_c = value; }
        }

        private String _marcDSuspect;

        public String MarcDSuspect
        {
            get { return _marcDSuspect; }
            set { _marcDSuspect = value; }
        }

        private String _marcCreator_d;

        public String MarcCreator_d
        {
            get { return _marcCreator_d; }
            set { _marcCreator_d = value; }
        }

        private String _fullSuspect;

        public String FullSuspect
        {
            get { return _fullSuspect; }
            set { _fullSuspect = value; }
        }

        private String _marcCreator_Full;

        public String MarcCreator_Full
        {
            get { return _marcCreator_Full; }
            set { _marcCreator_Full = value; }
        }

        #region ISetValues Members

        public void SetValues(CustomDataRow row)
        {
            foreach (CustomDataColumn column in row)
            {
                switch (column.Name)
                {
                    case "TitleID":
                        {
                            _titleID = (int)column.Value;
                            break;
                        }
                    case "InstitutionCode":
                        {
                            _institutionCode = (String)column.Value;
                            break;
                        }
                    case "InstitutionName":
                        {
                            _institutionName = (String)column.Value;
                            break;
                        }
                    case "CreationDate":
                        {
                            _creationDate = (DateTime)column.Value;
                            break;
                        }
                    case "OCLC":
                        {
                            _oclc = (String)column.Value;
                            break;
                        }
                    case "ZQuery":
                        {
                            _zQuery = (String)column.Value;
                            break;
                        }
                    case "CreatorID":
                        {
                            _creatorID = (int)column.Value;
                            break;
                        }
                    case "NameSuspect":
                        {
                            _nameSuspect = (String)column.Value;
                            break;
                        }
                    case "CreatorName":
                        {
                            _creatorName = (String)column.Value;
                            break;
                        }
                    case "MarcASuspect":
                        {
                            _marcASuspect = (String)column.Value;
                            break;
                        }
                    case "MarcCreator_a":
                        {
                            _marcCreator_a = (String)column.Value;
                            break;
                        }
                    case "MarcBSuspect":
                        {
                            _marcBSuspect = (String)column.Value;
                            break;
                        }
                    case "MarcCreator_b":
                        {
                            _marcCreator_b = (String)column.Value;
                            break;
                        }
                    case "MarcCSuspect":
                        {
                            _marcCSuspect = (String)column.Value;
                            break;
                        }
                    case "MarcCreator_c":
                        {
                            _marcCreator_c = (String)column.Value;
                            break;
                        }
                    case "MarcDSuspect":
                        {
                            _marcDSuspect = (String)column.Value;
                            break;
                        }
                    case "MarcCreator_d":
                        {
                            _marcCreator_d = (String)column.Value;
                            break;
                        }
                    case "FullSuspect":
                        {
                            _fullSuspect = (String)column.Value;
                            break;
                        }
                    case "MarcCreator_Full":
                        {
                            _marcCreator_Full = (String)column.Value;
                            break;
                        }
                }
            }
        }

        #endregion
    }
}
