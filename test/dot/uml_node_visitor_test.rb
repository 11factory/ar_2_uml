require 'minitest_helper'
require_relative 'uml_visitor_test'
require 'ar_2_uml/dot/uml_node_visitor'
require 'ar_2_uml/dot/uml_edge_visitor'
require 'ar_2_uml/graph/node'

class Ar2Uml::UMLNodeVisitorTest < Ar2Uml::UMLVisitorTest

  def setup
    @output_io = StringIO.new
    @visitor = Ar2Uml::UMLNodeVisitor.new(@output_io)
  end

  def test_output_node_label_and_attributes
    node = Ar2Uml::Node.new(label:"Pouet", attributes:{a: :integer, b: :string})
    assert_output_for_item(node, %Q(pouet [label="{Pouet|+a: integer\\l+b: string\\l}"]))
  end

  def test_nodify_node_label
    node = Ar2Uml::Node.new(label:"Name with spaces")
    assert_output_for_item(node, %Q(name_with_spaces [label="{Name with spaces|\\l}"]))
  end

  def test_output_node_edges
    node = Ar2Uml::Node.new(label:'a', edges:[Ar2Uml::Node.new(label:'b')])
    edge_io = StringIO.new
    node.edges.first.accept(Ar2Uml::UMLEdgeVisitor.new(edge_io))
    assert_output_for_item(node, %Q(
      a [label="{a|\\l}"]
      b [label="{b|\\l}"]
      #{edge_io.string}
    ))
  end
    
end