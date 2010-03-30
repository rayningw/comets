#!ruby

class RenderingService
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
      # TODO: Tick the entities forward so it can render animation?
    end
  end

  def render(g)
    @entities.each do |entity|
      # Render entity in its normal position
      bounds = entity.render(g)

      # If its rendering bounds exceed the visible frame then render it shifted
      bounds.each do |coord|
        if coord[0] < 0
          entity.translate(@width, 0) do
            entity.render(g)
          end
        end
        if coord[0] > @width
          entity.translate(-@width, 0) do
            entity.render(g)
          end
        end
        if coord[1] < 0
          entity.translate(0, @height) do
            entity.render(g)
          end
        end
        if coord[1] > @height
          entity.translate(0, -@height) do
            entity.render(g)
          end
        end
      end
    end
  end
end
