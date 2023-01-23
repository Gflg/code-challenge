require "test_helper"

class UserCreatorTest < ActionDispatch::SystemTestCase
    test "create user" do
        user_params = {
            email: "user@example.com"
        }
        user = UserCreator.new(user_params).call

        assert user.id.nil?, false
        assert user.email == user_params[:email]
        assert user.token_to_be_confirmed.nil?, true
        assert user.confirmed_token.nil?, true
    end

    test "get user when calls get_or_create" do
        @user = users(:two)
        user = UserCreator.new(email: "email2@example.com", create_unique: true).call

        assert user.id == @user.id
        assert user.email == @user.email
        assert user.token_to_be_confirmed != @user.token_to_be_confirmed
        assert user.confirmed_token == @user.confirmed_token
        assert user.is_active == @user.is_active
    end

    test "create user when calls get_or_create" do
        user = UserCreator.new(email: "email3@example.com", create_unique: true).call

        assert user.email == "email3@example.com"
    end
end