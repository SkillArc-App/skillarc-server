module AuthClient
  class Factory
    def self.build
      if ENV['MOCK_AUTH'] == 'true'
        AuthClient::Fake
      else
        AuthClient::Auth0Client
      end
    end
  end
end
