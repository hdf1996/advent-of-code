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
winners_data = []

def to_string(card)
  card.map{ |k| k.join(' ') }.join("\n")
end
numbers.each_with_index do |number, index|
  balls = numbers[0..index]
  cards.each_with_index do |card, card_index|
    winners_data.push([card_index, index]) if won?(card, balls) && winners_data.none? {|k|k[0] == card_index}
  end
end
winner_data = [cards[winners_data.last[0]], winners_data.last[1]]

winning_balls = numbers[0..winner_data[1]]
non_winner_numbers = winner_data[0].flatten.select do |num|
  !winning_balls.include?(num)
end
puts non_winner_numbers.sum * numbers[winner_data[1]]