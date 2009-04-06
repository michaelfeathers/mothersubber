

require 'objectmatcher'
require 'obj'

describe ObjectMatcher do

  it "can match a single symbol with an object's instance variable" do
    object = Obj.new "foo" => 0
    ObjectMatcher.matched_object([:@foo], object).should == object
  end
  
  it "returns nil when it can't match a symbol to an instance variable" do
    object = Obj.new "foo" => 0
    ObjectMatcher.matched_object([:@bar], object).should be_nil
  end
  
  it "returns nil when asked to match against an empty symbol list" do
    object = Obj.new "foo" => 0
    ObjectMatcher.matched_object([], object).should be_nil
  end
  
  it "returns nil when asked to match symbols against nil" do
    object = Obj.new
    ObjectMatcher.matched_object([:@foo], nil).should be_nil
  end
   
  it "can match a symbol list against an object structure" do
    inner_object = Obj.new "bar" => 0
    object = Obj.new "foo" => inner_object
    ObjectMatcher.matched_object([:@foo, :@bar], object).should == inner_object
  end
   
  it "returns nil when a complete symbol list isn't matched" do
    object = Obj.new "foo" => (Obj.new "bar" => 0)
    ObjectMatcher.matched_object([:@foo, :@blah], object).should be_nil
  end

end
