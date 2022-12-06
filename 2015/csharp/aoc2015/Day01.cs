using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/1
    /// </summary>
    [TestClass]
    public class Day01
    {
        string input = File.ReadAllText("Input\\01.txt");

        [TestMethod]
        public void Part1()
        {
            Assert.AreEqual(0, RightFloor("(())"));
            Assert.AreEqual(3, RightFloor("(()(()("));
            Assert.AreEqual(3, RightFloor("))((((("));
            Assert.AreEqual(-3, RightFloor(")())())"));
            Assert.AreEqual(138, RightFloor(input));
        }

        [TestMethod]
        public void Part2()
        {
            Assert.AreEqual(1, ReachBasement(")"));
            Assert.AreEqual(5, ReachBasement("()())"));
            Assert.AreEqual(1771, ReachBasement(input));
        }

        private int RightFloor(string movements)
        {
            int floor = 0;
            for (int i = 0; i < movements.Length; i++)
                floor += movements[i] == '(' ? 1 : -1;
            return floor;
        }

        private int ReachBasement(string movements)
        {
            int floor = 0;
            for (int i = 0; i < movements.Length; i++)
            {
                floor += movements[i] == '(' ? 1 : -1;
                if (floor < 0)
                    return i + 1;
            }

            return 0;
        }
    }
}

