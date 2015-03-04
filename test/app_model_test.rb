require 'minitest_helper'
require 'active_record'
require 'ar_2_uml/app_model'

class Ar2Uml::AppModelsTest < Minitest::Test

  def test_get_belonging_models
    belonging_models = Ar2Uml::AppModel.new(T1).belonging_models
    assert_equal(2, belonging_models.count)
  end
  
  def test_get_belonging_informations
    belonging_models = Ar2Uml::AppModel.new(T2).belonging_models
    assert_equal({t1:Ar2Uml::AppModelsTest::T1}, belonging_models.first)
  end
  
  def test_get_aliased_belonging
    belonging_models = Ar2Uml::AppModel.new(T3).belonging_models
    assert_equal({foo:Ar2Uml::AppModelsTest::T1}, belonging_models.first)
  end
  
  def test_get_table_name
    assert_equal("t1s", Ar2Uml::AppModel.new(T1).table_name)
  end
  
  def test_get_attributes
    T1.stubs(columns: [
      OpenStruct.new(type: :integer, name: :foo), 
      OpenStruct.new(type: :string, name: :bar)
    ])
    assert_equal({foo: :integer, bar: :string}, Ar2Uml::AppModel.new(T1).model_attributes)
  end
  
  class T1 < ActiveRecord::Base
    belongs_to :t2
    belongs_to :t1
  end
  
  class T2 < ActiveRecord::Base
    belongs_to :t1
  end
  
  class T3 < ActiveRecord::Base
    belongs_to :foo, class_name:"T1"
  end
end