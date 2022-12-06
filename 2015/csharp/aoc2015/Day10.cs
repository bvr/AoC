using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Text;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/10
    /// </summary>
    [TestClass]
    public class Day10
    {
        string input = "1321131112";

        [TestMethod]
        public void Part1()
        {
            Assert.AreEqual("11", Convert("1"));
            Assert.AreEqual("1211", Convert("21"));
            Assert.AreEqual("111221", Convert("1211"));
            Assert.AreEqual("312211", Convert("111221"));
            Assert.AreEqual(492982, Repeat(40, Convert, input).Length);
        }

        [TestMethod]
        public void Part2()
        {
            Assert.AreEqual(6989950, Repeat(50, Convert, input).Length);
        }

        /// <summary>
        /// Repeat the operation specified number of times, using result of previous iteration as input to the next
        /// </summary>
        /// <typeparam name="T">Type of the operation</typeparam>
        /// <param name="rep">Number of repetitions</param>
        /// <param name="op">Operation to transform the data</param>
        /// <param name="init">Initial value for first iteration</param>
        /// <returns>Result of last iteration</returns>
        T Repeat<T>(int rep, Func<T, T> op, T init)
        {
            T proc = init;
            for (int i = 0; i < rep; i++)
                proc = op(proc);
            return proc;
        }

        /// <summary>
        /// Convert sequence to Run Lenght Encoding (RLE), i.e. pairs of chars -- count of chars and char itself
        /// </summary>
        /// <param name="seq">Sequence of numbers</param>
        /// <returns>Encoded sequence</returns>
        string Convert(string seq)
        {
            StringBuilder sb = new StringBuilder();
            foreach(string s in GetSequences(seq))
            {
                sb.Append(s.Length);
                sb.Append(s[0]);
            }
            return sb.ToString();
        }

        /// <summary>
        /// Returns sequences of same characters
        /// </summary>
        /// <param name="seq">Sequence of characters</param>
        /// <returns>Enumerator of sequence of same character</returns>
        IEnumerable<string> GetSequences(string seq)
        {
            int start = 0, pos = 0;
            while(start < seq.Length)
            {
                while (pos < seq.Length && seq[start] == seq[pos])
                    pos++;

                yield return seq.Substring(start, pos - start);
                start = pos;
            }
        }

    }
}

