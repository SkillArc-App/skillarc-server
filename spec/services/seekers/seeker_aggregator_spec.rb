require 'rails_helper'

RSpec.describe Seekers::SeekerAggregator do
  it_behaves_like "a replayable message consumer"

  let(:consumer) { described_class.new }

  let(:user) { create(:user, onboarding_session: nil) }
  let(:seeker) { create(:seeker, user:) }

  describe "#handle_message" do
    subject { consumer.handle_message(message) }

    context "when the message is basic info added" do
      let(:message) do
        build(
          :message,
          schema: Events::BasicInfoAdded::V1,
          aggregate_id: seeker.id,
          data: {
            user_id: user.id,
            first_name: "John",
            last_name: "Chabot",
            phone_number: "333-333-3333",
            date_of_birth: "2000-10-10"
          }
        )
      end

      it "creates a onboarding session" do
        subject

        user.reload
        expect(user.first_name).to eq(message.data.first_name)
        expect(user.last_name).to eq(message.data.last_name)
        expect(user.phone_number).to eq(message.data.phone_number)
      end
    end

    context "when the message is experience added" do
      let(:message) do
        build(
          :message,
          schema: Events::ExperienceAdded::V1,
          aggregate_id: seeker.id,
          data: {
            id: SecureRandom.uuid,
            organization_name: "Org",
            position: "Position",
            start_date: "A",
            end_date: "$$$",
            description: "{}",
            is_current: false
          }
        )
      end

      context "when the event updates a record" do
        let!(:other_experience) { create(:other_experience, seeker_id: message.aggregate.id, id: message.data.id) }

        it "updates an other session" do
          expect { subject }.not_to change(OtherExperience, :count)

          other_experience.reload
          expect(other_experience.id).to eq(message.data.id)
          expect(other_experience.seeker_id).to eq(message.aggregate.id)
          expect(other_experience.organization_name).to eq(message.data.organization_name)
          expect(other_experience.position).to eq(message.data.position)
          expect(other_experience.start_date).to eq(message.data.start_date)
          expect(other_experience.end_date).to eq(message.data.end_date)
          expect(other_experience.description).to eq(message.data.description)
          expect(other_experience.is_current).to eq(message.data.is_current)
        end
      end

      context "when the event creates a record" do
        it "creates an other experience" do
          expect { subject }.to change(OtherExperience, :count).from(0).to(1)

          other_experience = OtherExperience.take(1).first
          expect(other_experience.id).to eq(message.data.id)
          expect(other_experience.seeker_id).to eq(message.aggregate.id)
          expect(other_experience.organization_name).to eq(message.data.organization_name)
          expect(other_experience.position).to eq(message.data.position)
          expect(other_experience.start_date).to eq(message.data.start_date)
          expect(other_experience.end_date).to eq(message.data.end_date)
          expect(other_experience.description).to eq(message.data.description)
          expect(other_experience.is_current).to eq(message.data.is_current)
        end
      end
    end

    context "when the message is experience removed" do
      let(:message) do
        build(
          :message,
          schema: Events::ExperienceRemoved::V1,
          aggregate_id: seeker.id,
          data: {
            id:
          }
        )
      end
      let(:id) { SecureRandom.uuid }
      let!(:other_experience) { create(:other_experience, seeker_id: seeker.id, id:) }

      it "remove the other experience" do
        expect { subject }.to change(OtherExperience, :count).from(1).to(0)
      end
    end

    context "when the message is education experience added" do
      let(:message) do
        build(
          :message,
          schema: Events::EducationExperienceAdded::V1,
          aggregate_id: seeker.id,
          data: {
            id: SecureRandom.uuid,
            organization_name: "Org",
            title: "Position",
            activities: "A",
            graduation_date: "$$$",
            gpa: "{}"
          }
        )
      end

      context "when the event updates a record" do
        let!(:education_experience) { create(:education_experience, seeker_id: message.aggregate.id, id: message.data.id) }

        it "updates and education experience" do
          expect { subject }.not_to change(EducationExperience, :count)

          education_experience.reload
          expect(education_experience.id).to eq(message.data.id)
          expect(education_experience.seeker_id).to eq(seeker.id)
          expect(education_experience.organization_name).to eq(message.data.organization_name)
          expect(education_experience.title).to eq(message.data.title)
          expect(education_experience.activities).to eq(message.data.activities)
          expect(education_experience.graduation_date).to eq(message.data.graduation_date)
          expect(education_experience.gpa).to eq(message.data.gpa)
        end
      end

      context "when the event creates a record" do
        it "creates a education experience" do
          expect { subject }.to change(EducationExperience, :count).from(0).to(1)

          education_experience = EducationExperience.take(1).first
          expect(education_experience.id).to eq(message.data.id)
          expect(education_experience.seeker_id).to eq(seeker.id)
          expect(education_experience.organization_name).to eq(message.data.organization_name)
          expect(education_experience.title).to eq(message.data.title)
          expect(education_experience.activities).to eq(message.data.activities)
          expect(education_experience.graduation_date).to eq(message.data.graduation_date)
          expect(education_experience.gpa).to eq(message.data.gpa)
        end
      end
    end

    context "when the message is education experience removed" do
      let(:message) do
        build(
          :message,
          schema: Events::EducationExperienceDeleted::V1,
          aggregate_id: seeker.id,
          data: {
            id:
          }
        )
      end
      let(:id) { SecureRandom.uuid }
      let!(:education_experience) { create(:education_experience, seeker_id: seeker.id, id:) }

      it "remove the education experience" do
        expect { subject }.to change(EducationExperience, :count).from(1).to(0)
      end
    end

    context "when the message is personal experience added" do
      let(:message) do
        build(
          :message,
          schema: Events::PersonalExperienceAdded::V1,
          aggregate_id: seeker.id,
          data: {
            id: SecureRandom.uuid,
            activity: "Org",
            description: "Position",
            start_date: "A",
            end_date: "$$$"
          }
        )
      end

      context "when the event updates a record" do
        let!(:personal_experience) { create(:personal_experience, seeker_id: message.aggregate.id, id: message.data.id) }

        it "updates and personal experience" do
          expect { subject }.not_to change(PersonalExperience, :count)

          personal_experience.reload
          expect(personal_experience.id).to eq(message.data.id)
          expect(personal_experience.seeker_id).to eq(seeker.id)
          expect(personal_experience.activity).to eq(message.data.activity)
          expect(personal_experience.description).to eq(message.data.description)
          expect(personal_experience.start_date).to eq(message.data.start_date)
          expect(personal_experience.end_date).to eq(message.data.end_date)
        end
      end

      context "when the event creates a record" do
        it "creates a personal experience" do
          expect { subject }.to change(PersonalExperience, :count).from(0).to(1)

          personal_experience = PersonalExperience.take(1).first
          expect(personal_experience.id).to eq(message.data.id)
          expect(personal_experience.seeker_id).to eq(seeker.id)
          expect(personal_experience.activity).to eq(message.data.activity)
          expect(personal_experience.description).to eq(message.data.description)
          expect(personal_experience.start_date).to eq(message.data.start_date)
          expect(personal_experience.end_date).to eq(message.data.end_date)
        end
      end
    end

    context "when the message is personal experience removed" do
      let(:message) do
        build(
          :message,
          schema: Events::PersonalExperienceRemoved::V1,
          aggregate_id: seeker.id,
          data: {
            id:
          }
        )
      end
      let(:id) { SecureRandom.uuid }
      let!(:personal_experience) { create(:personal_experience, seeker_id: seeker.id, id:) }

      it "remove the personal experience" do
        expect { subject }.to change(PersonalExperience, :count).from(1).to(0)
      end
    end

    context "when the message is seeker training provider created" do
      let(:message) do
        build(
          :message,
          schema: Events::SeekerTrainingProviderCreated::V4,
          aggregate_id: seeker.id,
          data: {
            id:,
            status: "doing good!",
            program_id: program.id,
            training_provider_id: training_provider.id
          }
        )
      end

      let(:program) { create(:program, training_provider:) }
      let(:training_provider) { create(:training_provider) }
      let(:id) { SecureRandom.uuid }

      it "creates a seeker training provider" do
        expect { subject }.to change(SeekerTrainingProvider, :count).from(0).to(1)

        onboarding_session = SeekerTrainingProvider.take(1).first
        expect(onboarding_session.id).to eq(message.data.id)
        expect(onboarding_session.seeker_id).to eq(message.aggregate.id)
        expect(onboarding_session.program_id).to eq(message.data.program_id)
        expect(onboarding_session.training_provider_id).to eq(message.data.training_provider_id)
        expect(onboarding_session.status).to eq(message.data.status)
      end
    end

    context "when the message is onboarding started" do
      let(:message) do
        build(
          :message,
          schema: Events::OnboardingStarted::V1,
          aggregate_id: seeker.id,
          data: {
            user_id: user.id
          }
        )
      end

      it "creates a onboarding session" do
        expect { subject }.to change(OnboardingSession, :count).from(0).to(1)

        onboarding_session = OnboardingSession.last_created
        expect(onboarding_session.user_id).to eq(message.data.user_id)
        expect(onboarding_session.seeker_id).to eq(message.aggregate.id)
        expect(onboarding_session.started_at).to eq(message.occurred_at)
      end
    end

    context "when the message is onboarding completed" do
      let(:message) do
        build(
          :message,
          schema: Events::OnboardingCompleted::V2,
          aggregate_id: seeker.id,
          data: Messages::Nothing
        )
      end

      context "when an onboarding session exists" do
        let!(:onboarding_session) { create(:onboarding_session, user:, seeker_id: seeker.id) }

        it "updates the completed at time" do
          subject

          expect(onboarding_session.reload.completed_at).to eq(message.occurred_at)
        end
      end

      context "when an onboarding session doesn't exist" do
        it "updates the completed at time" do
          expect { subject }.to change(OnboardingSession, :count).from(0).to(1)

          onboarding_session = OnboardingSession.take(1).first
          expect(onboarding_session.completed_at).to eq(message.occurred_at)
        end
      end
    end

    context "when the message is seeker skill created" do
      let(:message) do
        build(
          :message,
          schema: Events::SeekerSkillCreated::V1,
          aggregate_id: seeker.id,
          data: {
            skill_id: master_skill.id,
            description: "some descriptions",
            name: "Bob",
            type: MasterSkill::SkillTypes::TECHNICAL
          }
        )
      end

      let(:master_skill) { create(:master_skill) }

      it "creates a profile skill" do
        expect { subject }.to change(ProfileSkill, :count).from(0).to(1)

        profile_skill = ProfileSkill.take(1).first
        expect(profile_skill.seeker_id).to eq(message.aggregate.id)
        expect(profile_skill.description).to eq(message.data.description)
        expect(profile_skill.master_skill_id).to eq(message.data.skill_id)
      end
    end

    context "when the message is seeker skill update" do
      let(:message) do
        build(
          :message,
          schema: Events::SeekerSkillUpdated::V1,
          aggregate_id: seeker.id,
          data: {
            skill_id: master_skill.id,
            description: "some descriptions",
            name: "Bob",
            type: MasterSkill::SkillTypes::TECHNICAL
          }
        )
      end

      let(:master_skill) { create(:master_skill) }
      let!(:profile_skill) { create(:profile_skill, seeker:, master_skill:) }

      it "updates a profile skill" do
        subject

        profile_skill.reload
        expect(profile_skill.description).to eq(message.data.description)
      end
    end

    context "when the message is seeker skill destroyed" do
      let(:message) do
        build(
          :message,
          schema: Events::SeekerSkillDestroyed::V1,
          aggregate_id: seeker.id,
          data: {
            skill_id: master_skill.id,
            description: "some descriptions",
            name: "Bob",
            type: MasterSkill::SkillTypes::TECHNICAL
          }
        )
      end

      let(:master_skill) { create(:master_skill) }
      let!(:profile_skill) { create(:profile_skill, seeker:, master_skill:) }

      it "updates a profile skill" do
        expect { subject }.to change(ProfileSkill, :count).from(1).to(0)
      end
    end
  end
end
