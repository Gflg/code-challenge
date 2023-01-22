class UserHandler
    def initialize(params={})
        @params = params
    end

    def find_user
        User.find_by(@params)
    end

    def find_all_users
        User.all
    end

    def create_user
        User.new(@params)
    end

    def get_or_create_user
        user = self.find_user
        if user.nil?
            user = self.create_user
        end
        user.create_token

        user
    end

    def activate_user_token
        user = self.find_user
        user.confirm_token

        user
    end
end