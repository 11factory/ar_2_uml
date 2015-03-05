class Ar2Uml::Edge
  attr_accessor :from, :to, :label
  
  def initialize(options = {})
    self.from = options[:from]
    self.to = options[:to] || {}
    self.label = options[:label] || ""
  end
  
  def accept(edge_visitor)
    edge_visitor.visit(self)
  end
end