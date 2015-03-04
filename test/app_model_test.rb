require 'minitest_helper'
require 'active_record'
require 'ar_2_uml/app_model'

class Ar2Uml::AppModelsTest < Minitest::Test

  def test_get_belonging_models
    belonging_models = Ar2Uml::AppModel.new(Tt1).belonging_models
    assert_equal(2, belonging_models.count)
  end

  def test_get_belonging_informations
    belonging_models = Ar2Uml::AppModel.new(Tt2).belonging_models
    assert_equal({tt1:Ar2Uml::AppModelsTest::Tt1}, belonging_models.first)
  end
  
  def test_get_aliased_belonging
    belonging_models = Ar2Uml::AppModel.new(Tt3).belonging_models
    assert_equal({foo:Ar2Uml::AppModelsTest::Tt1}, belonging_models.first)
  end

  def test_get_table_name
    assert_equal("tt1s", Ar2Uml::AppModel.new(Tt1).table_name)
  end

  def test_get_attributes
    Tt1.stubs(columns: [
      OpenStruct.new(type: :integer, name: :foo),
      OpenStruct.new(type: :string, name: :bar)
    ])
    assert_equal({foo: :integer, bar: :string}, Ar2Uml::AppModel.new(Tt1).model_attributes)
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
end