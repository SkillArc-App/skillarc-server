require 'rails_helper'

RSpec.describe "LearnedSkills", type: :request do
  include_context "admin authenticated"

  let(:job) { create(:job) }

  describe "POST /create" do
    subject { post job_learned_skills_path(job), params:, headers: }

    let(:params) do
      {
        master_skill_id: master_skill.id
      }
    end
    let(:master_skill) { create(:master_skill) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(200)
    end

    it "creates a learned skill" do
      expect { subject }.to change { LearnedSkill.count }.by(1)
    end
  end

  describe "DELETE /destroy" do
  end
end
