input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n").map(&:to_i)

preamble = 25

first_bad_index = input.find_index.with_index do |number, index|
  next false if index < preamble

  !input[(index - preamble)..index].select { |a| a < number }.combination(2).find do |combo|
    combo.sum == number
  end
end

first_bad = input[first_bad_index]

puts first_bad