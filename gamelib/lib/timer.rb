#!/usr/bin/ruby

class Timer
  def initialize(period)
    @period = period
    @ticks = 0
  end
  
  def tick(n)
    @ticks += n
    result = @ticks / @period
    @ticks %= @period
    result
  end
  
  def period=(period)
    percent_through_current_period = @ticks.to_f / @period
    @period = period
    @ticks = (percent_through_current_period * @period).to_i
  end
end

class Slider
  def initialize(duration, start, finish)
    @duration, @start, @finish = duration, start, finish
    @timeElapsed = 0
  end
  
  def tick(n)
    @timeElapsed += n
    @timeElapsed >= @duration
  end
  
  def get_f
    return @finish if @timeElapsed >= @duration
    result = @start + (@finish - @start) * (@timeElapsed.to_f / @duration.to_f)
    result
  end
  
  def get
    get_f.to_i
  end
end