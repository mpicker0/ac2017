defmodule AC.Dec20Test do
  use ExUnit.Case
  alias AC.Dec20.Particle, as: Particle

  # problem 1
  test "example 1" do
    assert AC.Dec20.find_closest("data/dec20_test_input.txt", 3) == 0
  end

  # support
  test "it parses a triple" do
    # the test input has spaces; the real input doesn't but handle them anyway
    input = " 0,1,2"
    expected_kwlist = [x: 0, y: 1, z: 2]

    assert AC.Dec20.parse_triple(input) == expected_kwlist
  end

  test "it parses a particle" do
    input = "p=< 0,1,2>, v=< 3,4,5>, a=<6,7,8>"
    expected_particle =
      %Particle{xpos: 0, ypos: 1, zpos: 2,
                xvel: 3, yvel: 4, zvel: 5,
                xacc: 6, yacc: 7, zacc: 8,
                id: 1}

    assert AC.Dec20.parse_particle(input, 1) == expected_particle
  end

  test "it computes the distance between two particles" do
    p1 = %Particle{xpos: 0, ypos: 0, zpos: 0}
    p2 = %Particle{xpos: 1, ypos: 2, zpos: 3}

    assert AC.Dec20.distance(p1, p2) == 6
  end

  test "it moves a particle" do
    original_particle =
      %Particle{xpos:  3, ypos:  3, zpos:  3,
                xvel:  2, yvel:  2, zvel:  2,
                xacc: -1, yacc: -1, zacc: -1}
    moved_particle =
      %Particle{xpos:  4, ypos:  4, zpos:  4,
                xvel:  1, yvel:  1, zvel:  1,
                xacc: -1, yacc: -1, zacc: -1}

    assert AC.Dec20.move_particle(original_particle) == moved_particle
  end

  # Part 2
  test "example 1 (2)" do
    assert AC.Dec20.count_particles_after_collisions("data/dec20_test_input_2.txt", 4) == 1
  end

end
