require_relative 'graph/node'

class Ar2Uml::NodeFromAppModelBuilder
  attr_reader :node
  
  def initialize(app_model)
    @app_model = app_model
  end
  
  def process
    @node = Ar2Uml::Node.new(label:@app_model.table_name, attributes: @app_model.model_attributes)
    @app_model.belonging_models.each do |belonging_app_model|
      child_builder = Ar2Uml::NodeFromAppModelBuilder.new(belonging_app_model.values.first)
      child_builder.process
      @node.edges << Ar2Uml::Edge.new({from:@node, to:child_builder.node})
    end
  end
end