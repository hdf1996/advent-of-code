# This is an incomplete solution but i thought it will be funny to be able to see how it's discovered by using your keyboard

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

size = [100, 50]
@current_position = [size[0] / 2, size[1] / 2]
@matrix = (0..size[1]).to_a.fill { (0..size[0]).to_a.fill(nil) }
@matrix[@current_position[1]][@current_position[0]] = 3
def predict_position(direction)
  copy_position = @current_position.dup
  case direction
  when 1
    @current_position[1] +=1
  when 2
    @current_position[1] -=1
  when 3
    @current_position[0] +=1
  when 4
    @current_position[0] +=1
  end
  copy_position
end

def move(direction)
  old_position = @current_position.dup
  case direction
  when 1
    @current_position[1] -=1
  when 2
    @current_position[1] +=1
  when 3
    @current_position[0] -=1
  when 4
    @current_position[0] +=1
  end
  @input.push(direction)
  sleep 0.1
  status = @output.pop
  @matrix[@current_position[1]][@current_position[0]] = status
  case status
  when 0
    @current_position = old_position
  when 1
  when 2
  end
  status
end

SHOW_SIGNS = ['#', ' ', 'O', 'X', 'C']

def next_direction(direction)
  [3, 4, 2, 1][direction - 1]
end

frame = 0
loop do
  frame += 1
  system("clear") || system("cls")
  puts(@matrix.flatten.any? { |e| e == 2  })
  puts(@matrix.map.with_index do |e, y|
    e.map.with_index do |j, x|
      if [x, y] == @current_position
        'C'
      else
        j.nil? ? '.' : SHOW_SIGNS[j]
      end
    end.join
  end.join("\n"))

  begin
    system("stty raw -echo")
    case key = STDIN.getc
    when 'w'
      STDIN.flush
      move(1)
    when 's'
      STDIN.flush
      move(2)
    when 'd'
      STDIN.flush
      move(4)
    when 'a'
      STDIN.flush
      move(3)
    when 'q'
      exit
    when "\n"
      next
    else
      STDIN.flush
      next
    end
  ensure
    system("stty -raw echo")
  end
  sleep 0.05
end
