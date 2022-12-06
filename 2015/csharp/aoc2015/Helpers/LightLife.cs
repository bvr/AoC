using System.Diagnostics;

namespace aoc2015
{
    class LightLife : LightArray<bool>
    {
        public static LightLife FromLines(string[] lines)
        {
            var lightLife = new LightLife(lines[0].Length, lines.Length);
            int y = 0;
            foreach (string line in lines)
            {
                int x = 0;
                foreach (char c in line)
                {
                    lightLife[x, y] = c == '#' ? true : false;
                    x++;
                }
                y++;
            }

            return lightLife;
        }

        public LightLife(int width, int height) : base(width, height)
        {
        }

        private bool IsValidPoint(int x, int y) => 0 <= x && x < Width && 0 <= y && y < Height;

        public bool this[int x, int y]
        {
            get { return IsValidPoint(x, y) ? Array[x, y] : false; }
            set { if (IsValidPoint(x, y)) Array[x, y] = value; }
        }

        private int LiveNeighbors(int x, int y)
        {
            int sum = this[x - 1, y - 1] ? 1 : 0;
            sum += this[x - 1, y] ? 1 : 0;
            sum += this[x - 1, y + 1] ? 1 : 0;
            sum += this[x, y - 1] ? 1 : 0;
            sum += this[x, y + 1] ? 1 : 0;
            sum += this[x + 1, y - 1] ? 1 : 0;
            sum += this[x + 1, y] ? 1 : 0;
            sum += this[x + 1, y + 1] ? 1 : 0;
            return sum;
        }

        public void Step()
        {
            bool[,] newArray = new bool[Width, Height];
            for (int y = 0; y < Height; y += 1)
            {
                for (int x = 0; x < Width; x += 1)
                {
                    int count = LiveNeighbors(x, y);
                    newArray[x, y] =
                        Array[x, y] == false && count == 3 ? true                  // off -> on
                      : Array[x, y] == true && (count == 2 || count == 3) ? true   // on -> on
                      : false;
                }
            }
            Array = newArray;
        }

        public void SetFourCorners()
        {
            this[0, 0] = true;
            this[Width - 1, 0] = true;
            this[0, Height - 1] = true;
            this[Width - 1, Height - 1] = true;
        }

        public void Dump()
        {
            for (int y = 0; y < Height; y++)
            {
                for (int x = 0; x < Width; x++)
                    Debug.Write(this[x, y] == true ? '#' : '.');
                Debug.WriteLine("");
            }
            Debug.WriteLine("");
        }

    }
}

