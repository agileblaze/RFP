require File.dirname(__FILE__) + '/../test_helper'
class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  fixtures :users
  test "should not save user without data" do
    post = User.new
    assert !post.save
  end

  test "should" do
    post = User.new(:login=>'aaaaaa',:email=>'aaaa@aa.com',:password=>'123456',:password_confirmation=>'123456',:role_id=>'23')
    assert post.save
  end

  test "should report error" do
    # some_undefined_variable is not defined elsewhere in the test case
    some_undefined_variable='dddddd'
    assert true
  end
  
  test "password should mtch" do
    data=User.new(:login=>'aaaaaa',:email=>'aaaa@aa.com',:password=>'123456',:password_confirmation=>'123456',:role_id=>'23')
    data.save
    assert_equal(data.password,data.password_confirmation)
  end

   def test_should_authenticate_user
    assert_not_equal users(:quentin), User.authenticate('quentin', 'test')
  end

  def test_should_suspend_user
    users(:quentin).suspend!
    assert users(:quentin).suspended?
  end

  def test_suspended_user_should_not_authenticate
    users(:quentin).suspend!
    assert_not_equal users(:quentin), User.authenticate('quentin', 'test')
  end
  
  def test_should_unsuspend_user
    users(:quentin).suspend!
    assert users(:quentin).suspended?
    users(:quentin).unsuspend!
    assert users(:quentin).active?
  end  
end
