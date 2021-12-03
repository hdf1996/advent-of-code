input = File.read(File.join(__dir__, 'input.txt')).split("\n")


result = []


def calculate_predominant(input)
  width = input.first.length

  temp = Array.new(width, 0)

  width.times do |position|
    input.each do |row|
      temp[position] += 1 if row[position] == '1'
    end
  end

  temp.map { |ones| (ones >= input.length - ones) }
end

def calculate_rating(list, majority = true)
  width = list.first.length
  result = list.dup
  width.times do |position|
    predominants = calculate_predominant(result)
    value = predominants[position]
    lookup = majority ? (value ? '1' : '0') : (value ? '0' : '1')
    result = result.select do |row, index|
      row[position] == lookup
    end
    break if result.length == 1
  end
  result.first
end

oxygen = calculate_rating(input.dup).to_i(2)

co_2 = calculate_rating(input.dup, false).to_i(2)
puts oxygen * co_2