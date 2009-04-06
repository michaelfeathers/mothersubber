

require 'objectgatherer'
require 'objectmatcher'

module MotherSubber
  
  class NoMatchException < Exception; end
  class TooManyMatchesException < Exception; end
  
  def with(attr_symbols, new_object)
    matching_objects = collect_matching_objects(attr_symbols)
    
    raise NoMatchException          if matching_objects.size == 0
    raise TooManyMatchesException   if matching_objects.size > 1
    
    substitute_object(matching_objects, attr_symbols.last, new_object)
  end
  
  def collect_matching_objects(attr_symbols)
    matching_objects = []
    ObjectGatherer.objects_of(self).each do |object|
      matched = ObjectMatcher.matched_object(attr_symbols, object)
      matching_objects << matched if matched 
    end
    matching_objects
  end
   
   def substitute_object(objects, attr_symbol, new_object)
      objects.each do |element|
        element.instance_variable_set(attr_symbol, new_object)
      end
   end
   
end
