class Ar2Uml::UMLVisitor
  
  protected
  
  def nodify(node_label)
    node_label.downcase.gsub(/\s/, '_')
  end
end