require 'minitest_helper'
require_relative 'uml_visitor_test'
require 'ar_2_uml/dot/uml_graph_visitor'
require 'ar_2_uml/graph/graph'
require 'ar_2_uml/graph/node'

class Ar2Uml::UMLGraphVisitorTest < Ar2Uml::UMLVisitorTest

  def setup
    @output_io = StringIO.new
    @visitor = Ar2Uml::UMLGraphVisitor.new(@output_io)
  end
  
  def test_output_graph_structure
    graph = Ar2Uml::Graph.new
    assert_output_for_item(graph, %Q(
    digraph G {
      node [shape = "record"]
      splines=ortho
    }))
  end
  
  def test_output_graph
    b_node = Ar2Uml::Node.new(label:'b')
    a_node = Ar2Uml::Node.new(label:'a', edges:[b_node])
    graph = Ar2Uml::Graph.new([a_node])
    assert_output_for_item(graph, %Q(
    digraph G {
      node [shape = "record"]
      splines=ortho
      a [label=\"{a|\\l}\"]
      b [label=\"{b|\\l}\"]
      a -> b
    }))
  end

  def test_should_not_output_duplicate_nodes
    b_node = Ar2Uml::Node.new(label:'b')
    a_node = Ar2Uml::Node.new(label:'a', edges:[b_node])
    graph = Ar2Uml::Graph.new([a_node, b_node])
    assert_output_for_item(graph, %Q(
    digraph G {
      node [shape = "record"]
      splines=ortho
      a [label=\"{a|\\l}\"]
      b [label=\"{b|\\l}\"]
      a -> b
    }))
  end
  
end