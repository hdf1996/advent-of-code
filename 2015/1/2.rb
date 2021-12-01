input = File.read(File.join(__dir__, 'input.txt')).split('')

result = input.each_with_index.inject(0) do |acc, (current, index)|
  break index if acc.negative?
  if current == '('
    acc + 1
  else
    acc - 1
  end
end

puts result