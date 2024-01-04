RSpec.shared_context "coach authenticated" do
  let!(:user) do
    role = Role.create!(
      id: SecureRandom.uuid,
      name: "coach"
    )

    u = User.create!(
      id: 'clem7u5uc0007mi0rne4h3be0',
      name: 'Jake Not-Onboard',
      first_name: 'Jake',
      last_name: 'Not-Onboard',
      email: 'jake@statefarm.com',
      sub: 'jakesub'
    )

    UserRole.create!(
      id: SecureRandom.uuid,
      user_id: u.id,
      role_id: role.id
    )

    u
  end

  let(:headers) { { "Authorization" => "Bearer #{user.sub}" } }

  around do |example|
    original = ENV["MOCK_AUTH"]
    ENV["MOCK_AUTH"] = "true"

    example.run

    ENV["MOCK_AUTH"] = original
  end
end

RSpec.shared_examples "coach secured endpoint" do
  context "unauthenticated" do
    it "returns 401" do
      subject

      expect(response).to have_http_status(401)
    end
  end

  context "authenticated" do
    include_context "coach authenticated"

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end
  end
end
