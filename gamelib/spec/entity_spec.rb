require 'entity'

describe Entity do
  it "can have children" do
    entity = Entity.new
    entity << Entity.new
    entity.children.size.should == 1
  end
  
  it "has a position that defaults to [0, 0]" do
    entity = Entity.new
    entity.pos.should == [0, 0]
    entity.x.should == 0
    entity.y.should == 0
  end
  
  it "can have a position specified in its constructor" do
    entity = Entity.new [10, 10]
    entity.pos.should == [10, 10]
  end
  
  it "can have its position changed" do
    entity = Entity.new [10, 10]
    entity.pos = [20, 20]
    entity.pos.should == [20, 20]
  end
  
  it "moves children when it moves" do
    entity = Entity.new
    child = Entity.new [0, 0]
    entity << child
    
    entity.pos = [10, 0]
    child.pos.should == [10, 0]
  end
  
  it "positions its children relative to its upper left corner by default" do
    entity = Entity.new [10, 10], [100, 100]
    child = Entity.new [10, 10]
    entity << child
    entity.children[0].pos.should == [20, 20]
  end
  
  it "has dimensions that default to [0, 0]" do
    entity = Entity.new
    entity.dims.should == [0, 0]
  end
  
  it "has dimensions" do
    entity = Entity.new
    entity.dims = [3, 5]
    entity.width.should == 3
    entity.height.should == 5
  end
  
  it "has a horizontal alignment, that is left by default" do
    entity = Entity.new
    entity.x_align.should == :left
  end
  
  it "aligns its right side to its parent when right aligned" do
    entity = Entity.new [0, 0], [20, 20]
    child = Entity.new [0, 0], [5, 5]
    child.x_align = :right
    entity << child
    child.x.should == 15
  end
  
  it "aligns its top to its parent when top aligned" do
    entity = Entity.new [0, 0], [20, 20]
    child = Entity.new [0, 0], [5, 5]
    entity << child
    child.y.should == 0
  end
  
  it "applies its offset away from the edge in its parent that it is aligned to" do
    entity = Entity.new [0, 0], [20, 20]
    child = Entity.new [0, 10], [1, 1]
    entity << child
    child.y.should == 10
  end
  
  it "applies its offset away from the bottom edge if that is what it is aligned to" do
    entity = Entity.new [0, 0], [20, 20]
    child = Entity.new [0, 10], [5, 5], [:bottom, :left]
    entity << child
    child.y.should == 5
  end
  
  it "applies its offset away from the right edge if that is what it is aligned to" do
    entity = Entity.new [0, 0], [20, 20]
    child = Entity.new [5, 0], [5, 5], [:bottom, :right]
    entity << child
    child.x.should == 10
  end
  
  it "can have attributes" do
    entity = Entity.new
    entity.attributes = [:something, :something_else]
    entity[:something] = 5
    entity[:something].should == 5
  end
  
  it "should raise an exception when an attribute that wasn't declared was referenced" do
    entity = Entity.new
    entity.attributes = [:not_x]
    exception_thrown = false
    begin
      entity[:x] = 5
    rescue Exception => e
      exception_thrown = true
    end
    exception_thrown.should == true
  end
end