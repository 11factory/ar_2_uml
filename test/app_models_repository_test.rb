require 'minitest_helper'
require 'ar_2_uml/app_models_repository'

class Ar2Uml::AppModelsRepositoryTest < Minitest::Test

  def setup
    ObjectSpace.garbage_collect
    @repository = Ar2Uml::AppModelsRepository.new
  end
  
  def test_get_all_classes_in_object_space_that_looks_like_an_active_record_class
    assert(@repository.all.include?(T1))
    assert(@repository.all.include?(T2))
  end
  
  def test_load_object
    assert_equal(T1, @repository.load("Ar2Uml::AppModelsRepositoryTest::T1"))
  end
  
  def test_load_unknown_object_return_nil
    assert_nil(@repository.load("Ar2Uml::AppModelsRepositoryTest::Foo"))
  end

  class T1
    def self.table_name
    end
  end
  
  class T2
    def self.table_name
    end
  end
end