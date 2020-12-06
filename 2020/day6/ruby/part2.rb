input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n\n")

count = input.sum do |group|
  answers_count = group.split("\n").inject({}) do |acc, answers|
    answers.chars.map do |answer|
      acc[answer] = (acc[answer] || 0) + 1
    end
    acc
  end

  answers_count.select { |key, value| value === group.split("\n").length }.keys.count
end

pp count