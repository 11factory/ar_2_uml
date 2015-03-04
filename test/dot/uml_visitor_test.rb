require 'minitest_helper'

class Ar2Uml::UMLVisitorTest <  Minitest::Test
  
  def assert_output_for_item(item, expected_output)
    item.accept(@visitor)
    assert_equal(expected_output.gsub(/\n\s*/, "\n").gsub(/^\n/, "").chomp, 
      @output_io.string.gsub(/\n\s*/, "\n").gsub(/^\n/, "").chomp)
  end
  
end

