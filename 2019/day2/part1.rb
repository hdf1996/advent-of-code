intcodes = File.read(File.join(__dir__, 'input.txt')).split(",").map(&:to_i)

intcodes[1] = 12
intcodes[2] = 2

result = (0..intcodes.length).each_slice(4) do |range|
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

puts intcodes.inspect
