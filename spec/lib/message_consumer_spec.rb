require 'rails_helper'

RSpec.describe MessageConsumer do
  describe ".on_message" do
    let(:sub_klass) do
      Class.new(described_class) do
        on_message Events::SessionStarted::V1, &:checksum
      end
    end

    let(:message) { build(:message, schema: Events::SessionStarted::V1, data: Messages::Nothing) }

    it "executes the events for the approprate message" do
      expect(message)
        .to receive(:checksum)

      sub_klass.new.handle_message(message)
    end

    it "make individual handlers private" do
      expect { sub_klass.new.session_started_1(message) }.to raise_error(NoMethodError)
    end

    context "when on_message is sync" do
      let(:sub_klass) do
        Class.new(described_class) do
          on_message Events::SessionStarted::V1, :sync, &:checksum
        end
      end

      it "correctly reports how it handles events" do
        consumer = sub_klass.new

        expect(consumer.all_handled_messages).to eq([Events::SessionStarted::V1])
        expect(consumer.handled_messages_sync).to eq([Events::SessionStarted::V1])
        expect(consumer.handled_messages).to eq([])
      end
    end

    context "when on_message is async" do
      let(:sub_klass) do
        Class.new(described_class) do
          on_message Events::SessionStarted::V1, &:checksum
        end
      end

      it "correctly reports how it handles events" do
        consumer = sub_klass.new

        expect(consumer.all_handled_messages).to eq([Events::SessionStarted::V1])
        expect(consumer.handled_messages_sync).to eq([])
        expect(consumer.handled_messages).to eq([Events::SessionStarted::V1])
      end
    end
  end
end
