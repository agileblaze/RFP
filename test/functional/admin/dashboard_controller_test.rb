require File.dirname(__FILE__) + '/../../test_helper'

class Admin::DashboardControllerTest < ActionController::TestCase
  # Replace this with your real tests.
  include AuthenticatedTestHelper      # You may have already included this
  include RoleRequirementTestHelper
  fixtures :users, :roles, :roles_users
  def test_truth
    assert true
  end
  test "ddddd" do
    get :index
     assert_response :sucess
     assert_redirected_to "http://test.host/session/new" 
 end 
end
