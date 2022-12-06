using Microsoft.VisualStudio.TestTools.UnitTesting;
using Newtonsoft.Json.Linq;
using System.IO;
using System.Linq;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/12
    /// </summary>
    [TestClass]
    public class Day12
    {
        string input = File.ReadAllText("Input\\12.txt");

        [TestMethod]
        public void Part1()
        {
            var details = JToken.Parse(input);
            Assert.AreEqual(191164, SumIntegers(details, skipRedItems: false));
        }

        [TestMethod]
        public void Part2()
        {
            var details = JToken.Parse(input);
            Assert.AreEqual(87842, SumIntegers(details, skipRedItems: true));
        }

        private int SumIntegers(JToken item, bool skipRedItems)
        {
            if (skipRedItems && item.Type == JTokenType.Object && item.Children().Any(c => IsRedProperty(c)))
                return 0;
            if (item.Type == JTokenType.Integer)
                return item.Value<int>();
            return item.Children().Sum(c => SumIntegers(c, skipRedItems));
        }

        private bool IsRedProperty(JToken c)
        {
            return c.Type == JTokenType.Property && c.First().Type == JTokenType.String && c.First().Value<string>() == "red";
        }

    }
}

