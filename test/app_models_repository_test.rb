require 'minitest_helper'
require 'ar_2_uml/app_models_repository'

class Ar2Uml::AppModelsRepositoryTest < Minitest::Test

  def setup
    ObjectSpace.garbage_collect
  end
  
  def test_get_all_classes_in_object_space_that_looks_like_an_active_record_class
    repository = Ar2Uml::AppModelsRepository.new
    assert(repository.all.include?(T1))
    assert(repository.all.include?(T2))
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