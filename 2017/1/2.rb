input = File.read(File.join(__dir__, 'input.txt')).split('').map(&:to_i)

result = input.each_with_index.reduce([[], nil]) do |acc, (char, index)|
  i = (index + input.length / 2) % input.length
  acc[0].push(char) if input[i] == char
  [acc[0], char]
end

puts result[0].sum