require_relative './key_handler'
require_relative './mouse_handler'

include_class('javax.swing.SwingUtilities')
include_class('javax.swing.JFrame')
include_class('javax.swing.JLabel')
include_class('javax.swing.JPanel')
include_class('java.awt.Dimension')
include_class('java.awt.Color')
include_class('java.lang.System')

class GameFrame
  attr_reader :jf, :key_handler, :controller, :mouse_handler

  def initialize(width, height, &init)
    @width, @height = width, height
    @canvas = Canvas.new(width, height)
    @jf = JFrame.new
    @jf.resizable = false
    @jf.contentPane.add @canvas
    @jf.pack
    @jf.defaultCloseOperation = JFrame::EXIT_ON_CLOSE
    @jf.visible = true
    @jf.set_location 100, 100

    @key_handler = KeyHandler.new
    @mouse_handler = MouseHandler.new
    @controller = Controller.new(@key_handler)

    @jf.add_key_listener @key_handler
    @jf.add_mouse_listener @mouse_handler
    @jf.add_mouse_motion_listener @mouse_handler

    if init != nil
      go do
        init[self]
      end
    end
  end

  def render
    @canvas.render do |g|
      g.color = Color::BLACK
      g.fillRect(0, 0, @width, @height)
      @entity.render(g)
    end
  end

  def tick(n)
    @entity.tick(n)
    @key_handler.clear
    @mouse_handler.clear
  end

  def graphics
    @jf.graphics
  end

  def go &init
    @entity = init[self]
    SwingUtilities.invokeLater(Later.new(self))
  end
end

class Canvas < JPanel
  attr_writer :renderer

  def initialize(w, h)
    super()
    @width, @height, = w, h
    self.preferredSize = Dimension.new(w, h)
    self.doubleBuffered = true
  end

  def render &renderer
    bbg = acquireGraphics
    renderer[bbg]
    g = self.getGraphics
    g.drawImage(@backBuffer, 0, 0, nil)
    # TODO(koz): Figure out if we should reverse these two
    g.dispose
    bbg.dispose
  end

  def acquireGraphics
    if @backBuffer == nil
      @backBuffer = self.createImage(@width, @height)
    end
    @backBuffer.getGraphics
  end
end

class Later
  def initialize(gf)
    @gf = gf
  end

  def run
    Ticker.new(@gf, @gf).start
  end
end


class PerformanceClock
  WINDOW_SIZE = 10
  def initialize
    @last_ticks = []
    @ticks = 0
  end

  def calculate_average
    len = @last_ticks.count
    len = 1 if len == 0
    @last_ticks.reduce{|x, v| x + v}.to_f / len
  end

  def calculate_fps
    1000.0 / calculate_average
  end

  def tick(n)
    @ticks += 1
    @last_ticks << n
    @last_ticks.shift if @last_ticks.count >= WINDOW_SIZE
    if @ticks % 100 == 0
      @ticks = 0
      puts "FPS: #{calculate_fps.to_i}"
    end
  end
end

class Ticker < java.lang.Thread
  def initialize(game, renderer)
    super()
    @lastTick = System.currentTimeMillis
    @game, @renderer = game, renderer
  end

  def run
    p_clock = PerformanceClock.new
    @time_to_tick = 0
    while true
      timeNow = System.currentTimeMillis
      timeElapsed = timeNow - @lastTick
      @time_to_tick += timeElapsed
      @lastTick = timeNow
      while @time_to_tick > 10
        @game.tick(10)
        @time_to_tick -= 10
      end
      p_clock.tick(timeElapsed)
      # TODO(koz): Only render once every 60fps.
      @renderer.render
      if timeElapsed < 15
        java.lang.Thread.sleep(15 - timeElapsed)
      end
    end
  end
end
