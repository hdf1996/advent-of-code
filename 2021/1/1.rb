input = File.read(File.join(__dir__, 'input.txt')).split("\n")

result = 0
input.each_with_index do |_, index|
  next if index == 0
  slice = [input[index - 1], input[index]]
  result += 1 if slice[1].to_i > slice[0].to_i
end

puts result