require "test_helper"

class UserFinderTest < ActionDispatch::SystemTestCase
    test "find all users" do
        users = UserFinder.new.call

        #There are 2 users in users.yml
        assert users.count == 2
    end

    test "find user by id" do
        @user = users(:one)
        user = UserFinder.new(id: 1).call

        assert user.id == @user.id
        assert user.email == @user.email
        assert user.token_to_be_confirmed == @user.token_to_be_confirmed
        assert user.confirmed_token == @user.confirmed_token
        assert user.is_active == @user.is_active
    end
end