require_relative 'uml_visitor'
require_relative 'uml_edge_visitor'

class Ar2Uml::UMLNodeVisitor < Ar2Uml::UMLVisitor

  def initialize(output_io)
    @output_io = output_io
    @visited_node_stack = []
  end
  
  def visit(node)
    @visited_node_stack << node
    node_attributes = []
    node.attributes.each_pair do |name, type|
      node_attributes << "+#{name}: #{type}"
    end
    @output_io.puts(%Q(#{nodify(node.label)} [label="{#{node.label}|#{node_attributes.join("\\l")}\\l}"]))
    node.edges.each do |edge|
      belonging_node = edge.to
      unless(node_already_outputed?(belonging_node))
        belonging_node.accept(self)
      end
      edge.accept(Ar2Uml::UMLEdgeVisitor.new(@output_io))
    end
  end
  
  private
  
  def node_already_outputed?(node)
    @visited_node_stack.map(&:label).include?(node.label)
  end
end