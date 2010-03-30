require 'timer'

DURATION = 100
START = 0
FINISH = 10

describe Slider do
  before :each do
    @s = Slider.new(DURATION, START, FINISH)
  end
  
  it "returns the starting point when no time has passed" do
    @s.get.should == START
  end
  
  it "returns the finishing value when the duration has passed" do
    @s.tick(DURATION)
    @s.get.should == FINISH
  end
  
  it "returns the finishing value after duration has passed" do
    @s.tick(DURATION * 100)
    @s.get.should == FINISH
  end
  
  it "returns a point halfway between start and finish when the duration is half over" do
    @s.tick(DURATION / 2)
    @s.get.should == ((FINISH - START) / 2)
  end
  
  it "works whether or not finish or start is larger" do
    @s = Slider.new(100, 100, 0)
    @s.tick(10)
    @s.get.should == 90
  end
  
  it "returns true when it ticks to completion" do
    @s.tick(DURATION).should == true
  end
  
  it "returns true when it is ticked past completion" do
    @s.tick(DURATION)
    @s.tick(DURATION).should == true
  end
  
  it "returns floats for fractional results" do
    @s = Slider.new(100, 0, 1)
    @s.tick(10)
    @s.get_f.should == 0.1
  end
end