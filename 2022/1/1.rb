input = File.read(File.join(__dir__, 'input.txt')).split("\n\n")

food = input.map { |elf| elf.split("\n").map(&:to_i).sum } 

pp food.max