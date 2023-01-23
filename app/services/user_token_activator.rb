class UserTokenActivator
    def initialize(params={})
        @params = params
    end

    def call
        activate_user_token
    end

    private

    def activate_user_token
        user = UserFinder.new(@params).call
        user.confirm_token

        user
    end
end