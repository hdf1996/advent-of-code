input = File.read(File.join(__dir__, 'input.txt')).split("\n").map {|k| k.split(' ').map(&:to_i)}

result = input.map do |row|
  min = row.min
  max = row.max

  max - min
end

pp result.sum
