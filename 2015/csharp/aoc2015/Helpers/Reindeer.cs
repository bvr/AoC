using System;

namespace aoc2015
{
    class Reindeer
    {
        public string Name { get; }
        public int Speed { get; }
        public int FlyTime { get; }
        public int RestTime { get; }
        public int Points { get; set; } = 0;

        public Reindeer(string name, int speed, int flyTime, int restTime)
        {
            Name = name;
            Speed = speed;
            FlyTime = flyTime;
            RestTime = restTime;
        }

        public int ReachedIn(int elapsed)
        {
            int periodLength = FlyTime + RestTime;
            return Speed * FlyTime * (elapsed / periodLength) + Speed * Math.Min(elapsed % periodLength, FlyTime);
        }
    }
}

