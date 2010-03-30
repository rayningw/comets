#!ruby

include Math

class MovementService
  @@SPEED_PER_MILLI = 0.001
  
  def initialize
    @entities = []
  end

  def add(entity)
    @entities.push(entity)
  end

  def delete(entity)
    @entities.delete(entity)
  end

  def tick(millis)
    @entities.each do |entity|
      # Calculate the x and the y velocities
      speed_x = entity.speed * cos(entity.direction)
      speed_y = entity.speed * sin(entity.direction)

      # Now move the entity's co-ordinates
      entity.ord_x = entity.ord_x + speed_x * @@SPEED_PER_MILLI * millis
      entity.ord_y = entity.ord_y + speed_y * @@SPEED_PER_MILLI * millis
    end
  end
end
