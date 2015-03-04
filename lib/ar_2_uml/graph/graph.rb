class Ar2Uml::Graph
  attr_reader :nodes
  
  def initialize(nodes = [])
    @nodes = nodes
  end
  
  def accept(graph_visitor)
    graph_visitor.visit(self)
  end
end