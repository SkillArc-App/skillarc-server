module AuthClient
  class Factory
    def self.build(auth0_domain: ENV['AUTH0_DOMAIN'], mock_auth: ENV['MOCK_AUTH'], mock_email: ENV['MOCK_USER_EMAIL'], mock_sub: ENV['MOCK_USER_SUB'])
      if mock_auth == 'true'
        AuthClient::Fake.new(
          email: mock_email,
          sub: mock_sub
        )
      else
        AuthClient::Auth0Client.new(
          auth0_domain:
        )
      end
    end
  end
end
