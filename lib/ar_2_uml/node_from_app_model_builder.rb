require_relative 'graph/node'

class Ar2Uml::NodeFromAppModelBuilder
  attr_reader :node
  
  def initialize(app_model, node_stack = [])
    @app_model = app_model
    @node_stack = node_stack
  end
  
  def process
    candid_node = Ar2Uml::Node.new(label:@app_model.table_name, attributes: @app_model.model_attributes)
    if((@node = existing_node_in_call_stack(candid_node)))
      return
    else
      @node = candid_node
    end
    @node_stack << @node
    @app_model.belonging_models.each do |belonging_app_model|
      belonging_node = nil
      if(belonging_app_model[:model] == @app_model)
        belonging_node = @node
      else
        child_builder = Ar2Uml::NodeFromAppModelBuilder.new(belonging_app_model[:model], @node_stack)
        child_builder.process
        belonging_node = child_builder.node
      end
      edge = Ar2Uml::Edge.new({label:belonging_app_model[:relation_name], from:@node, to:belonging_node})
      @node.edges << edge
      belonging_node.incoming_edges << edge
    end
    @node_stack = []
  end
  
  private
  
  def existing_node_in_call_stack(candid_node)
    @node_stack.select { |node|
      node.label == candid_node.label
    }.first
  end
end