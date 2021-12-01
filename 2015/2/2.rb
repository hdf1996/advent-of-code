input = File.read(File.join(__dir__, 'input.txt')).split("\n")

result = input.reduce(0) do |acc, p|
  l, w, h = p.split('x').map(&:to_i)

  sides = [
    l * w,
    w * h,
    h * l
  ]

  acc + l * w * h + [l, w, h].min(2).sum * 2
end

puts result