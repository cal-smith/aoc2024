import std/strutils
import std/strformat

let sample = """
MMMSXXMASM
MSAMXMSMSA
AMXSXMAAMM
MSAMASMSMX
XMASAMXAMM
XXAMMXXAMA
SMSMSASXSS
SAXAMASAAA
MAMMMXMMMM
MXMXAXMASX
"""

proc parse(inputStr: string): seq[string] =
  return inputStr.strip.splitLines

proc findXmas(puzzle: seq[string]): int =
  let rows = puzzle.len
  let cols = puzzle[0].len
  var count = 0
  for (y, row) in puzzle.pairs:
    for (x, c) in row.pairs:
      if y <= rows - 4:
        if puzzle[y][x] & puzzle[y+1][x] & puzzle[y+2][x] & puzzle[y+3][x] == "XMAS":
          count += 1
        if x >= 3 and puzzle[y][x] & puzzle[y+1][x-1] & puzzle[y+2][x-2] & puzzle[y+3][x-3] == "XMAS":
          count += 1
        if x <= cols - 4 and puzzle[y][x] & puzzle[y+1][x+1] & puzzle[y+2][x+2] & puzzle[y+3][x+3] == "XMAS":
          count += 1
      if y >= 3:
        if puzzle[y-3][x] & puzzle[y-2][x] & puzzle[y-1][x] & puzzle[y][x] == "SAMX":
          count += 1
        if x >= 3 and puzzle[y-3][x-3] & puzzle[y-2][x-2] & puzzle[y-1][x-1] & puzzle[y][x] == "SAMX":
          count += 1
        if x <= cols - 4 and puzzle[y-3][x+3] & puzzle[y-2][x+2] & puzzle[y-1][x+1] & puzzle[y][x] == "SAMX":
          count += 1
      if x <= cols - 4:
        if puzzle[y][x] & puzzle[y][x+1] & puzzle[y][x+2] & puzzle[y][x+3] == "XMAS":
          count += 1
      if x >= 3:
        if puzzle[y][x-3] & puzzle[y][x-2] & puzzle[y][x-1] & puzzle[y][x] == "SAMX":
          count += 1
  return count


proc findXMASes(puzzle: seq[string]): int =
  let rows = puzzle.len
  let cols = puzzle[0].len
  var count = 0
  for (y, row) in puzzle.pairs:
    for (x, c) in row.pairs:
      if y <= rows - 3 and x <= cols - 3:
        let topValid = ['M', 'S'].contains(puzzle[y][x]) and ['M', 'S'].contains(puzzle[y][x+2])
        let middleValid = puzzle[y+1][x+1] == 'A'
        let bottomValid = ['M', 'S'].contains(puzzle[y+2][x]) and puzzle[y+2][x] != puzzle[y][x+2] and 
          ['M', 'S'].contains(puzzle[y+2][x+2]) and puzzle[y+2][x+2] != puzzle[y][x]
        if topValid and middleValid and bottomValid:
          count += 1
  return count

echo &"part 1 (sample): {sample.parse.findXmas}"
echo &"part 2 (sample): {sample.parse.findXMASes}"

let data = readFile("input.txt")
echo &"part 1: {data.parse.findXmas}"
echo &"part 2: {data.parse.findXMASes}"
