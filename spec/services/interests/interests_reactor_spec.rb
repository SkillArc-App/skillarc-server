require 'rails_helper'

RSpec.describe Interests::InterestsReactor do
  it_behaves_like "a replayable message consumer"

  let(:consumer) { described_class.new(message_service:) }
  let(:message_service) { MessageService.new }
  let(:stream) { Interests::INTEREST_STREAM }

  describe "#handle_message" do
    subject do
      consumer.handle_message(message)
      consumer.handle_message(message)
    end

    context "when the message set interests" do
      let(:message) do
        build(
          :message,
          stream:,
          schema: Interests::Commands::SetInterests::V1,
          data: {
            interests: %w[cats dogs]
          }
        )
      end

      it "emit a added event" do
        expect(message_service)
          .to receive(:create_once_for_trace!)
          .with(
            stream: message.stream,
            trace_id: message.trace_id,
            schema: Interests::Events::InterestsSet::V1,
            data: {
              interests: message.data.interests
            }
          )
          .twice
          .and_call_original

        subject
      end
    end
  end
end
