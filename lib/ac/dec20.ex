defmodule AC.Dec20 do

  defmodule Particle do
    defstruct xpos: nil, ypos: nil, zpos: nil,
              xvel: nil, yvel: nil, zvel: nil,
              xacc: nil, yacc: nil, zacc: nil,
              id: 0
  end

  # parse a triple like 0,1,2 into a keyword list like x: 0, y: 1, z: 2
  def parse_triple(string) do
    [x, y, z] =
      String.split(string, ",")
      |> Enum.map(fn(s) ->
           String.trim(s)
           |> String.to_integer
         end)
    [x: x, y: y, z: z]
  end

  def parse_particle(string, num \\ 0) do
    %{"pos" => pos_s, "vel" => vel_s, "acc" => acc_s} =
      Regex.named_captures(~r/p=<(?<pos>[^>]*)>, v=<(?<vel>[^>]*)>, a=<(?<acc>[^>]*)>/, string)
    [pos, vel, acc] =
      Enum.map([pos_s, vel_s, acc_s], fn(t) -> parse_triple(t) end)
    %Particle{xpos: pos[:x], ypos: pos[:y], zpos: pos[:z],
              xvel: vel[:x], yvel: vel[:y], zvel: vel[:z],
              xacc: acc[:x], yacc: acc[:y], zacc: acc[:z],
              id: num}
  end

  def distance(p1, p2) do
    abs(p1.xpos - p2.xpos) + abs(p1.ypos - p2.ypos) + abs(p1.zpos - p2.zpos)
  end

  def move_particle(p) do
    new_xvel = p.xvel + p.xacc
    new_yvel = p.yvel + p.yacc
    new_zvel = p.zvel + p.zacc
    new_xpos = p.xpos + new_xvel
    new_ypos = p.ypos + new_yvel
    new_zpos = p.zpos + new_zvel
    %Particle{p | xvel: new_xvel, yvel: new_yvel, zvel: new_zvel,
                  xpos: new_xpos, ypos: new_ypos, zpos: new_zpos}
  end

  def move_particles(particles, 0), do: particles
  def move_particles(particles, times) do
    moved = Enum.map(particles, fn(p) -> move_particle(p) end)
    move_particles(moved, times - 1)
  end

  # Part 1
  # 1_000 iterations gives the same answer as a million
  @iterations 1_000

  def find_closest(filename, iterations \\ @iterations) do
    origin = %Particle{xpos: 0, ypos: 0, zpos: 0}
    particles = File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.with_index
    |> Stream.map(fn({line, i}) -> parse_particle(line, i) end)
    |> Enum.to_list

    moved_particles = move_particles(particles, iterations)
    closest = Enum.min_by(moved_particles, fn(p) -> distance(p, origin) end)
    closest.id
  end

  # Part 2
  defmodule Position do
    defstruct x: nil, y: nil, z: nil
  end

  def get_position(p) do
    %Position{x: p.xpos, y: p.ypos, z: p.zpos}
  end

  def move_particles_2(particles, 0), do: particles
  def move_particles_2(particles, times) do
    moved = Enum.map(particles, fn(p) -> move_particle(p) end)

    # create a frequecy map based on position (which must be extracted)
    collisions =
      Enum.map(moved, fn(p) -> get_position(p) end)
      |> AC.list_to_freq_map
      |> Enum.filter(fn({_, count}) -> count > 1 end)
      |> Enum.map(fn({k, _}) -> k end)

    filtered = Enum.reject(moved, fn(p) -> get_position(p) in collisions end)

    move_particles_2(filtered, times - 1)
  end

  # 1_000 iterations gives the same answer as a million
  @iterations_2 1_000
  def count_particles_after_collisions(filename, iterations \\ @iterations_2) do
    File.stream!(filename)
    |> Stream.map(&String.trim/1)
    |> Enum.with_index
    |> Stream.map(fn({line, i}) -> parse_particle(line, i) end)
    |> move_particles_2(iterations)
    |> length
  end

end
