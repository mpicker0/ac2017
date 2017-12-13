defmodule AC.Dec13 do

  defmodule Layer do
    defstruct depth: nil, range: nil, scanner_location: 0, direction: 1
  end

  def parse_line(line) do
    [d,r|_] = String.split(line, ": ")
    %Layer{depth: String.to_integer(d), range: String.to_integer(r)}
  end

  # Part 1
  def move_scanners(firewall) do
    Enum.into(firewall, %{}, fn({k,v}) ->
      {new_direction, new_scanner_location} = cond do
        v.range == 1 ->
          {v.direction, v.scanner_location}

        v.scanner_location + v.direction < 0 or
          v.scanner_location + v.direction == v.range ->
            {-v.direction, v.scanner_location - v.direction}

        true ->
          {v.direction, v.scanner_location + v.direction}
      end
      {k, %{v | scanner_location: new_scanner_location, direction: new_direction}}
    end)
  end

  def find_severity_r(_, step, firewall_length, severity)
  when step > firewall_length do
    severity
  end

  def find_severity_r(firewall, step, firewall_length, severity) do
    # In the current firewall layer (i.e. step), is the scanner present?
    # If so, add to the severity
    new_severity = cond do
      !Map.has_key?(firewall, step) ->
        severity
      Map.get(firewall, step).scanner_location == 0 ->
        severity + (step * Map.get(firewall, step).range)
      true ->
        severity
    end

    find_severity_r(move_scanners(firewall), step + 1, firewall_length, new_severity)
  end

  def get_firewall(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> parse_line(line) end)
    |> Enum.reduce(%{}, fn(layer, acc) -> Map.put(acc, layer.depth, layer) end)
  end

  def find_severity(filename) do
    firewall = get_firewall(filename)
    {firewall_length, _} = Enum.max_by(firewall, fn({k,_}) -> k end)
    find_severity_r(firewall, 0, firewall_length, 0)
  end

  # Part 2

  def find_shortest_delay(filename) do
    firewall = get_firewall(filename)
    IO.puts("TODO")
    IO.inspect(firewall)
    -1
  end

end
