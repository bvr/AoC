using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/6
    /// </summary>
    [TestClass]
    public class Day06
    {
        static Regex syntax
            = new Regex(@"(?<command>toggle|turn off|turn on) (?<x1>\d+),(?<y1>\d+) through (?<x2>\d+),(?<y2>\d+)");

        LightArray<bool> lights = new LightArray<bool>(1000, 1000);
        LightArray<int> brigthness = new LightArray<int>(1000, 1000);

        public Day06()
        {
            foreach (string line in File.ReadLines("Input\\06.txt"))
            {
                Match found = syntax.Match(line);
                if (!found.Success)
                    throw new Exception($"Invalid format {line}");

                int x1 = int.Parse(found.Groups["x1"].Value);
                int y1 = int.Parse(found.Groups["y1"].Value);
                int x2 = int.Parse(found.Groups["x2"].Value);
                int y2 = int.Parse(found.Groups["y2"].Value);

                switch (found.Groups["command"].Value)
                {
                    case "toggle":
                        lights.SetRect(x1, y1, x2, y2, v => !v);
                        brigthness.SetRect(x1, y1, x2, y2, v => v + 2);
                        break;
                    case "turn on":
                        lights.SetRect(x1, y1, x2, y2, v => true);
                        brigthness.SetRect(x1, y1, x2, y2, v => v + 1);
                        break;
                    case "turn off":
                        lights.SetRect(x1, y1, x2, y2, v => false);
                        brigthness.SetRect(x1, y1, x2, y2, v => v > 0 ? v - 1 : v);
                        break;
                }
            }
        }

        [TestMethod]
        public void Part1()
        {
            Assert.AreEqual(400410, lights.Count(v => v == true));
        }

        [TestMethod]
        public void Part2()
        {
            Assert.AreEqual(15343601, brigthness.Sum());
        }
    }
}

