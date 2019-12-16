list_of_materials = File.read(File.join(__dir__, 'input.txt')).split("\n").map { |e| e.split(' => ').map { |j| j.split(', ').map { |k| k.split(' ').tap { |l| l[0] = l[0].to_i} } } }

@ordered_list = {
  "ORE" => { amount: 1, recipe: [] }
}
list_of_materials.each do |recipe|
  @ordered_list[recipe.last.first.last] = {
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
@produced['ORE'] = 0
@required['ORE'] = 0
def produce(chemical, amount, add_require = true)
  @required[chemical] += amount if add_require
  while @produced[chemical] < @required[chemical]
    @ordered_list[chemical][:recipe].each do |recipe|
      @required[recipe.last] += recipe.first
      while @produced[recipe.last] < @required[recipe.last]
        produce(recipe.last, recipe.first, false)
      end
    end
    @produced[chemical] += @ordered_list[chemical][:amount]
  end
end

# pp @ordered_list
produce('FUEL', 1)
# pp @required
pp @produced
