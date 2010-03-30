require 'rect'

Spec::Matchers.define :contain do |x|
  match do |range|
    range.contains? x
  end
end

describe Segment do
  it "contains points" do
    r = Segment.new(0, 10)
    r.should contain(3)
  end

  it "doesn't contain its endpoint" do
    r = Segment.new(0, 10)
    r.should_not contain 10
  end

  it "does contain its startpoint" do
    r = Segment.new(0, 10)
    r.should contain 0
  end

  it "can be intersected with another segment" do
    r = Segment.new(0, 10)
    r2 = Segment.new(5, 5)

    r.intersect(r2).should == r2
  end

  it "has an intersection that starts at the higher lower bound" do
    r = Segment.new(0, 10)
    r2 = Segment.new(5, 10)

    r.intersect(r2).should == Segment.new(5, 5)
  end

  it "has the correct intersection when intersected with something larger than itself" do
    r = Segment.new(5, 10)
    r2 = Segment.new(0, 100)

    r.intersect(r2).should == r
  end

  it "should return the smallest included point when 'low' is invoked" do
    r = Segment.new(5, 10)
    r.low.should == 5
  end

  it "should return the point one higher than the largest included point when 'high' is invoked" do
    r = Segment.new(5, 10)
    r.high.should == 15
  end

  it "returns nil when intersected with a range that doesn't intersect" do
    r = Segment.new(0, 10)
    r2 = Segment.new(10, 10)

    r.intersect(r2).should == Segment::EMPTY
  end

  it "should be empty if it has zero length" do
    r = Segment.new(5, 0)
    r.should be_empty
  end

  it "can be moved" do
    r = Segment.new(5, 10)
    r2 = r.move(3)
    r2.low.should == 8
    r2.high.should == 18
  end
end

describe Rect do
  def rect_with_dims(w, h, z)
    Rect.new [0, 0, 0], [w, h, z]
  end

  it "takes dimensions in the constructor" do
    r = Rect.new [1, 2, 10], [3, 4, 11]
    r.width.should == 3
    r.height.should == 4
    r.depth.should == 11
    r.x.should == 1
    r.y.should == 2
    r.z.should == 10
    r.xx.should == 4
    r.yy.should == 6
    r.zz.should == 21
  end

  it "is equal to rects with the same dimensions and position" do
    r = Rect.new [1, 2, 10], [3, 4, 11]
    r2 = Rect.new [1, 2, 10], [3, 4, 11]
    r.should == r2
  end

  it "is not equal to rects with different dimensions and position" do
    r = Rect.new [1, 2, 10], [3, 4, 11]
    r2 = Rect.new [0, 0, 10], [0, 0, 11]

    r.should_not == r2
  end

  it "can be intersected with other rects" do
    r = Rect.new [0, 0, 0], [5, 5, 5]
    r2 = Rect.new [0, 0, 0], [3, 3, 3]

    r.intersect(r2).should == r2
  end
  
  it "returns an empty rect when intersected with a non-overlapping rect" do
    r = Rect.new [0, 0, 0], [5, 5, 5]
    r2 = Rect.new [5, 5, 5], [5, 5, 5]
    r.intersect(r2).should be_empty
  end
  
  it "is empty when it has no area" do
    rect_with_dims(0, 5, 0).should be_empty
    rect_with_dims(5, 0, 1).should be_empty
    rect_with_dims(0, 0, 0).should be_empty
    rect_with_dims(1, 2, 3).should_not be_empty
  end
  
  it "is null when it has no dimensions" do
    rect_with_dims(0, 0, 0).should be_null
    rect_with_dims(0, 1, 0).should_not be_null
  end

  it "can be queried for its x range" do
    r = Rect.new [0, 0, 0], [4, 5, 6]

    r.x_range.should == Segment.new(0, 4)
  end

  it "can be moved" do
    r = Rect.new [0, 0, 0], [5, 5, 5]
    r.move(3, 4, 5)
    r.x.should == 3
    r.y.should == 4
    r.z.should == 5
  end

  it "should support floating point values" do
    r = Rect.new [0.5, 0.5, 0.5], [5, 5, 5]
    r.x.should == 0.5

    r.move(3.5, 0, 0)
    r.x.should == 4.0
  end

  it "pads out incomplete rectangles with zeroes" do
    r = Rect.new [1], [2]
    r.x.should == 1
    r.y.should == 0
    r.z.should == 0

    r.width.should == 2
    r.height.should == 0
    r.depth.should == 0
  end

  it "intersects correctly" do
    r = Rect.new [3, 10], [10, 10, 10]
    r2 = Rect.new [10, 10], [10, 10, 10]
    ir = r.intersect(r2)
    ir.width.should == 3
    ir.height.should == 10
    ir.depth.should == 10

    r = Rect.new [0, 0, -16], [32, 32, 16]
    r2 = Rect.new [1.0, 0.0, 0.0], [16, 16, 16]
    ir = r.intersect(r2)
    ir.should be_empty
  end

  it "knows its midpoint" do
    r = Rect.new [4, 4, 4], [4, 4, 4]
    r.midpoint.should == Vector.new(6, 6, 6)

    r = Rect.new [0, 0, 0], [2, 2, 2]
    r.midpoint.should == Vector.new(1, 1, 1)

    r = Rect.new [10, 20, 30], [10, 20, 30]
    r.midpoint.should == Vector.new(15, 30, 45)
  end

  it "can have its position set" do
    r = Rect.new [0, 0, 0], [1, 2, 3]
    r.pos = [1, 2, 3]
    r.should == Rect.new([1, 2, 3], [1, 2, 3])
  end

  it "can have its dimensions set" do
    r = Rect.new [0, 0, 0], [1, 2, 3]
    r.width = 10
    r.height = 20
    r.depth = 30
    r.should == Rect.new([0, 0, 0], [10, 20, 30])
  end

  it "can be created from a midpoint" do
    r = Rect.from_midpoint([10, 10, 10], [20, 20, 20])
    r.should == Rect.new([0, 0, 0], [20, 20, 20])
  end

  it "can be manipulated independently from its clone" do
    r = Rect.new([0, 0, 0], [10, 10, 10])
    r2 = r.clone
    r.width = 5
    r2.width.should == 10
  end

  it "returns false when compared to nil" do
    Rect.new([0, 1, 2], [10, 10, 10]).should_not == nil
  end

  it "can intersect as a square with another rect" do
    r = Rect.new [0, 0, 0], [10, 10, 0]
    r2 = Rect.new [5, 5, 0], [10, 10, 0]

    ir = r.intersect(r2)
    ir.width.should == 5
    ir.height.should == 5
  end

  it "can grow" do
    r = Rect.new [0, 0, 0], [5, 5, 5]
    r.grow(Vector.new(1, 2, 3))
    r.width.should == 6
    r.height.should == 7
    r.depth.should == 8
  end
end
