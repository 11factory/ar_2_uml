require 'minitest_helper'
require 'active_record'
require 'ar_2_uml/app_model'

class Ar2Uml::AppModelsTest < Minitest::Test

  def test_get_belonging_models
    belonging_models = app_model(Tt1).belonging_models
    assert_equal(2, belonging_models.count)
  end

  def test_get_belonging_informations
    belonging_models = app_model(Tt2).belonging_models
    assert_equal(Ar2Uml::AppModelsTest::Tt1, belonging_models.first[:tt1].active_record_model)
  end
  
  def test_get_aliased_belonging
    belonging_models = app_model(Tt3).belonging_models
    assert_equal(Ar2Uml::AppModelsTest::Tt1, belonging_models.first[:foo].active_record_model)
  end

  def test_get_table_name
    assert_equal("tt1s", app_model(Tt1).table_name)
  end

  def test_get_attributes
    Tt1.stubs(columns: [
      OpenStruct.new(type: :integer, name: :foo),
      OpenStruct.new(type: :string, name: :bar)
    ])
    assert_equal({foo: :integer, bar: :string}, app_model(Tt1).model_attributes)
  end
  
  class Tt1 < ActiveRecord::Base
    belongs_to :tt2
    belongs_to :tt1
  end
  
  class Tt2 < ActiveRecord::Base
    belongs_to :tt1
  end
  
  class Tt3 < ActiveRecord::Base
    belongs_to :foo, class_name:"Tt1"
  end
  
  private
  
  def app_model(klass)
    Ar2Uml::AppModel.new(klass)
  end
end