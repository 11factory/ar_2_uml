require_relative 'uml_visitor'
require_relative 'uml_edge_visitor'

class Ar2Uml::UMLNodeVisitor < Ar2Uml::UMLVisitor
  attr_accessor :hide_attributes
  
  def initialize(output_io)
    @output_io = output_io
    @visited_node_stack = {}
    self.hide_attributes = false
  end
  
  def visit(node)
    @visited_node_stack[node.label] = node
    node_attributes = []
    node.attributes.each_pair do |name, type|
      node_attributes << "+#{name}: #{type}"
    end
    node_attributes_string = "|#{node_attributes.join("\\l")}\\l"  
    @output_io.puts(%Q(#{nodify(node.label)} [label="{#{node.label}#{self.hide_attributes ? "" : node_attributes_string}}"]))
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
    @visited_node_stack.has_key?(node.label) rescue binding.pry
  end
end
