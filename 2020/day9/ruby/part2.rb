input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n").map(&:to_i)

preamble = 25

first_bad_index = input.find_index.with_index do |number, index|
  next false if index < preamble

  # .select { |a| a > number }
  !input[(index - preamble)..index].select { |a| a < number }.combination(2).find do |combo|
    combo.sum == number
  end
end

first_bad = input[first_bad_index]

def find_sequence(index, next_ones, max_number, list)
  return [false, -1, -1] if list[index..next_ones].sum > max_number
  return [index, list[index..next_ones].min, list[index..next_ones].max] if list[index..next_ones].sum == max_number

  find_sequence(index, next_ones + 1, max_number, list)
end

found_index = (0..first_bad_index).map { |k| input[k] }.select { |a| a < first_bad }.find_index.with_index do |number, index|
  result = find_sequence(index, index, first_bad, input)

  result[0]
end

puts find_sequence(found_index, found_index, first_bad, input).last(2).sum