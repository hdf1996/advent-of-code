input = File.read(File.join(__dir__, 'input.txt')).split("\n")

TAGS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}
POINTS = {
  ')' => 1,
  ']' => 2,
  '}' => 3,
  '>' => 4
}

incomplete_ones = input.map do |row|
  chars = row.chars
  next nil if TAGS.values.include? chars[0]
  opening_tags = []

  unexpected_chars = chars.inject(nil) do |acc, char|
    if TAGS.keys.include? char
      opening_tags.push(char)
    else
      if TAGS[opening_tags.last] == char
        opening_tags.pop
      else
        if acc.nil?
          acc = {
            char => 1
          }
        elsif acc[char]
          acc[char] += 1
        end
      end
    end
    acc
  end
  next nil unless unexpected_chars.nil?
  opening_tags 
end.compact

strings_to_fix = incomplete_ones.map { |k| k.reverse.map {|p| TAGS[p]} }
result = strings_to_fix.map do |string|
  string.inject(0) do |acc, current|
    acc * 5 + POINTS[current]
  end
end.sort
result = result[(result.length / 2.0).floor]


pp result