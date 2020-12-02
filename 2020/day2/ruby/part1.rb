input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n")

valid_count = input.count do |line|
	rule, password = line.split(': ')
	rule_range, rule_letter = rule.split(' ')
	rule_min, rule_max = rule_range.split('-').map(&:to_i)

	letter_count = password.count(rule_letter)

	letter_count >= rule_min && letter_count <= rule_max
end

puts valid_count
