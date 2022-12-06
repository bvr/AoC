using System;
using System.Collections.Generic;
using System.Linq;
using System.Text.RegularExpressions;

namespace aoc2015
{
    class PeopleRelations
    {
        public Dictionary<(string, string), int> HappinessPoints { get; } = new Dictionary<(string, string), int>();
        public HashSet<string> People { get; } = new HashSet<string>();

        private static Regex linePattern = new Regex(@"(\w+) would (gain|lose) (\d+) happiness units by sitting next to (\w+)\.");

        /// <summary>
        /// Create list of people and their relative happiness from list of lines
        /// </summary>
        /// <param name="lines">Lines like: "Alice would gain 54 happiness units by sitting next to Bob."</param>
        public PeopleRelations(IEnumerable<string> lines)
        {
            foreach (string line in lines)
            {
                Match m = linePattern.Match(line);
                if (!m.Success)
                    throw new Exception($"Invalid line {line}");

                string who = m.Groups[1].Value;
                int happiness = int.Parse(m.Groups[3].Value) * (m.Groups[2].Value == "lose" ? -1 : 1);
                string sittingBy = m.Groups[4].Value;

                People.Add(who);
                People.Add(sittingBy);

                HappinessPoints.Add((who, sittingBy), happiness);
            }
        }

        /// <summary>
        /// Add neutral yourself into the mix
        /// </summary>
        public void AddYourself()
        {
            string myName = "Me";

            foreach (string person in People)
            {
                HappinessPoints.Add((myName, person), 0);
                HappinessPoints.Add((person, myName), 0);
            }
            People.Add("Me");
        }

        /// <summary>
        /// Most happy combination of people
        /// </summary>
        /// <returns>The total amount of happiness in the most happy combination</returns>
        public int FindMostHappy() => AllPathHappiness().Last();

        /// <summary>
        /// Generates all combinations of people seatings and order then ascending by the total happiness
        /// </summary>
        /// <returns>Ordered happiness for all combinations</returns>
        private IEnumerable<int> AllPathHappiness()
        {
            return Utils.GetPermutations<string>(People.ToArray(), People.Count)
                .Select(path => TotalHappiness(path.ToArray()))
                .OrderBy(len => len);
        }

        /// <summary>
        /// Calculates happiness for seating at round table. Each person gets points for both neighbours
        /// </summary>
        /// <param name="path">Seating of people round the table</param>
        /// <returns>Total happiness for the combination</returns>
        private int TotalHappiness(string[] path)
        {
            if (path.Length < 2)
                return 0;

            int happiness = 0;
            for (int i = 0; i < path.Length - 1; i++)
            {
                happiness += HappinessPoints[(path[i], path[i + 1])];
                happiness += HappinessPoints[(path[i + 1], path[i])];
            }

            // close the circle
            happiness += HappinessPoints[(path[0], path[path.Length - 1])];
            happiness += HappinessPoints[(path[path.Length - 1], path[0])];

            return happiness;
        }
    }
}

