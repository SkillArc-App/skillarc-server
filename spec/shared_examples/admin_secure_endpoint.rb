RSpec.shared_context "admin authenticated" do
  before do
    r = Role.find_or_initialize_by(name: "admin") do |r|
      r.id = SecureRandom.uuid
      r.save!
    end
    u = User.find_or_create_by!(
      id: 'clem7u5uc0007mi0rne4h3be0',
      name: 'Jake Not-Onboard',
      first_name: 'Jake',
      last_name: 'Not-Onboard',
      email: 'jake@statefarm.com',
      sub: 'jakesub'
    )
    UserRole.create!(id: SecureRandom.uuid, user: u, role: r)
  end

  around do |example|
    original = ENV["MOCK_AUTH"]
    ENV["MOCK_AUTH"] = "true"
    
    example.run

    ENV["MOCK_AUTH"] = original
  end
end

RSpec.shared_examples "admin secured endpoint" do
  context "unauthenticated" do
    it "returns 401" do
      subject

      expect(response).to have_http_status(401)
    end
  end

  context "authenticated" do
    include_context "admin authenticated"

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end
  end
end