using System.Collections.Generic;
using System.Linq;

namespace aoc2015
{
    public static class Utils
    {
        // from https://stackoverflow.com/a/10630026/454144
        public static IEnumerable<IEnumerable<T>> GetPermutations<T>(IEnumerable<T> list, int length)
        {
            if (length == 1)
                return list.Select(t => new T[] { t });

            return GetPermutations(list, length - 1)
                .SelectMany(t => list.Where(e => !t.Contains(e)),
                    (t1, t2) => t1.Concat(new T[] { t2 }));
        }

        // from https://stackoverflow.com/a/33336576/454144
        public static IEnumerable<IEnumerable<T>> GetCombinations<T>(this IEnumerable<T> elements, int k)
        {
            return k == 0 
                ? new[] { new T[0] } 
                : elements.SelectMany((e, i) =>
                    elements.Skip(i + 1).GetCombinations(k - 1).Select(c => (new[] { e }).Concat(c)));
        }
    }
}
