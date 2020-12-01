input = File.read(File.join(__dir__, 'input.txt')).to_i

@cache = {}

def pattern_for_pos(position, index)
  @cache[position] ||= [0, 1, 0, -1].map { |e| [e] * (position + 1)  }.flatten(1)

  pattern = @cache[position]
  # pattern.shift
  if index + 1 >= pattern.length
    pattern[(index + 1) % pattern.length]
  else
    pattern[index + 1]
  end
end

def fft(input)
  chars = input.to_s.chars.map(&:to_i)
  chars_dup = chars.dup
  chars_dup.map.with_index do |ch, i|
    chars.map.with_index do |char, index|
      next 0 if index + 1 <= i
      # pp [pattern, index, index % pattern.length]
      char * pattern_for_pos(i, index)
    end.sum.abs.to_s[-1]
  end.join
end

pp(
  (0..99).reduce(input) do |acc|
    fft(acc)
  end.split('').first(8).join
)
