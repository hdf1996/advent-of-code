input = File.read(File.join(__dir__, 'input.txt')).split('')

result = input.inject(0) do |acc, current|
  if current == '('
    acc + 1
  else
    acc - 1
  end
end

puts result