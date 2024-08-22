require 'rails_helper'

RSpec.describe Users::UsersReactor do
  it_behaves_like "a replayable message consumer"

  describe "#handle_message" do
    subject do
      instance.handle_message(message)
      instance.handle_message(message)
    end

    before do
      Event.from_messages!(messages)
    end

    let(:messages) { [] }
    let(:message_service) { MessageService.new }
    let(:instance) { described_class.new(message_service:) }

    context "when message is role added" do
      let(:message) do
        build(
          :message,
          schema: Users::Events::RoleAdded::V2,
          stream_id: user_id,
          data: {
            role:
          }
        )
      end

      let(:user_id) { SecureRandom.uuid }

      context "when role is not coach" do
        let(:role) { Role::Types::ADMIN }

        it "does nothing" do
          expect(message_service)
            .not_to receive(:create!)

          subject
        end
      end

      context "when role is coach" do
        before do
          allow(MessageService)
            .to receive(:stream_events)
            .with(stream)
            .and_return(messages)
        end

        let(:user_created) do
          build(
            :message,
            schema: Users::Events::UserCreated::V1,
            stream_id: user_id,
            data: {
              email:
            }
          )
        end

        let(:email) { nil }
        let(:role) { Role::Types::COACH }
        let(:stream) { Users::Streams::User.new(user_id:) }

        context "when a user created does not exist" do
          let(:messages) { [] }

          it "does nothing" do
            expect(message_service)
              .not_to receive(:create!)

            subject
          end
        end

        context "when a user created does not have an email" do
          let(:messages) { [user_created] }
          let(:email) { nil }

          it "does nothing" do
            expect(message_service)
              .not_to receive(:create!)

            subject
          end
        end

        context "when a user created does not have an email" do
          let(:messages) { [user_created] }
          let(:email) { "some@email.com" }

          it "emits a coach added event once" do
            expect(message_service)
              .to receive(:create_once_for_stream!)
              .with(
                trace_id: message.trace_id,
                schema: Users::Events::CoachAdded::V1,
                user_id: message.stream.id,
                data: {
                  coach_id: be_a(String),
                  email:
                }
              )
              .twice
              .and_call_original

            subject
          end
        end
      end
    end

    context "when message is user create" do
      let(:message) do
        build(
          :message,
          schema: Users::Events::UserCreated::V1
        )
      end

      it "emits a send slack message command" do
        expect(message_service)
          .to receive(:create_once_for_stream!)
          .with(
            trace_id: message.trace_id,
            schema: Commands::SendSlackMessage::V2,
            message_id: message.deterministic_uuid,
            data: {
              channel: "#feed",
              text: "New user signed up: *#{message.data.email}*"
            }
          )
          .twice
          .and_call_original

        subject
      end
    end

    context "when the message is contact" do
      let(:message) do
        build(
          :message,
          schema: Users::Commands::Contact::V1,
          data: {
            person_id:
          }
        )
      end

      let(:person_id) { SecureRandom.uuid }

      let(:person) do
        build(
          :message,
          stream_id: person_id,
          schema: People::Events::PersonAdded::V1
        )
      end

      context "when the the person is missing" do
        let(:messages) { [] }

        it "does nothing" do
          allow(message_service).to receive(:query).and_call_original
          expect(message_service).not_to receive(:save!)

          subject
        end
      end

      context "when the person is present" do
        let(:messages) { [person] }

        it "emits a contacted event" do
          allow(message_service).to receive(:query).and_call_original
          expect(message_service)
            .to receive(:create_once_for_trace!)
            .with(
              schema: Users::Events::Contacted::V1,
              trace_id: message.trace_id,
              stream: message.stream,
              data: {
                person_id: message.data.person_id,
                note: message.data.note,
                contact_direction: message.data.contact_direction,
                contact_type: message.data.contact_type
              }
            )
            .twice
            .and_call_original

          subject
        end
      end
    end
  end
end
