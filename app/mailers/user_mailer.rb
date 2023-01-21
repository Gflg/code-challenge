class UserMailer < ApplicationMailer
    def activate_user_token
        @user = params[:user]
        @token  = @user.token_to_be_confirmed
        mail(to: @user.email, subject: 'Activate your user token')
    end
end
