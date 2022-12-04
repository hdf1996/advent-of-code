rucksacks = File.read(File.join(__dir__, 'input.txt')).split("\n").map { |k| k.split('') }

PRIORITIES = Hash[(('a'..'z').to_a + ('A'..'Z').to_a).map.with_index { |letter, index| [letter, index + 1] }]

result = rucksacks.sum do |rucksack|
  left, right = rucksack.each_slice((rucksack.size / 2).round).to_a
  used_twice = Hash[left.map { |letter| [letter.to_sym, true] }]

  PRIORITIES[right.find { |letter| used_twice[letter.to_sym] }]
end

pp result