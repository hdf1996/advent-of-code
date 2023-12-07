input = File.read(File.join(__dir__, 'input.txt')).split("\n")

class Round
  attr_accessor :red, :green, :blue

  def initialize(red: 0, green: 0, blue: 0)
    @red = red
    @green = green
    @blue = blue
  end

  def possible?
    red <= 12 && green <= 13 && blue <= 14
  end
end

class Game
  attr_accessor :rounds, :id

  def initialize(id, rounds)
    @id = id.split('Game ').last.to_i
    @rounds = rounds
  end

  def possible?
    rounds.all?(&:possible?)
  end
end

games = input.map do |line|
  game_number, rounds = line.split(': ')
  Game.new(game_number, rounds.split('; ').map do |round|
    colors = round.split(', ')
    Round.new(
      **Hash[*colors.map do |color| 
        number, color = color.split(' ')
        [color.to_sym, number.to_i]
      end.flatten]
    )
  end
  )
end

result = games.filter { |game| game.possible? }.sum(&:id)

pp result