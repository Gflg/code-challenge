require "test_helper"

class UserHandlerTest < ActionDispatch::SystemTestCase
    test "create user" do
        user_params = {
            email: "user@example.com"
        }
        user_handler = UserHandler.new(user_params)
        user = user_handler.create_user

        assert user.id.nil?, false
        assert user.email == user_params[:email]
        assert user.token_to_be_confirmed.nil?, true
        assert user.confirmed_token.nil?, true
    end

    test "get all users" do
        user_handler = UserHandler.new
        users = user_handler.find_all_users

        #There are 2 users in users.yml
        assert users.count == 2
    end

    test "find user by id" do
        @user = users(:one)
        user_handler = UserHandler.new(id: 1)
        user = user_handler.find_user

        assert user.id == @user.id
        assert user.email == @user.email
        assert user.token_to_be_confirmed == @user.token_to_be_confirmed
        assert user.confirmed_token == @user.confirmed_token
        assert user.is_active == @user.is_active
    end

    test "get user when calls get_or_create" do
        @user = users(:two)
        user_handler = UserHandler.new(email: "email2@example.com")
        user = user_handler.get_or_create_user

        assert user.id == @user.id
        assert user.email == @user.email
        assert user.token_to_be_confirmed != @user.token_to_be_confirmed
        assert user.confirmed_token == @user.confirmed_token
        assert user.is_active == @user.is_active
    end

    test "create user when calls get_or_create" do
        user_handler = UserHandler.new(email: "email3@example.com")
        user = user_handler.get_or_create_user

        assert user.email == "email3@example.com"
    end

    test "activate user token" do
        @user = users(:two)
        user_handler = UserHandler.new(id: 2)
        user = user_handler.activate_user_token

        assert user.id == @user.id
        assert user.email == @user.email
        assert user.is_active == true
        assert user.confirmed_token != @user.confirmed_token
        assert user.token_to_be_confirmed != @user.token_to_be_confirmed
    end
end