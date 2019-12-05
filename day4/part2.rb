range = 134792..675810

def check_password(password)
  digits = password.to_s.split('')
  digits.length == 6 &&
  digits.chunk(&:itself).map{|_, v| v.length}.any? { |e| e == 2 } &&
  digits.sort == digits
end

count = range.count { |password| check_password(password) }
puts count
