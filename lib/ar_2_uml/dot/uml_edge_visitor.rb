require_relative 'uml_visitor'

class Ar2Uml::UMLEdgeVisitor < Ar2Uml::UMLVisitor

  def initialize(output_io)
    @output_io = output_io
  end
  
  def visit(edge)
    @output_io.puts("#{nodify(edge.from.label)} -> #{nodify(edge.to.label)}")
  end
  
end