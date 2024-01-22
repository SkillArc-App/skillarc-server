require 'rails_helper'

RSpec.describe "OtherExperiences", type: :request do
  let(:profile) { create(:profile, user: profile_user) }
  let(:profile_user) { create(:user) }

  describe "POST /create" do
    subject { post profile_other_experiences_path(profile_id: profile.id), params:, headers: }

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

    it_behaves_like "a profile secured endpoint"

    context "authenticated" do
      include_context "profile owner"

      it "creates an other experience" do
        expect { subject }.to change(OtherExperience, :count).by(1)
      end
    end
  end

  describe "UPDATE /update" do
    subject { put profile_other_experience_path(profile_id: profile.id, id: other_experience.id), params:, headers: }

    let(:other_experience) { create(:other_experience, profile:) }

    let(:params) do
      {
        other_experience: {
          organization_name: "Dunder Mifflin 2.0"
        }
      }
    end

    it_behaves_like "a profile secured endpoint"

    context "authenticated" do
      include_context "profile owner"

      it "updates the other experience" do
        expect { subject }.to change { other_experience.reload.organization_name }.to("Dunder Mifflin 2.0")
      end
    end
  end

  describe "DELETE /destroy" do
    subject { delete profile_other_experience_path(profile_id: profile.id, id: other_experience.id), headers: }

    let!(:other_experience) { create(:other_experience, profile:) }

    it_behaves_like "a profile secured endpoint"

    context "authenticated" do
      include_context "profile owner"

      it "deletes the other experience" do
        expect { subject }.to change(OtherExperience, :count).by(-1)
      end
    end
  end
end
