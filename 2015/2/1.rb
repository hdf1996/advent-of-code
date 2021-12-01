input = File.read(File.join(__dir__, 'input.txt')).split("\n")

result = input.reduce(0) do |acc, p|
  l, w, h = p.split('x').map(&:to_i)

  sides = [
    l * w,
    w * h,
    h * l
  ]

  acc + 2 * sides.sum + sides.min
end

puts result