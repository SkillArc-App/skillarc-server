require 'rails_helper'

RSpec.describe "Skills", type: :request do
  include_context "authenticated"

  let(:master_skill) { create(:master_skill) }
  let(:profile) { create(:profile, user:) }

  describe "POST /create" do
    subject { post profile_skills_path(profile_id: profile.id), params:, headers: }

    let(:params) do
      {
        skill: {
          description: "This is a description",
          master_skill_id: master_skill.id
        }
      }
    end

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates a skill" do
      expect { subject }.to change { ProfileSkill.count }.by(1)
    end
  end

  describe "PUT /update" do
    subject { put profile_skill_path(profile_id: profile.id, id: skill.id), params:, headers: }

    let(:skill) { create(:profile_skill, profile:) }

    let(:params) do
      {
        skill: {
          description: "This is a new description"
        }
      }
    end

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "updates the skill" do
      subject

      expect(skill.reload.description).to eq("This is a new description")
    end
  end

  describe "DELETE /destroy" do
    subject { delete profile_skill_path(profile_id: profile.id, id: skill.id), headers: }

    let!(:skill) { create(:profile_skill, profile:) }

    it "returns a 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "deletes the skill" do
      expect { subject }.to change { ProfileSkill.count }.by(-1)
    end
  end
end
