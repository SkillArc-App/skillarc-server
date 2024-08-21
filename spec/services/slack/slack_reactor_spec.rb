require 'rails_helper'

RSpec.describe Slack::SlackReactor do
  describe "#handle_message" do
    subject { described_class.new(client:, message_service:).handle_message(message) }

    let(:client) { Slack::FakeClient.new }
    let(:message_service) { MessageService.new }

    context "wehn the message is send slack message" do
      let(:message) do
        build(
          :message,
          schema: Commands::SendSlackMessage::V2,
          data: {
            channel: "#somechannel",
            text: "*some text*",
            blocks: nil
          }
        )
      end

      it "sends a slack message to the provided channel and emits and event" do
        expect(message_service)
          .to receive(:create_once_for_stream!)
          .with(
            schema: Events::SlackMessageSent::V2,
            trace_id: message.trace_id,
            message_id: message.stream.message_id,
            data: {
              channel: "#somechannel",
              text: "*some text*",
              blocks: nil
            }
          )

        expect(client)
          .to receive(:chat_postMessage)
          .with(
            channel: '#somechannel',
            text: "*some text*",
            blocks: nil,
            as_user: true
          )

        subject
      end
    end
  end
end
