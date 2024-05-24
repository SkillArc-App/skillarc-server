require 'rails_helper'

RSpec.describe Seekers::Projectors::OnboardingStatus do
  describe ".project" do
    subject { described_class.new.project(messages) }

    let(:aggregate) { Aggregates::Seeker.new(seeker_id:) }
    let(:seeker_id) { SecureRandom.uuid }

    let(:onboarding_complete) do
      build(
        :message,
        aggregate:,
        schema: Events::OnboardingCompleted::V2,
        data: Messages::Nothing
      )
    end
    let(:basic_info_added) do
      build(
        :message,
        aggregate:,
        schema: Events::BasicInfoAdded::V1,
        data: {
          user_id: SecureRandom.uuid,
          first_name: "A",
          last_name: "B",
          phone_number: "333-333-3333",
          date_of_birth: "2000-10-10"
        }
      )
    end
    let(:reliability_added) do
      build(
        :message,
        aggregate:,
        schema: Events::ReliabilityAdded::V1,
        data: {
          reliabilities:
        }
      )
    end
    let(:education_experience_added) do
      build(
        :message,
        aggregate:,
        schema: Events::EducationExperienceAdded::V1,
        data: {
          id: SecureRandom.uuid
        }
      )
    end
    let(:experience_added) do
      build(
        :message,
        aggregate:,
        schema: Events::ExperienceAdded::V1,
        data: {
          id: SecureRandom.uuid
        }
      )
    end
    let(:seeker_training_provider_added) do
      build(
        :message,
        aggregate:,
        schema: Events::SeekerTrainingProviderCreated::V4,
        data: {
          id: SecureRandom.uuid,
          status: "cool beans",
          program_id: SecureRandom.uuid,
          training_provider_id: SecureRandom.uuid
        }
      )
    end
    let(:professional_interests) do
      build(
        :message,
        aggregate:,
        schema: Events::ProfessionalInterestsAdded::V1,
        data: {
          interests: []
        }
      )
    end

    let(:reliabilities) { [Reliability::JOB] }

    context "when nothing is associated with the aggregate" do
      let(:messages) { [] }

      it "reports the next step is start with no progress" do
        expect(subject.next_step).to eq(Onboarding::Steps::START)
        expect(subject.progress).to eq(0)
      end
    end

    context "when an onboarding complete event present" do
      let(:messages) { [onboarding_complete] }

      it "reports that onboarding is complete at 100%" do
        expect(subject.next_step).to eq(Onboarding::Steps::COMPLETE)
        expect(subject.progress).to eq(100)
      end
    end

    context "when a basic info added event is present" do
      let(:messages) { [basic_info_added] }

      it "reports the next step is reliability and progress at 30%" do
        expect(subject.next_step).to eq(Onboarding::Steps::RELIABILITY)
        expect(subject.progress).to eq(20)
      end
    end

    context "when a reliability is present" do
      let(:messages) { [basic_info_added, reliability_added] }

      context "when reliabilities only mention job" do
        let(:reliabilities) { [Reliability::JOB] }

        it "reports the next step is employment and progress is 40" do
          expect(subject.next_step).to eq(Onboarding::Steps::EMPLOYMENT)
          expect(subject.progress).to eq(40)
        end
      end

      context "when reliabilities only mention education" do
        let(:reliabilities) { [Reliability::EDUCATION] }

        it "reports the next step is employment and progress is 70" do
          expect(subject.next_step).to eq(Onboarding::Steps::EDUCATION)
          expect(subject.progress).to eq(70)
        end
      end

      context "when reliabilities only mention training providers" do
        let(:reliabilities) { [Reliability::TRAINING_PROGRAM] }

        it "reports the next step is employment and progress is 50" do
          expect(subject.next_step).to eq(Onboarding::Steps::TRAINING)
          expect(subject.progress).to eq(50)
        end
      end

      context "when reliabilities mentions all" do
        let(:reliabilities) { [Reliability::JOB, Reliability::EDUCATION, Reliability::TRAINING_PROGRAM] }

        it "reports the next step is employment and progress is 40 but needs the other two step" do
          expect(subject.next_step).to eq(Onboarding::Steps::EMPLOYMENT)
          expect(subject.progress).to eq(40)
          expect(subject.education.needed).to eq(true)
          expect(subject.education.provided).to eq(false)
          expect(subject.employment.needed).to eq(true)
          expect(subject.employment.provided).to eq(false)
          expect(subject.training.needed).to eq(true)
          expect(subject.training.provided).to eq(false)
        end
      end
    end

    context "when reliability and experience has been provided" do
      let(:messages) do
        [
          basic_info_added,
          reliability_added,
          education_experience_added,
          experience_added,
          seeker_training_provider_added
        ]
      end
      let(:reliabilities) do
        [
          Reliability::JOB,
          Reliability::EDUCATION,
          Reliability::TRAINING_PROGRAM
        ]
      end

      it "reports the next step is opprotunies and progress is 90" do
        expect(subject.next_step).to eq(Onboarding::Steps::OPPORTUNITIES)
        expect(subject.progress).to eq(90)
      end
    end

    context "when reliability and experience has been provided and opprotunity" do
      let(:messages) do
        [
          basic_info_added,
          reliability_added,
          education_experience_added,
          experience_added,
          seeker_training_provider_added,
          professional_interests
        ]
      end
      let(:reliabilities) do
        [
          Reliability::JOB,
          Reliability::EDUCATION,
          Reliability::TRAINING_PROGRAM
        ]
      end

      it "reports the next step is complete loading and progress is 100" do
        expect(subject.next_step).to eq(Onboarding::Steps::COMPLETE_LOADING)
        expect(subject.progress).to eq(100)
      end
    end
  end
end
