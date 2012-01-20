require File.dirname(__FILE__) + '/../test_helper'
class RfpDocumentTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end
  test "should attach file" do
     file=RfpDocument.new()
     assert !file.save
  end
end
