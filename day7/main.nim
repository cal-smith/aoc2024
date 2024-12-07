import std/strutils
import std/strformat
import std/sequtils
import std/algorithm

let sample = """
190: 10 19
3267: 81 40 27
83: 17 5
156: 15 6
7290: 6 8 6 15
161011: 16 10 13
192: 17 8 14
21037: 9 7 18 13
292: 11 6 16 20
"""

type Equation = object
  test: int
  values: seq[int]

proc parse(inputStr: string): seq[Equation] =
  var eqs: seq[Equation]
  for line in inputStr.strip.splitLines:
    let parts = line.split(":")
    let test = parts[0].parseInt
    let values = parts[1].strip.split(" ").map do (value: string) -> int:
      value.parseInt
    eqs.add(Equation(test: test, values: values))
  eqs

type Operator = proc(a: int, b: int): int

proc sumCalibrations(calibrations: seq[Equation], ops: seq[Operator]): int =
  var sum = 0
  for calibration in calibrations:
    proc f(a: int, b: (int, Operator)): int =
      let (v, o) = b
      return o(a, v)
  
    for p in product(@[ops].cycle(calibration.values.len)):
      let res = calibration.values[1 .. ^1].zip(p).foldl(f(a, b), calibration.values[0])
      if res == calibration.test:
        sum += calibration.test
        break

  return sum

let adds: Operator = proc(a: int, b: int): int = a + b
let mul: Operator = proc(a: int, b: int): int = a * b
let concat: Operator = proc (a: int, b: int): int = (&"{a}{b}").parseInt

echo &"part 1 (sample): {sample.parse.sumCalibrations(@[adds, mul])}"
echo &"part 2 (sample): {sample.parse.sumCalibrations(@[adds, mul, concat])}"

let data = readFile("input.txt")
echo &"part 1: {data.parse.sumCalibrations(@[adds, mul])}"
echo &"part 2: {data.parse.sumCalibrations(@[adds, mul, concat])}"