RSpec.shared_context "authenticated" do
  around do |example|
    original = ENV["MOCK_AUTH"]
    ENV["MOCK_AUTH"] = "true"
    
    example.run

    ENV["MOCK_AUTH"] = original
  end

  let!(:user) do
    User.create!(
      id: 'clem7u5uc0007mi0rne4h3be0',
      name: 'Jake Not-Onboard',
      first_name: 'Jake',
      last_name: 'Not-Onboard',
      email: 'jake@statefarm.com',
      sub: 'jakesub'
    )
  end
end

RSpec.shared_examples "a secured endpoint" do
  context "unauthenticated" do
    it "returns 401" do
      subject

      expect(response).to have_http_status(401)
    end
  end

  context "authenticated" do
    include_context "authenticated"

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end
  end
end
