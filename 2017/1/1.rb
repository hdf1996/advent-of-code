input = File.read(File.join(__dir__, 'input.txt')).split('').map(&:to_i)

result = input.each_with_index.reduce([[], nil]) do |acc, (char, index)|
  acc[0].push(char) if input[index +1 == input.length ? 0 : index + 1] == char
  [acc[0], char]
end

puts result[0].sum