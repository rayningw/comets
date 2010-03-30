
class Event
  attr_reader :key_code, :down
  def initialize(key_code, down)
    @key_code, @down = key_code, down
  end

  def to_s
    "Event<#{@key_code}, #{@down}>"
  end
end

class KeyHandler
  attr_reader :keys_down, :keys_pressed

  def initialize
    @keys_down = []
    @keys_pressed = []
    @already_handled = []
    @pending_events = []
  end

  def method_missing(m, *args, &block)
    event = args[0]
    case m
    when :keyPressed, :key_pressed
      queue_event Event.new(event.key_code, true)
    when :keyReleased, :key_released
      queue_event Event.new(event.key_code, false)
    end
  end

  def queue_event(e)
    @pending_events << e
  end

  def handle_event(e)
    if @already_handled.include? e.key_code
      @pending_events << e
      return
    end
    @already_handled << e.key_code
    if e.down
      @keys_down << e.key_code
      @keys_pressed << e.key_code
    else
      @keys_down.delete e.key_code
      @keys_pressed.delete e.key_code
    end
  end

  # Clears the 'pressed' list and handles any pending events.
  def clear
    @keys_pressed.clear
    @already_handled.clear
    handle_pending_events
  end

  # Interprets pending key events to figure out what keys are down/pressed.
  def handle_pending_events
    pending = @pending_events
    @pending_events = []
    pending.each do |e|
      handle_event e
    end
  end
end

class Controller
  attr_accessor :bindings
  def initialize(key_handler)
    @key_handler = key_handler
    @bindings = {}
  end

  def bindings=(m)
    @bindings = m
    @rev_bindings = invert(m)
  end

  # Inverts a map.
  def invert(m)
    result = {}
    m.each do |k, v|
      result[v] = k
    end
    result
  end

  # Is the given named key down?
  def down?(key)
    @key_handler.keys_down.include? vk_for(key)
  end

  # Has the given named just been pressed?
  def pressed?(key)
    @key_handler.keys_pressed.include? vk_for(key)
  end

  def vk_for(key)
    raise "'#{key}' isn't bound" unless @bindings.include? key
    @bindings[key]
  end

  # keys - A list of VK_ values.
  # return - The corresponding list of named keys.
  def rev_map(keys)
    keys.clone.delete_if{|x|
      not @rev_bindings.include? x
    }.map{|x|
      @rev_bindings[x]
    }
  end

  # What keys have just been pressed?
  def keys_pressed
    rev_map(@key_handler.keys_pressed)
  end

  # What keys are currently down?
  def keys_down
    rev_map(@key_handler.keys_down)
  end

  def clone
    Controller.new(@key_handler)
  end
end
