require 'rails_helper'

RSpec.describe "EducationExperiences", type: :request do
  include_context "authenticated"

  let(:profile) { create(:profile, user:) }

  describe "GET /create" do
    subject { post profile_education_experiences_path(profile), params:, headers: }

    let(:params) do
      {
        education_experience: {
          organization_name: "Linden High School",
          title: "Student",
          graduation_date: "2014-01-01",
          gpa: "3.5",
          activities: "Football, Basketball"
        }
      }
    end

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "creates an education experience" do
      expect { subject }.to change(EducationExperience, :count).by(1)
    end
  end

  describe "PUT /update" do
    subject { put profile_education_experience_path(profile, education_experience), params:, headers: }

    let(:education_experience) { create(:education_experience, profile:) }
    let(:params) do
      {
        education_experience: {
          organization_name: "Linden High School 2.0"
        }
      }
    end

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "updates the education experience" do
      expect { subject }.to change { education_experience.reload.organization_name }.to("Linden High School 2.0")
    end
  end

  describe "DELETE /destroy" do
    subject { delete profile_education_experience_path(profile, education_experience), headers: }

    let!(:education_experience) { create(:education_experience, profile:) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "deletes the education experience" do
      expect { subject }.to change(EducationExperience, :count).by(-1)
    end
  end
end
