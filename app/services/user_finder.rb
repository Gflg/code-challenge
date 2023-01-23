class UserFinder
    def initialize(params={})
        @params = params
    end

    def call
        if @params == {}
            find_all_users
        else
            find_user
        end
    end

    def find_user
        User.find_by(@params)
    end

    def find_all_users
        User.all
    end
end