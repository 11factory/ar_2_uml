require_relative 'graph/node'

class Ar2Uml::NodeFromAppModelBuilder
  attr_reader :node
  
  def initialize(app_model, limit_first_belongings = false, node_stack = {}, level = 0)
    @app_model = app_model
    @node_stack = node_stack
    @level = level
    @limit_first_belongings = limit_first_belongings
  end
  
  def process
    candid_node_label = @app_model.table_name
    if((@node = existing_node_in_call_stack_with_label(candid_node_label)))
      return
    end
    @node = Ar2Uml::Node.new(label:candid_node_label, attributes: @app_model.model_attributes)
    @node_stack[candid_node_label] = @node
    unless(@limit_first_belongings && @level >= 1)
      @app_model.belonging_models.each do |belonging_app_model|
        belonging_node = nil
        if(belonging_app_model[:model] == @app_model)
          belonging_node = @node
        else
          child_builder = Ar2Uml::NodeFromAppModelBuilder.new(belonging_app_model[:model], @limit_first_belongings, @node_stack, @level + 1)
          child_builder.process
          belonging_node = child_builder.node
        end
        edge = Ar2Uml::Edge.new({label:belonging_app_model[:relation_name], from:@node, to:belonging_node})
        @node.edges << edge
      end
      @node_stack = []
    end
  end
  
  private
  
  def existing_node_in_call_stack_with_label(label)
    @node_stack[label]
  end
end