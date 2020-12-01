require 'benchmark'

wires = File.read(File.join(__dir__, 'input.txt'))
            .split("\n")
            .map { |k| k.split(',') }
            .map { |k| k.map { |i| [i[0], i[1..-1].to_i] } }

def prefill_line(mat, index, amount, current_pos)
  if index.negative?
    mat.unshift([])
    index += 1
    current_pos[:y] += 1
    prefill_line(mat, index, amount, current_pos) if index.negative?
  end

  current_line = mat[index] || (0..(current_pos[:x] + amount + 2)).to_a.fill('=')
  (0..[(current_pos[:x] + amount), current_line.length].max).map.with_index do |k, i|
    current_line[i] || '='
  end
end

def write(current_line, pos, value)
  return if(current_line[pos] == 'O')
  current_line[pos] = '.'
end

def right(matrix, current_pos, amount)
  [matrix.dup.tap { |mat|
    current_line = prefill_line(mat, current_pos[:y], amount, current_pos)
    amount.times do |i|
      write(current_line, current_pos[:x] + i + 1, '.')
    end
    mat[current_pos[:y]] = current_line
  }, {x: current_pos[:x] + amount, y: current_pos[:y]}]
end

def down(matrix, current_pos, amount)
  [matrix.tap { |mat|
    amount.times do |i|
      current_line = prefill_line(mat, current_pos[:y] + i + 1, amount, current_pos)
      write(current_line, current_pos[:x], '.')
      mat[current_pos[:y] + i + 1] = current_line
    end
  }, {x: current_pos[:x], y: current_pos[:y] + amount}]
end

def up(matrix, current_pos, amount)
  [matrix.dup.tap { |mat|
    amount.times do |i|
      current_line = prefill_line(mat, current_pos[:y] - i - 1, amount, current_pos)
      write(current_line, current_pos[:x], '.')
      mat[current_pos[:y] - i - 1] = current_line
    end
  }, { x: current_pos[:x], y: current_pos[:y] - amount }]
end

def left(matrix, current_pos, amount)
  [matrix.tap { |mat|
    current_x = current_pos[:x]
    current_line = prefill_line(mat, current_pos[:y], amount, current_pos)
    amount.times do |i|
      index = current_pos[:x] - i - 1
      if index.negative?
        mat.map.with_index do |k, p|
          if p == current_pos[:y]
            current_x += 1
            current_line.unshift('.')
          else
            k.unshift('=')
          end
        end
        current_pos[:x] += 1
      else
        write(current_line, index, '.')
      end
    end

    mat[current_pos[:y]] = current_line
  }, {x: current_pos[:x] - amount, y: current_pos[:y]}]
end

def put_wires(wire, matrix)
  current_pos = {x: 0, y: 0}
  wire.each do |(direction, amount)|
    case direction
    when 'R'
      matrix, current_pos = right(matrix, current_pos, amount)
    when 'U'
      matrix, current_pos = up(matrix, current_pos, amount)
    when 'L'
      matrix, current_pos = left(matrix, current_pos, amount)
    when 'D'
      matrix, current_pos = down(matrix, current_pos, amount)
    else
    end
  end
  matrix
end

def find_origin(matrix)
  o_position = { x: 0, y: 0 }
  matrix.each_with_index do |line, index|
    line_x = line.index('O')
    return {
      x: line_x,
      y: index
    } if line_x
  end

end

# Credits to https://stackoverflow.com/a/5609035
def padleft(a, n, x)
  Array.new([0, n-a.length].max, x)+a
end

def padright(a, n, x)
  a.dup.fill(x, a.length...n)
end

def normalize_matrix(matrix1, matrix2, first_pass = true)

  matrix1_o = find_origin(matrix1)
  matrix2_o = find_origin(matrix2)
  max_x = [matrix1.map(&:length).max, matrix2.map(&:length).max].max
  max_y = [matrix1.length, matrix2.length].max
  max_o_x = [matrix1_o[:x], matrix2_o[:x]].max
  max_o_y = [matrix1_o[:y], matrix2_o[:y]].max
  fill_array = (0...max_x).to_a.fill('=')

  results = [matrix1, matrix2].map do |matrix|
    current_origin = find_origin(matrix)
    padleft(padright(matrix.map do |e|
      padleft(padright(e, max_x, '='), max_x + max_o_x - current_origin[:x], '=')
    end, max_y, fill_array), max_y + max_o_y - current_origin[:y], fill_array)
  end

  return normalize_matrix(*results, false) if first_pass
  results
end

def compare(matrix1, matrix2)
  origin = find_origin(matrix1)
  result = matrix1.map.with_index do |line1, x|
    line1.map.with_index do |char1, y|
      (char1 == '.' && matrix2[x][y] == '.') ? 'X' : '='
    end
  end
  result[origin[:y]][origin[:x]] = 'O'
  result
end

def get_nearest_to_origin(matrix)
  origin = find_origin(matrix)
  matrix.map.with_index do |e, index|
    j = e.index('X')
    [(origin[:y] - index).abs, (j - origin[:x]).abs] if j
  end.compact.map(&:sum).min
end

time = Benchmark.measure {
  compared = compare(*normalize_matrix(*wires.map do |wire|
    put_wires(wire, [['O']])
  end))

  puts get_nearest_to_origin(compared).inspect
}
puts time.real
