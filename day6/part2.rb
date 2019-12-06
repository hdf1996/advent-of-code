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

  def get_way_until_depth(desired_depth)
    return [] if desired_depth == depth
    [parent] + parent.get_way_until_depth(desired_depth)
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

  def common_orbit_for(orbit1_name, orbit2_name)
    orbit1 = find_orbit(orbit1_name)
    orbit2 = find_orbit(orbit2_name)

    orbit1.get_way_until_depth(0).find do |orbit|
      orbit2.get_way_until_depth(0).include? orbit
    end
  end

  def find_orbit(name)
    @orbits_hash[name] ||= Orbit.new(name)
  end
end

orbit_calculator = OrbitCalculator.new(orbits)
orbit_calculator.calculate
common_orbit = orbit_calculator.common_orbit_for('YOU', 'SAN')

puts(
  orbit_calculator.find_orbit('SAN').get_way_until_depth(common_orbit.depth).length - 1 +
  orbit_calculator.find_orbit('YOU').get_way_until_depth(common_orbit.depth).length - 1
)
