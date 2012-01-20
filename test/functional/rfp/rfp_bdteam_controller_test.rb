require File.dirname(__FILE__) + '/../../test_helper'
class Rfp::RfpBdteamControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  include AuthenticatedTestHelper      # You may have already included this
  include RoleRequirementTestHelper
  fixtures :users, :roles, :roles_users
  test "the truth" do
    assert true
  end
  test "testing" do 
    get :index
   # assert_response :sucess
     assert_redirected_to "http://test.host/login"
  end
end
