@input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n").map { |i| i.split('') }

pp "Width is #{@input.first.length}"
pp "Height is #{@input.length}"

@height = @input.length - 1
@width = @input.first.length - 1


def check_slope(speed_x, speed_y)
	count = 0
	x = 0
	y = 0
	loop do
		x += speed_x
		y += speed_y
		break if y > @height

		if x >= @width
			x = x - @width - 1
		end

		count += 1 if @input[y][x] == '#'
	end
	count
end

multiplied = [
	[1, 1],
	[3, 1],
	[5, 1],
	[7, 1],
	[1, 2]
].map do |slope_speed|
	check_slope(slope_speed[0], slope_speed[1])
end.inject(:*)

puts multiplied
