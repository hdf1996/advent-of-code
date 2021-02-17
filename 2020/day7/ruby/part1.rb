input = File.read(File.join(__dir__, '..', 'input.txt')).split("\n")

class Bag
  attr_reader :color, :childrens, :parents
  def initialize(color)
    @color = color
    @childrens = []
    @parents = []
  end

  def add_childrens(childrens)
    @childrens.push(childrens)
    childrens.map { |children| children.add_parents(self) }
  end

  def add_parents(parents)
    @parents.push(parents)
  end

  def deep_parents
    (parents + parents.map(&:deep_parents).flatten).uniq
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
  childrens = _childrens.split(',').map { |bag| bag.split(' bag').first.split(' ').drop(1).join(' ') }.map do |color|
    colors[color] ||= Bag.new(color)
  end

  container.add_childrens(childrens)
end

pp colors['shiny gold'].deep_parents.count