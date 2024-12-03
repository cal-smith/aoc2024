import std/strutils
import std/sequtils
import std/strformat

let sample = """
7 6 4 2 1
1 2 7 8 9
9 7 6 2 1
1 3 2 4 5
8 6 4 4 1
1 3 6 7 9
"""

proc parse(inputStr: string): seq[seq[int]] =
  return inputStr.strip.splitLines.map(proc(line: string): seq[int] =
    line.split(" ").map(proc(part: string): int = part.parseInt)
  )

type Direction = enum up, down, none

proc isSafeReport(report: seq[int], tolerence: int = 0): bool = 
  var prevLevel = -1
  var direction = if report[0] - report[1] > 0: Direction.up else: Direction.down
  var problems: seq[int] = @[]
  for (index, level) in report.pairs:
    if prevLevel != -1:
      let change = abs(prevLevel - level)
      if change < 1 or change > 3:
        problems.addUnique(index)

      # figure out the current direction
      var currentDirection = if prevLevel - level > 0:
        Direction.up
      else:
        Direction.down

      # they all have to be insreasing or decreasing
      if currentDirection != direction:
        problems.addUnique(index)

    prevLevel = level    

  if problems.len > 0:
    return false

  return true

proc countSafeReports(reports: seq[seq[int]]): int =
  var safeReports = 0
  for report in reports:
    if report.isSafeReport:
      safeReports += 1

  return safeReports

proc countDampenedReports(reports: seq[seq[int]]): int =
  var safeReports = 0
  for report in reports:
    if report.isSafeReport:
      safeReports += 1
    else:
      for (index, _) in report.pairs:
        var copy = deepCopy(report)
        copy.delete(index)
        if copy.isSafeReport:
          safeReports += 1
          break

  return safeReports


echo &"part 1 (sample): {sample.parse.countSafeReports}"
echo &"part 2 (sample): {sample.parse.countDampenedReports}" 

let data = readFile("input.txt")
echo &"part 1: {data.parse.countSafeReports}" 
echo &"part 2: {data.parse.countDampenedReports}" 
