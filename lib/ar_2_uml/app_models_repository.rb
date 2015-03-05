require 'active_support/core_ext/string'

class Ar2Uml::AppModelsRepository

  def all
    ObjectSpace.each_object(::Class).select {|o|o.methods.include?(:table_name)}
  end
  
  def load(object_name)
    all.select {|object|
      object.to_s == object_name
    }.first || object_name.constantize rescue nil
  end
  
end