# AC

[Advent of Code 2017](http://adventofcode.com/2017) solutions

## Running
* December 1:  `mix run scripts/dec01.exs` (or `mix run scripts/dec01.exs 12345`
  to pass in a specific CAPCHA value)
* December 2:  `mix run scripts/dec02.exs`.  Passing in a specific "spreadsheet"
  is not supported since there are newlines involved.

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
