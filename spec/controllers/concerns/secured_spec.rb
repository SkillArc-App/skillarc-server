require 'rails_helper'

RSpec.describe ApplicationController, type: :controller do
  describe "#authorize" do
    controller do
      include Secured

      before_action :authorize

      def example
        render json: @current_user
      end
    end

    let(:auth_client) do
      AuthClient::Fake.new(
        email:,
        sub: 'some_sub'
      )
    end
    let(:user_finder) do
      UserFinder.new
    end
    let(:token) { '123' }
    let(:email) { 'some@email.com' }

    it "doesn't explode" do
      request.headers['Authorization'] = "Bearer #{token}"

      expect(AuthClient::Factory)
        .to receive(:build)
        .and_return(auth_client)

      expect(EventService)
        .to receive(:create!)
        .with(
          aggregate_id: be_a(String),
          event_schema: Events::UserCreated::V1,
          data: Events::Common::UntypedHashWrapper.new(
            first_name: nil,
            last_name: nil,
            email:,
            sub: token
          ),
          occurred_at: anything
        ).and_call_original

      routes.draw { get 'example' => 'anonymous#example' }
      get :example

      expect(response).to be_successful

      body = JSON.parse(response.body)
      expect(body['email']).to eq(email)
      expect(body['user_type']).to eq('SEEKER')
      expect(body['sub']).to eq(token)
    end
  end
end
