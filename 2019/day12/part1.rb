moons = File.read(File.join(__dir__, 'input.txt')).split("\n").map { |e| [*e.split(',').map(&:to_i), 0, 0, 0] }

def possible_combinations
  @possible_combinations ||= (0..3).to_a.combination(2).to_a
end

def apply_gravity(moons, nth, acc = 0)
  moons = moons.map { |e| e.dup }
  return moons if acc == nth

  possible_combinations.each do |combination|
    (0..2).each do |position|
      if moons[combination.first][position] < moons[combination.last][position]
        moons[combination.first][position + 3] += 1
        moons[combination.last][position + 3] -= 1
      elsif moons[combination.first][position] > moons[combination.last][position]
        moons[combination.first][position + 3] -= 1
        moons[combination.last][position + 3] += 1
      end
    end
  end
  moons.each do |moon|
    (0..2).each do |position|
      moon[position] += moon[position + 3]
    end
  end
  apply_gravity(moons, nth, acc + 1)
end

def calculate_potential_energy(moons)
  moons.sum do |moon|
    moon.first(3).map(&:abs).sum * moon.last(3).map(&:abs).sum
  end
end

pp calculate_potential_energy(
  apply_gravity(moons.dup, 10)
)
