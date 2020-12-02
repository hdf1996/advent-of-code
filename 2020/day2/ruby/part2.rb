input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n")

valid_count = input.count do |line|
	rule, password = line.split(': ')
	rule_positions, rule_letter = rule.split(' ')
	rule_first_position, rule_second_position = rule_positions.split('-').map(&:to_i)

	(password[rule_first_position - 1] == rule_letter) ^
		(password[rule_second_position - 1] == rule_letter) 
end

puts valid_count
