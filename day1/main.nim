import std/strutils
import std/algorithm
import std/sequtils
import std/strformat

let sample = """
3   4
4   3
2   5
1   3
3   9
3   3
"""

proc parse(inputStr: string): (seq[int], seq[int]) =  
    var list1: seq[int]
    var list2: seq[int]
    for line in inputStr.strip.splitLines:
        let parts = line.split("   ")
        list1.add(parts[0].parseInt)
        list2.add(parts[1].parseInt)
    return (list1, list2)

proc distance(lists: (seq[int], seq[int])): int =
    let (list1, list2) = lists
    return list1.sorted.zip(list2.sorted).foldl(a + abs(b[0] - b[1]), 0)

proc compare(lists: (seq[int], seq[int])): int =
    let (list1, list2) = lists
    return list1.foldl(a + b * list2.countIt(it == b), 0)

echo &"part 1 (sample): {sample.parse.distance}"
echo &"part 1 (sample): {sample.parse.compare}"

let data = readFile("input.txt")
echo &"part 1: {data.parse.distance}"
echo &"part 1: {data.parse.compare}"
