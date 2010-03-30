class Entity
  attr_reader :children, :dims
  attr_writer :attributes
  
  def initialize(pos=[0, 0], dims=[0, 0], alignment=[:left, :top])
    @pos = pos
    @dims = dims
    @children = []
    @parent = nil
    @alignment = alignment
    @attributes = []
    @attribute_map = {}
    normalize
  end
  
  def [](key)
    check_bad_key(key)
    @attribute_map[key]
  end
  
  def []=(key, value)
    check_bad_key(key)
    @attribute_map[key] = value
  end
  
  def check_bad_key(key)
    raise "#{key} is not an attribute on #{self}" unless @attributes.include? key
  end
  
  def normalize
    if @parent == nil
      @true_pos = @pos
    else
      @true_pos = [normalize_x, normalize_y]
    end
    @children.each do |child|
      child.reposition(self)
    end
  end
  
  def normalize_x
    if x_align == :left
      @parent.x + @pos[0]
    else
      @parent.x + @parent.width - @pos[0] - width
    end
  end
  
  def normalize_y
    if y_align == :top
      @parent.y + @pos[1]
    else
      @parent.y + @parent.height - @pos[1] - height
    end
  end
  
  def <<(child)
    child.reposition(self)
    @children << child
  end
  
  def pos
    @true_pos
  end
  
  def pos=(pos)
    @pos = pos
    normalize
  end
  
  def reposition(parent)
    @parent = parent
    normalize
  end
  
  def plus(p, q)
    [p[0] + q[0], p[1] + q[1]]
  end
  
  def dims=(dims)
    @dims = dims
    normalize
  end
  
  def x ; @true_pos[0] ; end
  def y ; @true_pos[1] ; end
  def x=(x)
    @pos[0] = x
    normalize
  end
  def y=(y)
    @pos[1] = y
    normalize
  end
  def width ; @dims[0] ; end
  def height ; @dims[1] ; end
  def x_align ; @alignment[0] ; end
  def y_align ; @alignment[1] ; end
  
  def x_align=(alignment)
    @alignment[0] = alignment
    normalize
  end
  
  def y_align=(alignment)
    @alignment[1] = alignment
  end
  
  def pretty_print(start=false)
    @@indent_counter = 0 if start
    puts "#{'  ' * @@indent_counter}#{self} {"
    @@indent_counter += 1
    @children.each do |child|
      child.pretty_print
    end
    @@indent_counter -= 1
    puts "#{'  ' * @@indent_counter}}"
  end
  
  def to_s
    "(#{x}, #{y})x(#{width}, #{height})"
  end
end