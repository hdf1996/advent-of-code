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

  def operate(inputs)
    current_opt_index = 0
    i = 0
    inputs = inputs.dup
    output = []
    while i <= @intcodes.length
      index = i.dup
      i += 1
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
        @intcodes[section.last] = inputs.pop
      when 4
        current_opt_index += 2
        section = @intcodes[index..(index + 1)]
        output << @intcodes[section.last]
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
          @intcodes[section.last] = 1
        else
          @intcodes[section.last] = 0
        end
      when 8
        current_opt_index += 4
        section = @intcodes[index..(index + 3)]
        if read_parameter(section[1], 1) == read_parameter(section[2], 2)
          @intcodes[section.last] = 1
        else
          @intcodes[section.last] = 0
        end
      else
        puts "unknown optcode #{parsed_optcode.last}"
        break "error"
      end
    end
    output
  end
end

best_combination = (0..4).to_a.permutation.map do |phase_setting_sequence|
  phase_setting_sequence.reduce(0) do |input, acc|
    intcode_processor = IntcodeProcessor.new(original_intcodes.dup)

    intcode_processor.operate([input, acc])[0]
  end
end.max
puts best_combination
