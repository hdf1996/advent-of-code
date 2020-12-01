orbits = File.read(File.join(__dir__, 'input.txt')).split("\n").map { |e| e.split(")") }

class Orbit
  attr_accessor :childrens, :parent, :name
  def initialize(name)
    @name = name
    @childrens = []
  end

  def depth
    return 0 unless parent

    1 + parent.depth
  end

  def total_size
    depth + childrens.sum(&:total_size)
  end
end

class OrbitCalculator
  attr_accessor :orbits_hash, :orbits
  def initialize(orbits)
    @orbits = orbits
    @orbits_hash = {}
  end

  def calculate
    orbits.each do |orbit|
      parent_name, children_name = orbit
      parent = find_orbit(parent_name)
      orbiter = find_orbit(children_name)

      orbiter.parent = parent
      parent.childrens << orbiter
    end
  end

  def find_orbit(name)
    @orbits_hash[name] ||= Orbit.new(name)
  end
end

orbit_calculator = OrbitCalculator.new(orbits)
orbit_calculator.calculate

puts orbit_calculator.orbits_hash['COM'].total_size
