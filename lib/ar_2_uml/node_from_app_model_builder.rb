require_relative 'graph/node'

class Ar2Uml::NodeFromAppModelBuilder
  attr_reader :node
  
  def initialize(app_model)
    @app_model = app_model
  end
  
  def process
    @node = Ar2Uml::Node.new(label:@app_model.table_name, attributes: @app_model.model_attributes)
    @app_model.belonging_models.each do |belonging_app_model|
      belonging_node = nil
      if(belonging_app_model[:model] == @app_model)
        belonging_node = @node
      else
        child_builder = Ar2Uml::NodeFromAppModelBuilder.new(belonging_app_model[:model])
        child_builder.process
        belonging_node = child_builder.node
      end
      @node.edges << Ar2Uml::Edge.new({label:belonging_app_model[:relation_name], from:@node, to:belonging_node})
    end
  end
end