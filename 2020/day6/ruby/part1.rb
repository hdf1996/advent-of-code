input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n\n")

count = input.sum do |group|
  group.split("\n").inject({}) do |acc, answers|
    answers.chars.each { |answer| acc[answer] = true }
    acc
  end.values.count(&:itself)
end

pp count