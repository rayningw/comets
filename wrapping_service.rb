#!ruby

class WrappingService
  def initialize(width, height)
    @entities = []
    @width = width
    @height = height
  end

  def add(entity)
    @entities.push(entity)
  end

  def delete(entity)
    @entities.delete(entity)
  end
  
  def tick(millis)
    @entities.each do |entity|
      if entity.ord_x > @width
        entity.ord_x = entity.ord_x - @width
      end
      if entity.ord_x < 0
        entity.ord_x = entity.ord_x + @width
      end
      if entity.ord_y > @height
        entity.ord_y = entity.ord_y - @height
      end
      if entity.ord_y < 0
        entity.ord_y = entity.ord_y + @height
      end
    end
  end
end
