using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace aoc2015
{

    /// <summary>
    /// https://adventofcode.com/2015/day/14
    /// </summary>
    [TestClass]
    public class Day14
    {
        [TestMethod]
        public void RunRace()
        {
            // test cases
            Assert.AreEqual(5, new Reindeer("Simple", 1, 3, 5).ReachedIn(10));

            var comet = new Reindeer("Comet", 14, 10, 127);
            Assert.AreEqual(1120, comet.ReachedIn(1000));
            var dancer = new Reindeer("Dancer", 16, 11, 162);
            Assert.AreEqual(1056, dancer.ReachedIn(1000));

            // load list of reindeers
            Regex linePattern = new Regex(@"(?<name>\w+) can fly (?<speed>\d+) km/s for (?<fly>\d+) seconds, but then must rest for (?<rest>\d+) seconds.");
            Reindeer[] reindeers = File.ReadLines(@"Input\14.txt").Select(line =>
            {
                Match result = linePattern.Match(line);
                if (!result.Success)
                    throw new Exception($"Unable to parse {line}");

                return new Reindeer(
                    result.Groups["name"].Value,
                    int.Parse(result.Groups["speed"].Value),
                    int.Parse(result.Groups["fly"].Value),
                    int.Parse(result.Groups["rest"].Value)
                );
            }).ToArray();

            // part 1
            int raceLength = 2503;
            Reindeer winner = reindeers.OrderBy(rd => rd.ReachedIn(raceLength)).Last();
            Assert.AreEqual(2640, winner.ReachedIn(raceLength));

            // part 2 - test
            RunRace(new[] { comet, dancer }, 1000);
            Assert.AreEqual(689, dancer.Points);
            Assert.AreEqual(312, comet.Points);

            // part 2 - race
            RunRace(reindeers, raceLength);
            Assert.AreEqual(1102, reindeers.Max(rd => rd.Points));
        }

        private static void RunRace(Reindeer[] reindeers, int raceLength)
        {
            foreach (int sec in Enumerable.Range(1, raceLength))
            {
                Reindeer[] race = reindeers.OrderBy(rd => rd.ReachedIn(sec)).ToArray();
                int leadDistance = race.Last().ReachedIn(sec);
                foreach (var rd in race.Where(rd => rd.ReachedIn(sec) == leadDistance))
                    rd.Points++;
            }
        }
    }
}

