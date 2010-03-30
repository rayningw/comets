require 'collision_service'

describe Vector do
  it "can create other vectors in the opposite direction to itself" do
    v = Vector.new(1, 1, 1)
    v2 = v.in_reversed_direction(3, 3, 3)
    v2.should == Vector.new(-3, -3, -3)
    
    v = Vector.new(-1, 1, 1)
    v.in_reversed_direction(3, 4, 5).should == Vector.new(3, -4, -5)
  end
  
  it "can create new vectors that only consider the smallest non-zero axis" do
    Vector.new(1, 0, 0).smallest_positive_axis.should == Vector.new(1, 0, 0)
    Vector.new(3, 4, 0).smallest_positive_axis.should == Vector.new(3, 0, 0)
    Vector.new(-3, -5, 0).smallest_positive_axis.should == Vector.new(-3, 0, 0)
    Vector.new(-3, -5, -1).smallest_positive_axis.should == Vector.new(0, 0, -1)
  end
  
  it "should favour lower order axes in SPA operations when there are equals" do
    Vector.new(5, 5, 0).smallest_positive_axis.should == Vector.new(5, 0, 0)
    Vector.new(0, 5, 5).smallest_positive_axis.should == Vector.new(0, 5, 0)
    Vector.new(5, 5, 5).smallest_positive_axis.should == Vector.new(5, 0, 0)
  end

  it "is equal to another vector if they both have the same fields" do
    v = Vector.new(1, 2, 3)
    v.should == Vector.new(1, 2, 3)
  end

  it "is empty? when all of its values are zero" do
    Vector.new(0.0, 0.0, 0.0).should be_empty
  end

  it "can be converted to an array" do
    Vector.new(1, 2, 3).to_a.should == [1, 2, 3]
  end

  it "can be negated" do
    Vector.new(1, 2, 3).negate.should == Vector.new(-1, -2, -3)
  end

  it "can be multiplied by a number" do
    (Vector.new(1, 2, 3) * 1.5).should == Vector.new(1.5, 3.0, 4.5)
  end

  it "can be multiplied by a vector" do
    (Vector.new(1, 2, 3) * Vector.new(3, 4, 5)).should == Vector.new(3, 8, 15)
  end

  it "can be added to a number" do
    (Vector.new(1, 2, 3) + 1.5).should == Vector.new(2.5, 3.5, 4.5)
  end

  it "can be added to a vector" do
    (Vector.new(1, 2, 3) + Vector.new(2, 3, 4)).should == Vector.new(3, 5, 7)
  end

  it "can have a number subtracted from it" do
    (Vector.new(1, 2, 3) - Vector.new(2, 3, 4)).should == Vector.new(-1, -1, -1)
  end

  it "can be divided by a number" do
    (Vector.new(1, 2, 3) / 2.0).should == Vector.new(0.5, 1.0, 1.5)
  end

  it "can be normalized" do
    Vector.new(1.0, 0.0, 0.0).normalize.should == Vector.new(1.0, 0.0, 0.0)
  end

  it "has a magnitude" do
    Vector.new(1.0, 0.0, 0.0).magnitude.should == 1.0
  end
end
