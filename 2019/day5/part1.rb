original_intcodes = File.read(File.join(__dir__, 'input.txt')).split(",").map(&:to_i)

class IntcodeProcessor
  attr_accessor :intcodes, :parameter_mode
  def initialize(intcodes)
    @intcodes = intcodes
    @parameter_mode = 0
  end

  def parse_optcode(optcode)
     bits = optcode.to_s.rjust(5, "0").split('')
     [bits[0], bits[1], bits[2], [bits[3], bits[4]].join].map(&:to_i)
  end

  def read_parameter(parameter, index)
    return intcodes[parameter] if @parameter_mode[3 - index] == 0
    parameter
  end

  def operate
    current_opt_index = 0
    intcodes.each_with_index do |_, index|
      next if index < current_opt_index
      parsed_optcode = parse_optcode(intcodes[index])
      @parameter_mode = parsed_optcode.first(3)
      case parsed_optcode.last
      when 99
        break intcodes
      when 1
        current_opt_index += 4
        section = intcodes[index..(index + 3)]
        @intcodes[section.last] = read_parameter(section[1], 1) + read_parameter(section[2], 2)
      when 2
        current_opt_index += 4
        section = @intcodes[index..(index + 3)]
        @intcodes[section.last] = read_parameter(section[1], 1) * read_parameter(section[2], 2)
      when 3
        current_opt_index += 2
        section = @intcodes[index..(index + 1)]
        @intcodes[section.last] = 1
      when 4
        current_opt_index += 2
        section = @intcodes[index..(index + 1)]
        puts @intcodes[section.last]
      else
        break "error"
      end
    end
    intcodes
  end
end

intcode_processor = IntcodeProcessor.new(original_intcodes.dup)
puts
intcode_processor.operate.inspect
puts 'o'
