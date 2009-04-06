


class ObjectMatcher
  
  def self.matched_object(attr_symbols, object) 
    return nil if attr_symbols.length == 0
    
    partial_match = object.instance_variable_get(attr_symbols.first)
    return nil if not partial_match
    
    attr_symbols.length == 1 ? object : matched_object(attr_symbols[1..-1], partial_match)
  end
   
end