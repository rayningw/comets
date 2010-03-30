include_class 'java.awt.event.MouseListener'
include_class 'java.awt.event.MouseMotionListener'

class MouseHandler
  include MouseListener
  include MouseMotionListener
  def initialize
    @pending_events = []
  end

  def method_missing(m, *args, &block)
    event = args[0]
    case m
    when :mouseClicked, :mouse_clicked
      add_event [:mouse_clicked, event]
    when :mouseEntered, :mouse_entered
      add_event [:mouse_entered, event]
    when :mouseExited, :mouse_exited
      add_event [:mouse_exited, event]
    when :mousePressed, :mouse_pressed
      add_event [:mouse_pressed, event]
    when :mouseReleased, :mouse_released
      add_event [:mouse_released, event]
    when :mouseMoved, :mouse_moved
      add_event [:mouse_moved, event]
    when :mouseDragged, :mouse_dragged
      add_event [:mouse_dragged, event]
    else
      puts "#{m} called"
    end
  end

  def add_event(event)
    @pending_events << event
  end

  def pending_events
    @pending_events.clone
  end

  def clear
    @pending_events.clear
  end
end
