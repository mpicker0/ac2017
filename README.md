# AC

[Advent of Code 2017](http://adventofcode.com/2017) solutions

## Running
All scripts should be run with this directory as the current directory, so that
input files can be resolved correctly.

* December 1:  `mix run scripts/dec01.exs` (or `mix run scripts/dec01.exs 12345`
  to pass in a specific CAPCHA value)
* December 2:  `mix run scripts/dec02.exs`.  Passing in a specific "spreadsheet"
  is not supported since there are newlines involved.
* December 3:  `mix run scripts/dec03.exs`.  Note that if uncommented, the tests
  will take an _extremely_ long time to run; there is a variable in the code
  that will help somewhat, but this is not currently efficient at all.
* December 4:  `mix run scripts/dec04.exs`
* December 5:  `mix run scripts/dec05.exs`.  Problem two takes several minutes
  to calculate.
* December 6:  `mix run scripts/dec06.exs`
* December 7:  `mix run scripts/dec07.exs`.  This could benefit from some
  cleanup; I'm using a Struct to represent the nodes, but a Map to hold the
  nodes together in a tree, and the syntax is very cumbersome, having to
  transport the tree around with each function call.
* December 8:  `mix run scripts/dec08.exs`.  Since the changes to solve part 2
  were so minor, I just added them into the part 1 code.
* December 9:  `mix run scripts/dec09.exs`.  As above, the changes for part 2
  were minimal, so some of the part 1 code was modified.
* December 10:  `mix run scripts/dec10.exs`
* December 11:  `mix run scripts/dec11.exs`
* December 12:  `mix run scripts/dec12.exs`
* December 13:  `mix run scripts/dec13.exs`.  Part two takes a few seconds to
  run.
* December 14:  `mix run scripts/dec14.exs`.  This isn't too efficient as it
  uses a map and creates lots of intermediate maps along the way.  Still, it
  runs quickly enough.
* December 15:  `mix run scripts/dec15.exs`
* December 16:  `mix run scripts/dec16.exs`.  I initially tried brute force for
  Part 2, but it was way too slow.  Fortunately, there is a loop early on in the
  output sequence (after 56 items, and it starts right away) and adjusting it to
  detect the loop and omit most of the runs made it much faster.
* December 17:  `mix run scripts/dec17.exs`
* December 18:  `mix run scripts/dec18.exs`
* December 19:  `mix run scripts/dec19.exs`.  Since keeping count was such an
  easy modification, I changed my `walk_path` function to return a keyword list
  with both the path and the count.
* December 20:  `mix run scripts/dec20.exs`.   I don't attempt to find out when
  the stopping condition is met; I just ran for a million iterations, then again
  for 1,000 iterations and got the same answer.  Since it's fast at 1,000
  iterations, that's good enough.
* December 21:  `mix run scripts/dec21.exs`.  Part 2 takes a few seconds to run.
  Not sure if there is an optimization.
* December 22:  `mix run scripts/dec22.exs`.  There are some unused debugging
  statements in the code.  Part 2 takes a few seconds to run.
* December 23:  `mix run scripts/dec23.exs`.  I worked to translate the assembly
  code into C; `dec23.c` is that experiment.  I did cheat a bit on this one;
  a good hint is at this link:
  <https://github.com/dp1/AoC17/blob/master/day23.5.txt>
* December 24:  `mix run scripts/dec24.exs`
* December 25:  `mix run scripts/dec25.exs`.  No part 2 on this puzzle.  I
  guess I could have written code to actually parse the puzzle input and build
  the instructions based on that, but there were only six states after all.  It
  takes about 10 seconds to run.

## Poking around
To start an interactive `iex` session and try out the code live, run:

    iex -S mix

Then, you can execute methods directly:

    AC.Dec10.find_hash("AoC 2017")

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `ac` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:ac, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/ac](https://hexdocs.pm/ac).
