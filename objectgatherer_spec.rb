

require 'objectgatherer'
require 'obj'

describe ObjectGatherer do
  
  it "gathers an object and its subobject" do
    ObjectGatherer.objects_of(Obj.new("a" => Obj.new)).size.should == 2
  end
   
  it "gathers an object, its subobject, and its subobject's subobject" do
    ObjectGatherer.objects_of(Obj.new("one" => Obj.new("two" => Obj.new))).size.should == 3
  end
   
  it "gathers only two objects when a subobject is shared" do
    shared = Obj.new
    ObjectGatherer.objects_of(Obj.new("one" => shared, "two" => shared)).size.should == 2
  end

end
