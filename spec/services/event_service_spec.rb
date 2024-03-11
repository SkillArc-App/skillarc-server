require 'rails_helper'

RSpec.describe EventService do
  describe ".create!" do
    subject do
      instance.create!(
        id:,
        event_schema:,
        aggregate_id:,
        trace_id:,
        data:,
        occurred_at:,
        metadata:
      )
    end

    let(:instance) { described_class.new(message_service: MessageService.new) }

    let(:aggregate_id) { SecureRandom.uuid }
    let(:trace_id) { SecureRandom.uuid }
    let(:data) { Events::UserCreated::Data::V1.new }
    let(:occurred_at) { DateTime.new(2000, 1, 1) }
    let(:event_schema) { Events::UserCreated::V1 }
    let(:metadata) { Messages::Nothing }
    let(:id) { SecureRandom.uuid }

    it "calls MessageService.create! with the same data" do
      expect_any_instance_of(MessageService)
        .to receive(:create!)
        .with(
          id:,
          message_schema: event_schema,
          aggregate_id:,
          trace_id:,
          data:,
          occurred_at:,
          metadata:
        )

      subject
    end
  end
end
