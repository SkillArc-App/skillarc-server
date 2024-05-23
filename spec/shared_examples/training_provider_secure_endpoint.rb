RSpec.shared_context "training provider authenticated" do
  let!(:training_provider_profile) do
    TrainingProviderProfile.create!(
      id: SecureRandom.uuid,
      user:,
      training_provider:
    )
  end
  let(:training_provider) { create(:training_provider) }
  let!(:user) do
    User.create!(
      id: '1a7d78bd-ae41-4d09-95d5-0b417efbcb7f',
      first_name: 'Jake',
      last_name: 'Not-Onboard',
      email: 'jake@statefarm.com',
      sub: 'jakesub'
    )
  end
  let(:headers) { { "Authorization" => "Bearer #{user.sub}" } }

  around do |example|
    original = ENV.fetch("MOCK_AUTH", nil)
    ENV["MOCK_AUTH"] = "true"

    example.run

    ENV["MOCK_AUTH"] = original
  end
end

RSpec.shared_examples "training provider secured endpoint" do
  context "when unauthenticated" do
    it "returns 401" do
      subject

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "when authenticated" do
    include_context "training provider authenticated"

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end
end

RSpec.shared_context "training provider authenticated openapi" do
  let!(:user) do
    u = User.create!(
      id: '1a7d78bd-ae41-4d09-95d5-0b417efbcb7f',
      first_name: 'Jake',
      last_name: 'Not-Onboard',
      email: 'jake@statefarm.com',
      sub: 'jakesub'
    )

    FactoryBot.create(:training_provider_profile, user: u)

    u
  end
  let!(:coach) { create(:coaches__coach, user_id: user.id) }

  let(:Authorization) { "Bearer #{user.sub}" }

  around do |example|
    original = ENV.fetch("MOCK_AUTH", nil)
    ENV["MOCK_AUTH"] = "true"

    example.run

    ENV["MOCK_AUTH"] = original
  end
end
