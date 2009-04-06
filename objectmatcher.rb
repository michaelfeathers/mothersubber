

class ObjectMatcher
  
  def self.head(list)
    list.first
  end
  
  def self.tail(list)
    list[1..-1]
  end
  
  def self.matched_object(attr_symbols, object) 
    return nil if attr_symbols.length == 0
    
    partial_match = object.instance_variable_get(head(attr_symbols))
    return nil if not partial_match
    
    attr_symbols.length == 1 ? object : matched_object(tail(attr_symbols), partial_match)
  end
   
end