using System;

namespace MOBOT.BHL.DataObjects
{
	public class FindItItem
	{
		public FindItItem()
		{	}

		#region Private variables

		private string _name;
		private string _canonicalName;
		private string _genus;
		private string _species;
		private string _unknownComponent;
		private int _namebankID;

		#endregion

		#region Public Properties

		public string Name
		{
			get { return this._name; }
			set { this._name = value; }
		}

		public string CanonicalName
		{
			get { return this._canonicalName; }
			set { this._canonicalName = value; }
		}

		public string Genus
		{
			get { return this._genus; }
			set { this._genus = value; }
		}

		public string Species
		{
			get { return this._species; }
			set { this._species = value; }
		}

		public string UnknownComponent
		{
			get { return this._unknownComponent; }
			set { this._unknownComponent = value; }
		}

		public int NamebankID
		{
			get { return this._namebankID; }
			set { this._namebankID = value; }
		}

		#endregion
	}
}
