RSpec.shared_context "training provider authenticated" do
  let!(:training_provider_profile) do
    TrainingProviderProfile.create!(
      id: SecureRandom.uuid,
      user:,
      training_provider: create(:training_provider)
    )
  end
  let!(:user) do
    User.create!(
      id: 'clem7u5uc0007mi0rne4h3be0',
      first_name: 'Jake',
      last_name: 'Not-Onboard',
      email: 'jake@statefarm.com',
      sub: 'jakesub'
    )
  end
  let(:headers) { { "Authorization" => "Bearer #{user.sub}" } }

  around do |example|
    original = ENV["MOCK_AUTH"]
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
