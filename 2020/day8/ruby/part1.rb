require 'set'
input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n")

instructions = input.map do |instruction|
  type, argument = instruction.split(' ')
  [type, argument.to_i]
end

@executed_instructions = Set.new
@acc = 0
def execute_instruction(index, list)
  return unless @executed_instructions.add? index
  instruction, argument = list[index]
  next_index = index + 1
  case instruction
  when 'nop'
  when 'acc'
    @acc += argument
  when 'jmp'
    next_index = index + argument
  end

  return if next_index == list.length 

  execute_instruction(next_index, list)
end

execute_instruction(0, instructions)
pp @acc

