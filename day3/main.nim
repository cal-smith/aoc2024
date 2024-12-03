import std/strutils
import std/sequtils
import std/strformat
import std/re

let sample = """
xmul(2,4)%&mul[3,7]!@^do_not_mul(5,5)+mul(32,64]then(mul(11,8)mul(8,5))
"""

let sample2 = """
xmul(2,4)&mul[3,7]!^don't()_mul(5,5)+mul(32,64](mul(11,8)undo()?mul(8,5))
"""

type Instruction = object
  op: string
  args: seq[int]

proc parse(inputStr: string): seq[Instruction] =
  var instrs: seq[Instruction] = @[]
  for o in inputStr.findAll(re"(mul\(\d{1,3},\d{1,3}\)|do\(\)|don't\(\))"):
    let op = o.findAll(re"\w[a-z']+")[0]
    let args = o.findAll(re"\d{1,3}").map(parseInt)
    instrs.add(Instruction(op: op, args: args))
  return instrs

proc run(program: seq[Instruction]): int =
  var res = 0
  for instr in program:
    if instr.op == "mul":
      res += instr.args[0] * instr.args[1]

  return res

proc runWithDo(program: seq[Instruction]): int =
  var res = 0
  var canEval = true
  for instr in program:
    if instr.op == "mul" and canEval:
      res += instr.args[0] * instr.args[1]
    
    if instr.op == "do":
      canEval = true
    
    if instr.op == "don't":
      canEval = false

  return res



echo &"part 1 (sample): {sample.parse.run}"
echo &"part 2 (sample): {sample2.parse.runWithDo}"

let data = readFile("input.txt")
echo &"part 1: {data.parse.run}"
echo &"part 2: {data.parse.runWithDo}"
