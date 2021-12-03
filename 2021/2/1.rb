input = File.read(File.join(__dir__, 'input.txt')).split("\n")

POSITIONS = {
  'forward' => [0, 1],
  'down' => [1, 0],
  'up' => [-1, 0]
}

result = input.reduce([0, 0]) do |acc, current|
  command, steps = current.split(' ')
  position_to_move = POSITIONS[command]
  acc = [acc[0] + position_to_move[0] * steps.to_i, acc[1] + position_to_move[1] * steps.to_i]

  acc
end
pp result.inject(:*)