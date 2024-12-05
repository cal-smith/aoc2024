import std/strutils
import std/strformat
import std/intsets
import std/sequtils
import std/tables
import std/algorithm

let sample = """
47|53
97|13
97|61
97|47
75|29
61|13
75|53
29|13
97|29
53|29
61|53
97|53
61|29
47|13
75|47
97|75
47|61
75|61
47|29
75|13
53|13

75,47,61,53,29
97,61,53,29,13
75,29,13
75,97,47,61,53
61,13,29
97,13,75,29,47
"""

type Rules = Table[int, IntSet]
type Update = seq[int]
type Updates = seq[Update]

proc parse(inputStr: string): (Rules, Updates) =
  let parts = inputStr.strip.split("\n\n")
  let rules = parts[0]
  let pages = parts[1]

  var ruleTable: Rules
  for rule in rules.splitLines:
    let ruleParts = rule.split("|")
    let before = ruleParts[0].parseInt
    let after = ruleParts[1].parseInt
    var rules = ruleTable.getOrDefault(before, initIntSet())
    rules.incl(after)
    ruleTable[before] = rules

  var pageList: seq[seq[int]] = @[]
  for page in pages.splitLines:
    let p = page.split(",").map do (page: string) -> int:
      return page.parseInt
    pageList.add(p)

  (ruleTable, pageList)

proc isOrdered(update: Update, rules: Rules): bool =
  var seen: IntSet
  for page in update:
    let after = rules.getOrDefault(page, initIntSet())
    if not seen.disjoint(after):
      return false
    seen.incl(page)

  return true

proc getOrderedUpdates(t: (Rules, Updates)): Updates =
  let (rules, updates) = t
  updates.filter do (update: Update) -> bool:
    update.isOrdered(rules)

proc sumMiddle(updates: Updates): int = 
  updates.foldl(a + b[((b.len - 1) / 2).toInt], 0)

proc getUnorderedUpdates(t: (Rules, Updates)): Updates =
  let (rules, updates) = t
  updates.filter do (update: Update) -> bool:
    not update.isOrdered(rules)

proc sortUnorderedUpdates(t: (Rules, Updates)): Updates =
  let (rules, _) = t
  let updates = t.getUnorderedUpdates
  updates.map do (update: Update) -> Update:
    update.sorted do (a: int, b: int) -> int:
      let aRules = rules.getOrDefault(a, initIntSet())
      let bRules = rules.getOrDefault(a, initIntSet())
      if b in aRules or a in bRules:
        return -1
      if a == b:
        return 0
      return 1

echo &"part 1 (sample): {sample.parse.getOrderedUpdates.sumMiddle}"
echo &"part 2 (sample): {sample.parse.sortUnorderedUpdates.sumMiddle}"

let data = readFile("input.txt")
echo &"part 1: {data.parse.getOrderedUpdates.sumMiddle}"
echo &"part 2: {data.parse.sortUnorderedUpdates.sumMiddle}"
