input = File.read(File.join(__dir__, 'input.txt')).split('')

POSITIONS = {
  '^' => [0, 1],
  'v' => [0, -1],
  '>' => [1, 0],
  '<' => [-1, 0]
}

result = input.reduce([{}, [0, 0]]) do |acc, current|
  position_to_move = POSITIONS[current]
  acc[1] = [acc[1][0] + position_to_move[0], acc[1][1] + position_to_move[1]]
  acc[0][acc[1][0]] ||= {}
  acc[0][acc[1][0]][acc[1][1]] = true

  acc
end
pp result[0].values.map(&:length).sum