input = File.read(File.join(__dir__, 'input.txt')).split("\n")

class Round
  attr_accessor :red, :green, :blue

  def initialize(red: 0, green: 0, blue: 0)
    @red = red
    @green = green
    @blue = blue
  end
end

class Game
  attr_accessor :rounds, :id

  def initialize(id, rounds)
    @id = id.split('Game ').last.to_i
    @rounds = rounds
  end

  def min_cubes
    [:red, :green, :blue].map do |color|
      rounds.map(&color).max
    end
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

result = games.sum { |game| game.min_cubes.inject(&:*) }

pp result