# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
    def activate_user_token
        user = User.find_by(id: 1)
        if user.token_to_be_confirmed.nil?
            user.create_token
        end
        token = user.token_to_be_confirmed

        UserMailer.with(user: user).activate_user_token
    end
end
