require 'securerandom'
class User < ApplicationRecord
    
    def confirm_token
        self.confirmed_token = self.token_to_be_confirmed
        self.token_to_be_confirmed = nil
        self.is_active = true
    end

    def create_token
        self.token_to_be_confirmed = generate_auth_token
        self.is_active = false
    end

    private

    def generate_auth_token
        SecureRandom.uuid.gsub(/\-/,'')
    end
end
