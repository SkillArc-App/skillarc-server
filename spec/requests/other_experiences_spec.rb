require 'rails_helper'

RSpec.describe "OtherExperiences", type: :request do
  include_context "authenticated"

  let(:profile) { create(:profile, user: user) }

  describe "POST /create" do
    subject { post profile_other_experiences_path(profile_id: profile.id), params: params }

    let(:params) do
      {
        other_experience: {
          organization_name: "Dunder Mifflin",
          position: "Assistant to the Regional Manager",
          start_date: "2014-01-01",
          end_date: "2015-01-01",
          is_current: false,
          description: "I sold paper"
        }
      }
    end

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates an other experience" do
      expect { subject }.to change { OtherExperience.count }.by(1)
    end
  end

  describe "UPDATE /update" do
    subject { put profile_other_experience_path(profile_id: profile.id, id: other_experience.id), params: params }

    let(:other_experience) { create(:other_experience, profile: profile) }

    let(:params) do
      {
        other_experience: {
          organization_name: "Dunder Mifflin 2.0",
        }
      }
    end

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "updates the other experience" do
      expect { subject }.to change { other_experience.reload.organization_name }.to("Dunder Mifflin 2.0")
    end
  end

  describe "DELETE /destroy" do
    subject { delete profile_other_experience_path(profile_id: profile.id, id: other_experience.id) }

    let!(:other_experience) { create(:other_experience, profile: profile) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "deletes the other experience" do
      expect { subject }.to change { OtherExperience.count }.by(-1)
    end
  end
end
