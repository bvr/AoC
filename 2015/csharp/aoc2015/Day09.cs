using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;

namespace aoc2015
{

    /// <summary>
    /// https://adventofcode.com/2015/day/9
    /// </summary>
    [TestClass]    
    public class Day09
    {
        static string[] test = new string[]
        {
                "London to Dublin = 464",
                "London to Belfast = 518",
                "Dublin to Belfast = 141",
        };

        Locations testLoc = new Locations(test);
        Locations realLoc = new Locations(File.ReadLines("Input\\09.txt"));

        [TestMethod]
        public void Part1()
        {
            Assert.AreEqual(605, testLoc.FindShortestPath());
            Assert.AreEqual(207, realLoc.FindShortestPath());
        }

        [TestMethod]
        public void Part2()
        {
            Assert.AreEqual(982, testLoc.FindLongestPath());
            Assert.AreEqual(804, realLoc.FindLongestPath());
        }
    }
}

