using System;
using CustomDataAccess;


namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class Page : __Page
	{
        private int _pageID;
	    public new int PageID
        {
            get
            {
                if (_pageID == 0)
                {
                    _pageID = base.PageID;
                }
                return _pageID;
            }
            set
            {
                _pageID = value;
            }
        }

        private string _indicatedPages = string.Empty;
        public string IndicatedPages
        {
            get
            {
                return _indicatedPages;
            }
            set
            {
                if (value != null) value = value.Trim().PadRight(1000).Substring(0, 1000).Trim();
                if (_indicatedPages != value)
                {
                    _indicatedPages = value;
                }
            }
        }

        private string _pageTypes = string.Empty;
        public string PageTypes
        {
            get
            {
                return _pageTypes;
            }
            set
            {
                if (value != null) value = value.Trim().PadRight(1000).Substring(0, 1000).Trim();
                if (_pageTypes != value)
                {
                    _pageTypes = value;
                }
            }
        }

        private string _folderShare = string.Empty;
        public string FolderShare
        {
            get
            {
                return _folderShare;
            }
            set
            {
                if (value != null) value = value.Trim().PadRight(30).Substring(0, 30).Trim();
                if (_folderShare != value)
                {
                    _folderShare = value;
                }
            }
        }

        private string _webVirtualDirectory = string.Empty;
        public string WebVirtualDirectory
        {
            get
            {
                return _webVirtualDirectory;
            }
            set
            {
                if (value != null) value = value.Trim().PadRight(30).Substring(0, 30).Trim();
                if (_webVirtualDirectory != value)
                {
                    _webVirtualDirectory = value;
                }
            }
        }

        private string _barCode = string.Empty;
        public string BarCode
        {
            get
            {
                return _barCode;
            }
            set
            {
                if (value != null) value = value.Trim().PadRight(20).Substring(0, 20).Trim();
                if (_barCode != value)
                {
                    _barCode = value;
                }
            }
        }

        private string _marcBibID = string.Empty;
        public string MARCBibID
        {
            get
            {
                return _marcBibID;
            }
            set
            {
                if (value != null) value = value.Trim().PadRight(20).Substring(0, 20).Trim();
                if (_marcBibID != value)
                {
                    _marcBibID = value;
                }
            }
        }

        private string _shortTitle = string.Empty;

        public string ShortTitle
        {
            get { return _shortTitle; }
            set { _shortTitle = value; }
        }

        private bool _rareBooks = false;
        public bool RareBooks
        {
            get
            {
                return _rareBooks;
            }
            set
            {
                _rareBooks = value;
            }
        }

        //private bool _illustration = false;
        //public bool Illustration
        //{
        //    get
        //    {
        //        return _illustration;
        //    }
        //    set
        //    {
        //        _illustration = value;
        //    }
        //}

        //private string _externalURL = string.Empty;
        //public string ExternalURL
        //{
        //    get
        //    {
        //        return _externalURL;
        //    }
        //    set
        //    {
        //        _externalURL = value;
        //    }
        //}

        public string WebDisplay
        {
            get
            {
                string returnValue = this.IndicatedPages;
                if (returnValue.Length == 0)
                {
                    returnValue = this.PageTypes;
                    returnValue = returnValue.Replace("Text, ", "");
                    returnValue = returnValue.Replace(", Text", "");
                }
                if (returnValue.Length == 0)
                {
                    returnValue = "Seq " + this.SequenceOrder.ToString();
                }
                return returnValue;
            }
            set
            {
            }
        }

        public override void SetValues(CustomDataRow row)
        {

            foreach (CustomDataColumn column in row)
            {
                switch (column.Name)
                {
                    case "IndicatedPages":
                        {
                            _indicatedPages = Utility.EmptyIfNull(column.Value);
                            break;
                        }
                    case "PageTypes":
                        {
                            _pageTypes = Utility.EmptyIfNull(column.Value);
                            break;
                        }
                    case "FolderShare":
                        {
                            _folderShare = Utility.EmptyIfNull(column.Value);
                            break;
                        }
                    case "WebVirtualDirectory":
                        {
                            _webVirtualDirectory = Utility.EmptyIfNull(column.Value);
                            break;
                        }
                    case "BarCode":
                        {
                            _barCode = Utility.EmptyIfNull(column.Value);
                            break;
                        }
                    case "MARCBibID":
                        {
                            _marcBibID = Utility.EmptyIfNull(column.Value);
                            break;
                        }
                    case "ShortTitle":
                        {
                            _shortTitle = Utility.EmptyIfNull(column.Value);
                            break;
                        }
                    case "RareBooks":
                        {
                            _rareBooks = Utility.FalseIfNull(column.Value);
                            break;
                        }
                    //case "Illustration":
                    //    {
                    //        _illustration = Utility.FalseIfNull(column.Value);
                    //        break;
                    //    }
                    //case "ExternalURL":
                    //    {
                    //        _externalURL = Utility.EmptyIfNull(column.Value);
                    //        break;
                    //    }
                }
            }

            base.SetValues(row);

        }



    }
}
