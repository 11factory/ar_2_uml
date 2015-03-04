require_relative 'uml_visitor'
require_relative 'uml_node_visitor'

class Ar2Uml::UMLGraphVisitor < Ar2Uml::UMLVisitor

  def initialize(output_io)
    @output_io = output_io
  end
  
  def visit(graph)
    nodes_output = StringIO.new
    node_visitor = Ar2Uml::UMLNodeVisitor.new(nodes_output)
    graph.nodes.map {|node| node.accept(node_visitor)}
    @output_io.puts(%Q(
    digraph G {
      node [shape = "record"]
      splines=ortho
      {{nodes}}
    }).gsub("{{nodes}}", string_by_removing_duplicate_lines(nodes_output.string)))
  end
  
  private
  
  def string_by_removing_duplicate_lines(string)
    string.split(/\n/).uniq.join("\n")
  end
end