
open System.IO

let filename = "..\\input\\01.txt"
let items = filename |> File.ReadLines |> Seq.map int

// first problem
items |> Seq.sum |> printfn "Part 1 = %A"

// need to figure out how to create infinite iterator to cycle over the items
// then simply add up numbers over this iterator 

// items |> Seq.pairwise 