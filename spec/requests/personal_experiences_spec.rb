require 'rails_helper'

RSpec.describe "PersonalExperiences", type: :request do
  include_context "authenticated"

  let(:seeker) { create(:seeker, user:) }

  describe "POST /create" do
    subject { post profile_personal_experiences_path(seeker), params:, headers: }

    let(:params) do
      {
        personal_experience: {
          title: "My Title",
          description: "My Description",
          start_date: "2020-01-01",
          end_date: "2020-01-01"
        }
      }
    end

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "creates a personal experience" do
      expect { subject }.to change(PersonalExperience, :count).by(1)
    end
  end

  describe "PUT /update" do
    subject { put profile_personal_experience_path(seeker, personal_experience), params:, headers: }

    let(:params) do
      {
        personal_experience: {
          activity: "new activity"
        }
      }
    end
    let!(:personal_experience) { create(:personal_experience, seeker:) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "updates the personal experience" do
      subject

      expect(personal_experience.reload.activity).to eq("new activity")
    end
  end

  describe "DELETE /destroy" do
    subject { delete profile_personal_experience_path(seeker, personal_experience), headers: }

    let(:params) do
      {
        personal_experience: {
          activity: "new activity"
        }
      }
    end
    let!(:personal_experience) { create(:personal_experience, seeker:) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "deletes the personal experience" do
      expect { subject }.to change(PersonalExperience, :count).by(-1)
    end
  end
end
