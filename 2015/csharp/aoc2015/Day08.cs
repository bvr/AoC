using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/8
    /// </summary>
    [TestClass]
    public class Day08
    {
        string[] testData = new string[]
        {
                "\"\"",
                "\"abc\"",
                "\"aaa\\\"aaa\"",
                "\"\\x27\"",
        };

        string[] input = File.ReadAllLines("Input\\08.txt");

        [TestMethod]
        public void Part1()
        {
            Assert.AreEqual(12, CountTotalMinusInMemory(testData));
            Assert.AreEqual(1350, CountTotalMinusInMemory(input));
        }

        [TestMethod]
        public void Part2()
        {
            Assert.AreEqual(19, CountExpandedMinusTotal(testData));
            Assert.AreEqual(2085, CountExpandedMinusTotal(input));
        }

        private int CountTotalMinusInMemory(IEnumerable<string> lines)
        {
            Regex removeEscape = new Regex(@"\\(\\|""|x[0-9a-f]{2})");
            return lines.Select(line => line.Trim().Length - (removeEscape.Replace(line.Trim(), "*").Length - 2)).Sum();
        }

        private int CountExpandedMinusTotal(IEnumerable<string> lines)
        {
            return lines.Select(line => line.Replace("\\", "\\\\").Replace("\"", "\\\"").Length + 2 - line.Length).Sum();
        }
    }
}

