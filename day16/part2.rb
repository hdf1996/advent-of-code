input = File.read(File.join(__dir__, 'input.txt')).strip

partial, offset = input.chars.map(&:to_i), input[0, 7].to_i
complete = (partial * 10000).slice(offset..-1)

100.times do
  (complete.length - 2).downto(0) do |i|
    complete[i] = (complete[i] + complete[i.next]).to_s[-1].to_i
  end
end
pp complete.first(8).join
