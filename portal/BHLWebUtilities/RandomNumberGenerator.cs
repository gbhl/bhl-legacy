using System;
using System.Collections.Generic;
using System.Text;

namespace MOBOT.BHL.Web.Utilities
{
    public class RandomNumberGenerator
    {
        private static Random random = null;

        protected RandomNumberGenerator()
        {
        }

        public static int GetRandomNumber(int minValue, int maxValue)
        {
            if (random == null)
                random = new Random();

            return random.Next(minValue, maxValue);
        }
    }
}
