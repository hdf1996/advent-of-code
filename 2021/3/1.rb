input = File.read(File.join(__dir__, 'input.txt')).split("\n")

width = input.first.length

result = []

temp = Array.new(width, 0)

width.times do |position|
  input.each do |row|
    temp[position] += 1 if row[position] == '1'
  end
end

temp = temp.map { |ones| (ones > input.length - ones) }

gamma_rate =  temp.map { |i| i ? 1 : 0 }.join('').to_i(2)
epsilon_rate = temp.map { |i| i ? 0 : 1 }.join('').to_i(2)

puts gamma_rate * epsilon_rate

