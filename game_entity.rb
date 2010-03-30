#!/usr/bin/ruby

include Math

class GameEntity
  # Units
  attr_accessor :ord_x
  attr_accessor :ord_y

  # Direction that the entity is moving, expressed in radians where zero points
  # right and angle rotates *clockwise*
  attr_accessor :direction

  # Units per second
  attr_accessor :speed

  # Direction that the entity is pointing
  attr_accessor :rotation

  def initialize(ord_x, ord_y)
    @ord_x = ord_x
    @ord_y = ord_y
    @direction = 0
    @speed = 0
    @rotation = 0
  end

  # Accelerate the entity for a number of seconds in a direction and magnitude
  def accelerate(direction, magnitude, time)
    new_x = @speed * cos(@direction) + magnitude * cos(direction) * time
    new_y = @speed * sin(@direction) + magnitude * sin(direction) * time
    @speed = sqrt(new_x**2 + new_y**2)
    @direction = atan2(new_y, new_x)
  end
  
  # TODO: Performs an operation where the origin is (x1,y1)
  def translate(x1, y1, &op)
    @ord_x = @ord_x + x1
    @ord_y = @ord_y + y1
    op.call
    @ord_x = @ord_x - x1
    @ord_y = @ord_y - y1
  end

  # Rotates a point around the entity's current position and direction
  # TODO: Is it possible to wrap in a translate?
  def rotate_point(x1, y1)
    rel_x = x1 - @ord_x
    rel_y = y1 - @ord_y

    return [rel_x * cos(@rotation) - rel_y * sin(@rotation) + @ord_x,
        rel_x * sin(@rotation) + rel_y * cos(@rotation) + @ord_y]
  end
end
