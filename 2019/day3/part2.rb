require 'benchmark'

wires = File.read(File.join(__dir__, 'input.txt'))
            .split("\n")
            .map { |k| k.split(',') }
            .map { |k| k.map { |i| [i[0], i[1..-1].to_i] } }

def dots_for(matrix)
  points = []
  last_pos = [0, 0]
  matrix.each_with_index do |dot, index|
    direction, amount = dot
    case direction
    when 'R'
      amount.times { |i| points << [last_pos[0] + i + 1, last_pos[1], points.length] }
      last_pos[0] += amount
    when 'D'
      amount.times { |i| points << [last_pos[0], last_pos[1] - i - 1, points.length] }
      last_pos[1] -= amount
    when 'U'
      amount.times { |i| points << [last_pos[0], last_pos[1] + i + 1, points.length] }
      last_pos[1] += amount
    when 'L'
      amount.times { |i| points << [last_pos[0] - i - 1, last_pos[1], points.length] }
      last_pos[0] -= amount
    else
    end
  end
  points
end

time = Benchmark.measure {
  dots = wires.map { |e| dots_for(e) }
  dots_without_step = dots.map { |wire| wire.map { |e| [e[0], e[1]] } }
  intersections = dots_without_step[0] & dots_without_step[1]
  intersections_with_steps = intersections.map do |e|
    list = dots.map do |list|
      list[list.each_index.select { |j| e == [list[j][0], list[j][1]] }.min][2] + 1
    end
    list.sum
  end

  puts intersections_with_steps.min
}
puts time.real
