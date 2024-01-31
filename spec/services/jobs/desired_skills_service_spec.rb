require 'rails_helper'

RSpec.describe Jobs::DesiredSkillService do
  describe ".create" do
    subject { described_class.create(job, master_skill_id) }

    let(:job) { create(:job) }
    let(:master_skill_id) { create(:master_skill).id }

    it "creates a desired skill" do
      expect { subject }.to change { job.desired_skills.count }.by(1)

      desired_skill = job.desired_skills.last

      expect(desired_skill.master_skill_id).to eq(master_skill_id)
      expect(desired_skill.job).to eq(job)
    end

    it "publishes an event" do
      expect(Events::DesiredSkillCreated::Data::V1).to receive(:new).with(
        id: be_present,
        job_id: job.id,
        master_skill_id:
      ).and_call_original

      expect(EventService).to receive(:create!).with(
        event_schema: Events::DesiredSkillCreated::V1,
        aggregate_id: job.id,
        data: be_a(Events::DesiredSkillCreated::Data::V1)
      ).and_call_original

      subject
    end
  end

  describe ".destroy" do
    subject { described_class.destroy(desired_skill) }

    let!(:desired_skill) { create(:desired_skill) }

    it "destroys the desired skill" do
      expect { subject }.to change { DesiredSkill.count }.by(-1)
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::DesiredSkillDestroyed::V1,
        aggregate_id: desired_skill.job_id,
        data: Events::DesiredSkillDestroyed::Data::V1.new(
          id: desired_skill.id
        )
      )

      subject
    end
  end
end
