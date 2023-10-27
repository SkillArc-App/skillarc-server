require 'rails_helper'

RSpec.describe "PersonalExperiences", type: :request do
  include_context "authenticated"

  let!(:profile) { create(:profile, user:) }

  describe "POST /create" do
    subject { post profile_personal_experiences_path(profile), params: params }

    let(:params) do
      {
        personal_experience: {
          title: "My Title",
          description: "My Description",
          start_date: "2020-01-01",
          end_date: "2020-01-01",
        },
      }
    end

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates a personal experience" do
      expect { subject }.to change { PersonalExperience.count }.by(1)
    end
  end

  describe "PUT /update" do
    subject { put profile_personal_experience_path(profile, personal_experience), params: params }

    let(:params) do
      {
        personal_experience: {
          activity: "new activity",
        },
      }
    end
    let!(:personal_experience) { create(:personal_experience, profile: profile) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "updates the personal experience" do
      subject

      expect(personal_experience.reload.activity).to eq("new activity")
    end
  end

  describe "DELETE /destroy" do
    subject { delete profile_personal_experience_path(profile, personal_experience) }

    let(:params) do
      {
        personal_experience: {
          activity: "new activity",
        },
      }
    end
    let!(:personal_experience) { create(:personal_experience, profile: profile) }


    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "deletes the personal experience" do
      expect { subject }.to change { PersonalExperience.count }.by(-1)
    end
  end
end
