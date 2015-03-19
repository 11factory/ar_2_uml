require_relative 'app_models_repository'

class Ar2Uml::AppModel
  
  def initialize(active_record_model)
    @active_record_model = active_record_model
    @app_models_repository = Ar2Uml::AppModelsRepository.new
  end
  
  def table_name
    @active_record_model.table_name
  end
  
  def model_attributes
    ({}).tap do |result|
      @active_record_model.columns.each do |col|
        result[col.name] = col.type
      end
    end
  end
  
  def belonging_models
    @active_record_model.reflect_on_all_associations(:belongs_to).map do |belongs_to|
      next if(belongs_to.options.has_key?(:polymorphic))
      belonging_name = belongs_to.name.to_s
      belonging_classified_name = (belongs_to.options[:class_name] || belonging_name).classify
      belonging_class = @app_models_repository.load(belonging_classified_name)
      { 
        model: Ar2Uml::AppModel.new(belonging_class),
        relation_name: belonging_name.to_s
      }
    end.compact
  end
  
  def active_record_model
    @active_record_model
  end
end