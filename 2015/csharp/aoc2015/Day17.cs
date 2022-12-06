using System.Collections.Generic;
using System.Linq;
using System.IO;
using Microsoft.VisualStudio.TestTools.UnitTesting;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/17
    /// </summary>
    [TestClass]
    public class Day17
    {
        int[] test = new int[] { 20, 15, 10, 5, 5 };
        int[] containers = File.ReadLines(@"Input\17.txt").Select(int.Parse).ToArray();

        [TestMethod]
        public void BothParts()
        {
            // part 1
            Assert.AreEqual(4, StorageCombinations(25, test).Count());

            var combinations = StorageCombinations(150, containers);
            Assert.AreEqual(1638, combinations.Count());

            // part 2
            int minCombination = combinations.Min(c => c.Count());
            Assert.AreEqual(17, combinations.Where(c => c.Count() == minCombination).Count());
        }

        /// <summary>
        /// Build all possible sets of containers and filter it for target volume
        /// </summary>
        /// <param name="volume">Target volume of the eggnog</param>
        /// <param name="containers">available containers specified by volume</param>
        /// <returns>all combinations of containers that exactly fill the target volume</returns>
        private IEnumerable<IEnumerable<int>> StorageCombinations(int volume, IEnumerable<int> containers)
        {
            // using as many bits as containers, find all possible combinations of them
            return Enumerable.Range(1, (1 << containers.Count()) - 1)
                .Select(mask => containers.Where((_, i) => ((1 << i) & mask) != 0).ToList())
                .Where(used => used.Sum() == volume);
        }
    }
}

