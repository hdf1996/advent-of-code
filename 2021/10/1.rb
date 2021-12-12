input = File.read(File.join(__dir__, 'input.txt')).split("\n")

TAGS = {
  '(' => ')',
  '[' => ']',
  '{' => '}',
  '<' => '>'
}
POINTS = {
  ')' => 3,
  ']' => 57,
  '}' => 1197,
  '>' => 25137
}

corrupted_ones = input.map do |row|
  chars = row.chars
  next false if TAGS.values.include? chars[0]
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
end.compact

result = corrupted_ones.map {|k| POINTS[k.keys.first] }.sum

pp result