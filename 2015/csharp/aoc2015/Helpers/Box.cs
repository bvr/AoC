using System.Linq;

namespace aoc2015
{
    class Box
    {
        public int Width { get; }
        public int Height { get; }
        public int Length { get; }

        public Box(int l, int w, int h)
        {
            this.Length = l;
            this.Width = w;
            this.Height = h;
        }

        public static Box FromLine(string line)
        {
            string[] items = line.Split('x');
            return new Box(int.Parse(items[0]), int.Parse(items[1]), int.Parse(items[2]));
        }

        public int WrappingPaperArea()
        {
            int[] sideArea = new int[] { Length * Width, Width * Height, Height * Length };
            int extra = sideArea.OrderBy(a => a).First();
            return sideArea.Sum(a => 2 * a) + extra;
        }

        public int RibbonLenght()
        {
            int[] dim = new int[] { Width, Length, Height };
            int bowLength = dim.Aggregate((product, next) => product * next);
            return dim.OrderBy(d => d).Take(2).Sum(d => 2 * d) + bowLength;
        }
    }
}

