require 'rails_helper'

RSpec.describe Contact::ContactReactor do
  describe "#handle_message" do
    subject { described_class.new(message_service:).handle_message(message) }

    let(:message_service) { MessageService.new }

    context "when the message is send message" do
      let(:message) do
        build(
          :message,
          schema: Commands::SendMessage::V1,
          data: {
            title: "A title",
            body: "A body",
            url:,
            user_id:
          },
          metadata: {}
        )
      end
      let(:user_id) { SecureRandom.uuid }
      let!(:user_contact) do
        create(
          :contact__user_contact,
          user_id:,
          preferred_contact:
        )
      end

      context "when the user prefers slack" do
        let(:preferred_contact) { Contact::ContactPreference::SLACK }

        context "when a url is present" do
          let(:url) { "www.google.com" }

          it "fires off a send slack message command" do
            expect(message_service)
              .to receive(:create!)
              .with(
                schema: Commands::SendSlackMessage::V1,
                trace_id: message.trace_id,
                message_id: message.aggregate.message_id,
                data: {
                  channel: user_contact.slack_id,
                  text: "*A title*: A body <www.google.com|Link>"
                }
              ).and_call_original

            expect(message_service)
              .to receive(:create!)
              .with(
                schema: Events::MessageEnqueued::V1,
                trace_id: message.trace_id,
                message_id: message.aggregate.message_id,
                data: Messages::Nothing
              ).and_call_original

            subject
          end
        end

        context "when a url is absent" do
          let(:url) { nil }

          it "fires off a send slack message command" do
            expect(message_service)
              .to receive(:create!)
              .with(
                schema: Commands::SendSlackMessage::V1,
                trace_id: message.trace_id,
                message_id: message.aggregate.message_id,
                data: {
                  channel: user_contact.slack_id,
                  text: "*A title*: A body"
                }
              ).and_call_original

            expect(message_service)
              .to receive(:create!)
              .with(
                schema: Events::MessageEnqueued::V1,
                trace_id: message.trace_id,
                message_id: message.aggregate.message_id,
                data: Messages::Nothing
              ).and_call_original

            subject
          end
        end
      end

      context "when the user prefers email" do
        let(:preferred_contact) { Contact::ContactPreference::EMAIL }
        let(:url) { "www.google.com" }

        it "fires off a send email message command" do
          expect(message_service)
            .to receive(:create!)
            .with(
              schema: Commands::SendEmailMessage::V1,
              trace_id: message.trace_id,
              message_id: message.aggregate.message_id,
              data: {
                recepent_email: user_contact.email,
                title: message.data.title,
                body: message.data.body,
                url: message.data.url
              }
            ).and_call_original

          expect(message_service)
            .to receive(:create!)
            .with(
              schema: Events::MessageEnqueued::V1,
              trace_id: message.trace_id,
              message_id: message.aggregate.message_id,
              data: Messages::Nothing
            ).and_call_original

          subject
        end
      end

      context "when the user prefers sms" do
        let(:preferred_contact) { Contact::ContactPreference::SMS }

        context "when a url is present" do
          let(:url) { "www.google.com" }

          it "fires off a send sms message command" do
            expect(message_service)
              .to receive(:create!)
              .with(
                schema: Commands::SendSmsMessage::V3,
                trace_id: message.trace_id,
                message_id: message.aggregate.message_id,
                data: {
                  phone_number: user_contact.phone_number,
                  message: "A title: A body www.google.com"
                }
              ).and_call_original

            expect(message_service)
              .to receive(:create!)
              .with(
                schema: Events::MessageEnqueued::V1,
                trace_id: message.trace_id,
                message_id: message.aggregate.message_id,
                data: Messages::Nothing
              ).and_call_original

            subject
          end
        end

        context "when a url is absent" do
          let(:url) { nil }

          it "fires off a send sms message command" do
            expect(message_service)
              .to receive(:create!)
              .with(
                schema: Commands::SendSmsMessage::V3,
                trace_id: message.trace_id,
                message_id: message.aggregate.message_id,
                data: {
                  phone_number: user_contact.phone_number,
                  message: "A title: A body"
                }
              ).and_call_original

            expect(message_service)
              .to receive(:create!)
              .with(
                schema: Events::MessageEnqueued::V1,
                trace_id: message.trace_id,
                message_id: message.aggregate.message_id,
                data: Messages::Nothing
              ).and_call_original

            subject
          end
        end
      end

      context "when the user prefers notification" do
        let(:url) { "www.google.com" }
        let(:preferred_contact) { Contact::ContactPreference::IN_APP_NOTIFICATION }

        it "fires off a create notification event and message sent event" do
          expect(message_service)
            .to receive(:create!)
            .with(
              schema: Events::NotificationCreated::V3,
              trace_id: message.trace_id,
              message_id: message.aggregate.message_id,
              data: {
                title: message.data.title,
                body: message.data.body,
                url: message.data.url,
                notification_id: be_a(String),
                user_id: message.data.user_id
              }
            ).and_call_original

          expect(message_service)
            .to receive(:create!)
            .with(
              schema: Events::MessageSent::V1,
              trace_id: message.trace_id,
              message_id: message.aggregate.message_id,
              data: Messages::Nothing
            ).and_call_original

          subject
        end
      end
    end
  end
end
