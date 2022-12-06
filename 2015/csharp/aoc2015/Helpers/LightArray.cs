using System;
using System.Collections;
using System.Collections.Generic;

namespace aoc2015
{
    class LightArray<T> : IEnumerable<T>
    {
        public int Width { get; }
        public int Height { get; }

        public T[,] Array { get; protected set; }

        public LightArray(int width, int height)
        {
            Width = width;
            Height = height;
            Array = new T[Width, Height];
        }

        public void SetRect(int x1, int y1, int x2, int y2, Func<T, T> apply)
        {
            for (int x = x1; x <= x2; x++)
                for (int y = y1; y <= y2; y++)
                    Array[x, y] = apply(Array[x, y]);
        }

        public IEnumerator<T> GetEnumerator()
        {
            for (int x = 0; x < Width; x++)
                for (int y = 0; y < Height; y++)
                    yield return Array[x, y];
        }

        IEnumerator IEnumerable.GetEnumerator() => GetEnumerator();
    }
}

