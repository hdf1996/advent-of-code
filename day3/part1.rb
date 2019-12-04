require 'benchmark'

wires = File.read(File.join(__dir__, 'input.txt'))
            .split("\n")
            .map { |k| k.split(',') }
            .map { |k| k.map { |i| [i[0], i[1..-1].to_i] } }

def dots_for(matrix)
  points = []
  last_pos = [0, 0]
  matrix.each do |dot|
    direction, amount = dot
    case direction
    when 'R'
      amount.times { |i| points << [last_pos[0] + i + 1, last_pos[1]] }
      last_pos[0] += amount
    when 'D'
      amount.times { |i| points << [last_pos[0], last_pos[1] - i - 1] }
      last_pos[1] -= amount
    when 'U'
      amount.times { |i| points << [last_pos[0], last_pos[1] + i + 1] }
      last_pos[1] += amount
    when 'L'
      amount.times { |i| points << [last_pos[0] - i - 1, last_pos[1]] }
      last_pos[0] -= amount
    else
    end
  end
  points
end

time = Benchmark.measure {
  dots = wires.map { |e| dots_for(e) }
  intersections = dots[0] & dots[1]
  # You will need ruby 2.6.3 or higher to use intersection!
  puts intersections.map { |e| e[0].abs + e[1].abs }.min
}
puts time.real
