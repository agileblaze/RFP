#require 'test_helper'
require File.dirname(__FILE__) + '/../../test_helper'
class Rfp::RfpManagerControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  test "the truth" do
    assert true
  end

  test "should index" do
    get :index
    assert_response :success
  end
end
