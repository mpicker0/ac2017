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

  def find_severity_r(_, step, firewall_length, severity, _)
  when step > firewall_length do
    severity
  end

  # count_zero specifies whether we should count a hit in layer zero, which we
  # need to for part 2.  This skews the severity score in part 2, but it doesn't
  # matter since we're only interested when there are no collisions.
  def find_severity_r(firewall, step, firewall_length, severity, count_zero) do
    # In the current firewall layer (i.e. step), is the scanner present?
    # If so, add to the severity
    new_severity = cond do
      !Map.has_key?(firewall, step) ->
        severity
      Map.get(firewall, step).scanner_location == 0 ->
        severity + (step * Map.get(firewall, step).range) + (if (step == 0 and count_zero), do: 1, else: 0)
      true ->
        severity
    end

    find_severity_r(move_scanners(firewall), step + 1, firewall_length, new_severity, count_zero)
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
    find_severity_r(firewall, 0, firewall_length, 0, :false)
  end

  # Part 2

  # Instead of trying to represent the state of the firewall, we instead just
  # register all the scanners in a map
  def get_firewall_2(filename) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Stream.map(fn(line) -> String.split(line, ": ") end)
    |> Enum.reduce(%{}, fn([d,r|_], acc) ->
         Map.put(acc, String.to_integer(d), String.to_integer(r))
       end)
  end

  # Return the position of the scanner at 'layer' at time 'step'.  Note that
  # we don't attempt to show the "reversing" behavior; a scanner with four
  # positions might show up with a position of 5 just before it repeats its
  # cycle.  This is fine, since all we really care about is whether it's zero
  def position_at(firewall, layer, step) do
    scanner_steps = ((Map.get(firewall, layer) - 2) * 2) + 2
    rem(step , scanner_steps)
  end

  def walk_firewall_r(firewall, delay, firewall_length) do
    # Will the packet hit any scanner?
    # If I am delaying 'delay' steps, I care about scanner at 'pos' at a time 'delay' + 'pos'
    positions = Enum.map(firewall, fn({pos, _}) ->
      #IO.puts("evaluating layer #{pos} with a delay of #{delay}; delay + pos is #{delay+pos}")
      position_at(firewall, pos, delay + pos)
    end)

    if Enum.any?(positions, fn(p) -> p == 0 end) do
      walk_firewall_r(firewall, delay + 1, firewall_length)
    else
      delay
    end
  end

  def find_shortest_delay(filename) do
    firewall = get_firewall_2(filename)
    {firewall_length, _} = Enum.max_by(firewall, fn({k,_}) -> k end)
    walk_firewall_r(firewall, 0, firewall_length)
  end

end
