
input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n").map(&:to_i)

permutations =  input.permutation(3).to_a

combination = permutations.find do |permutation|
	permutation.sum == 2020
end

puts combination.inject(:*)
