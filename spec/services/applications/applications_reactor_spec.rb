require 'rails_helper'

RSpec.describe Applications::ApplicationsReactor do
  it_behaves_like "a replayable message consumer"

  describe "#handle_message" do
    subject do
      instance.handle_message(message)
      instance.handle_message(message)
    end

    let(:instance) do
      described_class.new(message_service:)
    end

    let(:message_service) { MessageService.new }

    describe "when message is seeker applied" do
      let(:message) do
        build(
          :message,
          schema: People::Events::PersonApplied::V1,
          data: {
            application_id: SecureRandom.uuid,
            seeker_first_name: "Katina",
            seeker_last_name: "Hall",
            seeker_email: "katina@skillarc.com",
            seeker_phone_number: "123-456-7890",
            user_id: SecureRandom.uuid,
            job_id: SecureRandom.uuid,
            employer_name: "Skillarc",
            employment_title: "Welder"
          },
          stream_id: seeker_id
        )
      end
      let(:seeker_id) { SecureRandom.uuid }

      it "emits a applicant status updated" do
        expect(message_service)
          .to receive(:create_once_for_stream!)
          .with(
            application_id: message.data.application_id,
            trace_id: message.trace_id,
            schema: Events::ApplicantStatusUpdated::V6,
            data: {
              applicant_first_name: message.data.seeker_first_name,
              applicant_last_name: message.data.seeker_last_name,
              applicant_email: message.data.seeker_email,
              applicant_phone_number: message.data.seeker_phone_number,
              seeker_id: message.stream.id,
              user_id: message.data.user_id,
              job_id: message.data.job_id,
              employer_name: message.data.employer_name,
              employment_title: message.data.employment_title,
              status: ApplicantStatus::StatusTypes::NEW,
              reasons: []
            },
            metadata: {
              user_id: message.data.user_id
            }
          )
          .twice
          .and_call_original

        subject
      end
    end

    describe "when message is applicant status update" do
      let(:message) do
        build(
          :message,
          schema: Events::ApplicantStatusUpdated::V6,
          data: {
            status:,
            seeker_id: SecureRandom.uuid,
            applicant_email: "an@email.com",
            employment_title: "Job",
            employer_name: "Employer"
          }
        )
      end

      context "when status is new" do
        let(:status) { ApplicantStatus::StatusTypes::NEW }

        it "emits a applicant status updated" do
          expect(message_service)
            .to receive(:create_once_for_stream!)
            .with(
              trace_id: message.trace_id,
              schema: Commands::SendSlackMessage::V2,
              message_id: Digest::UUID.uuid_v3(Digest::UUID::DNS_NAMESPACE, message.stream.id),
              data: {
                channel: "#feed",
                text: "<#{ENV.fetch('FRONTEND_URL', nil)}/profiles/#{message.data.seeker_id}|#{message.data.applicant_email}> has applied to *#{message.data.employment_title}* at *#{message.data.employer_name}*"
              }
            )
            .twice
            .and_call_original

          subject
        end
      end

      context "when status is not new" do
        let(:status) { ApplicantStatus::StatusTypes::PENDING_INTRO }

        it "emits a applicant status updated" do
          expect(message_service).not_to receive(:save!)

          subject
        end
      end
    end
  end
end
