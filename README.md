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
* December 6:  `mix run scripts/dec06.exs`.
* December 7:  `mix run scripts/dec07.exs`.  This could benefit from some
  cleanup; I'm using a Struct to represent the nodes, but a Map to hold the
  nodes together in a tree, and the syntax is very cumbersome, having to
  transport the tree around with each function call.
* December 8:  `mix run scripts/dec08.exs`.  Since the changes to solve part 2
  were so minor, I just added them into the part 1 code.

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
