require 'minitest_helper'
require 'ar_2_uml/graph/node'

class Ar2Uml::NodeTest < Minitest::Test

  def test_auto_resolve_incoming_edges_from_edges_defined
    child_node1 = Ar2Uml::Node.new
    child_node2 = Ar2Uml::Node.new
    node = Ar2Uml::Node.new(edges:[child_node1, child_node2])
    assert_equal(1, child_node1.incoming_edges.count)
    assert_equal(node, child_node1.incoming_edges.first.from)
    assert_equal(1, child_node2.incoming_edges.count)
    assert_equal(node, child_node2.incoming_edges.first.from)
    assert_equal([], node.incoming_edges)
  end
  
end