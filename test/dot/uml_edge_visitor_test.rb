require 'minitest_helper'
require_relative 'uml_visitor_test'
require 'ar_2_uml/dot/uml_edge_visitor'
require 'ar_2_uml/graph/node'
require 'ar_2_uml/graph/edge'

class Ar2Uml::UMLEdgeVisitorTest < Ar2Uml::UMLVisitorTest

  def setup
    @output_io = StringIO.new
    @visitor = Ar2Uml::UMLEdgeVisitor.new(@output_io)
  end
  
  def test_output_node_with_edge_relationship
    edge = Ar2Uml::Edge.new(from:Ar2Uml::Node.new(label:'a'), to:Ar2Uml::Node.new(label:'b'))
    assert_output_for_item(edge, "a -> b")
  end
      
end