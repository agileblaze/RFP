require File.dirname(__FILE__) + '/../test_helper'
#require 'users_controller'
#fixtures :users
class UsersControllerTest < ActionController::TestCase
  #fixtures :users
  # Be sure to include AuthenticatedTestHelper in test/test_helper.rb instead
  # Then, you can remove it from this and the units test.
 # include AuthenticatedTestHelper
  fixtures :users
  def setup
   @controller =  UsersController.new
   @request = ActionController::TestRequest.new
   @response = ActionController::TestResponse.new
  end

  def test
    #post :login, :login => 'quentin', :password => 'test'
    #assert session[:user]
    assert true
  end
  def test_should_allow_signup
      create_user
      assert_response :sucess
  end

  def test_should_require_login_on_signup
    assert_no_difference 'User.count' do
      create_user(:login => nil)
      assert assigns(:user).errors.on(:login)
      assert_response :success
    end
  end
  
   def test_should_require_password_on_signup
    assert_no_difference 'User.count' do
      create_user(:password => nil)
      assert assigns(:user).errors.on(:password)
      assert_response :success
    end
  end

  def test_should_require_password_confirmation_on_signup
    assert_no_difference 'User.count' do
      create_user(:password_confirmation => nil)
      assert assigns(:user).errors.on(:password_confirmation)
      assert_response :success
    end
  end
protected
    def create_user(options = {})
      post :create, :user => { :login => 'quire', :email => 'quire@example.com',
        :password => 'quire', :password_confirmation => 'quire',:role_id=>1 }.merge(options)
    end
end
