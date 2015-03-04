class Ar2Uml::AppModelsRepository

  def all
    ObjectSpace.each_object(::Class).select {|o|o.methods.include?(:table_name)}
  end
  
end