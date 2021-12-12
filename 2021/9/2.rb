input = File.read(File.join(__dir__, 'input.txt')).split("\n").map { |k| k.split('').map(&:to_i)}

def get_sorroundings(x, y, input)
  row = input[y]
  left = x == 0 ? nil : [y, x - 1]
  up = y == 0 ? nil : [y - 1, x]
  bottom = y >= input.length - 1 ? nil : [y + 1, x]
  right = x >= row.length - 1 ? nil : [y, x + 1]

  [
    left, 
    up, 
    bottom, 
    right
  ]
end

lowest_points = input.each_with_index.map do |row, y|
  row.each_with_index.map do |cell, x|
    next [x, y] if get_sorroundings(x, y, input).compact.map { |k| input[k[0]][k[1]] }.all? { |k| cell < k}
    nil
  end
end.flatten(1).compact


result = lowest_points.map do |point|
  x, y = point
  visited_points = Hash.new { |hash, key| hash[key] = {} }
  visited_points[y][x] = true
  points_to_visit = get_sorroundings(x, y, input).compact
  while points_to_visit.any?
    points_to_visit = points_to_visit.inject([]) do |acc, k|
      cell = input[k[0]][k[1]]
      visited_points[k[0]][k[1]] = true
      next acc if cell == 9

      acc.push(*get_sorroundings(k[1], k[0], input).compact.select { |p| !visited_points[p[0]][p[1]] })
      acc
    end.compact
  end

  visited_points.keys.map { |y| visited_points[y].keys.map { |x| input[y][x]} }.flatten.select {|k| k != 9}.length
end.sort.last(3).inject(:*)

pp result