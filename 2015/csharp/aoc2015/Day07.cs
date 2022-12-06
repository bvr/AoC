using Microsoft.VisualStudio.TestTools.UnitTesting;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;

namespace aoc2015
{
    /// <summary>
    /// https://adventofcode.com/2015/day/7
    /// </summary>
    [TestClass]
    public class Day07
    {
        interface IValue
        {
            string Name { get; }
            ushort GetValue();
        }

        class Wire : IValue
        {
            private ushort Value { get; set; }
            private bool Calculated { get; set; } = false;

            public string Name { get; }
            public IValue Producer { get; set; }

            public Wire(string name, IValue producer = null)
            {
                Name = name;
                Producer = producer;
            }

            public void Reset()
            {
                Calculated = false;
            }

            public void SetValue(ushort val)
            {
                Value = val;
                Calculated = true;
            }

            public ushort GetValue()
            {
                if (Calculated || Producer == null)
                    return Value;

                // calculate only once
                Value = Producer.GetValue();
                Calculated = true;
                return Value;
            }
        }

        class Constant : IValue
        {
            public string Name => Value.ToString();
            public ushort Value { get; }

            public Constant(ushort value)
            {
                Value = value;
            }

            public ushort GetValue() => Value;
        }

        class Gate : IValue
        {
            public Gate(string name, IEnumerable<IValue> inputs)
            {
                Name = name;
                Inputs = inputs.ToList();
            }

            public string Name { get; }
            public List<IValue> Inputs { get; }

            public ushort GetValue()
            {
                switch(Name)
                {
                    case "AND":    return (ushort)(Inputs[0].GetValue() & Inputs[1].GetValue());
                    case "OR":     return (ushort)(Inputs[0].GetValue() | Inputs[1].GetValue());
                    case "LSHIFT": return (ushort)(Inputs[0].GetValue() << Inputs[1].GetValue());
                    case "RSHIFT": return (ushort)(Inputs[0].GetValue() >> Inputs[1].GetValue());
                    case "NOT":    return (ushort)(~Inputs[0].GetValue());
                    default:
                        throw new System.Exception($"Not supported operation {Name}");
                }
            }
        }

        class Machine
        {
            private Dictionary<string, IValue> Wires { get; } = new Dictionary<string, IValue>();

            public IValue GetWire(string name) => Wires[name];

            public void SetWire(string name, ushort value)
            {
                (Wires[name] as Wire).SetValue(value);
            }

            /// <summary>
            /// Set all wires as not calculated -- basically forces recalculation on next GetValue
            /// </summary>
            public void ResetAll()
            {
                foreach(Wire wire in Wires.Values.Select(w => w as Wire).Where(w => w != null))
                    wire.Reset();

            }

            /// <summary>
            /// Creates new wire or constant and adds it into the list of them
            /// </summary>
            /// <param name="name">Name of the wire or value of constant. If numeric, constant will be created</param>
            /// <param name="producer">IValue item that can produce value of the wire</param>
            /// <returns>The created object Wire or Constant</returns>
            public IValue GetOrSetupWire(string name, IValue producer = null)
            {
                // wire already exist
                if (Wires.ContainsKey(name))
                {
                    // update producer if needed
                    Wire found = Wires[name] as Wire;
                    if (found != null && producer != null)
                        if (found.Producer == null)
                            found.Producer = producer;
                        else
                            throw new Exception($"Wire {found.Name} has more than one producing gates");

                    return Wires[name];
                }

                IValue ni;
                if(ushort.TryParse(name, out ushort val))
                    ni = new Constant(val);             // numeric name - plain value
                else
                    ni = new Wire(name, producer);

                Wires.Add(ni.Name, ni);
                return ni;
            }

            public void DumpWires()
            {
                foreach (var kv in Wires.OrderBy(kv => kv.Key))
                    Debug.WriteLine($"{kv.Value.Name}: {kv.Value.GetValue()}");
            }
        }


        [TestMethod]
        public void MachineTests()
        {
            // simple test for building blocks and calculation
            Gate g = new Gate(name: "AND", inputs: new IValue[]
            {
                new Wire(name: "x", producer: new Constant(123)),
                new Wire(name: "y", producer: new Constant(456)),
            });
            Assert.AreEqual(72, g.GetValue());

            // example data
            string[] testCircuit = new string[]
            {
                "123 -> x",
                "456 -> y",
                "x AND y -> d",
                "x OR y -> e",
                "x LSHIFT 2 -> f",
                "y RSHIFT 2 -> g",
                "NOT x -> h",
                "NOT y -> i",
            };

            Machine testMachine = BuildMachine(testCircuit);
            Assert.AreEqual(123, testMachine.GetWire("x").GetValue());
            //testMachine.DumpWires();
        }

        [TestMethod]
        public void Part1()
        {
            Machine realMachine = BuildMachine(File.ReadLines("Input\\07.txt"));
            // part1.DumpWires();
            ushort wireA = realMachine.GetWire("a").GetValue();
            Assert.AreEqual(3176, wireA);
        }

        [TestMethod]
        public void Part2()
        {
            Machine realMachine = BuildMachine(File.ReadLines("Input\\07.txt"));
            ushort wireA = realMachine.GetWire("a").GetValue();

            realMachine.ResetAll();
            realMachine.SetWire("b", wireA);
            Assert.AreEqual(14710, realMachine.GetWire("a").GetValue());
        }

        static Regex expr = new Regex(
            @"((?<i1>[a-z]+|\d+) \s+)? ((?<op>AND|OR|LSHIFT|RSHIFT|NOT) \s+)?"
          + @"(?<i2>[a-z]+|\d+) \s* -> \s* (?<out>[a-z]+)", RegexOptions.IgnorePatternWhitespace);

        Machine BuildMachine(IEnumerable<string> circuit)
        {
            Machine m = new Machine();
            foreach (string line in circuit)
            {
                Match parsed = expr.Match(line);
                if (!parsed.Success)
                    throw new System.Exception($"Unable to parse {line}");

                string outputWire = parsed.Groups["out"].Value;

                // block for functions/gates
                if (parsed.Groups["op"].Success)
                    m.GetOrSetupWire(outputWire, new Gate(parsed.Groups["op"].Value,
                        new string[] { "i1", "i2" }
                            .Where(input => parsed.Groups[input].Success)
                            .Select(input => m.GetOrSetupWire(parsed.Groups[input].Value)).ToList()));
                // plain wire setup: c -> x
                else
                    m.GetOrSetupWire(outputWire, m.GetOrSetupWire(parsed.Groups["i2"].Value));
            }
            return m;
        }
    }
}

