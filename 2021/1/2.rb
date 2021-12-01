input = File.read(File.join(__dir__, 'input.txt')).split("\n")

result = 0
window_size = 3
input.each_with_index do |_, index|
  slice_a = input[index...(index + window_size)].map(&:to_i).sum
  slice_b = input[(index + 1)...(index + window_size + 1)].map(&:to_i).sum
  result += 1 if slice_b > slice_a
  break if input.length - index < window_size * 2 - 1
end

puts result