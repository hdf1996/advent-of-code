require 'set'
require 'benchmark'
moons = File.read(File.join(__dir__, 'input.txt')).split("\n").map do |e|
  moon = [*e.split(',').map(&:to_i), 0, 0, 0]
  {
    0 => moon[0],
    1 => moon[1],
    2 => moon[2],
    3 => moon[3],
    4 => moon[4],
    5 => moon[5]
  }
end

def possible_combinations
  @possible_combinations ||= (0..3).to_a.combination(2).to_a
end

def apply_gravity(moons, nth, acc = 0, old_list = Set.new, axis)
  return [moons, old_list] if acc == nth
  vector_name = moons.map { |e| e.values.join(' ') }.join

  return nth if old_list.add?(vector_name).nil?

  possible_combinations.each do |combination|
    if moons[combination[0]][axis] < moons[combination[1]][axis]
      moons[combination[0]][axis + 3] += 1
      moons[combination[1]][axis + 3] -= 1
    elsif moons[combination[0]][axis] > moons[combination[1]][axis]
      moons[combination[0]][axis + 3] -= 1
      moons[combination[1]][axis + 3] += 1
    end
  end
  moons.each do |moon|
    moon[axis] += moon[axis + 3]
  end
  apply_gravity(moons, nth, acc + 1, old_list, axis)
end

def calculate_potential_energy(moons)
  moons.sum do |moon|
    moon.first(3).map(&:abs).sum * moon.last(3).map(&:abs).sum
  end
end

pp((0..2).map do |axis|
  ((0..10000000000).reduce([moons, Set.new]) do |acc, i|
    pp i if i % 1000 == 0
    applied = apply_gravity(acc[0], 1, 0, acc[1], axis)
    if applied.is_a? Array
      applied
    else
      pp i
      break i
    end
    applied
  end)
end.reduce(1, :lcm))
