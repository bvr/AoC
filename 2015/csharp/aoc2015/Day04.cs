using System.Text;
using System.Security.Cryptography;
using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Linq;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/4
    /// </summary>
    [TestClass]
    public class Day04
    {
        string secret = "yzbqklnj";

        [TestMethod]
        public void Part1()
        {
            using (var md5 = MD5.Create())
            {
                Assert.AreEqual(609043, FindAdventCoin("abcdef", md5, "00000"));
                Assert.AreEqual(1048970, FindAdventCoin("pqrstuv", md5, "00000"));
                Assert.AreEqual(282749, FindAdventCoin(secret, md5, "00000"));
            }
        }

        [TestMethod]
        public void Part2()
        {
            using (var md5 = MD5.Create())
            {
                Assert.AreEqual(9962624, FindAdventCoin(secret, md5, "000000"));
            }
        }

        long FindAdventCoin(string secret, MD5 md5, string expectedStart)
        {
            long i = 1;
            while(true)
            {
                byte[] byteSecret = Encoding.ASCII.GetBytes(secret + i.ToString());
                byte[] computed = md5.ComputeHash(byteSecret);
                if (BitConverter.ToString(computed).Replace("-", "").StartsWith(expectedStart))
                    break;
                i++;
            }
            return i;
        }
    }
}

