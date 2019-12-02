modules = File.read(File.join(__dir__, 'input.txt')).split("\n")

result = modules.map do |mass|
  (mass.to_f / 3).floor - 2
end.reduce(0, :+)

puts result
