input = File.read(File.join(__dir__, 'input.txt'))

target = 2
dimension = Math.sqrt(target).ceil

grid = Array.new(dimension) { Array.new(dimension, '.') }
middle = dimension / 2
x = middle
y = middle

dirs = [:right, :up, :left, :down]
dir = dirs[0]

def move(pos, dir)
  case dir
  when :right
    [pos[0] + 1, pos[1]]
  else
    pos
  end
end

(target - 1).times do |i|
  grid[y][x] = i + 1

  new_address = move([x, y], dir)
  new_dir = dirs[(dirs.index(dir) + 1) % dirs.length]
  dir = new_dir if grid[new_address[0]][new_address[1]].nil?

  x, y = new_address
end

puts grid.map { |k|k.join('')}.join("\n")
