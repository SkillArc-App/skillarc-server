module AuthClient
  class Fake
    def initalize(email:, sub:)
      @email = email
      @sub = sub
    end

    def validate_token(token)
      ValidationResponse.ok(sub: token)
    end

    def get_user_info(_token)
      {
        'email' => @email,
        'email_verified' => nil,
        'picture' => nil,
        'nickname' => nil,
        'sub' => @sub
      }
    end
  end
end
