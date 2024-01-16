module AuthClient
  class Factory
    def self.build
      if ENV['MOCK_AUTH'] == 'true'
        AuthClient::Fake.new
      else
        AuthClient::Auth0Client.new
      end
    end
  end
end
