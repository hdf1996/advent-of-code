input = File.read(File.join(__dir__, 'input.txt')).split("\n").map {|k| k.split(' ').map(&:to_i)}

result = input.map do |row|
  selected = nil
  row.combination(2).reduce([]) do |acc, combo|
    break selected = combo if combo.max % combo.min == 0
  end
  raise 'Impossible!' if selected.nil?

  selected.max / selected.min
end

pp result.sum
