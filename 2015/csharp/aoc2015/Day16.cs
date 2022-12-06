using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using System.Linq;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/16
    /// </summary>
    [TestClass]
    public class Day16
    {
        AuntSue measured = AuntSue.FromLine("Sue 0: children: 3, cats: 7, samoyeds: 2, pomeranians: 3, akitas: 0, vizslas: 0, goldfish: 5, trees: 3, cars: 2, perfumes: 1");
        AuntSue[] aunts = File.ReadLines(@"Input\16.txt").Select(line => AuntSue.FromLine(line)).ToArray();

        [TestMethod]
        public void Part1()
        {
            Assert.AreEqual(103, aunts.Where(aunt => aunt.Matches(measured.Properties)).Single().Number);
        }

        [TestMethod]
        public void Part2()
        {
            Assert.AreEqual(405, aunts.Where(aunt => aunt.MatchRanges(measured.Properties)).Single().Number);
        }
    }
}

