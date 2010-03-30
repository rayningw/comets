require 'rect'

class Vector
  attr_accessor :x, :y, :z

  def initialize(x, y, z)
    @x, @y, @z = x, y, z
  end

  %w/dx dy dz/.each do |name|
    eval <<-EOM
      def #{name}
        puts "Vector\##{name} is obsolete"
        puts caller
        @#{name}
      end
    EOM
  end

  EMPTY = Vector.new(0.0, 0.0, 0.0)

  # The context this is being used in is that this vector represents a
  # collision vector, so we want to select the least significant axis that is
  # actually colliding. So the smallest positive axis, in other words.
  def smallest_positive_axis
    ds = [@x, @y, @z].map{|x| x.abs}.sort
    until ds.empty? || ds[0] > 0
      ds.shift
    end
    return EMPTY if ds.empty?
    smallest = ds.shift
    smallest_assigned = false
    assign_smallest = proc {|n|
      if smallest_assigned
        0
      elsif n.abs == smallest
        smallest_assigned = true
        n
      else
        0
      end
    }

    ds = [@x, @y, @z].map{|n| assign_smallest[n]}
    Vector.new(*ds)
  end

  def reverse
    Vector.new(-@x, -@y, -@z)
  end

  def in_reversed_direction(x, y, z)
    Vector.new(signum(@x) * -x, signum(@y) * -y, signum(@z) * -z)
  end

  def signum(n)
    if n < 0
      -1
    elsif n == 0
      0
    else
      1
    end
  end

  def move(r)
    r.move(@x, @y, @z)
  end

  def null?
    @x == 0 && @y == 0 && @z == 0
  end

  def to_s
    "Vector<#@x, #@y, #@z>"
  end

  def ==(o)
    @x == o.x && @y == o.y && @z == o.z
  end

  def empty?
    self == EMPTY
  end

  def axis(axis)
    case axis
    when :x then Vector.new(@x, 0.0, 0.0)
    when :y then Vector.new(0.0, @y, 0.0)
    when :z then Vector.new(0.0, 0.0, @z)
    else
      raise "Bad axis #{axis}"
    end
  end

  def to_a
    [@x, @y, @z]
  end

  def negate
    self * -1
  end

  def *(n)
    if n.kind_of? Vector
      Vector.new(@x * n.x, @y * n.y, @z * n.z)
    else
      Vector.new(n * @x, n * @y, n * @z)
    end
  end

  def /(n)
    self * (1.0 / n)
  end

  def +(n)
    if n.kind_of? Vector
      Vector.new(@x + n.x, @y + n.y, @z + n.z)
    else
      Vector.new(n + @x, n + @y, n + @z)
    end
  end

  def -@
    self * -1
  end

  def -(n)
    self + (-n)
  end

  def randomize
    ds = [@x, @y, @z].map{|x|
      rand(0) - 0.5
    }
    Vector.new(*ds)
  end

  def normalize
    m = magnitude
    Vector.new(*(to_a.map{|x| x / m}))
  end

  def magnitude
    Math.sqrt(to_a.map{|x| x*x}.reduce{|d, x| x+d})
  end
end

