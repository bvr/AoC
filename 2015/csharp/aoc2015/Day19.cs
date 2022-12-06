using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;
using System.Threading.Tasks;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/19
    /// </summary>
    [TestClass]
    public class Day19
    {
        class Plant
        {
            public string Start { get; }
            public ILookup<string, string> Replacements { get; }
            private Regex Molecules { get; }

            static Regex replacementLine = new Regex(@"(\w+) => (\w+)");

            public static Plant FromLines(string[] lines)
            {
                ILookup<string, string> repl = lines.Select(line => replacementLine.Match(line)).Where(m => m.Success).ToLookup(m => m.Groups[1].Value, m => m.Groups[2].Value);
                string start = lines.Where(line => line != "" && !replacementLine.Match(line).Success).First();
                return new Plant(start, repl);
            }

            public Plant(string start, ILookup<string, string> replacements)
            {
                Start = start;
                Replacements = replacements;
                Molecules = new Regex(string.Join("|", Replacements.Select(r => r.Key)));
            }

            public IEnumerable<string> BuildExpansions(string input)
            {
                foreach(Match m in Molecules.Matches(input))
                    foreach(string repl in Replacements[m.Value])
                        yield return input.Substring(0, m.Index) + repl + input.Substring(m.Index + m.Length);
            }

            public IEnumerable<(int, string)> BuildAllExpansions(string input)
            {
                Queue<(int, string)> queue = new Queue<(int, string)>();
                queue.Enqueue((0, input));
                while(queue.Count > 0)
                {
                    (int, string) curr = queue.Dequeue();
                    //Debug.WriteLine("{0}: {1}", curr.Item1, curr.Item2);
                    yield return curr;

                    foreach(string exp in BuildExpansions(curr.Item2))
                        queue.Enqueue((curr.Item1 + 1, exp));
                }
            }
        }

        string[] testLinesPart1 = new string[]
        {
            "H => HO",
            "H => OH",
            "O => HH",
            "",
            "HOH",
        };
        string[] testLinesPart2 = new string[]
        {
            "e => H",
            "e => O",
            "H => HO",
            "H => OH",
            "O => HH",
            "",
            "HOH",
        };
        string[] realLines = File.ReadAllLines("Input\\19.txt");

        [TestMethod]
        public void Part1()
        {
            Plant test = Plant.FromLines(testLinesPart1);
            Assert.AreEqual(4, test.BuildExpansions(test.Start).Distinct().Count());

            Plant real = Plant.FromLines(realLines);
            Assert.AreEqual(535, real.BuildExpansions(real.Start).Distinct().Count());
        }

        [TestMethod]
        public void Part2()
        {
            Plant test = Plant.FromLines(testLinesPart2);
            var found = test.BuildAllExpansions("e").First(exp => exp.Item2 == test.Start);
            Assert.AreEqual(3, found.Item1);

            Plant real = Plant.FromLines(realLines);
            var molecule = real.BuildAllExpansions("e").First(exp => exp.Item2 == test.Start);
            Assert.AreEqual(3, molecule.Item1);
        }
    }
}
