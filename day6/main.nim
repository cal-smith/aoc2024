import std/strutils
import std/strformat
import std/sets

let sample = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"""

proc parse(inputStr: string): seq[string] =
  inputStr.strip.splitLines

proc findStart(map: seq[string]): (int, int) =
  for (y, row) in map.pairs:
    for (x, col) in row.pairs:
      if col == '^':
        return (x,y)

proc getPathPositions(map: seq[string]): HashSet[(int,int)] =
  var position = map.findStart
  var move = (0,-1)
  var path: HashSet[(int,int)]
  while true:
    path.incl(position)
    let (x,y) = position
    let (mx,my) = move
    if y + my >= map.len or y + my < 0 or x + mx >= map[0].len or x + mx < 0:
      break
    elif map[y + my][x + mx] == '#':
      if mx > 0:
        move = (0,1)
      elif mx < 0:
        move = (0,-1)
      elif my > 0:
        move = (-1,0)
      elif my < 0:
        move = (1, 0)
    else:
      position = (x + mx,y + my)
  path

proc countPath(map: seq[string]): int =
  map.getPathPositions.len

proc countLoops(map: seq[string]): int =
  let start = map.findStart
  let possibleObstructions = map.getPathPositions
  var count = 0
  for (ox,oy) in possibleObstructions:
    if (ox,oy) == start:
      continue
    var position = start
    var move = (0,-1)
    var newPath: HashSet[((int, int), (int, int))]
    var newMap = map
    newMap[oy][ox] = '#'
    while true:
      let (x,y) = position
      let (mx,my) = move

      if (position, move) in newPath:
        count += 1
        break
      newPath.incl((position, move))

      if y + my >= newMap.len or y + my < 0 or x + mx >= newMap[0].len or x + mx < 0:
        break
      elif newMap[y + my][x + mx] == '#':
        if mx > 0:
          move = (0,1)
        elif mx < 0:
          move = (0,-1)
        elif my > 0:
          move = (-1,0)
        elif my < 0:
          move = (1, 0)
      else:
        position = (x + mx,y + my)
  count

echo &"part 1 (sample): {sample.parse.countPath}"
echo &"part 2 (sample): {sample.parse.countLoops}"

let data = readFile("input.txt")
echo &"part 1: {data.parse.countPath}"
echo &"part 2: {data.parse.countLoops}"
