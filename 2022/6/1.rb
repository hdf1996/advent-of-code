input = File.read(File.join(__dir__, 'input.txt')).chars

result = input.find_index.with_index do |char, index|
  input[index..(index+3)].length == input[index..(index+3)].uniq.length
end + 4

pp result

