input = File.read(File.join(__dir__, 'input.txt')).split("\n")

result = input.sum do |line|
  (line.chars.find { |char| ('0'..'9').any? char } +
  line.chars.reverse_each.find { |char| ('0'..'9').any? char }).to_i
end

puts result