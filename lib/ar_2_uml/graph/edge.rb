class Ar2Uml::Edge
  attr_accessor :from, :to
  
  def initialize(options = {})
    self.from = options[:from]
    self.to = options[:to] || {}
  end
  
  def accept(edge_visitor)
    edge_visitor.visit(self)
  end
end