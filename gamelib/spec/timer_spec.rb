require 'timer'

describe Timer, "#tick" do
  it "returns 0 when it hasn't ticked past its limit" do
    t = Timer.new(100)
    t.tick(10).should == 0
  end
  
  it "returns 1 when it has ticked past its limit" do
    t = Timer.new(100)
    t.tick(100).should == 1
  end
  
  it "returns a number when it gets ticked over its limit" do
    t = Timer.new(100)
    t.tick(50).should == 0
    t.tick(40).should == 0
    t.tick(20).should == 1
  end
  
  it "returns N for how many times over its limit it has been ticked" do
    t = Timer.new(100)
    t.tick(300).should == 3
  end
  
  it "can be retargeted to a new period" do
    t = Timer.new(100)
    t.period = 50
    t.tick(50).should == 1
  end
  
  it "preserves its progress through its current period when retargeted to a new period" do
    t = Timer.new(100)
    t.tick(50) # Half way done
    t.period = 50
    t.tick(25).should == 1
  end
end