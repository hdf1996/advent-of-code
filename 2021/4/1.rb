input = File.read(File.join(__dir__, 'input.txt'))
numbers, *bingo_cards = input.split("\n\n")
numbers = numbers.split(',').map(&:to_i)
cards = bingo_cards.map { |card| card.split("\n").map { |row| row.split(' ').map(&:to_i)} }

#puts bingo_cards

#puts numbers
def col?(card,nums)
  card.any? do|col|
    col.all? { |number| nums.include?(number) }
  end
end
def row?(card, nums)
  r = card.transpose
  col?(r, nums)
end
def won?(card, nums)
  col?(card,nums) || row?(card, nums)
end
winner_data = nil
numbers.each_with_index do |number, index|
  balls = numbers[0..index]
  winner = cards.find do |card|
    won?(card, balls)
    
  end
  if winner
    winner_data =[winner, index]
    break
  end
end
winning_balls = numbers[0..winner_data[1]]
non_winner_numbers = winner_data[0].flatten.select do |num|
  !winning_balls.include?(num)
end
puts non_winner_numbers.sum * numbers[winner_data[1]]