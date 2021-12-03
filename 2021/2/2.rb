input = File.read(File.join(__dir__, 'input.txt')).split("\n")

result = input.reduce({
  aim: 0,
  depth: 0,
  x: 0
}) do |acc, current|
  command, steps = current.split(' ')
  steps = steps.to_i
  case command
  when 'forward'
    acc.merge(x: acc[:x] + steps, depth: acc[:depth] + acc[:aim] * steps)
  when 'down'
    acc.merge(aim: acc[:aim] + steps)
  when 'up'
    acc.merge(aim: acc[:aim] - steps)
  else
    acc
  end
end
pp result[:depth] * result[:x]