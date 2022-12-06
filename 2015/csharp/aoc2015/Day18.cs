using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Diagnostics;
using System.IO;
using System.Linq;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/18
    /// </summary>
    [TestClass]
    public class Day18
    {
        static string[] testData = new string[]
        {
            ".#.#.#",
            "...##.",
            "#....#",
            "..#...",
            "#.#..#",
            "####..",
        };

        string[] lines = File.ReadAllLines("Input\\18.txt").ToArray();

        [TestMethod]
        public void Tests()
        {
            var testArray = LightLife.FromLines(testData);
            foreach(int i in Enumerable.Range(1, 4))
            {
                Debug.WriteLine(i);
                testArray.Step();
                testArray.Dump();
            }

            var testArray2 = LightLife.FromLines(testData);
            testArray2.SetFourCorners();
            foreach (int i in Enumerable.Range(1, 5))
            {
                Debug.WriteLine(i);
                testArray2.Step();
                testArray2.SetFourCorners();
                testArray2.Dump();
            }
        }

        [TestMethod]
        public void Part1()
        {
            var realArray = LightLife.FromLines(lines);
            foreach (int i in Enumerable.Range(1, 100))
                realArray.Step();
            Assert.AreEqual(1061, realArray.Count(v => v == true));
        }

        [TestMethod]
        public void Part2()
        {
            var realArray = LightLife.FromLines(lines);
            realArray.SetFourCorners();
            foreach (int i in Enumerable.Range(1, 100))
            {
                realArray.Step();
                realArray.SetFourCorners();
            }
            Assert.AreEqual(1006, realArray.Count(v => v == true));
        }
    }
}

