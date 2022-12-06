input = File.read(File.join(__dir__, 'input.txt')).chars

result = input.find_index.with_index do |char, index|
  input[index..(index+13)].length == input[index..(index+13)].uniq.length
end + 14

pp result

