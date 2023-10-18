# frozen_string_literal: true

module Secured
  extend ActiveSupport::Concern

  attr_reader :current_user

  REQUIRES_AUTHENTICATION = { message: 'Requires authentication' }.freeze
  BAD_CREDENTIALS = {
    message: 'Bad credentials'
  }.freeze
  MALFORMED_AUTHORIZATION_HEADER = {
    error: 'invalid_request',
    error_description: 'Authorization header value must follow this format: Bearer access-token',
    message: 'Bad credentials'
  }.freeze

  def authorize(user_finder: UserFinder.new)
    token = token_from_request

    return if performed? 

    auth_client = AuthClient::Factory.build

    validation_response = auth_client.validate_token(token)
    user = user_finder.find_or_create(validation_response.decoded_token, token, auth_client: auth_client)

    @current_user = user

    return unless (error = validation_response.error)

    render json: { message: error.message }, status: error.status
  end

  private

  def token_from_request
    return if ENV['MOCK_AUTH'] == 'true'

    authorization_header_elements = request.headers['Authorization']&.split

    render json: REQUIRES_AUTHENTICATION, status: :unauthorized and return unless authorization_header_elements

    unless authorization_header_elements.length == 2
      render json: MALFORMED_AUTHORIZATION_HEADER, status: :unauthorized and return
    end

    scheme, token = authorization_header_elements

    render json: BAD_CREDENTIALS, status: :unauthorized and return unless scheme.downcase == 'bearer'

    token
  end
end
