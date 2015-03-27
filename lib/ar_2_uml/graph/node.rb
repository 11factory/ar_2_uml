require_relative 'edge'

class Ar2Uml::Node
  attr_accessor :label, :attributes, :edges, :incoming_edges
  
  def initialize(options = {})
    self.label = options[:label]
    self.attributes = options[:attributes] || {}
    self.edges = (options[:edges] || []).map {|target_node| Ar2Uml::Edge.new(from:self, to:target_node)}
    self.incoming_edges = []
    self.edges.each do |edge|
      edge.to.incoming_edges << edge
    end
  end
    
  def accept(node_visitor)
    node_visitor.visit(self)
  end
  
end