require 'minitest_helper'
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
    foo_model = stub("foo model", @default_model_stub.merge(table_name:"foos", belonging_models:[{bar:bar_model}]))
    parent_model = stub("parent model", @default_model_stub.merge(belonging_models:[{foo:foo_model}]))
    node = node_for_model(parent_model)
    assert_equal(1, node.edges.count)
    assert_equal(node, node.edges.first.from)
    assert_equal("foos", node.edges.first.to.label)
    assert_equal("bars", node.edges.first.to.edges.first.to.label)
  end

  
  def node_for_model(model)
    builder = Ar2Uml::NodeFromAppModelBuilder.new(model)
    builder.process
    builder.node
  end
  
end