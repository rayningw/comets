#!ruby

require_relative './game_entity'

include Java
include Math

include_class 'java.awt.Polygon'

class Player < GameEntity
  @@ship_polygon = [[20,0], [-20,-10], [-10,0], [-20,10]]
  @@turret_coord = [20,0]
  @@turret_radius = 3.0

  def render(g)
    # Rotate the ship polygon around the player's position
    co_pts = @@ship_polygon.map do |pt|
      rotate_point(@ord_x + pt[0], @ord_y + pt[1])
    end

    # Paint the ship
    # NOTE: Have to construct a Polygon first because JRuby has trouble calling
    # Graphics.fillPolygon(xPoints:int[], yPoints:int[], nPoints:int)
    poly = Polygon.new
    co_pts.each do |pt|
      poly.addPoint(pt[0], pt[1])
    end

    g.color = Color::WHITE
    g.fillPolygon(poly)

    # Paint the turret
    co_pt = rotate_point(@ord_x + @@turret_coord[0],
        @ord_y + @@turret_coord[1])
    g.color = Color::RED
    g.fillOval(co_pt[0] - @@turret_radius, co_pt[1] - @@turret_radius,
        @@turret_radius * 2, @@turret_radius * 2)

    # Return the rendering bounds
    return co_pts
  end
end
