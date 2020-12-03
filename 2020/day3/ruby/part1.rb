input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n").map { |i| i.split('') }

pp "Width is #{input.first.length}"
pp "Height is #{input.length}"

height = input.length - 1
width = input.first.length - 1

count = 0
x = 0
y = 0

loop do
	x += 3 
	y += 1
	break if y > height

	if x >= width
		x = x - width - 1
	end

	count += 1 if input[y][x] == '#'
end
pp count
