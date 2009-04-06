# MotherSubber is an experimental tool which allows you to replace 
# objects deep within aggregates.  The intention is that you create 
# aggregates in an ObjectMother and then use MotherSubber to replace 
# bits and pieces for individual tests.
#
# It's rather easy to use MotherSubber. You simply include MotherSubber
# in a class and then use the 'with' method to replace a piece.  In the 
# simplest case, you supply 'with' with a list containing exactly one 
# symbol.  MotherSubber walks through the object and all of its sub-objects
# and it tries to find an instance variable with that name.  If it finds
# exactly one, it sets that instance variable to point to the object you
# supply as the other argument to 'with.'  If MotherSubber finds zero or 
# more than one matches, it throws an exception. Since MotherSubber is 
# intended to be used in tests, it is convenient to just throw an exception
# when it's obvious that the internals of the object aren't what the user
# expected them to be.
#
# If you've read this far you are probably thinking that it is rather 
# ridiculous assume that all instance variables in an aggregate are
# uniquely named.  What MotherSubber says (through it's API) is "wouldn't
# it be nice if they were?" But, since reality often intrudes in awkward
# ways, MotherSubber accepts a list of symbols which represent a partial
# path to an object.  You can specify just as many leading instance 
# variable names as you need to disambiguate the object you want to replace.

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
