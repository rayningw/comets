require_relative './gamelib/lib/gamelib'
require_relative './game'

include Java

include_class 'java.awt.event.KeyEvent'

class GameHolder
  def initialize(controller, game)
    @controller = controller
    @controller.bindings = {
      :reload => KeyEvent::VK_R,
    }
    @game = game
  end

  def tick(n)
    if @controller.pressed? :reload
      load 'game.rb'
      @game = Game.new(@controller.clone)
    end
    @game.tick(n)
  end

  def render(g)
    @game.render(g)
  end
end

Gamelib.run(640, 480) do |gf|
  GameHolder.new(gf.controller.clone, Game.new(gf.controller.clone))
end
