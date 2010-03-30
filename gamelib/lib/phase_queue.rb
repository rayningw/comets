class PhaseWrapper
  def initialize(phase, before, after)
    @phase = phase
    @before, @after = before, after
  end
  
  def tick(n)
    if @before != nil
      @before[@phase]
    end
    result = @phase.tick(n)
    if @after != nil
      @after[@phase]
    end
    result
  end
  
  def spawn_children
    if @phase.respond_to? :spawn_children
      @phase.spawn_children
    else
      []
    end
  end
end

class PhaseQueue
  def initialize(queue=[])
    @queue = queue
    @after_tick = nil
    @before_tick = nil
  end
  
  def <<(phase)
    @queue << wrap_phase(phase, @before_tick, @after_tick)
  end
  
  def wrap_phase(phase, before, after)
    PhaseWrapper.new(phase, before, after)
  end
  
  def tick(n)
    return true if @queue.empty?
    cur_phase = @queue[0]
    is_done = cur_phase.tick(n)
    if is_done
      @queue.shift
      spawned_children = cur_phase.spawn_children
      @queue = spawned_children + @queue
    end
    @queue.empty?
  end
  
  def phases_remaining
    @queue.size
  end
  
  def phases
    @queue
  end
  
  def after_tick(&after_tick)
    @after_tick = after_tick
  end
  
  def before_tick(&before_tick)
    @before_tick = before_tick
  end
end
