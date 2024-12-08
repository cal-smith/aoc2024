import std/strutils
import std/strformat
import std/algorithm
import std/tables
import std/sets

let sample = """
............
........0...
.....0......
.......0....
....0.......
......A.....
............
............
........A...
.........A..
............
............
"""

type Map = (seq[string], tuple[width: int, height: int])

proc parse(inputTxt: string): Map =
  let lines = inputTxt.strip.splitLines
  (lines, (lines[0].len - 1, lines.len - 1))

proc findAntennas(map: seq[string]): Table[char, seq[(int, int)]] =
  var antennas: Table[char, seq[(int, int)]]
  for (y, row) in map.pairs:
    for (x, c) in row.pairs:
      if c != '.':
        antennas.mgetOrPut(c, @[]).add((x, y))
  antennas

proc findAntinodes(mapInput: Map): int =
  let (map, dimensions) = mapInput

  var antinodes: HashSet[(int, int)]
  for antennaLocations in map.findAntennas.values:
    for antennaPairs in product(@[antennaLocations, antennaLocations]):
      let (a1x, a1y) = antennaPairs[0]
      let (a2x, a2y) = antennaPairs[1]
      let distanceX = abs(a1x - a2x)
      let distanceY = abs(a1y - a2y)
      if distanceX + distanceY >= 2:
        var antinodeX: int
        var antinodeY: int
        if a1x - a2x > 0:
          antinodeX = a2x - distanceX
        else:
          antinodeX = a2x + distanceX

        if a1y - a2y > 0:
          antinodeY = a2y - distanceY
        else:
          antinodeY = a2y + distanceY

        if antinodeX >= 0 and antinodeX <= dimensions.width and 
          antinodeY >= 0 and antinodeY <= dimensions.height:
          antinodes.incl((antinodeX, antinodeY))
  return antinodes.len

proc findResonantAntinodes(mapInput: Map): int =
  let (map, dimensions) = mapInput

  var antinodes: HashSet[(int, int)]
  for antennaLocations in map.findAntennas.values:
    for antennaPairs in product(@[antennaLocations, antennaLocations]):
      antinodes.incl(antennaPairs[0])
      antinodes.incl(antennaPairs[1])
      let (a1x, a1y) = antennaPairs[0]
      let (a2x, a2y) = antennaPairs[1]
      let distanceX = abs(a1x - a2x)
      let distanceY = abs(a1y - a2y)
      if distanceX + distanceY >= 2:
        var antinodeX: int
        var antinodeY: int
        if a1x - a2x > 0:
          antinodeX = a2x - distanceX
        else:
          antinodeX = a2x + distanceX

        if a1y - a2y > 0:
          antinodeY = a2y - distanceY
        else:
          antinodeY = a2y + distanceY

        if antinodeX >= 0 and antinodeX <= dimensions.width and antinodeY >= 0 and antinodeY <= dimensions.height:
          antinodes.incl((antinodeX, antinodeY))

        while antinodeX >= 0 and antinodeX <= dimensions.width and antinodeY >= 0 and antinodeY <= dimensions.height:
          if a1x - a2x > 0:
            antinodeX = antinodeX - distanceX
          else:
            antinodeX = antinodeX + distanceX

          if a1y - a2y > 0:
            antinodeY = antinodeY - distanceY
          else:
            antinodeY = antinodeY + distanceY

          if antinodeX >= 0 and antinodeX <= dimensions.width and antinodeY >= 0 and antinodeY <= dimensions.height:
            antinodes.incl((antinodeX, antinodeY))
  return antinodes.len

#  012345678911
#            01
#0 ......#....#
#1 ...#....0...
#2 ....#0....#.
#3 ..#....0....
#4 ....0....#..
#5 .#....A.....
#6 ...#........
#7 #......#....
#8 ........A...
#9 .........A..
#10..........#.
#11..........#.

echo &"part 1 (sample): {sample.parse.findAntinodes}"
echo &"part 2 (sample): {sample.parse.findResonantAntinodes}"

let data = readFile("input.txt")
echo &"part 1: {data.parse.findAntinodes}"
echo &"part 1: {data.parse.findResonantAntinodes}"
