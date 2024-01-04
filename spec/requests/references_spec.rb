require 'rails_helper'

RSpec.describe "References", type: :request do
  describe "GET /show" do
    subject { get reference_path(reference), headers: }

    let(:reference) { create(:reference, author_profile: training_provider_profile) }
    let!(:training_provider_profile) do
      tpp = TrainingProviderProfile.create!(
        id: SecureRandom.uuid,
        user:,
        training_provider: create(:training_provider)
      )
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

    it_behaves_like "training provider secured endpoint"
  end

  describe "POST /create" do
    subject { post references_path, params:, headers: }

    include_context "training provider authenticated"

    let(:params) do
      {
        reference: "This is a reference",
        seeker_profile_id: seeker_profile.id
      }
    end

    let(:seeker_profile) { create(:profile) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates a reference" do
      expect { subject }.to change { Reference.count }.by(1)
    end
  end

  describe "PUT /update" do
    subject { put reference_path(reference), params:, headers: }

    include_context "training provider authenticated"

    let(:params) do
      {
        reference: {
          reference_text: "This is a new reference"
        }
      }
    end

    let(:reference) { create(:reference, author_profile: training_provider_profile) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "updates the reference" do
      expect { subject }.to change { reference.reload.reference_text }.to("This is a new reference")
    end
  end
end
