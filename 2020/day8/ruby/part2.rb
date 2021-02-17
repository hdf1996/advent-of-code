require 'set'
input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n")

instructions = input.map do |instruction|
  type, argument = instruction.split(' ')
  [type, argument.to_i]
end

def execute_instruction(index, list, executed_instructions = Set.new, acc = 0)
  return false unless executed_instructions.add? index
  instruction, argument = list[index]
  next_index = index + 1
  case instruction
  when 'nop'
  when 'acc'
    acc += argument
  when 'jmp'
    next_index = index + argument
  end

  return acc if next_index == list.length 

  execute_instruction(next_index, list, executed_instructions, acc)
end

last_acc = instructions.each_with_index do |instruction, index|
  if ['jmp', 'nop'].include? instructions[index].first
    modified_instructions = instructions.dup
    modified_instructions[index] = [modified_instructions[index].first == 'nop' ? 'jmp' : 'nop', modified_instructions[index].last]
    result =  execute_instruction(0, modified_instructions)

    break result if result
  else 
    false
  end
end

pp last_acc
