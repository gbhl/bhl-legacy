﻿using System;
using System.Collections.Generic;
using System.Text;
using CustomDataAccess;

namespace MOBOT.BHL.DataObjects
{
    public class TitleBibTeX : ISetValues
    {
        private String _citationKey = String.Empty;

        public String CitationKey
        {
            get { return _citationKey; }
            set { _citationKey = value; }
        }

        private String _url = String.Empty;

        public String Url
        {
            get { return _url; }
            set { _url = value; }
        }

        private String _note = String.Empty;

        public String Note
        {
            get { return _note; }
            set { _note = value; }
        }

        private String _title = String.Empty;

        public String Title
        {
            get { return _title; }
            set { _title = value; }
        }

        private String _publisher = String.Empty;

        public String Publisher
        {
            get { return _publisher; }
            set { _publisher = value; }
        }

        private String _year = String.Empty;

        public String Year
        {
            get { return _year; }
            set { _year = value; }
        }

        private String _volume = String.Empty;

        public String Volume
        {
            get { return _volume; }
            set { _volume = value; }
        }

        private String _copyrightStatus = String.Empty;

        public String CopyrightStatus
        {
            get { return _copyrightStatus; }
            set { _copyrightStatus = value; }
        }

        private String _authors = String.Empty;

        public String Authors
        {
            get { return _authors; }
            set { _authors = value; }
        }

        private int _pages = 0;

        public int Pages
        {
            get { return _pages; }
            set { _pages = value; }
        }

        private String _keywords = String.Empty;

        public String Keywords
        {
            get { return _keywords; }
            set { _keywords = value; }
        }

        #region ISetValues Members

        void ISetValues.SetValues(CustomDataRow row)
        {
            foreach (CustomDataColumn column in row)
            {
                switch (column.Name)
                {
                    case "CitationKey":
                        {
                            CitationKey = (String)column.Value;
                            break;
                        }
                    case "Url":
                        {
                            Url = (String)column.Value;
                            break;
                        }
                    case "Note":
                        {
                            Note = (String)column.Value;
                            break;
                        }
                    case "Title":
                        {
                            Title = (String)column.Value;
                            break;
                        }
                    case "Publisher":
                        {
                            Publisher = (String)column.Value;
                            break;
                        }
                    case "Year":
                        {
                            Year = (String)column.Value;
                            break;
                        }
                    case "Volume":
                        {
                            Volume = (String)column.Value;
                            break;
                        }
                    case "CopyrightStatus":
                        {
                            CopyrightStatus = (String)column.Value;
                            break;
                        }
                    case "Authors":
                        {
                            Authors = (String)column.Value;
                            break;
                        }
                    case "Pages":
                        {
                            Pages = (int)column.Value;
                            break;
                        }
                    case "Keywords":
                        {
                            Keywords = (String)column.Value;
                            break;
                        }
                }
            }
        }

        #endregion
    }
}
