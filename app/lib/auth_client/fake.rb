module AuthClient
  class Fake
    def validate_token(token)
      Response.new(
        [{
          'sub' => "email|#{token}"
        }],
        nil
      )
    end

    def get_user_info(_token)
      {
        'email' => ENV['MOCK_USER_EMAIL'],
        'email_verified' => nil,
        'picture' => nil,
        'nickname' => nil,
        'sub' => ENV['MOCK_USER_SUB']
      }
    end
  end
end
