require 'mocha'
require 'phase_queue'

module Matchers
  class HaveName
    def initialize(expected_name)
      @expected_name = expected_name
    end
    
    def matches?(actual)
      @actual = actual
      @expected_name == @actual.name
    end
    
    def failure_message
      "expected something with name '#@expected_name', but got something with name '#{@actual.name}'"
    end
    
    def negative_failure_message
      "expected something with a name that isn't #@expected_name"
    end
  end  
    
  def have_name(name)
    HaveName.new(name)
  end
end

Spec::Runner.configure do |config|
  config.mock_with :mocha
  config.include(Matchers)
end

class DummyPhase
  attr_accessor :phase_queue, :name
  
  def initialize(name='Dummy')
    @name = name
  end
  
  def spawn_children
    []
  end
  
  def has_name?
    true
  end
  
  def to_s
    "DummyPhase #{@name}"
  end
end

describe PhaseQueue do
  it "removes phases when they are done" do
    pq = PhaseQueue.new
    wait_phase = DummyPhase.new
    wait_phase.expects(:tick).with(anything).returns(true)
    pq << wait_phase
    pq.tick(100)
    pq.phases_remaining.should == 0
  end

  it "retains phases that aren't done" do
    pq = PhaseQueue.new
    wait_phase = DummyPhase.new
    wait_phase.expects(:tick).with(anything).returns(false)
    pq << wait_phase
    pq.tick(50)
    pq.phases_remaining.should == 1
  end
  
  it "asks phases for their spawned children when they finish" do
    pq = PhaseQueue.new
    spawn_phase = DummyPhase.new
    spawn_phase.expects(:tick).with(anything).returns(true)
    spawn_phase.expects(:spawn_children).returns([])
    
    pq << spawn_phase
    pq.tick(100)
  end
  
  it "adds spawned children at the beginning of the queue" do
    pq = PhaseQueue.new
    spawn_phase = DummyPhase.new "spawner"
    child_phase = DummyPhase.new "spawned"
    tail_phase = DummyPhase.new "tail"
    spawn_phase.stubs(:tick).with(100).returns(true)
    spawn_phase.expects(:spawn_children).returns([child_phase])
    
    pq << spawn_phase
    pq << tail_phase
    pq.phases_remaining.should == 2
    pq.tick(100)
    pq.phases_remaining.should == 2
    pq.phases[0].should have_name("spawned")
  end
  
  it "signals done when there are no phases in it" do
    pq = PhaseQueue.new
    pq.tick(100).should == true
  end
  
  it "signals done when the only phase it has finishes and doesn't spawn any children" do
    pq = PhaseQueue.new
    phase = DummyPhase.new
    pq << phase
    phase.stubs(:tick).with(anything).returns(true)
    pq.tick(100).should == true
  end
  
  it "signals 'not done' when it has a phase that isn't finished" do
    pq = PhaseQueue.new
    phase = DummyPhase.new
    phase.stubs(:tick).with(anything).returns(false)
    pq << phase
    pq.tick(100).should == false
  end
  
  it "allows an 'after tick' method to be specified, to be called after each tick" do
    pq = PhaseQueue.new
    pq.after_tick do |phase|
      phase.something_phase_specific
    end
    phase = DummyPhase.new
    pq << phase
    seq = sequence('sequence')
    phase.expects(:tick).in_sequence(seq)
    phase.expects(:something_phase_specific).in_sequence(seq)
    pq.tick(100)
  end
  
  it "allows a 'before tick' method to be specified, to be called before each tick" do
    pq = PhaseQueue.new
    pq.before_tick do |phase|
      phase.something_phase_specific
    end
    phase = DummyPhase.new
    pq << phase
    seq = sequence('sequence')
    phase.expects(:something_phase_specific).in_sequence(seq)
    phase.expects(:tick).in_sequence(seq)
    pq.tick(100)
  end
  
  it "calls the 'after tick' method on a phase after its final tick" do
    pq = PhaseQueue.new
    pq.after_tick do |phase|
      phase.something_phase_specific
    end
    phase = DummyPhase.new
    phase.expects(:tick).returns(true)
    phase.expects(:something_phase_specific)
    pq << phase
    pq.tick(1)
  end
  
  it "can have its backing queue structure specified in the constructor" do
    queue = []
    pq = PhaseQueue.new queue
    pq << DummyPhase.new
    queue.size.should == 1
  end
  
  it "modifies phases coming in so that they define before / after ticks" do
    queue = []
    pq = PhaseQueue.new queue
    pq2 = PhaseQueue.new queue
    
    pq.after_tick do |phase|
      phase.blah
    end
    
    pq2.after_tick do |phase|
      phase.from_q2
    end
    
    phase = DummyPhase.new "one"
    phase.expects(:tick).returns(true)
    phase.expects(:blah)
    phase2 = DummyPhase.new "two"
    phase2.expects(:tick).returns(true)
    phase2.expects(:from_q2)
    
    pq << phase
    pq2 << phase2
    
    pq.tick(1)
    pq.tick(1)
  end
end
