require 'key_handler'
require 'ostruct'
require 'mocha'

def event(n)
  OpenStruct.new :key_code => n
end


Spec::Runner.configure do |config|
  config.mock_with :mocha
end

describe KeyHandler do
  before(:each) do
    @kh = KeyHandler.new
  end
  
  it "remembers which keys are down" do
    @kh.key_pressed event(1)
    @kh.clear
    @kh.keys_down.should include 1
  end
  
  it "forgets that a key is down when it is released" do
    @kh.key_pressed event(1)
    @kh.clear
    @kh.key_released event(1)
    @kh.clear
    @kh.keys_down.should_not include 1
  end
  
  it "remembers what keys are newly pressed (pressed before a call to clear)" do
    @kh.key_pressed event(1)
    @kh.clear
    @kh.keys_pressed.should include 1
  end
  
  it "discards old key press events" do
    @kh.key_pressed event(1)
    @kh.clear
    @kh.clear
    @kh.keys_pressed.should_not include 1
  end
  
  it "handles multiple different keys at the same time" do
    @kh.key_pressed event(1)
    @kh.key_pressed event(2)
    @kh.clear
    
    @kh.keys_pressed.should include 1
    @kh.keys_pressed.should include 2
    @kh.keys_down.should include 1
    @kh.keys_down.should include 2
  end

  it "only processes key events on a single key one at a time" do
    @kh.key_pressed event(1)
    @kh.key_released event(1)
    @kh.clear

    @kh.keys_pressed.should include 1
    @kh.keys_down.should include 1

    @kh.clear

    @kh.keys_pressed.should_not include 1
    @kh.keys_down.should_not include 1
  end

  it "queues up key events and handles them one at a time on each clear" do
    @kh.key_pressed event(1)
    @kh.key_released event(1)
    @kh.key_pressed event(1)
    @kh.key_released event(1)

    @kh.keys_pressed.should_not include 1
    @kh.clear
    @kh.keys_pressed.should include 1
    @kh.clear
    @kh.keys_pressed.should_not include 1
    @kh.clear
    @kh.keys_pressed.should include 1
    @kh.clear
    @kh.keys_pressed.should_not include 1
  end
end
