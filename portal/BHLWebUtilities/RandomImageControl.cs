using System;
using System.Collections.Generic;
using System.Text;
using System.Web.UI;
using System.Web.UI.HtmlControls;

namespace MOBOT.BHL.Web.Utilities
{
    public class RandomImageControl : UserControl
    {

        private string imagePrefix = "";
        private string directory = "";
        private int minIndex = 0;
        private int maxIndex = 0;
        private string alternateText = "";
        private ImageFileFormat fileFormat = ImageFileFormat.GIF;
        private string align = "";

        public string ImagePrefix
        {
            get
            {
                return imagePrefix;
            }
            set
            {
                imagePrefix = value;
            }
        }

        public string Directory
        {
            get
            {
                return directory;
            }
            set
            {
                directory = value;
            }
        }

        public int MinIndex
        {
            get
            {
                return minIndex;
            }
            set
            {
                minIndex = value;
            }
        }

        public int MaxIndex
        {
            get
            {
                return maxIndex;
            }
            set
            {
                maxIndex = value;
            }
        }

        public string AlternateText
        {
            get
            {
                return alternateText;
            }
            set
            {
                alternateText = value;
            }
        }

        public ImageFileFormat FileFormat
        {
            get
            {
                return fileFormat;
            }
            set
            {
                fileFormat = value;
            }
        }

        public string Align
        {
            get
            {
                return align;
            }
            set
            {
                align = value;
            }
        }

        protected override void OnLoad(EventArgs e)
        {
            base.OnLoad(e);

            int index = RandomNumberGenerator.GetRandomNumber(MinIndex, MaxIndex);

            string path = Directory.Trim();
            if (!path.EndsWith("/"))
                path += "/";

            path += ImagePrefix + index.ToString() + "." + FileFormat.ToString();
            HtmlImage randomImage = new HtmlImage();
            randomImage.Src = path;
            randomImage.Alt = AlternateText;
            if (Align != null && Align.Trim().Length > 0)
                randomImage.Attributes.Add("align", Align.Trim());

            this.Controls.Add(randomImage);
        }


        public enum ImageFileFormat
        {
            JPG,
            GIF
        }
    }
}
