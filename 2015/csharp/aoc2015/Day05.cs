using Microsoft.VisualStudio.TestTools.UnitTesting;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/5
    /// </summary>
    [TestClass]
    public class Day05
    {
        enum Result {
            Nice,
            Naugthy,
        };

        static Regex vowels = new Regex(@"[aeiou]");
        static Regex twice = new Regex(@"(\w)\1");
        static Regex forbidden = new Regex(@"(ab|cd|pq|xy)");
        static Regex twotwice = new Regex(@"(\w{2}).*\1");
        static Regex letterbetween = new Regex(@"(\w).\1");

        string[] lines = File.ReadAllLines("Input\\05.txt");

        [TestMethod]
        public void Part1()
        {
            Assert.AreEqual(Result.Nice, CheckString1("ugknbfddgicrmopn"));
            Assert.AreEqual(Result.Nice, CheckString1("aaa"));
            Assert.AreEqual(Result.Naugthy, CheckString1("jchzalrnumimnmhp"));
            Assert.AreEqual(Result.Naugthy, CheckString1("haegwjzuvuyypxyu"));
            Assert.AreEqual(Result.Naugthy, CheckString1("dvszwmarrgswjxmb"));
            Assert.AreEqual(238, lines.Count(line => CheckString1(line) == Result.Nice));
        }

        [TestMethod]
        public void Part2()
        {
            Assert.AreEqual(Result.Nice, CheckString2("qjhvhtzxzqqjkmpb"));
            Assert.AreEqual(Result.Nice, CheckString2("xxyxx"));
            Assert.AreEqual(Result.Naugthy, CheckString2("uurcxstgmygtbstg"));
            Assert.AreEqual(Result.Naugthy, CheckString2("ieodomkazucvgmuy"));
            Assert.AreEqual(69, lines.Count(line => CheckString2(line) == Result.Nice));
        }

        Result CheckString1(string v)
        {
            return vowels.Matches(v).Count >= 3 
                && twice.Match(v).Success 
                && !forbidden.Match(v).Success 
                    ? Result.Nice : Result.Naugthy;
        }

        Result CheckString2(string v)
        {
            return twotwice.Match(v).Success 
                && letterbetween.Match(v).Success
                    ? Result.Nice : Result.Naugthy;
        }
    }
}

