require 'rails_helper'

RSpec.describe "EducationExperiences", type: :request do
  let(:profile) { create(:profile, user: profile_user) }
  let(:profile_user) { create(:user) }

  describe "POST /create" do
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

    it_behaves_like "a profile secured endpoint"

    context "authenticated" do
      include_context "profile owner"

      it "calls EducationExperienceService.create" do
        expect_any_instance_of(EducationExperienceService)
          .to receive(:create)
          .with(
            organization_name: "Linden High School",
            title: "Student",
            graduation_date: "2014-01-01",
            gpa: "3.5",
            activities: "Football, Basketball"
          ).and_call_original

        subject
      end
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

    it_behaves_like "a profile secured endpoint"

    context "authenticated" do
      include_context "profile owner"

      it "calls EducationExperienceService.update" do
        expect_any_instance_of(EducationExperienceService)
          .to receive(:update)
          .with(
            id: education_experience.id,
            organization_name: "Linden High School 2.0"
          ).and_call_original

        subject
      end
    end
  end

  describe "DELETE /destroy" do
    subject { delete profile_education_experience_path(profile, education_experience), headers: }

    let!(:education_experience) { create(:education_experience, profile:) }

    it_behaves_like "a profile secured endpoint"

    context "authenticated" do
      include_context "profile owner"

      it "calls EducationExperienceService.destroy" do
        expect_any_instance_of(EducationExperienceService)
          .to receive(:destroy)
          .with(
            id: education_experience.id
          ).and_call_original

        subject
      end
    end
  end
end
