map = File.read(File.join(__dir__, 'input.txt')).split("\n").map { |e| e.split('') }
@asteroids = map.map.with_index do |asteroids_row, asteroid_y|
  asteroids_row.map.with_index do |asteroid, asteroid_x|
    next if asteroid == '.'
    [asteroid_x, asteroid_y]
  end.compact
end.flatten(1)

def angle_for(width, height)
  angle = (
    Math.atan2(width.to_f, height.to_f)
  ) / Math::PI * 180
end

def count_for(x, y)
  grades = {}
  @asteroids.each do |asteroid|
    next if asteroid == [x, y]
    angle = angle_for(asteroid[0] - x, asteroid[1] - y)
    grades[angle.to_s] ||= []
    grades[angle.to_s].push asteroid
  end
  # pp grades
  grades.values.count { |e| e.count >= 1 }
  # angle_for(x, y)
end

# .7..7
# .....
# 67775
# ....7
# ...87

best_count = @asteroids.map do |asteroid|
  count_for(asteroid[0], asteroid[1])
end.max
puts best_count
