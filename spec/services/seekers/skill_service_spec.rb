require 'rails_helper'

RSpec.describe Seekers::SkillService do
  describe "#create" do
    subject { described_class.new(seeker).create(master_skill_id:, description:) }

    let(:seeker) { create(:seeker) }
    let(:description) { "This is a description" }
    let(:master_skill_id) { master_skill.id }
    let(:master_skill) do
      create(
        :master_skill,
        skill: "Skill",
        type: MasterSkill::SkillTypes::TECHNICAL
      )
    end

    it "creates a skill" do
      expect { subject }.to change(ProfileSkill, :count).by(1)
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::SeekerSkillCreated::V1,
        seeker_id: seeker.id,
        data: Events::SeekerSkillCreated::Data::V1.new(
          skill_id: master_skill.id,
          name: "Skill",
          description: "This is a description",
          type: MasterSkill::SkillTypes::TECHNICAL
        )
      ).and_call_original

      subject
    end
  end

  describe "#update" do
    subject { described_class.new(seeker).update(skill, description:) }

    let(:seeker) { create(:seeker) }
    let(:skill) { create(:profile_skill, seeker:) }
    let(:description) { "This is a new description" }

    it "updates the skill" do
      subject

      expect(skill.reload.description).to eq("This is a new description")
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::SeekerSkillUpdated::V1,
        seeker_id: seeker.id,
        data: Events::SeekerSkillUpdated::Data::V1.new(
          skill_id: skill.master_skill.id,
          description: "This is a new description",
          type: skill.master_skill.type,
          name: skill.master_skill.skill
        )
      ).and_call_original

      subject
    end
  end

  describe "#destroy" do
    subject { described_class.new(seeker).destroy(skill) }

    let(:seeker) { create(:seeker) }
    let!(:skill) { create(:profile_skill, seeker:) }

    it "deletes the skill" do
      expect { subject }.to change(ProfileSkill, :count).by(-1)
    end

    it "publishes an event" do
      expect(EventService).to receive(:create!).with(
        event_schema: Events::SeekerSkillDestroyed::V1,
        seeker_id: seeker.id,
        data: Events::SeekerSkillDestroyed::Data::V1.new(
          skill_id: skill.master_skill.id,
          description: skill.description,
          type: skill.master_skill.type,
          name: skill.master_skill.skill
        )
      ).and_call_original

      subject
    end
  end
end
