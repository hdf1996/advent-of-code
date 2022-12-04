pairs = File.read(File.join(__dir__, 'input.txt'))
            .split("\n")
            .map do |pair| 
              pair.split(',').map do |assignment| 
                first, last = assignment.split('-').map(&:to_i)

                Range.new(first, last)
              end
            end
          
result = pairs.count do |pair|
  pair[0].cover?(pair[1]) || pair[1].cover?(pair[0])
end

pp result