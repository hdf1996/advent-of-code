class ChristmasFolder
  attr_accessor :path, :parent, :childrens

  def initialize(path = '')
    @path = path
    @childrens = []
  end

  def full_path
    [parent&.full_path || '', path].filter{ |k| !k.nil? }.join('/').gsub! %r{/+}, '/'
  end

  def append(*elements)
    elements.each { |element| element.parent = self }
    childrens.push(*elements)
  end

  def find(name)
    childrens.find { |children| children.path == name }
  end

  def size
    childrens.sum(&:size)
  end

  def folder?
    true
  end

  def deep_each(&block)
    childrens.select(&:folder?).each do |folder|
      block.call(folder)
      folder.deep_each(&block)
    end
  end

  def to_s
    "#{size} #{full_path}"
  end
end

class ChristmasFile
  attr_accessor :path, :parent, :size

  def initialize(path = '', size = 0)
    @path = path
    @size = size.to_i
  end

  def full_path
    "/#{path}"
  end

  def folder?
    false
  end
end

class ChristmasFileSystem
  attr_accessor :current_folder, :root

  def initialize
    @current_folder = ChristmasFolder.new
    @root = @current_folder
  end

  def cd(new_path)
    return @current_folder = current_folder.parent if new_path == '..'
    return @current_folder = root if new_path == '/'
    @current_folder = current_folder.find(new_path)
  end
end

input = File.read(File.join(__dir__, 'input.txt')).split("\n")

file_system = ChristmasFileSystem.new

input.each do |line|
  if line.start_with? '$'
    _, command, argument = line.split(' ')

    case command
    when 'cd'
      file_system.cd(argument)      
    when 'ls'
      # We can safely ignore this branch, but i've the feeling it may be used for part 2
    end
  else
    # If not, then is a file/folder listing
    size, name = line.split(' ')
    entity = size == 'dir' ? ChristmasFolder.new(name) : ChristmasFile.new(name, size)
    file_system.current_folder.append(entity)
  end
end

file_system.cd('/')
lower_than_100_000 = []
results = file_system.current_folder.deep_each do |entity|
  next unless entity.folder?

  if entity.size < 100000
    lower_than_100_000.push(entity)
  end
end

puts lower_than_100_000.sum(&:size)

