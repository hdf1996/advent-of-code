require 'set'
input = File.read(File.join(__dir__, 'input.txt')).split("\n").map { |k| k.split('-') }



class Cave
  attr_accessor :name, :connections
  def initialize(name)
    @name = name
    @connections = Set.new
  end

  def eql?(cave)
    name == cave.name
  end

  def hash
    name.hash
  end

  def big?
    /[[:upper:]]/.match(name)
  end

  def inspect
    "<Cave #{name} #{big? ? 'big' : 'small'}>"
  end

  def link!(cave2)
    self.connections << cave2
    cave2.connections << self
  end

  def small?
    !big? && name != 'start' && name != 'end'
  end
end

class Map
  attr_accessor :caves, :connections

  def initialize(connections)
    @caves = []
    @connections = connections.map { |k| k.map { |p| named(p) } }
    @caves = @connections.flatten.uniq

    link_caves!
  end

  def link_caves!
    connections.each do |(cave1, cave2)|
      cave1.link! cave2
    end
  end

  def named(name)
    @caves.find { |k| k.name.eql? name } || Cave.new(name).tap { |c| @caves.push(c) }
  end
end

map = Map.new(input)

@potential_connections = []
start_point = map.named('start')

def nodes_till_end?(start_point, nodes = [])
  matched_double = false
  start_point.connections.select { |k| k.name != 'start'}.each do |node|
    new_node_list = [*nodes, start_point]
    if node.name == 'end'
      @potential_connections.push([*nodes, start_point, node])
    elsif node.big? || (
      new_node_list.count { |k| k.name == node.name } < (
        (new_node_list.select(&:small?).tally.values.count { |k| k >= 2} == 0) ? 2 : 1
      )
    )
      nodes_till_end?(node, new_node_list)
    end
  end
end
nodes_till_end?(start_point, [])

result = @potential_connections.map { |k| k.map(&:name).join(',')}.uniq

puts result.length