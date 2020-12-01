require 'benchmark'

list_of_materials = File.read(File.join(__dir__, 'input.txt')).split("\n").map { |e| e.split(' => ').map { |j| j.split(', ').map { |k| k.split(' ').tap { |l| l[0] = l[0].to_i; l[1] = l[1].to_sym} } } }

@ordered_list = {
  ORE: { amount: 1, recipe: [] }
}
list_of_materials.each do |recipe|
  @ordered_list[recipe.last.first.last.to_sym] = {
    amount: recipe.last.first.first,
    recipe: recipe.first
  }
end

@produced = @ordered_list.keys.inject({}) do |acc, current|
  acc[current] = 0
  acc
end
@required = @ordered_list.keys.inject({}) do |acc, current|
  acc[current] = 0
  acc
end
@produced[:ORE] = 0
@required[:ORE] = 0
def produce(chemical, amount, add_require = true)
  @required[chemical] += amount if add_require
  diff = @required[chemical] - @produced[chemical]
  times = (diff / @ordered_list[chemical][:amount].to_f).ceil
  @produced[chemical] += @ordered_list[chemical][:amount] * times
  # while @produced[chemical] < @required[chemical]
  @ordered_list[chemical][:recipe].each do |recipe|
    @required[recipe.last] += recipe.first * times
    produce(
      recipe.last,
      (
        times * (@required[recipe.last] - @produced[recipe.last])
      ),
      false
    )
  end
end

target = 1000000000000
min = []
(1..9928927000053).bsearch do |i|
  @produced = @ordered_list.keys.inject({}) do |acc, current|
    acc[current] = 0
    acc
  end
  @required = @ordered_list.keys.inject({}) do |acc, current|
    acc[current] = 0
    acc
  end

  time = Benchmark.measure {
    produce(:FUEL, i)
  }
  min.push([@produced[:ORE] - target, i]) if (target - @produced[:ORE]).positive?
  min = [min.min { |e| e[0] }]
  target <=> @produced[:ORE]
end
pp min[0][1]
