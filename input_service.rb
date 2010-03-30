#!ruby

class InputService
  def initialize(controller)
    @controller = controller
    @key_events = {}
  end

  def add_keyevent(key, &action)
    @key_events[key] = action
  end

  def delete_keyevent(key)
    @key_events.delete(key)
  end

  def tick(millis)
    # Execute the keyevents that were satisfied
    @key_events.each do |key, action|
      if @controller.down? key
        action.call
      end
    end
  end
end
