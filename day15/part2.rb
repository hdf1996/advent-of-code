require 'benchmark'
original_intcodes = File.read(File.join(__dir__, 'input.txt')).split(",").map(&:to_i)
class IntcodeProcessor
  attr_accessor :intcodes, :parameter_mode, :inputs, :outputs, :relative_base
  def initialize(intcodes, inputs, outputs)
    @intcodes = intcodes
    @parameter_mode = 0
    @inputs = inputs
    @outputs = outputs
    @relative_base = 0
  end

  def finished?
    @finished
  end

  def parse_optcode(optcode)
     bits = optcode.to_s.rjust(5, "0").split('')
     [bits[0], bits[1], bits[2], [bits[3], bits[4]].join].map(&:to_i)
  end

  def index_for(parameter, mode)
    return parameter if mode.zero?
    @relative_base + parameter
  end

  def write_parameter(parameter, index, value)
    mode = @parameter_mode[3 - index]
    return @intcodes[parameter + @relative_base] = value if mode == 2
    return @intcodes[parameter] = value if mode == 1
    return @intcodes[parameter] = value if mode == 0
  end

  def read_parameter(parameter, index, position = 0)
    mode = @parameter_mode[3 - index]
    return @intcodes[parameter + @relative_base] || 0 if mode == 2
    return parameter if mode == 1
    return @intcodes[parameter] || 0 if mode == 0
  end

  def operate
    current_opt_index = 0
    i = 0
    while i <= @intcodes.length
      index = i.dup
      i += 1
      next if index < current_opt_index
      parsed_optcode = parse_optcode(intcodes[index])
      @parameter_mode = parsed_optcode.first(3)
      case parsed_optcode.last
      when 99
        puts 'finished'
        break intcodes
      when 1
        current_opt_index += 4
        section = intcodes[index..(index + 3)]
        write_parameter(section.last, 3, read_parameter(section[1], 1) + read_parameter(section[2], 2))
      when 2
        current_opt_index += 4
        section = @intcodes[index..(index + 3)]
        write_parameter(section.last, 3, read_parameter(section[1], 1) * read_parameter(section[2], 2))
      when 3
        current_opt_index += 2
        section = @intcodes[index..(index + 1)]
        write_parameter(section.last, 1, inputs.shift)
      when 4
        current_opt_index += 2
        section = @intcodes[index..(index + 1)]
        @outputs.push(read_parameter(section[1], 1))
      when 5
        current_opt_index += 3
        section = @intcodes[index..(index + 2)]
        if read_parameter(section[1], 1) != 0
          i = read_parameter(section[2], 2)
          current_opt_index = read_parameter(section[2], 2)
        end
      when 6
        current_opt_index += 3
        section = @intcodes[index..(index + 2)]
        if read_parameter(section[1], 1) == 0
          i = read_parameter(section[2], 2)
          current_opt_index = read_parameter(section[2], 2)
        end
      when 7
        current_opt_index += 4
        section = @intcodes[index..(index + 3)]
        if read_parameter(section[1], 1) < read_parameter(section[2], 2)
          write_parameter(section.last, 3, 1)
        else
          write_parameter(section.last, 3, 0)
        end
      when 8
        current_opt_index += 4
        section = @intcodes[index..(index + 3)]
        if read_parameter(section[1], 1) == read_parameter(section[2], 2)
          write_parameter(section.last, 3, 1)
        else
          write_parameter(section.last, 3, 0)
        end
      when 9
        current_opt_index += 2
        section = @intcodes[index..(index + 1)]
        @relative_base += read_parameter(section.last, 1)
      else
        puts "unknown optcode #{parsed_optcode.last}"
        break "error"
      end
    end
  end
end

@input = Queue.new
@output = Queue.new
thread = Thread.new {
  IntcodeProcessor.new(
    original_intcodes.dup,
    @input,
    @output
  ).tap(&:operate)
}

size = [50, 50]
@current_position = [size[0] / 2, size[1] / 2]
@matrix = (0..size[1]).to_a.fill { (0..size[0]).to_a.fill(nil) }
@matrix[@current_position[1]][@current_position[0]] = 3

SHOW_SIGNS = ['#', ' ', 'O', 'X', 'C']

def next_direction(direction)
  [3, 4, 2, 1][direction - 1]
end

def print_matrix(matrix, current_position)
  puts(matrix.map.with_index do |e, y|
    e.map.with_index do |j, x|
      if [x, y] == current_position
        'C'
      else
        j.nil? ? '.' : SHOW_SIGNS[j]
      end
    end.join
  end.join("\n"))
end

def calculate_position(position, direction)
  case direction
  when 1
    [position[0], position[1] + 1]
  when 2
    [position[0], position[1] - 1]
  when 3
    [position[0] + 1, position[1]]
  when 4
    [position[0] - 1, position[1]]
  end
end

def reverse_of(direction)
  [2, 1, 4, 3][direction - 1]
end

def reverse(direction)
  @input.push(reverse_of(direction))
  @output.pop
end

@max = 0
@oxigen_pos = nil
def traverse_with_bot(matrix, current_position, nth = 0, last_direction = nil, directions = [])
  ([1, 2, 3, 4] - [last_direction]).inject(matrix) do |acc, direction|
    @input.push(direction)
    status = @output.pop
    new_position = calculate_position(current_position, direction)
    acc[new_position[1]][new_position[0]] = status
    case status
    when 0
      acc
    when 1
      traverse_with_bot(matrix, new_position, nth + 1, reverse_of(direction), directions + [direction])
      reverse(direction)
      acc
    when 2
      reverse(direction)
      @oxigen_pos = new_position
      acc
    end
  end
end

def traverse(matrix, current_position, nth = 0, last_direction = nil, directions = [])
  # return matrix if nth >= 1

  ([1, 2, 3, 4] - [last_direction]).inject(matrix) do |acc, direction|
    # @input.push(direction)
    new_position = calculate_position(current_position, direction)
    status = matrix[new_position[1]][new_position[0]]

    acc[new_position[1]][new_position[0]] = status
    case status
    when 0
      acc
    when 1
      traverse(matrix, new_position, nth + 1, reverse_of(direction), directions + [direction])
      @max = [@max, directions.length + 1].max
      reverse(direction)
      acc
    when 2
      reverse(direction)
      acc
    end
  end
end

new_matrix = traverse_with_bot(@matrix, @current_position)
traverse(new_matrix, @oxigen_pos)
puts @max
