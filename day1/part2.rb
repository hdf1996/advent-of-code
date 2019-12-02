modules = File.read(File.join(__dir__, 'input.txt')).split("\n")

def calculate_fuel(mass, acc = 0)
  pre_fuel = (mass / 3).floor - 2
  return acc if pre_fuel.negative?
  acc + calculate_fuel(pre_fuel, pre_fuel)
end

result = modules.map do |mass|
  calculate_fuel(mass.to_f)
end.reduce(0, :+)

puts result
