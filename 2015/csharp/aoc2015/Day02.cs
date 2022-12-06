using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using System.Linq;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/2
    /// </summary>
    [TestClass]
    public class Day02
    {
        Box[] boxes = File.ReadAllLines("Input\\02.txt").Select(line => Box.FromLine(line)).ToArray();

        [TestMethod]
        public void Part1()
        {
            Assert.AreEqual(58, new Box(2, 3, 4).WrappingPaperArea());
            Assert.AreEqual(43, new Box(1, 1, 10).WrappingPaperArea());
            Assert.AreEqual(1598415, boxes.Sum(b => b.WrappingPaperArea()));
        }

        [TestMethod]
        public void Part2()
        {
            Assert.AreEqual(34, new Box(2, 3, 4).RibbonLenght());
            Assert.AreEqual(14, new Box(1, 1, 10).RibbonLenght());
            Assert.AreEqual(3812909, boxes.Sum(b => b.RibbonLenght()));
        }
    }
}

