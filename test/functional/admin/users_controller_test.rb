require File.dirname(__FILE__) + '/../../test_helper'

class UsersControllerTest < ActionController::TestCase
  include AuthenticatedTestHelper      # You may have already included this
  include RoleRequirementTestHelper
  fixtures :users, :roles, :roles_users



def setup
   @controller =  UsersController.new
   @request = ActionController::TestRequest.new
   @response = ActionController::TestResponse.new
  end
  test "test _show" do
    post :show,{:id=>1}
    assert_response :success
  end

  def test_should_get_new
    get :new
    assert_response :success
  end
end
