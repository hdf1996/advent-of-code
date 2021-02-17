input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n")

class Bag
  attr_reader :color, :childrens, :parents
  def initialize(color)
    @color = color
    @childrens = []
    @parents = []
  end

  def add_childrens(childrens)
    @childrens.push(*childrens)
    childrens.map { |children| children[1].add_parents(self) }
  end

  def add_parents(parents)
    @parents.push(parents)
  end

  def deep_parents
    (parents + parents.map(&:deep_parents).flatten).uniq
  end

  def deep_childrens_count
    childrens.map(&:first).map(&:to_i).sum + childrens.map do |children|
      children[0].to_i * children[1].deep_childrens_count
    end.sum
  end

  def to_s
    "#{color}"
  end

  def inspect
    "#{color}"
  end
end

colors = {}

input.each do |rule|
  _container, _childrens = rule.split(' bags contain ')

  colors[_container] = container = colors[_container] || Bag.new(_container)
  childrens = _childrens.split(',').map { |bag| bag.split(' bag').first }.map do |color|
    amount, *color = color.split(' ')
    [amount, colors[color.join(' ')] ||= Bag.new(color.join(' '))]
  end

  container.add_childrens(childrens)
end

pp colors['shiny gold'].deep_childrens_count