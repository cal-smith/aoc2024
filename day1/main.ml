let sample = {|
3   4
4   3
2   5
1   3
3   9
3   3
|}

let parse (input: string) = 
  String.trim input
  |> String.split_on_char '\n' 
  |> List.map (fun line -> 
    let parts = String.split_on_char ' ' line in
    List.filter (fun part -> not (String.equal (String.trim part) "")) parts
    |> List.map (fun part -> part |> String.trim |> int_of_string)
  )
  |> List.map (fun parts -> (List.nth parts 0, List.nth parts 1))
  |> List.split

let distance (lists: int list * int list) = 
  let (list1, list2) = lists in
  List.sort (-) list1
  |> List.combine (List.sort (-) list2)
  |> List.fold_left (fun acc (a, b) -> acc + abs (a - b)) 0


let count (query_list: int list) (el: int) = 
  query_list 
  |> List.find_all (fun x -> x == el) 
  |> List.length

let compare (lists: int list * int list) =
  let (list1, list2) = lists in
  List.fold_left (fun acc x -> acc + (x * (count list2 x))) 0 list1

let read_to_string filename =
  let ch = open_in_bin filename in
  let s = really_input_string ch (in_channel_length ch) in
  close_in ch;
  s

let () =
  parse sample |> distance |> Printf.printf "part 1 (sample): %i\n";
  parse sample |> compare |> Printf.printf "part 2 (sample): %i\n";
  read_to_string "input.txt" |> parse |> distance |> Printf.printf "part 1: %i\n";
  read_to_string "input.txt" |> parse |> compare |> Printf.printf "part 1: %i\n";
