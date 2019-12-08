digits = File.read(File.join(__dir__, 'input.txt')).split("").map(&:to_i)
digits.pop

size = [25, 6]

layers = digits.each_slice(size.inject(:*)).to_a

layer_with_more_zeros = layers[layers.map { |e| e.count(&:zero?) }.each_with_index.min[1]]

puts(layer_with_more_zeros.count(1) * layer_with_more_zeros.count(2))
