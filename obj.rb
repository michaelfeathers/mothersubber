
require 'mothersubber'

class Obj
  include MotherSubber
   
  def initialize(hash = {})
    hash.each_pair do |attrib_name, value|
      instance_variable_set("@#{attrib_name}", value) 
      metaclass = class << self; self; end
      metaclass.instance_eval { attr_accessor attrib_name }
    end
  end
end