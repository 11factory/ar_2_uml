require_relative 'uml_visitor'
require_relative 'uml_edge_visitor'

class Ar2Uml::UMLNodeVisitor < Ar2Uml::UMLVisitor

  def initialize(output_io)
    @output_io = output_io
  end
  
  def visit(node)
    node_attributes = []
    node.attributes.each_pair do |name, type|
      node_attributes << "+#{name}: #{type}"
    end
    @output_io.puts(%Q(#{nodify(node.label)} [label="{#{node.label}|#{node_attributes.join("\\l")}\\l}"]))
    node.edges.each do |edge|
      edge.to.accept(self)
      edge.accept(Ar2Uml::UMLEdgeVisitor.new(@output_io))
    end
  end
  
end