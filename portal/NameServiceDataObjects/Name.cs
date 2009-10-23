using System;
using CustomDataAccess;

namespace MOBOT.Services.NameServiceDataObjects
{
    [Serializable]
    public class Name : ISetValues
    {
		#region Constructors
		
		/// <summary>
		/// Default constructor.
		/// </summary>
		public Name()
		{
		}

		public Name(int nameBankID, 
			string nameConfirmed) : this()
		{
            _NameBankID = nameBankID;
            _NameConfirmed = nameConfirmed;
		}
		
		#endregion Constructors
		
		#region Destructor
		
		/// <summary>
		///
		/// </summary>
        ~Name()
		{
		}
		
		#endregion Destructor
		
		#region Set Values
		
		/// <summary>
		/// Set the property values of this instance from the specified <see cref="CustomDataRow"/>.
		/// </summary>
		public virtual void SetValues(CustomDataRow row)
		{
			foreach (CustomDataColumn column in row)
			{
				switch (column.Name)
				{
                    case "NameBankID":
					{
                        _NameBankID = (int)column.Value;
						break;
					}
                    case "NameConfirmed":
					{
                        _NameConfirmed = (string)column.Value;
						break;
					}
                }
			}
		}
		
		#endregion Set Values
		
		#region Properties		

        private int  _NameBankID = default(int);
        public int NameBankID
        {
            get
            {
                return _NameBankID;
            }
            set
            {
                _NameBankID = value;
            }
        }
		
		private string _NameConfirmed= null;
        public string NameConfirmed
		{
			get
			{
                return _NameConfirmed;
			}
			set
			{
				if (value != null) value = CalibrateValue(value, 100);
                _NameConfirmed = value;
			}
		}

        CustomGenericList<Title> _Titles;
        public CustomGenericList<Title> Titles
        {
            get
            {
                return _Titles;
            }
            set
            {
                _Titles = value;
            }
        }

		#endregion Properties
		
		#region SortColumn
		
		/// <summary>
		/// Use when defining sort columns for a collection sort request.
		/// For example where list is a instance of <see cref="CustomGenericList">, 
        /// list.Sort(SortOrder.Ascending, Name.SortColumn.NameID);
		/// </summary>
		[Serializable]
		public sealed class SortColumn
		{
            public const string NameBankID = "NameBankID";
            public const string NameConfirmed = "NameConfirmed";
        }
				
		#endregion SortColumn

        private string CalibrateValue(string value, int maximumCharacterLength)
        {
            value = value.Trim();
            if (value.Length > maximumCharacterLength)
            {
                value = value.Substring(0, maximumCharacterLength);
            }

            return value;
        }
    }
}
