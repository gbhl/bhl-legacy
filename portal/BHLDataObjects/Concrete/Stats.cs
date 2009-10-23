#region Using

using System;

#endregion Using

namespace MOBOT.BHL.DataObjects
{
	[Serializable]
	public class Stats
	{
		private int _titleCount;
		private int _titleTotal;
		private int _volumeTotal;
		private int _pageTotal;
		private int _uniqueCount;
		private int _uniqueTotal;

		public int TitleCount
		{
			get
			{
				return _titleCount;
			}
			set
			{
				_titleCount = value;
			}
		}

		private int _volumeCount;

		public int VolumeCount
		{
			get
			{
				return _volumeCount;
			}
			set
			{
				_volumeCount = value;
			}
		}

		private int _pageCount;

		public int PageCount
		{
			get
			{
				return _pageCount;
			}
			set
			{
				_pageCount = value;
			}
		}

		public int TitleTotal
		{
			get { return this._titleTotal; }
			set { this._titleTotal = value; }
		}

		public int VolumeTotal
		{
			get { return this._volumeTotal; }
			set { this._volumeTotal = value; }
		}

		public int PageTotal
		{
			get { return this._pageTotal; }
			set { this._pageTotal = value; }
		}

		public int UniqueCount
		{
			get { return this._uniqueCount; }
			set { this._uniqueCount = value; }
		}

		public int UniqueTotal
		{
			get { return this._uniqueTotal; }
			set { this._uniqueTotal = value; }
		}
	}
}