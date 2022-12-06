input = File.read(File.join(__dir__, 'input.txt')).split("\n\n")
steps = input[1].split("\n").map { |step| step.scan(/\d+/).map(&:to_i) }

raw_stacks = input[0].split("\n")

total_stacks = raw_stacks[-1].split(' ')[-1].to_i

stacks = Array.new(total_stacks) { [] }

raw_stacks.reverse_each.with_index do |stack, index|
  next if index == 0

  total_stacks.times do |current_stack|
    separator_length = '] ['.length

    padding = current_stack * separator_length
    current_content = stack[(padding + current_stack + 1)..(padding + current_stack + 1)]

    stacks[current_stack] << current_content unless current_content == ' '
  end
end

steps.each do |step|
  times, from, to = step

  times.times do
    stacks[to - 1] << stacks[from - 1].pop
  end
end

result = stacks.map(&:last).join('')
pp result