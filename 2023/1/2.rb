input = File.read(File.join(__dir__, 'input.txt')).split("\n")

replacements = {
  one: '1',
  two: '2',
  three: '3',
  four: '4',
  five: '5',
  six: '6',
  seven: '7',
  eight: '8',
  nine: '9',
  '1': '1',
  '2': '2',
  '3': '3',
  '4': '4',
  '5': '5',
  '6': '6',
  '7': '7',
  '8': '8',
  '9': '9'
}

matchs = (replacements.keys + (0..9).to_a).map(&:to_s)

result = input.sum do |line|
  numbers = line.chars.map.with_index do |char, index|
    matchs.find { |match| line[index..(line.length)].start_with? match}
  end.compact

  (replacements[numbers.first.to_sym] + replacements[numbers.last.to_sym]).to_i
end

pp result