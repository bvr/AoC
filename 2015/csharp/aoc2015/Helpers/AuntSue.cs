using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace aoc2015
{
    class AuntSue
    {
        public int Number { get; }
        public Dictionary<string, int> Properties { get; }

        public AuntSue(int number, Dictionary<string, int> properties)
        {
            Number = number;
            Properties = properties;
        }

        public bool Matches(Dictionary<string, int> measured) => Properties.All(prop => measured[prop.Key] == prop.Value);
        public bool MatchRanges(Dictionary<string, int> measured) => Properties.All(prop => Compares(prop.Key, measured[prop.Key], prop.Value));

        private bool Compares(string key, int measured, int value)
        {
            if (key == "trees" || key == "cats")
                return value > measured;
            if (key == "pomeranians" || key == "goldfish")
                return value < measured;
            return value == measured;
        }

        public override string ToString()
        {
            return $"Sue {Number}: " + string.Join(", ", Properties.Select(prop => $"{prop.Key}: {prop.Value}"));
        }


        private static Regex linePattern = new Regex(@"Sue (\d+): (.*)$");
        private static Regex propPattern = new Regex(@"(\w+): (\d+)");

        public static AuntSue FromLine(string line)
        {
            Match lineMatch = linePattern.Match(line);
            if (!lineMatch.Success)
                throw new Exception($"{line} does not match the pattern");

            int number = int.Parse(lineMatch.Groups[1].Value);
            Dictionary<string, int> props = new Dictionary<string, int>();

            foreach (Match pair in propPattern.Matches(lineMatch.Groups[2].Value))
                props[pair.Groups[1].Value] = int.Parse(pair.Groups[2].Value);

            return new AuntSue(number, props);
        }
    }
}

