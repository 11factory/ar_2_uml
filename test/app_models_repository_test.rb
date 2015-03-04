require 'minitest_helper'
require 'ar_2_uml/app_models_repository'

class Ar2Uml::AppModelsRepositoryTest < Minitest::Test

  def test_get_all_classes_in_object_space_that_looks_like_an_active_record_class
    repository = Ar2Uml::AppModelsRepository.new
    assert_equal([T1, T2].map(&:to_s).sort, repository.all.map(&:to_s).sort)
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