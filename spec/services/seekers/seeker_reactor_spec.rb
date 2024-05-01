require 'rails_helper'

RSpec.describe Seekers::SeekerReactor do # rubocop:disable Metrics/BlockLength
  it_behaves_like "a message consumer"

  let(:consumer) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }
  let(:seeker_id) { SecureRandom.uuid }
  let(:trace_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }

  describe "add_education_experience" do
    subject do
      consumer.add_education_experience(
        seeker_id:,
        organization_name:,
        title:,
        graduation_date:,
        gpa:,
        activities:,
        trace_id:,
        id:
      )
    end

    let(:organization_name) { "Some org" }
    let(:title) { "Scholar" }
    let(:graduation_date) { "Some date" }
    let(:gpa) { "3.9" }
    let(:activities) { "Picking my nose" }
    let(:id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::EducationExperienceAdded::V1,
          trace_id:,
          seeker_id:,
          data: {
            id:,
            activities:,
            organization_name:,
            title:,
            graduation_date:,
            gpa:
          }
        )

      subject
    end
  end

  describe "add_seeker" do
    subject do
      consumer.add_seeker(
        seeker_id:,
        user_id:,
        trace_id:
      )
    end

    it "emits an add seeker command" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Commands::AddSeeker::V1,
          trace_id:,
          user_id:,
          data: {
            id: seeker_id
          }
        )

      subject
    end
  end

  describe "add_seeker_training_provider" do
    subject do
      consumer.add_seeker_training_provider(
        seeker_id:,
        user_id:,
        trace_id:,
        training_provider_id:,
        program_id:,
        id:
      )
    end

    let(:id) { SecureRandom.uuid }
    let(:training_provider_id) { SecureRandom.uuid }
    let(:program_id) { SecureRandom.uuid }

    it "emits an seeker training provider created event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          seeker_id:,
          trace_id:,
          schema: Events::SeekerTrainingProviderCreated::V3,
          data: {
            id:,
            user_id:,
            program_id:,
            training_provider_id:
          }
        )

      subject
    end
  end

  describe "add_reliability" do
    subject do
      consumer.add_reliability(
        seeker_id:,
        trace_id:,
        reliabilities:
      )
    end

    let(:reliabilities) { [Reliability::JOB, Reliability::EDUCATION] }

    it "emits an reliability added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          seeker_id:,
          trace_id:,
          schema: Events::ReliabilityAdded::V1,
          data: {
            reliabilities:
          }
        )

      subject
    end
  end

  describe "add_professional_interests" do
    subject do
      consumer.add_professional_interests(
        seeker_id:,
        trace_id:,
        interests:
      )
    end

    let(:interests) { %w[Pokemon Cowboys] }

    it "emits an professional interest event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          seeker_id:,
          trace_id:,
          schema: Events::ProfessionalInterestsAdded::V1,
          data: {
            interests:
          }
        )

      subject
    end
  end

  describe "add_basic_info" do
    subject do
      consumer.add_basic_info(
        seeker_id:,
        user_id:,
        first_name:,
        last_name:,
        phone_number:,
        date_of_birth:,
        trace_id:
      )
    end

    let(:first_name) { "John" }
    let(:last_name) { "Chabot" }
    let(:phone_number) { "333-333-3333" }
    let(:date_of_birth) { "10-10-2000" }

    it "emits an basic info added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          seeker_id:,
          trace_id:,
          schema: Events::BasicInfoAdded::V1,
          data: {
            user_id:,
            first_name:,
            last_name:,
            phone_number:,
            date_of_birth:
          }
        )

      subject
    end
  end

  describe "complete_onboarding" do
    subject do
      consumer.complete_onboarding(
        seeker_id:,
        trace_id:
      )
    end

    it "emits an basic info added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          seeker_id:,
          trace_id:,
          schema: Commands::CompleteOnboarding::V1,
          data: Messages::Nothing
        )

      subject
    end
  end

  describe "remove_education_experience" do
    subject do
      consumer.remove_education_experience(
        seeker_id:,
        education_experience_id:,
        trace_id:
      )
    end

    let(:education_experience_id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::EducationExperienceDeleted::V1,
          trace_id:,
          seeker_id:,
          data: {
            id: education_experience_id
          }
        )

      subject
    end
  end

  describe "add_personal_experience" do
    subject do
      consumer.add_personal_experience(
        seeker_id:,
        activity:,
        description:,
        start_date:,
        end_date:,
        trace_id:,
        id:
      )
    end

    let(:activity) { "Do stuff" }
    let(:description) { "Best stuff" }
    let(:start_date) { "bro" }
    let(:end_date) { "15" }
    let(:id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::PersonalExperienceAdded::V1,
          trace_id:,
          seeker_id:,
          data: {
            id:,
            activity:,
            description:,
            start_date:,
            end_date:
          }
        )

      subject
    end
  end

  describe "remove_personal_experience" do
    subject do
      consumer.remove_personal_experience(
        seeker_id:,
        personal_experience_id:,
        trace_id:
      )
    end

    let(:personal_experience_id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::PersonalExperienceRemoved::V1,
          trace_id:,
          seeker_id:,
          data: {
            id: personal_experience_id
          }
        )

      subject
    end
  end

  describe "add_experience" do
    subject do
      consumer.add_experience(
        seeker_id:,
        organization_name:,
        position:,
        start_date:,
        end_date:,
        is_current:,
        description:,
        trace_id:
      )
    end

    let(:organization_name) { "Some org" }
    let(:position) { "Best position" }
    let(:start_date) { "2000-10-25" }
    let(:end_date) { "2005-3-25" }
    let(:is_current) { true }
    let(:description) { "It was a great job" }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::ExperienceAdded::V1,
          trace_id:,
          seeker_id:,
          data: {
            id: be_a(String),
            organization_name:,
            position:,
            start_date:,
            end_date:,
            description:,
            is_current:
          }
        )

      subject
    end
  end

  describe "remove_experience" do
    subject do
      consumer.remove_experience(
        seeker_id:,
        experience_id:,
        trace_id:
      )
    end

    let(:experience_id) { SecureRandom.uuid }

    it "emits an experience added event" do
      expect(message_service)
        .to receive(:create!)
        .with(
          schema: Events::ExperienceRemoved::V1,
          trace_id:,
          seeker_id:,
          data: {
            id: experience_id
          }
        )

      subject
    end
  end

  describe "#handle_message" do
    subject { consumer.handle_message(message) }

    context "when the message is add seeker" do
      let(:message) do
        build(
          :message,
          schema: Commands::AddSeeker::V1,
          aggregate_id: user_id,
          data: {
            id: SecureRandom.uuid
          }
        )
      end

      context "when a seeker created event has already occurred" do
        before do
          Event.from_message!(
            build(
              :message,
              schema: Events::SeekerCreated::V1,
              aggregate_id: user_id,
              data: {
                id: SecureRandom.uuid,
                user_id:
              }
            )
          )
        end

        it "does nothing" do
          expect(message_service)
            .not_to receive(:create!)

          subject
        end
      end

      context "when a seeker created event has not occurred" do
        it "creates a seeker created event" do
          expect(message_service)
            .to receive(:create!)
            .with(
              schema: Events::SeekerCreated::V1,
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              data: {
                id: message.data.id,
                user_id: message.aggregate.id
              }
            )

          subject
        end
      end
    end

    context "when the message is seeker created" do
      let(:message) do
        build(
          :message,
          schema: Events::SeekerCreated::V1,
          data: {
            id: SecureRandom.uuid,
            user_id: SecureRandom.uuid
          }
        )
      end

      it "creates a start onboarding command" do
        expect(message_service)
          .to receive(:create!)
          .with(
            schema: Commands::StartOnboarding::V1,
            trace_id: message.trace_id,
            seeker_id: message.data.id,
            data: {
              user_id: message.aggregate.id
            }
          )

        subject
      end
    end

    context "when the message is start onboarding" do
      let(:message) do
        build(
          :message,
          schema: Commands::StartOnboarding::V1,
          aggregate_id: seeker_id,
          data: {
            user_id:
          }
        )
      end

      context "when a seeker created event has already occurred" do
        before do
          Event.from_message!(
            build(
              :message,
              schema: Events::OnboardingStarted::V1,
              aggregate_id: seeker_id,
              data: {
                user_id:
              }
            )
          )
        end

        it "does nothing" do
          expect(message_service)
            .not_to receive(:create!)

          subject
        end
      end

      context "when a seeker created event has not occurred" do
        it "creates a seeker created event" do
          expect(message_service)
            .to receive(:create!)
            .with(
              schema: Events::OnboardingStarted::V1,
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              data: {
                user_id: message.data.user_id
              }
            )

          subject
        end
      end
    end

    context "when the message is complete onboarding" do
      let(:message) do
        build(
          :message,
          schema: Commands::CompleteOnboarding::V1,
          aggregate_id: seeker_id
        )
      end

      context "when an onboarding completed event has already occured" do
        before do
          expect(Projections::HasOccurred)
            .to receive(:project)
            .with(aggregate: message.aggregate, schema: Events::OnboardingCompleted::V2)
            .and_return(true)
        end

        it "does nothing" do
          expect(message_service)
            .not_to receive(:create!)

          subject
        end
      end

      context "when an onboarding completed event has already occured" do
        before do
          expect(Projections::HasOccurred)
            .to receive(:project)
            .with(aggregate: message.aggregate, schema: Events::OnboardingCompleted::V2)
            .and_return(false)
        end

        it "creates an onboarding complete event" do
          expect(message_service)
            .to receive(:create!)
            .with(
              schema: Events::OnboardingCompleted::V2,
              trace_id: message.trace_id,
              aggregate: message.aggregate,
              data: Messages::Nothing
            )

          subject
        end
      end
    end

    context "when message could trigger and onboarding complete" do
      let(:message) do
        build(
          :message,
          schema: Events::ReliabilityAdded::V1,
          data: {
            reliabilities: [Reliability::JOB]
          }
        )
      end

      before do
        expect(Seekers::Projections::OnboardingStatus)
          .to receive(:project)
          .with(aggregate: message.aggregate)
          .and_return(projection)
      end

      context "when onboarding status next step is not complete" do
        let(:projection) do
          Seekers::Projections::OnboardingStatus.new(message.aggregate).init
        end

        it "does nothing" do
          expect(message_service)
            .not_to receive(:create!)

          subject
        end
      end

      context "when onboarding status next step is complete" do
        let(:projection) do
          Seekers::Projections::OnboardingStatus::Projection.new(
            start: Seekers::Projections::OnboardingStatus::Step.new(needed: true, provided: true),
            name: Seekers::Projections::OnboardingStatus::Step.new(needed: true, provided: true),
            reliability: Seekers::Projections::OnboardingStatus::Step.new(needed: true, provided: true),
            employment: Seekers::Projections::OnboardingStatus::Step.new(needed: false, provided: true),
            education: Seekers::Projections::OnboardingStatus::Step.new(needed: false, provided: true),
            training: Seekers::Projections::OnboardingStatus::Step.new(needed: false, provided: true),
            opportunities: Seekers::Projections::OnboardingStatus::Step.new(needed: true, provided: true)
          )
        end

        it "emits an onboarding complete event" do
          expect(message_service)
            .to receive(:create!)
            .with(
              schema: Commands::CompleteOnboarding::V1,
              aggregate: message.aggregate,
              trace_id: message.trace_id,
              data: Messages::Nothing
            )

          subject
        end
      end
    end
  end
end
