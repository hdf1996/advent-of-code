original_intcodes = File.read(File.join(__dir__, 'input.txt')).split(",").map(&:to_i)



def calculate_gravity_assist(noun, verb, intcodes)
  intcodes[1] = noun
  intcodes[2] = verb
  (0..intcodes.length).each_slice(4) do |range|
    section = intcodes[range.first..range.last]
    case section.first
    when 99
      break intcodes
    when 1
      intcodes[section.last] = intcodes[section[1]] + intcodes[section[2]]
    when 2
      intcodes[section.last] = intcodes[section[1]] * intcodes[section[2]]
    else
      break "error"
    end
  end
  intcodes[0]
end

noun, verb = (0..99).map do |noun|
  found = (0..99).find do |verb|
    calculate_gravity_assist(noun, verb, original_intcodes.dup) == 19690720
  end
  break [noun, found] if found
  nil
end.compact

puts 100 * noun + verb
