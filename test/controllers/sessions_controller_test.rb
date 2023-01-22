require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
  end

  test "should create session" do
    post login_url, params: { user: { token: @user.confirmed_token } }
    
    assert session[:current_user_id] == @user.id
    assert session[:current_user_email] == @user.email
    assert_redirected_to invoices_url
  end

  test "should get new" do
    get login_url
    assert_response :success
  end

  test "should destroy session" do
    delete logout_url
    assert session[:current_user_id].nil?, true
    assert session[:current_user_email].nil?, true
    assert_redirected_to root_url
  end
end
