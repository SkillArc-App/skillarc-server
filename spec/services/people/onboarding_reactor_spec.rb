require 'rails_helper'

RSpec.describe People::OnboardingReactor do
  it_behaves_like "a replayable message consumer"

  let(:consumer) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }
  let(:trace_id) { SecureRandom.uuid }
  let(:user_id) { SecureRandom.uuid }
  let(:person_id) { SecureRandom.uuid }
  let(:messages) { [] }

  describe "#handle_message" do
    subject do
      consumer.handle_message(message)
      consumer.handle_message(message)
    end

    before do
      Event.from_messages!(messages)
    end

    context "when the message is person associated to user" do
      let(:message) do
        build(
          :message,
          schema: People::Events::PersonAssociatedToUser::V1,
          stream_id: person_id,
          data: {
            user_id:
          }
        )
      end

      it "creates a start onboarding command" do
        expect(message_service)
          .to receive(:create_once_for_trace!)
          .with(
            schema: People::Commands::StartOnboarding::V2,
            trace_id: message.trace_id,
            stream: message.stream,
            data: Core::Nothing
          )
          .twice
          .and_call_original

        subject
      end
    end

    context "when the message is start onboarding" do
      let(:message) do
        build(
          :message,
          schema: People::Commands::StartOnboarding::V2,
          stream_id: person_id,
          data: Core::Nothing
        )
      end

      it "creates an onboarding complete event once for the stream" do
        expect(message_service)
          .to receive(:create_once_for_stream!)
          .with(
            schema: People::Events::OnboardingStarted::V2,
            trace_id: message.trace_id,
            stream: message.stream,
            data: Core::Nothing
          )
          .twice
          .and_call_original

        subject
      end
    end

    context "when the message is complete onboarding" do
      let(:message) do
        build(
          :message,
          schema: People::Commands::CompleteOnboarding::V2,
          stream_id: person_id
        )
      end

      it "creates an onboarding complete event once for the stream" do
        expect(message_service)
          .to receive(:create_once_for_stream!)
          .with(
            schema: People::Events::OnboardingCompleted::V3,
            trace_id: message.trace_id,
            stream: message.stream,
            data: Core::Nothing
          )
          .twice
          .and_call_original

        subject
      end
    end

    context "when an existing email is need" do
      let(:messages) do
        [
          build(
            :message,
            stream:,
            schema: People::Events::PersonAdded::V1,
            data: {
              email: "some@email.com"
            }
          )
        ]
      end

      let(:stream) { People::Streams::Person.new(person_id:) }

      context "when the message is onboarding started" do
        let(:message) do
          build(
            :message,
            schema: People::Events::OnboardingStarted::V2,
            stream:
          )
        end

        it "creates an send slack message command" do
          expect(message_service)
            .to receive(:create_once_for_stream!)
            .with(
              trace_id: message.trace_id,
              schema: Commands::SendSlackMessage::V2,
              message_id: message.deterministic_uuid,
              data: {
                channel: "#feed",
                text: "<#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{message.stream.id}|some@email.com> has started onboarding"
              }
            )
            .twice
            .and_call_original

          subject
        end
      end

      context "when the message is onboarding started" do
        let(:message) do
          build(
            :message,
            schema: People::Events::OnboardingCompleted::V3,
            stream:
          )
        end

        it "creates an send slack message command" do
          expect(message_service)
            .to receive(:create_once_for_stream!)
            .with(
              trace_id: message.trace_id,
              schema: Commands::SendSlackMessage::V2,
              message_id: message.deterministic_uuid,
              data: {
                channel: "#feed",
                text: "<#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{message.stream.id}|some@email.com> has completed onboarding"
              }
            )
            .twice
            .and_call_original

          subject
        end
      end
    end

    context "when message could trigger an onboarding complete" do
      let(:message) do
        build(
          :message,
          schema: People::Events::ReliabilityAdded::V2,
          data: {
            reliabilities: [Reliability::JOB]
          }
        )
      end

      before do
        allow_any_instance_of(People::Projectors::OnboardingStatus)
          .to receive(:project)
          .and_return(projection)
      end

      context "when onboarding status next step is not complete" do
        let(:projection) do
          People::Projectors::OnboardingStatus.new.init
        end

        it "does nothing" do
          expect(message_service)
            .not_to receive(:create!)

          subject
        end
      end

      context "when onboarding status next step is complete_loading" do
        let(:projection) do
          People::Projectors::OnboardingStatus::Projection.new(
            start: People::Projectors::OnboardingStatus::Step.new(needed: true, provided: true),
            reliability: People::Projectors::OnboardingStatus::Step.new(needed: true, provided: true),
            employment: People::Projectors::OnboardingStatus::Step.new(needed: false, provided: true),
            education: People::Projectors::OnboardingStatus::Step.new(needed: false, provided: true),
            training: People::Projectors::OnboardingStatus::Step.new(needed: false, provided: true),
            opportunities: People::Projectors::OnboardingStatus::Step.new(needed: true, provided: true),
            complete: People::Projectors::OnboardingStatus::Step.new(needed: true, provided: false)
          )
        end

        it "emits an onboarding complete event" do
          allow(message_service).to receive(:query).and_call_original
          expect(message_service)
            .to receive(:create_once_for_stream!)
            .with(
              schema: People::Commands::CompleteOnboarding::V2,
              stream: message.stream,
              trace_id: message.trace_id,
              data: Core::Nothing
            )
            .twice
            .and_call_original

          subject
        end
      end
    end
  end
end
