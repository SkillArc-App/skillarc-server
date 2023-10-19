module AuthClient
  class Fake
    Error = Struct.new(:message, :status)
    Response = Struct.new(:decoded_token, :error)

    def self.validate_token(_token)
      Response.new(
        [{
          'sub' => "email|#{ENV['MOCK_USER_SUB']}"
        }],
        nil
      )
    end

    def self.get_user_info(_token)
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
