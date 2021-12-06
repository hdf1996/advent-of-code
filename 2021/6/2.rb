input = File.read(File.join(__dir__, 'input.txt')).split("\n")
lines = input.map { |line| line.split(' -> ').map { |vertex| vertex.split(',').map(&:to_i) } }
biggest_coord = 1 + lines.flatten.max.to_i

depths = Array.new(biggest_coord) { Array.new(biggest_coord, 0) }

lines.each do |line|
  a, b = line

  x1, x2 = [a[0], b[0]].sort
  y1, y2 = [a[1], b[1]].sort

  if a[0] - b[0] == a[0] - y1
    puts 'square'
    steps = x2 - x1
    
    steps.times do |i|
      depths[y1 + i][x1 + i] += 1
    end
  else
    puts 'orto'

    (x1..x2).each do |x|
      (y1..y2).each do |y|
        depths[y][x] += 1
      end
    end
  end
end

puts depths.flatten.count { |k| k > 1 }
puts depths.map { |k| k.join('').gsub('0', '.') }.join("\n")