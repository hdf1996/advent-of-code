input = File.read(File.join(__dir__, 'input.txt')).split(',').map(&:to_i)
min = input.min
max = input.max

def serie_sum(n)
  (n * (n + 1)) / 2
end
def simulate_movement(input, position)
  input.reduce(0) do |acc, pos|
    acc + serie_sum((pos - position).abs)
  end
end

result = (min..max).inject(nil) do |acc, current|
  simulation = simulate_movement(input, current)
  acc = simulation if acc.nil? || simulation < acc
  acc
end

puts result
