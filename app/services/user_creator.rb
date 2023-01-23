class UserCreator
    def initialize(params={})
        @params = params
    end

    def call
        if create_unique_user
            get_or_create_user
        else
            create_user
        end
    end

    private

    def create_user
        User.new(@params)
    end

    def get_or_create_user
        @params.delete(:create_unique)
        user = UserFinder.new(@params).call
        if user.nil?
            user = create_user
        end
        user.create_token

        user
    end

    def create_unique_user
        @params[:create_unique]
    end
end