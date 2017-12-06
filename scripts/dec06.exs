input = "11	11	13	7	0	15	5	5	4	4	1	1	7	1	15	11"

IO.puts(:io_lib.format "Solution for problem 1: ~B", [AC.Dec06.cycles_to_loop(input)])
IO.puts(:io_lib.format "Solution for problem 2: ~B", [AC.Dec06.cycles_in_loop(input)])
