

require 'mothersubber'
require 'obj'

describe MotherSubber do
  
  it "should throw when there is no match" do
    lambda { Obj.new.with([:@foo], 0) }.should raise_error(MotherSubber::NoMatchException)
  end
  
  it "should substitute when it matches" do
    object = Obj.new "foo" => 0
    object.with([:@foo], 1)
    object.foo.should == 1
  end
  
  it "should substitute when it matches a sub-object attribute" do
    object = Obj.new "foo" => (Obj.new "bar" => 0)
    object.with([:@bar], 1)
    object.foo.bar.should == 1
  end
  
  it "should run to completion even when it has cyclic references" do    
    a = Obj.new "other" => 0
    b = Obj.new "other" => 0
    a.other = b
    b.other = a
    
    lambda { a.with([:@other], 0) }
  end
  
  it "should throw when there is more than one attribute match" do
    object = Obj.new "dup" => 0, "foo" => (Obj.new "dup" => 1)
    lambda { object.with([:@dup], Object.new) }.should raise_error(MotherSubber::TooManyMatchesException)
  end
  
  it "should substitute when it is given a path" do
    object = Obj.new "foo" => (Obj.new "bar" => 0)
    object.with([:@foo, :@bar], 1)
    object.foo.bar.should == 1
  end
  
  it "should substitute on an inner match" do
    f = Obj.new "g" => 0
    e = Obj.new "f" => f
    d = Obj.new "e" => e
    c = Obj.new "d" => d
    b = Obj.new "c" => c
    a = Obj.new "b" => b
    
    a.with([:@d, :@e], 1)
    a.b.c.d.e.should == 1
  end
  
end
