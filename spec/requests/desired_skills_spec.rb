require 'rails_helper'

RSpec.describe "DesiredSkills", type: :request do
  describe "POST /create" do
    subject { post job_desired_skills_path(job), params:, headers: }

    include_context "admin authenticated"

    let(:job) { create(:job) }
    let(:master_skill) { create(:master_skill) }
    let(:params) do
      {
        master_skill_id: master_skill.id
      }
    end

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "creates a desired skill" do
      expect { subject }.to change(DesiredSkill, :count).by(1)
    end
  end

  describe "DELETE /destroy" do
    subject { delete job_desired_skill_path(job, desired_skill), headers: }

    include_context "admin authenticated"

    let!(:job) { create(:job) }
    let!(:desired_skill) { create(:desired_skill, job:) }

    it "returns 200" do
      subject

      expect(response).to have_http_status(:ok)
    end

    it "destroys the desired skill" do
      expect { subject }.to change(DesiredSkill, :count).by(-1)
    end
  end
end
