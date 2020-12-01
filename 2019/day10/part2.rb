map = File.read(File.join(__dir__, 'input.txt')).split("\n").map { |e| e.split('') }
@asteroids = map.map.with_index do |asteroids_row, asteroid_y|
  asteroids_row.map.with_index do |asteroid, asteroid_x|
    next if asteroid == '.'
    [asteroid_x, asteroid_y]
  end.compact
end.flatten(1)
size = [@asteroids.length, @asteroids[0].length]

def angle_for(width, height)
  angle = (
    Math.atan2(width.to_f, height.to_f)
  ) / Math::PI * 180
end

def rebase_angle(angle)
  -angle + 180
end

def angles_for(x, y, asteroids)
  angles = {}
  asteroids.each do |asteroid|
    next if asteroid == [x, y]
    angle = angle_for(asteroid[0] - x, asteroid[1] - y)
    angles[rebase_angle(angle)] ||= []
    angles[rebase_angle(angle)].push asteroid
  end
  angles
end

def count_for(x, y)
  angles = angles_for(x, y, @asteroids)

  angles.values.count { |e| e.count >= 1 }
end

def round_of_laser(x, y, asteroids, nth, acc = 0)
  angles = angles_for(x, y, asteroids)
  angles.keys.sort.each do |angle|
    next if angles[angle].empty?
    return angles[angle].last if acc + 1 == nth

    angles[angle].pop
    acc += 1
  end

  round_of_laser(x, y, angles.values.flatten(1), nth, acc)
end



ranking = @asteroids.map do |asteroid|
  [count_for(asteroid[0], asteroid[1]), asteroid]
end
best_count = ranking.max_by { |e| e[0] }
round_200 = round_of_laser(best_count[1][0], best_count[1][1], @asteroids, 200)
pp(round_200[0] * 100 + round_200[1])
