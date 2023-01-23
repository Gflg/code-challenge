require "test_helper"

class UserTokenActivatorTest < ActionDispatch::SystemTestCase
    test "activate user token" do
        @user = users(:two)
        user = UserTokenActivator.new(id: 2).call

        assert user.id == @user.id
        assert user.email == @user.email
        assert user.is_active == true
        assert user.confirmed_token != @user.confirmed_token
        assert user.token_to_be_confirmed != @user.token_to_be_confirmed
    end
end