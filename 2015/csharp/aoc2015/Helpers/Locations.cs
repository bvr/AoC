using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace aoc2015
{
    class Locations
    {
        private Dictionary<(string, string), int> Distances { get; } = new Dictionary<(string, string), int>();
        private HashSet<string> Places { get; } = new HashSet<string>();

        private static Regex linePattern = new Regex(@"(.*) to (.*) = (\d+)");

        public Locations(IEnumerable<string> lines)
        {
            foreach (string line in lines)
            {
                Match m = linePattern.Match(line);
                if (!m.Success)
                    throw new Exception($"Invalid line {line}");

                string from = m.Groups[1].Value;
                string to = m.Groups[2].Value;
                int dist = int.Parse(m.Groups[3].Value);

                Places.Add(from);
                Places.Add(to);

                Distances.Add((from, to), dist);            // add both directions in distance list
                Distances.Add((to, from), dist);
            }
        }

        public int FindShortestPath() => AllPathLengths().First();
        public int FindLongestPath() => AllPathLengths().Last();

        private IEnumerable<int> AllPathLengths()
        {
            return Utils.GetPermutations<string>(Places.ToArray(), Places.Count)
                .Select(path => PathLength(path.ToArray()))
                .OrderBy(len => len);
        }

        private int PathLength(string[] path)
        {
            if (path.Length < 2)
                return 0;
            return Enumerable.Range(0, path.Length - 1).Sum(i => Distances[(path[i], path[i + 1])]);
        }
    }
}

