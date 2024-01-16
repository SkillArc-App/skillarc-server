# frozen_string_literal: true

require 'jwt'
require 'net/http'

module AuthClient
  class Auth0Client
    # Auth0 Client Objects
    Error = Struct.new(:message, :status)
    Response = Struct.new(:decoded_token, :error)

    # Helper Functions
    def domain_url
      "https://blocktrain.us.auth0.com/"
    end

    def decode_token(token, jwks_hash)
      JWT.decode(token, nil, true, {
                   algorithm: 'RS256',
                   iss: domain_url,
                   verify_iss: true,
                   aud: 'https://hello-world.example.com',
                   verify_aud: true,
                   jwks: { keys: jwks_hash[:keys] }
                 })
    end

    # Token Validation
    def validate_token(token)
      decoded_token = decode_token(token, jwks_hash)

      Response.new(decoded_token, nil)
    rescue JWT::VerificationError, JWT::DecodeError => _e
      error = Error.new('Bad credentials', :unauthorized)
      Response.new(nil, error)
    end

    def get_user_info(token)
      uri = URI("https://#{ENV['AUTH0_DOMAIN']}/userinfo")
      req = Net::HTTP::Get.new(uri)
      req['Authorization'] = "Bearer #{token}"

      res = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) do |http|
        http.request(req)
      end

      JSON.parse(res.body)
    end

    private

    def jwks_hash
      return @jwks_hash if @jwks_hash

      jwks_response = jwks

      unless jwks_response.is_a? Net::HTTPSuccess
        error = Error.new(message: 'Unable to verify credentials', status: :internal_server_error)
        return Response.new(nil, error)
      end

      @jwks_hash = JSON.parse(jwks_response.body).deep_symbolize_keys
    end

    def jwks
      jwks_uri = URI("#{domain_url}.well-known/jwks.json")
      Net::HTTP.get_response jwks_uri
    end
  end
end
