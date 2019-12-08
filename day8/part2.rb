digits = File.read(File.join(__dir__, 'input.txt')).split("").map(&:to_i)
digits.pop

size = [25, 6]

layers_by_size = digits.each_slice(size.inject(:*)).to_a.map { |e| e.each_slice(size[0]).to_a }
layers = digits.each_slice(size.inject(:*)).to_a

result = layers.reverse.inject([]) do |acc, matrix|
  matrix.map.with_index do |pixel, index|
    next acc[index] if pixel == 2
    pixel
  end
end

puts result.each_slice(size[0]).map { |e| e.map { |i| i.zero? ? '.' : 'X'}.join }.join("\n")
