input = File.read(File.join(__dir__, 'input.txt')).split("\n")
lines = input.map { |line| line.split(' -> ').map { |vertex| vertex.split(',').map(&:to_i) } }
biggest_coord = 2 + lines.flatten.max.to_i

depths = Hash.new(0)

lines.each do |line|
  a, b = line

  width_and_height = [b[0] - a[0], b[1] - a[1]]

  dx, dy = width_and_height.map { |x| x <=> 0 }

  (width_and_height.map(&:abs).max + 1).times do |i|
    depths[[a[0] + i * dx, a[1] + i * dy]] += 1
  end
end

puts depths.values.count { |k| k > 1 }