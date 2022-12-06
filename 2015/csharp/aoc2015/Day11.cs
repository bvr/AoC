using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/11
    /// </summary>
    [TestClass]
    public class Day11
    {
        string input = "vzbxkghb";

        [TestMethod]
        public void Tests()
        {
            Assert.AreEqual(true, HasStraight("hijklmmn"));
            Assert.AreEqual(false, IsValid("hijklmmn"));
            Assert.AreEqual(false, IsValid("abbceffg"));
            Assert.AreEqual(false, IsValid("abbcegjk"));
            Assert.AreEqual(true, IsValid("ghjaabcc"));
            Assert.AreEqual("abcdffaa", RotatePassword("abcdefgh").First(password => IsValid(password)));
            Assert.AreEqual("ghjaabcc", RotatePassword("ghijklmn").First(password => IsValid(password)));
        }

        [TestMethod]
        public void BothParts()
        {
            string firstRotation = RotatePassword(input).First(password => IsValid(password));
            Assert.AreEqual("vzbxxyzz", firstRotation);

            string secondRotation = RotatePassword(firstRotation).First(password => IsValid(password));
            Assert.AreEqual("vzcaabcc", secondRotation);
        }

        private IEnumerable<string> RotatePassword(string str)
        {
            while (true)
                yield return str = IncPassword(str);
        }

        private string IncPassword(string str, int inc = 1)
        {
            if (str.Length == 0 || inc == 0)
                return str;

            char lastChar = str[str.Length - 1];
            return IncPassword(new string(str.Take(str.Length - 1).ToArray()), lastChar == 'z' ? 1 : 0)
                + (lastChar == 'z' ? 'a' : Convert.ToChar(lastChar + inc));
        }

        static Regex confusing = new Regex(@"[iol]");
        static Regex twice = new Regex(@"(\w)\1");

        private bool IsValid(string password)
        {
            return twice.Matches(password).Count >= 2 
                && !confusing.Match(password).Success
                && HasStraight(password);
        }

        private bool HasStraight(string password)
        {
            int prev = -1, len = 0;

            // each char is decreased by its position, then looking for three same consecutive
            foreach(int num in password.Select((c, i) => c - i))
            {
                if (num != prev) 
                    len = 0;
                else 
                    if(++len >= 2) return true;
                prev = num;
            }

            return false;
        }

    }
}

