input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n")

def binary_lookup(branch, min, extra)
  return min + (extra / 2.0).ceil if branch
  min
end

def calculate_id(col, row)
  (row * 8) + col
end

plane = (0..127).map { (0..7).to_a.map { 'O' } }

input.each do |boarding_pass|
  row_steps = boarding_pass.chars.first(7)
  col_steps = boarding_pass.chars.last(3)
  last_row_number = 0
  last_row_range = 127
  row_steps.each do |i|
    last_row_number = binary_lookup(i == 'B', last_row_number, last_row_range)
    last_row_range = last_row_range / 2
  end

  last_col_number = 0
  last_col_range = 7
  col_steps.each do |i|
    last_col_number = binary_lookup(i == 'R', last_col_number, last_col_range)
    last_col_range = last_col_range / 2
  end
  
  plane[last_row_number][last_col_number] = 'X'
  calculate_id(last_col_number, last_row_number)
end


plane_row = plane.find_index { |k| k.count('O') == 1 }
plane_col = plane[plane_row].find_index { |k| k.count('O') == 1 }

pp [plane_col, plane_row]

pp calculate_id(plane_col, plane_row)
