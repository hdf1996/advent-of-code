rucksacks = File.read(File.join(__dir__, 'input.txt')).split("\n").map { |k| k.split('') }

PRIORITIES = Hash[(('a'..'z').to_a + ('A'..'Z').to_a).map.with_index { |letter, index| [letter, index + 1] }]

result = rucksacks.each_slice(3).to_a.sum do |group|
  used_twice = {}

  group.each do |rucksack|
    rucksack.uniq.each do |letter|
      used_twice[letter] ||= 0
      used_twice[letter] += 1
    end
  end

  PRIORITIES[used_twice.key(3)]
end

pp result