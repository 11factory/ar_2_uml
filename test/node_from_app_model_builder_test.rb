require 'minitest_helper'
require 'pry'
require 'ar_2_uml/app_model'
require 'ar_2_uml/node_from_app_model_builder'

class Ar2Uml::NodeFromAppModelBuilderTest < Minitest::Test
  
  def setup
    @default_model_stub = {table_name:"t1s", model_attributes:{}, belonging_models:[]}
  end
  
  def test_use_table_name_as_node_label
    app_model = stub("app model", @default_model_stub)
    assert_equal("t1s", node_for_model(app_model).label)
  end

  def test_use_model_attributes_as_node_attributes
    app_model = stub("app model", @default_model_stub.merge(model_attributes:{a: :int, b: :float}))
    assert_equal({a: :int, b: :float}, node_for_model(app_model).attributes)
  end

  def test_deep_build_of_children_nodes_with_edges
    bar_model = stub("bar model", @default_model_stub.merge(table_name:"bars"))
    foo_model = stub("foo model", @default_model_stub.merge(
      table_name:"foos",
      belonging_models:[{relation_name:"bar", model:bar_model}]))
    parent_model = stub("parent model", @default_model_stub.merge(
      belonging_models:[{relation_name:"foo_rel", model:foo_model}]))
    node = node_for_model(parent_model)
    assert_equal(1, node.edges.count)
    assert_equal("foo_rel", node.edges.first.label)
    assert_equal(node, node.edges.first.from)
    assert_equal("foos", node.edges.first.to.label)
    assert_equal("bars", node.edges.first.to.edges.first.to.label)
  end

  def test_record_incoming_edges_too
    child_model = stub("child model", @default_model_stub.merge(table_name:"childs"))
    parent_model = stub("parent model", @default_model_stub.merge(
      belonging_models:[{relation_name:"child", model:child_model}]))
    parent_node = node_for_model(parent_model)
    assert_equal(1, parent_node.edges.count)
    child_node = parent_node.edges.first.to
    assert_equal("childs", child_node.label)
    assert_equal(1, child_node.incoming_edges.count)
    assert_equal(parent_node, child_node.incoming_edges.first.from)
  end


  def test_handle_self_belonging_associations
    foo_model = stub("foo model")
    foo_model.stubs(@default_model_stub.merge(
      table_name:"foos",
      belonging_models:[{relation_name:"foo", model:foo_model}]))
    parent_model = stub("parent model", @default_model_stub.merge(
      belonging_models:[{relation_name:"foo", model:foo_model}]))
    node = node_for_model(parent_model)
    assert_equal(1, node.edges.count)
    assert_equal(node, node.edges.first.from)
    assert_equal("foos", node.edges.first.to.label)
    assert_equal("foos", node.edges.first.to.edges.first.to.label)
  end
  
  def test_handle_indirect_self_belonging_associations
    bar_model = stub("bar model")
    foo_model = stub("foo model")
    foo_model.stubs(@default_model_stub.merge(
      table_name:"foos", 
      belonging_models:[{relation_name:"bar", model:bar_model}]))
    bar_model.stubs(@default_model_stub.merge(
      table_name:"bars", 
      belonging_models:[{relation_name:"foo", model:foo_model}]))
    node = node_for_model(foo_model)
    assert_equal(1, node.edges.count)
    assert_equal(node, node.edges.first.to.edges.first.to)
    assert_equal("foos", node.edges.first.to.edges.first.to.label)
  end
  
  private
  
  def node_for_model(model)
    builder = Ar2Uml::NodeFromAppModelBuilder.new(model)
    builder.process
    builder.node
  end
  
end