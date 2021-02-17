input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n\n")

required_keys = %w(byr iyr eyr hgt hcl ecl pid)
validations = {
	byr: ->(i) { i.length == 4 && i.to_i.between?(1920, 2002) },
	iyr: ->(i) { i.length == 4 && i.to_i.between?(2010, 2020) },
	eyr: ->(i) { i.length == 4 && i.to_i.between?(2020, 2030) },
	hgt: ->(i) { 
		numeric_value = i.to_i
		if !(i =~ /(\d+)(cm|in)/).nil?
			if i.end_with? 'cm'
				numeric_value >= 150 && numeric_value <= 193
			elsif i.end_with? 'in'
				numeric_value >= 59 && numeric_value <= 76
			else
				false
			end
		else
			false
		end
	},
	hcl: ->(i) { i.match?(/\A#[0-9a-f]{6}\z/) },
	ecl: ->(i) { %w(amb blu brn gry grn hzl oth).include? i },
	pid: ->(i) { i.match?(/\A\d{9}\z/) },
	cid: ->(i) { true }
}
count = (input.map do |passport|

	(required_keys - passport.split("\n").map do |passport_line|
		passport_line.split(' ').map do |passport_property|
			type, value = passport_property.split(':')
			
			result = validations[type.to_sym]
			type if result[value]
		end
	end.reduce(:+)).empty?
end).count(&:itself)

pp count
