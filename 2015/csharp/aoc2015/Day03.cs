using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/3
    /// </summary>
    [TestClass]
    public class Day03
    {
        string directions = File.ReadAllText("Input\\03.txt");

        [TestMethod]
        public void Part1()
        {
            Assert.AreEqual(2, OneSanta(">"));
            Assert.AreEqual(4, OneSanta("^>v<"));
            Assert.AreEqual(2, OneSanta("^v^v^v^v^v"));
            Assert.AreEqual(2572, OneSanta(directions));
        }

        [TestMethod]
        public void Part2()
        {
            Assert.AreEqual(3, SantaWithRobot("^v"));
            Assert.AreEqual(3, SantaWithRobot("^>v<"));
            Assert.AreEqual(11, SantaWithRobot("^v^v^v^v^v"));
            Assert.AreEqual(2631, SantaWithRobot(directions));
        }

        int OneSanta(string directions)
        {
            HashSet<Point> presents = new HashSet<Point>();
            RecordLocations(directions, presents);
            return presents.Count;
        }

        int SantaWithRobot(string directions)
        {
            HashSet<Point> presents = new HashSet<Point>();
            RecordLocations(new string(directions.Where((x, i) => i % 2 == 0).ToArray()), presents);
            RecordLocations(new string(directions.Where((x, i) => i % 2 != 0).ToArray()), presents);
            return presents.Count;
        }

        void RecordLocations(string directions, HashSet<Point> presents)
        {
            Point loc = new Point(0, 0);
            presents.Add(loc);

            foreach(char c in directions)
            {
                switch(c)
                {
                    case '^': loc.Offset(0, -1); break;
                    case 'v': loc.Offset(0, 1);  break;
                    case '<': loc.Offset(-1, 0); break;
                    case '>': loc.Offset(1, 0); break;
                    default: throw new Exception("Unexpected char"); 
                }
                presents.Add(loc);
            }
        }
    }
}

