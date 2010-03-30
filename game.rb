#!/usr/bin/ruby

require 'movement_service'
require 'rendering_service'
require 'input_service'
require 'wrapping_service'
require 'player'

include Math

class Game
  def initialize(controller)
    @controller = controller
    @controller.bindings = {
      :up => KeyEvent::VK_UP,
      :down => KeyEvent::VK_DOWN,
      :left => KeyEvent::VK_LEFT,
      :right => KeyEvent::VK_RIGHT,
      :fire => KeyEvent::VK_SPACE,
    }

    # Movement service moves the entities on each tick
    @movement_serv = MovementService.new

    # Rendering service renders the entities
    @render_serv = RenderingService.new(640, 480)

    # Input service listens for keystrokes and executes an action
    @input_serv = InputService.new(@controller)

    # Wrapping service that keeps entities within the visible frame
    @wrapping_serv = WrappingService.new(640, 480)

    # Create and register the player
    @player = Player.new(320, 240)
    @movement_serv.add(@player)
    @render_serv.add(@player)
    @wrapping_serv.add(@player)

    # Register movement events for the player
    # TODO: Should pass in the tick seconds into accelerate
    @input_serv.add_keyevent(:up) do
      @player.accelerate(@player.rotation, 5, 1)
    end
    @input_serv.add_keyevent(:down) do
      @player.accelerate(@player.rotation + PI, 5, 1)
    end
    @input_serv.add_keyevent(:left) do
      @player.rotation = @player.rotation - PI/45
    end
    @input_serv.add_keyevent(:right) do
      @player.rotation = @player.rotation + PI/45
    end
  end

  def tick(millis)
    @movement_serv.tick(millis)
    @render_serv.tick(millis)
    @input_serv.tick(millis)
    @wrapping_serv.tick(millis)
  end

  def render(g)
    @render_serv.render(g)
  end
end
