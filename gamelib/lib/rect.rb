require_relative './vector'

class Segment
  attr_reader :length

  def initialize(from, length)
    @from, @length = from, length
  end

  EMPTY = Segment.new(0, 0)

  def contains?(x)
    x >= low && x < high
  end

  def low
    @from
  end

  def high
    @from + @length
  end

  def max(x, y)
    x > y ? x : y
  end

  def min(x, y)
    x < y ? x : y
  end

  def intersect(o)
    return Segment::EMPTY if high <= o.low || o.high <= low
    l = max(low, o.low)
    h = min(high, o.high)
    Segment.new(l, h - l)
  end

  def empty?
    @length == 0
  end

  def move(dx)
    Segment.new(@from + dx, @length)
  end

  def ==(o)
    low == o.low && length == o.length
  end

  def to_s
    "[#{@from}, #{@length}]"
  end
end

class Rect
  attr_reader :pos, :dims
  def initialize pos, dims
    @pos, @dims = pos, dims
    while @pos.count < 3
      @pos << 0
    end
    while @dims.count < 3
      @dims << 0
    end
  end

  def self.from_midpoint(mp, dims)
    pos = []
    mp.each_index do |i|
      m = mp[i]
      d = dims[i]
      pos << (m - d / 2.0)
    end
    Rect.new(pos, dims)
  end

  def width ; @dims[0] ; end
  def height ; @dims[1] ; end
  def depth ; @dims[2] ; end
  def w ; width ; end
  def h ; height ; end
  def x ; @pos[0] ; end
  def y ; @pos[1] ; end
  def z ; @pos[2] ; end
  def x=(n) ; @pos[0] = n ; end
  def y=(n) ; @pos[1] = n ; end
  def z=(n) ; @pos[2] = n ; end
  def xx ; x + width ; end
  def yy ; y + height ; end
  def zz ; z + depth ; end

  def width=(n) ; @dims[0] = n ; end
  def height=(n) ; @dims[1] = n ; end
  def depth=(n) ; @dims[2] = n ; end

  def ==(o)
    return false if o == nil
    x == o.x && y == o.y && w == o.w && h == o.h && depth == o.depth
  end

  def intersect(o)
    x_int = x_range.intersect(o.x_range)
    y_int = y_range.intersect(o.y_range)
    z_int = z_range.intersect(o.z_range)

    Rect.new([x_int.low, y_int.low, z_int.low], [x_int.length, y_int.length, z_int.length])
  end

  def empty?
    width * height * depth == 0
  end

  def null?
    width == 0 && height == 0 && depth == 0
  end

  def x_range
    Segment.new(x, width)
  end

  def y_range
    Segment.new(y, height)
  end

  def z_range
    Segment.new(z, depth)
  end

  # TODO(koz): Replace these arguments with a vector.
  def move(dx, dy, dz)
    @pos[0] += dx
    @pos[1] += dy
    @pos[2] += dz
  end

  def grow(vec)
    @dims[0] += vec.x
    @dims[1] += vec.y
    @dims[2] += vec.z
  end

  def pos=(p)
    @pos = p.clone
  end

  def midpoint
    Vector.new(x + width/2.0, y + height/2.0, z + depth/2.0)
  end

  def clone
    Rect.new @pos.clone, @dims.clone
  end

  def to_s
    "(#{x}, #{y}, #{z})x(#{w},#{h},#{depth})"
  end
end

# Object that represents something in the game space.
module OccupiesSpace
  def x ; @rect.x ; end
  def y ; @rect.y ; end
  def z ; @rect.z ; end
  def xx ; @rect.xx ; end
  def yy ; @rect.yy ; end
  def zz ; @rect.zz ; end
  def x=(n) ; @rect.x = n ; end
  def y=(n) ; @rect.y = n ; end
  def z=(n) ; @rect.z = n ; end
  def width ; @rect.width ; end
  def height ; @rect.height ; end
  def depth ; @rect.depth ; end
  def width=(n) ; @rect.width = n ; end
  def height=(n) ; @rect.height = n ; end
  def depth=(n) ; @rect.depth = n ; end
  def pos=(n) ; @rect.pos = n ; end
  def intersect(o) ; @rect.intersect(o) ; end
  def move(dx, dy, dz) ; @rect.move(dx, dy, dz) end
  def x_range ; @rect.x_range ; end
  def y_range ; @rect.y_range ; end
  def z_range ; @rect.z_range ; end
  def midpoint ; @rect.midpoint ;end
  def grow(vec) ; @rect.grow(vec) ; end
end
