require 'rails_helper'

RSpec.describe Jobs::LearnedSkillService do
  describe ".create" do
    subject { described_class.create(job, master_skill_id) }

    include_context "event emitter"

    let(:job) { create(:job) }
    let(:master_skill_id) { create(:master_skill).id }

    it "creates a learned skill" do
      expect { subject }.to change { job.learned_skills.count }.by(1)

      learned_skill = job.learned_skills.last_created

      expect(learned_skill.master_skill_id).to eq(master_skill_id)
      expect(learned_skill.job).to eq(job)
    end

    it "publishes an event" do
      expect(Events::LearnedSkillCreated::Data::V1).to receive(:new).with(
        id: be_present,
        job_id: job.id,
        master_skill_id:
      ).and_call_original

      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::LearnedSkillCreated::V1,
        job_id: job.id,
        data: be_a(Events::LearnedSkillCreated::Data::V1)
      ).and_call_original

      subject
    end
  end

  describe ".destroy" do
    subject { described_class.destroy(learned_skill) }

    include_context "event emitter"

    let!(:learned_skill) { create(:learned_skill) }

    it "destroys the desired skill" do
      expect { subject }.to change { LearnedSkill.count }.by(-1)
    end

    it "publishes an event" do
      expect_any_instance_of(EventService).to receive(:create!).with(
        event_schema: Events::LearnedSkillDestroyed::V1,
        job_id: learned_skill.job_id,
        data: Events::LearnedSkillDestroyed::Data::V1.new(
          id: learned_skill.id
        )
      )

      subject
    end
  end
end
