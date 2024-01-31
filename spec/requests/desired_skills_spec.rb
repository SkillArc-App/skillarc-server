require 'rails_helper'

RSpec.describe "DesiredSkills", type: :request do
  describe "POST /create" do
    subject { post job_desired_skills_path(job), params:, headers: }

    let(:job) { create(:job) }
    let(:master_skill) { create(:master_skill) }
    let(:params) do
      {
        master_skill_id: master_skill.id
      }
    end

    it_behaves_like "admin secured endpoint"

    context "admin authenticated" do
      include_context "admin authenticated"

      it "calls Jobs::DesiredSkillService.create" do
        expect(Jobs::DesiredSkillService).to receive(:create).with(job, master_skill.id).and_call_original

        subject
      end
    end
  end

  describe "DELETE /destroy" do
    subject { delete job_desired_skill_path(job, desired_skill), headers: }

    let!(:job) { create(:job) }
    let!(:desired_skill) { create(:desired_skill, job:) }

    it_behaves_like "admin secured endpoint"

    context "admin authenticated" do
      include_context "admin authenticated"

      it "calls Jobs::DesiredSkillService.destroy" do
        expect(Jobs::DesiredSkillService).to receive(:destroy).with(desired_skill).and_call_original

        subject
      end
    end
  end
end
