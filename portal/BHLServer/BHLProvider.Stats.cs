using MOBOT.BHL.DAL;
using MOBOT.BHL.DataObjects;

namespace MOBOT.BHL.Server
{
    public partial class BHLProvider
    {
        /// <summary>
        /// Select Botanicus Stats.
        /// </summary>
        /// <returns>Objects of type Title.</returns>
        public Stats StatsSelect()
        {
            return (new StatsDAL().StatsSelect(null, null));
        }

        public Stats StatsSelectExpanded()
        {
            return (new StatsDAL().StatsSelectExpanded(null, null));
        }

        public Stats StatsSelectExpandedNames()
        {
            return (new StatsDAL().StatsSelectExpandedNames(null, null));
        }
    }
}

