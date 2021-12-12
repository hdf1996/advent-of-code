input = File.read(File.join(__dir__, 'input.txt')).split("\n").map { |k| k.split('').map(&:to_i)}

def get_sorroundings(x, y, input)
  row = input[y]
  left = x == 0 ? nil : row[x - 1]
  up = y == 0 ? nil : input[y - 1][x]
  bottom = y >= input.length - 1 ? nil : input[y + 1][x]
  right = x >= row.length - 1 ? nil : row[x + 1]

  [left, up, bottom, right]
end

result = input.each_with_index.map do |row, y|
  row.each_with_index.map do |cell, x|
    next cell if get_sorroundings(x, y, input).compact.all? { |k| cell < k}
    nil
  end
end.flatten.compact.map { |k| k + 1 }.sum

pp result