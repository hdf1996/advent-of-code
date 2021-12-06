input = File.read(File.join(__dir__, 'input.txt')).split(',').map(&:to_i).group_by(&:itself).map{ |k, v| [k, v.length]}.to_h

def simulate(ages, rounds = 1)
  return ages if rounds == 0
  new_ages = ages.keys.reduce(Hash.new(0)) do |acc, current|
    if current == 0
      acc[6] += ages[current]
      acc[8] += ages[current]
    else
      acc[current - 1] += ages[current]
    end
    acc
  end
  simulate(new_ages, rounds - 1)
end
list = simulate(input, 256)

puts list
pp list.values.sum