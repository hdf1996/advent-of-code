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
  raise "#{number} cannot be rendered"if number > 9
  render(@letters[number])
end

def identify_number_5_digits(segments, outputs)
  # %w(a c d e g), # 2
  # %w(a c d f g), # 3
  # %w(a b d f g), # 5
  '.'
end

def identify_number(segments, outputs)
  return 1 if segments.length == 2
  return 7 if segments.length == 3
  return 4 if segments.length == 4
  return 8 if segments.length == 7
  return identify_number_5_digits(segments, outputs) if segments.length == 5
  '-'
end

result = input.inject(0) do |acc, line|
  signals, outputs = line.split(' | ').map {|k| k.split(' ')}

  result = outputs.map do |segment|
    identify_number(segment, outputs)
  end
  acc += result.count { |k| [1, 4, 7, 8].include? k}
  puts "#{line} | #{result.compact.join(' ')}"
  acc
end

puts result
