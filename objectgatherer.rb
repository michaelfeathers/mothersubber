

require 'set'

class ObjectGatherer
  
  def self.objects_of(source)
     set = Set.new
     gather_objects(source, set)
     set.to_a
   end

   def self.gather_objects(source_object, set)
     return if not set.add? source_object 
     source_object.instance_variables.each do |var|
       gather_objects(source_object.instance_variable_get(var), set)
     end
   end
   
end