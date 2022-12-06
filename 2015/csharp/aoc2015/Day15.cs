using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/15
    /// </summary>
    [TestClass]
    public class Day15
    {
        [TestMethod]
        public void Tests()
        {
            Assert.AreEqual(62842880, TestScores().Max(t => t.score));
            Assert.AreEqual(57600000, TestScores().Where(t => t.calorie == 500).Max(t => t.score));
        }

        [TestMethod]
        public void Part1()
        {
            Assert.AreEqual(222870, Scores().Max(t => t.score));
        }

        [TestMethod]
        public void Part2()
        {
            Assert.AreEqual(117936, Scores().Where(t => t.calorie == 500).Max(t => t.score));
        }

        private IEnumerable<(int score, int calorie)> TestScores()
        {
            // Butterscotch: capacity -1, durability -2, flavor 6, texture 3, calories 8
            // Cinnamon: capacity 2, durability 3, flavor -2, texture -1, calories 3

            for (int butterscotch = 0; butterscotch <= 100; butterscotch++)
            {
                int cinnamon = 100 - butterscotch;
                int score =
                    Math.Max(0, butterscotch * -1 + cinnamon * 2)        // capacity
                  * Math.Max(0, butterscotch * -2 + cinnamon * 3)        // durability
                  * Math.Max(0, butterscotch * 6 + cinnamon * -2)        // flavor
                  * Math.Max(0, butterscotch * 3 + cinnamon * -1);       // texture
                yield return (score: score, calorie: butterscotch * 8 + cinnamon * 3);
            }
        }

        private IEnumerable<(int score, int calorie)> Scores()
        {
            // Sugar: capacity 3, durability 0, flavor 0, texture -3, calories 2
            // Sprinkles: capacity -3, durability 3, flavor 0, texture 0, calories 9
            // Candy: capacity -1, durability 0, flavor 4, texture 0, calories 1
            // Chocolate: capacity 0, durability 0, flavor -2, texture 2, calories 8

            for(int sugar = 0; sugar <= 100; sugar++)
                for(int sprinkles = 0; sprinkles <= 100 - sugar; sprinkles++)
                    for(int candy = 0; candy <= 100 - sugar - sprinkles; candy++)
                    {
                        int choco = 100 - sugar - sprinkles - candy;
                        int score =
                            Math.Max(0, sugar * 3 + sprinkles * -3 + candy * -1 + choco * 0)       // capacity
                          * Math.Max(0, sugar * 0 + sprinkles * 3 + candy * 0 + choco * 0)         // durability
                          * Math.Max(0, sugar * 0 + sprinkles * 0 + candy * 4 + choco * -2)        // flavor
                          * Math.Max(0, sugar * -3 + sprinkles * 0 + candy * 0 + choco * 2);       // texture
                        yield return (score: score, calorie: sugar * 2 + sprinkles * 9 + candy * 1 + choco * 8);
                    }
        }
    }
}

