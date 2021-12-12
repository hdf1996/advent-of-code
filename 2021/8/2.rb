require 'set'
input = File.read(File.join(__dir__, 'input.txt')).split("\n")

@letters = [
  %w(a b c e f g), # 0
  %w(c f), # 1
  %w(a c d e g), # 2
  %w(a c d f g), # 3
  %w(b c d f), # 4
  %w(a b d f g), # 5
  %w(a b d e f g), # 6
  %w(a c f), # 7
  %w(a b c d e f g), # 8
  %w(a b c d f g), # 9
]


def render(segments = [])
  a, b, c, d, e, f, g = ['a', 'b', 'c', 'd', 'e', 'f', 'g'].map { |letter| segments.include? letter }
  "
  #{a ? 'aaaa': '....'}
 #{b ? 'b': '.'}    #{c ? 'c': '.'}
 #{b ? 'b': '.'}    #{c ? 'c': '.'}
  #{d ? 'dddd': '....'} 
 #{e ? 'e': '.'}    #{f ? 'f': '.'} 
 #{e ? 'e': '.'}    #{f ? 'f': '.'} 
  #{g ? 'gggg': '....'}
 "
end

def render_number(number)
  raise "#{number} cannot be rendered" if number > 9
  render(@letters[number])
end

def decode(segments)
  dict = { }
  tmp = { 1 => [], 2 => [], 3 => [], 4 => [], 5 => [], 6 => [], 7 => [], 8 => [], 9 => [], 0 => []}
  fives = segments.select { |k| k.length == 5 }.map(&:chars).map(&:sort)
  segments.sort {|k| k.length}.each do |segment|
    # 1-7-4-8
    index = [1, 7, 4, 8].find { |k| @letters[k].length == segment.length }
    if index
      tmp[index] = segment.chars.sort
      dict[tmp[7].difference(tmp[1])[0]] ||= 'a' unless tmp[7].empty? || tmp[1].empty?
    end
  end

  # 2
  tmp[2] = fives.find do |segment|
    segment.intersection(tmp[4]).length == 2
  end.sort

  # 3
  tmp[3] = fives.find do |segment|
    segment.intersection(tmp[1]).length == 2
  end.sort

  # 5
  tmp[5] = fives.find {|k| k != tmp[3] && k != tmp[2]}.sort

  dict[(tmp[5].sort - tmp[4].sort - [dict.key('a')])[0]] = 'g'
  dict[(tmp[3].sort - tmp[1].sort - [dict.key('a'), dict.key('g')])[0]] = 'd'
  dict[(tmp[2].sort - tmp[3].sort)[0]] = 'e'
  dict[(tmp[3].sort - tmp[2].sort)[0]] = 'f'
  dict[(tmp[1].sort - [dict.key('f')])[0]] = 'c'
  dict[(tmp[5].sort - (tmp[3].sort))[0]] = 'b'
  dict
end

result = input.inject(0) do |acc, line|
  signals, outputs = line.split(' | ').map {|k| k.split(' ')}

  dict = decode(signals)
  num_output = (outputs.map do |signal|
    @letters.find_index { |k| k == signal.chars.map {|p| dict[p]}.compact.sort }
  end.join('').to_i)
  acc + num_output
end
puts result

