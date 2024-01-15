RSpec.shared_context "employer authenticated" do
  let!(:recruiter) { create(:recruiter, user:, employer:) }
  let!(:employer) { create(:employer) }
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

RSpec.shared_examples "employer secured endpoint" do
  context "unauthenticated" do
    it "returns 401" do
      subject

      expect(response).to have_http_status(:unauthorized)
    end
  end

  context "authenticated" do
    include_context "employer authenticated"

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end
  end
end
