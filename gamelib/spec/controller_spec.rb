require 'key_handler'

def event(n)
  OpenStruct.new :key_code => n
end

describe Controller do
  before :each do
    @kh = KeyHandler.new
    @c = Controller.new(@kh)
  end

  it "knows which keys are pressed" do
    @c.bindings = {
      :a => 1,
      :b => 2,
    }
    @kh.key_pressed event(1)
    @kh.key_pressed event(2)

    @kh.clear
    keys = @c.keys_pressed
    keys.should include :a
    keys.should include :b
    keys.count.should == 2
  end

  it "doesn't mutate @key_handler.keys_down when keys_down is called" do
    c1 = @c.clone
    c2 = @c.clone

    c1.bindings = {
      :a => 1,
      :b => 2
    }

    c2.bindings = {
      :f => 3,
      :g => 4
    }

    @kh.key_pressed event(1)
    @kh.key_pressed event(3)

    @kh.clear
    # This method used to mutate the underlying @keys_down list, causing
    # errors in cloned controllers' output.
    c1.keys_down.should include :a
    c2.down?(:f).should == true
  end
end
