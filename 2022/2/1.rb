rounds = File.read(File.join(__dir__, 'input.txt')).split("\n")

PLAYER_B_MAPPING = {
  X: :A, # Piedra
  Y: :B, # Papel
  Z: :C, # Tijera
}

SHAPE_SCORES = {
  A: 1,
  B: 2,
  C: 3
}

WHO_WINS = {
  C: :B,
  B: :A,
  A: :C
}

def score(player_b, player_a)
  count = 0

  count += 3 if player_a === player_b
  count += 6 if WHO_WINS[player_a] == player_b

  count += SHAPE_SCORES[player_a]
end

score = rounds.sum do |round|
  player_a, player_b = round.split(' ').map(&:to_sym)
  score(player_a, PLAYER_B_MAPPING[player_b])
end

puts score