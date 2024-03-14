require 'rails_helper'

RSpec.describe Contact::CalDotCom::SchedulingReactor do
  describe "#handle_message" do
    subject { described_class.new(command_service:).handle_message(message) }

    it_behaves_like "a message consumer"

    context "the event is a cal.com webhook recieved event" do
      let(:message) do
        build(
          :message,
          trace_id:,
          schema: Events::CalWebhookReceived::V1,
          data: Events::CalWebhookReceived::Data::V1.new(
            cal_trigger_event_type:,
            payload:
          )
        )
      end
      let(:command_service) { CommandService.new }
      let(:trace_id) { "78476f14-3e1a-4191-9f61-feed9a44951d" }
      let(:payload) { {} }

      context "when the trigger event is BOOKING_CREATED" do
        let(:cal_trigger_event_type) { Events::CalWebhookReceived::CalTriggerEventTypes::BOOKING_CREATED }

        context "when the payload type is CAREER_CONSULTATION" do
          before do
            allow(SecureRandom)
              .to receive(:uuid)
              .and_return(dummie_uuid)
          end

          let(:dummie_uuid) { "6ac44c8a-4221-4814-bb32-fa16f965b7fd" }

          context "when the leads provides additional notes" do
            let(:payload) do
              {
                type: Events::CalWebhookReceived::KnownBookingTypes::CAREER_CONSULTATION,
                attendees: [
                  {
                    email: "john@skillarc.com",
                    firstName: "John",
                    lastName: "Chabot"
                  }
                ],
                location: "+17403573931",
                organizer: {
                  email: "katina@skillarc.com"
                }
              }
            end

            it "emits a ADD_LEAD command and an ASSIGN_COACH command" do
              expect(command_service)
                .to receive(:create!)
                .with(
                  trace_id:,
                  context_id: dummie_uuid,
                  command_schema: Commands::AddLead::V1,
                  data: Commands::AddLead::Data::V1.new(
                    email: "john@skillarc.com",
                    lead_id: dummie_uuid,
                    phone_number: "+17403573931",
                    first_name: "John",
                    last_name: "Chabot",
                    lead_captured_by: "cal.com"
                  )
                )

              expect(command_service)
                .to receive(:create!)
                .with(
                  trace_id:,
                  context_id: dummie_uuid,
                  command_schema: Commands::AssignCoach::V1,
                  data: Commands::AssignCoach::Data::V1.new(
                    coach_email: "katina@skillarc.com"
                  )
                )

              subject
            end
          end

          context "when the leads doesn't provides additional notes" do
            let(:payload) do
              {
                type: Events::CalWebhookReceived::KnownBookingTypes::CAREER_CONSULTATION,
                attendees: [
                  {
                    email: "john@skillarc.com",
                    firstName: "John",
                    lastName: "Chabot"
                  }
                ],
                location: "+17403573931",
                organizer: {
                  email: "katina@skillarc.com"
                },
                additionalNotes: "This seems like a cool place!"
              }
            end

            it "emits ADD_LEAD, ASSIGN_COACH and ADD_NOTE commands" do
              expect(command_service)
                .to receive(:create!)
                .with(
                  trace_id:,
                  context_id: dummie_uuid,
                  command_schema: Commands::AddLead::V1,
                  data: Commands::AddLead::Data::V1.new(
                    email: "john@skillarc.com",
                    lead_id: dummie_uuid,
                    phone_number: "+17403573931",
                    first_name: "John",
                    last_name: "Chabot",
                    lead_captured_by: "cal.com"
                  )
                )

              expect(command_service)
                .to receive(:create!)
                .with(
                  trace_id:,
                  context_id: dummie_uuid,
                  command_schema: Commands::AssignCoach::V1,
                  data: Commands::AssignCoach::Data::V1.new(
                    coach_email: "katina@skillarc.com"
                  )
                )

              expect(command_service)
                .to receive(:create!)
                .with(
                  trace_id:,
                  context_id: dummie_uuid,
                  command_schema: Commands::AddNote::V1,
                  data: Commands::AddNote::Data::V1.new(
                    originator: "cal.com",
                    note: "From John Chabot on the meeting invite: This seems like a cool place!",
                    note_id: dummie_uuid
                  )
                )

              subject
            end
          end
        end

        context "when the payload type is anything else" do
          let(:payload) do
            { type: "some other meeting" }
          end

          it "does not emit a command and reports an error to sentry" do
            expect(command_service)
              .not_to receive(:create!)

            expect(Sentry)
              .to receive(:capture_exception)
              .with(be_a(described_class::UnknownMeetingType))

            subject
          end
        end
      end

      context "when the trigger event is anything else" do
        let(:cal_trigger_event_type) { Events::CalWebhookReceived::CalTriggerEventTypes::FORM_SUBMITTED }

        it "does nothing" do
          expect(command_service)
            .not_to receive(:create!)

          subject
        end
      end
    end
  end
end
